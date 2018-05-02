//
//  Observable.swift
//  RxSwift-Books
//
//  Created by Zorot on 4/30/18.
//  Copyright © 2018 Zorot. All rights reserved.
//

import Foundation
import RxSwift

class ObservableTest {
    
    /* Note
     - Lifecycle of an observable
     + An observable emits next events that contain elements. It can continue to do this until it either:
     + ...emits an error event and is terminated, or
     + ...emits a completed event and is terminated.
     + Once an observable is terminated, it can no longer emit events.
     
     
     */
    
    
    class func test() {
        //Define some integer constants you’ll use in the following examples.
        let one = 1
        let two = 2
        let three = 3
        
        // Create an observable sequence of type Int using the just method with the one integer.
        let observable: Observable<Int> = Observable<Int>.just(one)
        let observable2 = Observable.of(one, two, three)
        let observable3 = Observable.of([one, two, three])
        let observable4 = Observable.from([one, two, three])
        
        let disposeBag = DisposeBag()
        
        // Creating observables
        example(of: "just, of, from") {
            
        }
        
        // MARK: - Subscribing to observables
        example(of: "Subscribing to observables") {
            print("Observable<Int>.just(one)")
            _ = observable.subscribe {event in
                print(event)
            }
            
            print("Observable.of(one, two, three)")
            _ = observable2.subscribe{ event in
                print(event)
            }
            
            print("Observable.of([one, two, three])")
            _ = observable3.subscribe{ event in
                print(event)
            }
            
            print("Observable.from([one, two, three])")
            _ = observable4.subscribe{ event in
                print(event)
            }
        }
        
        //MARK: - empty():  it will only emit a .completed event.
        example(of: "empty") {
            let observable = Observable<Void>.empty()
            _ = observable.subscribe{ event in
                print(event)
            }
        }
        
        
        //MARK: - never(): the never operator creates an observable that doesn’t emit anything and never terminates
        example(of: "never") {
            let observable = Observable<Any>.never()
            _ = observable.subscribe{ event in
                print(event)
            }
        }
        
        //MARK: - range(start: , count: ): generate an observable from a range of values.
        example(of: "range") {
            let observable = Observable<Int>.range(start: 1, count: 10)
            _ = observable.subscribe{ event in
                print(event)
            }
        }
        
        example(of: "DisposeBag") {
            Observable.of("A", "B", "C")
                .subscribe {
                    print($0) }
                .disposed(by: disposeBag)
        }
        
        //MARK: - create()
        example(of: "create") {
            let simpleObservable = Observable<String>.create { observer in
                observer.onNext("1")
                observer.onCompleted()
                observer.onNext("?")
                return Disposables.create()
            }
            
            simpleObservable
                .subscribe {
                    print($0) }
                .disposed(by: disposeBag)
        }
        
        
        //MARK: - deferred():  Creating observable factories
        // Rather than creating an observable that waits around for subscribers,
        // it’s possible to create observable factories that vend a new observable to each subscriber
        example(of: "deferred") {
            var flip = false
            let factory: Observable<Int> = Observable.deferred {
                flip = !flip
                if flip {
                    return Observable.of(1, 2, 3)
                } else {
                    return Observable.of(4, 5, 6)
                }
            }
            
            (0...3).forEach {_ in
                factory
                    .subscribe(onNext: {
                        print($0, terminator: "")
                    })
                    .disposed(by: disposeBag)
                print()
            }
        }
        
        //MARK: - Using Traits
        /*
         Traits are observables with a narrower (hẹp hơn) set of behaviors than regular observables.
         There are three kinds of traits in RxSwift: Single, Maybe, and Completable.
         
         - Singles will emit either a .success(value) or .error event. (Hoặc - Hoặc),
         This is useful for one-time processes that will either succeed and yield a value or fail, such as downloading data or loading it from disk.
         
         - A Completable will only emit a .completed or .error event.
         You could use a completable when you only care that an operation completed successfully or failed, such as a file write.
         
         - And Maybe is a mashup of a Single and Completable
         It can either emit a .success(value), .completed, or .error.
         If you need to implement an operation that could either succeed or fail, and optionally return a value on success, then Maybe is your ticket.
         */
        
        //MARK: - Single
        example(of: "Single") {
            loadText(from: "data")
                .subscribe({ event in
                    print("content: \(event)")
                })
                .disposed(by: disposeBag)
        }
    }
    
    
}







