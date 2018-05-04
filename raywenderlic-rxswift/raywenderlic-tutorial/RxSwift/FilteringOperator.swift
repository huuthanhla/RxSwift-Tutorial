//
//  FilteringOperator.swift
//  RxSwift-Books
//
//  Created by Zorot on 5/1/18.
//  Copyright © 2018 Zorot. All rights reserved.
//

import Foundation
import RxSwift

class FilteringOperator {
    class func test() {
        
        //MARK: - ignoreElements
        // ignore .next event elements
        // ignoreElements is useful when you only want to be notified when an observable has terminated,
        // via a .completed or .error event
        example(of: "ignoreElements") {
            let strikes = PublishSubject<String>()
            let disposeBag = DisposeBag()
            strikes
                .ignoreElements()
                .subscribe { _ in
                    print("You're out!")
                }
                .disposed(by: disposeBag)
            strikes.onNext("X")
            strikes.onNext("X")
            strikes.onNext("X")
            strikes.onCompleted()
        }
        
        //MARK: - elementAt
        /*
         There may be times when you only want to handle the the nth (ordinal) element emitted by an observable,
         such as the third strike. For that you can use elementAt, which takes the index of the element you want to receive,
         and it ignores everything else
         */
        example(of: "elementAt") {
            let strikes = PublishSubject<String>()
            let disposeBag = DisposeBag()
            strikes
                .elementAt(2)
                .subscribe(onNext: { element in
                    print("You're out! \(element)")
                })
                .disposed(by: disposeBag)
            strikes.onNext("X0")
            strikes.onNext("X1")
            strikes.onNext("X2") //consoler: You're out! X2
        }
        
        //MARK: - Filter
        example(of: "Filter") {
            let disposeBag = DisposeBag()
            Observable.of(1, 2, 3, 4, 5, 6)
                .filter { integer in
                    integer % 2 == 0
                }
                .subscribe(onNext: {
                    print($0)
                })
                .disposed(by: disposeBag)
        }
        
        //MARK: - Skipping operator
        /*
         The skip operator allows you to ignore from the 1st to the number you pass as its parameter.
         */
        example(of: "Skipping operator") {
            let disposeBag = DisposeBag()
            Observable.of("A", "B", "C", "D", "E", "F")
                .skip(3) // Use skip to skip the first 3 elements and subscribe to .next events.
                .subscribe(onNext: {
                    print($0) })
                .disposed(by: disposeBag)
        }
        
        //MARK: - skipWhile
        /*
         skipWhile will only skip up until something is not skipped,
         and then it will let everything else through from that point on.
         
         phép toán này sẽ skip cho đến khi tìm thấy phần tử đầu tiên thỏa mãn điều kiện,
         sau khi đó sẽ k skip nữa
         */
        example(of: "skipWhile") {
            let disposeBag = DisposeBag()
            Observable.of(2, 2, 3, 4, 4)
                .skipWhile { integer in
                    integer % 2 == 0
                }
                .subscribe(onNext: {
                    print($0)
                })
                .disposed(by: disposeBag)
        }
        
        //MARK: - SkipUntil
        /*
         skipUntil, which will keep skipping elements from the source observable
         (the one you’re subscribing to) until some other trigger observable emits
         
         In this marble diagram, skipUntil ignores elements emitted by the source observable (the top line) until the trigger observable (second line) emits a .next event.
         Then it stops skipping and lets everything through from that point on.
         */
        
        example(of: "SkipUntil") {
            let disposeBag = DisposeBag()
            let subject = PublishSubject<String>()
            let trigger = PublishSubject<String>()
            subject
                .skipUntil(trigger)
                .subscribe(onNext: {
                    print($0) })
                .disposed(by: disposeBag)
            
            subject.onNext("A")
            subject.onNext("B")
            trigger.onNext("X")
            subject.onNext("C") //consoler: C
            
        }
        
        //MARK: - Taking operators
        
        /*
         - Taking is the opposite of skipping
         - When you want to take elements, RxSwift has you covered
         */
        
        example(of: "take") {
            let disposeBag = DisposeBag()
            Observable.of(1, 2, 3, 4, 5, 6)
                .take(3)
                .subscribe(onNext: {
                    print($0) })
                .disposed(by: disposeBag)
        }
        
        //MARK: - takeWhile
        /*
         - There’s also a takeWhile operator that works similarly to skipWhile, except you’re taking instead of skipping.
         */
        
        example(of: "takeWhile") {
            let disposeBag = DisposeBag()
            Observable.of(2, 2, 4, 4, 6, 6)
                .enumerated() // Use the enumerated operator to get tuples containing the index and value of each element emitted.
                .takeWhile { index, integer in
                    integer % 2 == 0 && index < 3
                }
                .map { $0.element } // to reach into the tuple returned from takeWhile and get the element
                .subscribe(onNext: {
                    print($0) })
                .disposed(by: disposeBag)
        }
        
        //MARK: - takeUntil
        /*
         Like skipUntil, there's also a takeUntil operator, shown in this marble diagram,
         taking from the source observable until the trigger observable emits an element.
         
         NOTE:
         takeUntil can also be used to dispose of a subscription, instead of adding it to a dispose bag.
         ex:
         
         someObservable
         .takeUntil(self.rx.deallocated)
         .subscribe(onNext: {
         print($0) })
         
         */
        
        example(of: "takeUntil") {
            let disposeBag = DisposeBag()
            // 1
            let subject = PublishSubject<String>()
            let trigger = PublishSubject<String>()
            
            subject
                .takeUntil(trigger)
                .subscribe(onNext: {
                    print($0) })
                .disposed(by: disposeBag)
            subject.onNext("1")
            subject.onNext("2")
            trigger.onNext("X")
            subject.onNext("3")
        }
        
        //MARK: - Distinct operators
        /*
         distinctUntilChanged only prevents duplicates that are right next to each other
         */
        
        example(of: "distinctUntilChanged") {
            let disposeBag = DisposeBag()
            Observable.of("A", "A", "B", "B", "A")
                .distinctUntilChanged()
                .subscribe(onNext: {
                    print($0) })
                .disposed(by: disposeBag)
        }
        
        example(of: "distinctUntilChanged(_:)") {
            let disposeBag = DisposeBag()
            let formatter = NumberFormatter()
            formatter.numberStyle = .spellOut
            
            Observable<NSNumber>.of(10, 110, 20, 200, 210, 310)
                .distinctUntilChanged {a, b in
                    guard let aWords = formatter.string(from: a)?.components(separatedBy: " "),
                          let bWords = formatter.string(from: b)?.components(separatedBy: " ") else {return false}
                    var containsMatch = false
                    
                    for aWord in aWords {
                        for bWord in bWords {
                            if aWord == bWord {
                                containsMatch = true
                                break
                            }
                        }
                    }
                    return containsMatch
                }
                .subscribe(onNext: {
                    print("--- \($0)")
                })
                .disposed(by: disposeBag)
        }
        
        //MARK: - Sharing subscriptions
        /*
         - observables are lazy
         - The moment you call subscribe(...) directly on an observable or on one of the operators applied to it,
           that’s when the Observable livens up and starts producing elements
         - To do that, the observable calls its create closure each time you subscribe to it. in some
           situations, this might produce some bedazzling effects!
         
         */
        example(of: "example for above theory") {
            let disposeBag = DisposeBag()
            var start = 0
            func getStartNumber() -> Int {
                start += 1
                return start
            }
            let numbers = Observable<Int>.create { observer in
                let start = getStartNumber()
                observer.onNext(start)
                observer.onNext(start+1)
                observer.onNext(start+2)
                observer.onCompleted()
                return Disposables.create()
            }
            numbers
                .subscribe(onNext: { el in
                    print("element [\(el)]")
                }, onCompleted: {
                    print("-------------")
                })
                .disposed(by: disposeBag)
            
            numbers
                .subscribe(onNext: { el in
                    print("element [\(el)]")
                }, onCompleted: {
                    print("-------------")
                })
                .disposed(by: disposeBag)
            
            //Result:
            /*
             element [1]
             element [2]
             element [3]
             -------------
             element [2]
             element [3]
             element [4]
             -------------
             */
            
            // The problem is that each time you call subscribe(...),
            // this creates a new Observable for that subscription — and each copy is not guaranteed to be the same as the previous.
            
        }
        
        // MARK: - Ignoring all elements
        /*
         ignoreElements() is the operator that lets you do just that:
         it discards all elements of the source sequence and lets through only .completed or .error.
         ex:
         
         newPhotos
         .ignoreElements()
         .subscribe(onCompleted: { [weak self] in
         self?.updateNavigationIcon()
         })
         .disposed(by: photosViewController.bag)
         
         */
        
        //MARK: - Implementing a basic uniqueness filter
        
    }
}
