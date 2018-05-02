//
//  CombiningOperators.swift
//  RxSwift-Books
//
//  Created by Zorot on 5/2/18.
//  Copyright © 2018 Zorot. All rights reserved.
//

import Foundation
import RxSwift

class CombiningOperators {
    
    class func test() {
        //MARK: - startWith
        /*
         The startWith(_:) operator prefixes an observable sequence with the given initial
         value. This value must be of the same type as the observable elements.
         */
        let bag = DisposeBag()
        example(of: "startWith") {
            let numbers = Observable.of(2, 3, 4)
            let observable = numbers.startWith(1)
            observable
                .subscribe(onNext: { value in
                    print(value)
                })
                .disposed(by: bag)
            
            /*
             --- Example of: startWith ---
             1
             2
             3
             4
             */
        }
        
        
        //MARK:- concat (concatenation: nối)
        /*
         startWith(_:) is the simple variant (biến thể) of the more general concat family of operators
         */
        example(of: "Observable.concat") {
            let first = Observable.of(1, 2, 3)
            let second = Observable.of(4, 5, 6)
            let observable = Observable.concat([first, second])
            observable
                .subscribe(onNext: { value in
                    print(value)
                })
                .disposed(by: bag)
            /*
             --- Example of: Observable.concat ---
             1
             2
             3
             4
             5
             6
             */
        }
        
        //Another way to append sequences together is the concat(_:) operator
        example(of: "concat") {
            let germanCities = Observable.of("Berlin", "Münich", "Frankfurt")
            let spanishCities = Observable.of("Madrid", "Barcelona", "Valencia")
            let observable = germanCities.concat(spanishCities)
            observable.subscribe(onNext: { value in
                print(value)
            }).disposed(by: bag)
            
            /*
             --- Example of: concat ---
             Berlin
             Münich
             Frankfurt
             Madrid
             Barcelona
             Valencia
             */
        }
        
        //MARK: - concatMap(_:)
        /*
          closely related to flatMap(_:)
         - flatMap(_:) returns an Observable sequence which is subscribed to, and the emitted observables are all merged
         - concatMap(_:) guarantees(đảm bảo) that each sequence produced by the closure will run to completion before the next is subscribed to.
                         concatMap(_:) is therefore a handy way to guarantee sequential order.
         */
        example(of: "concatMap") {
            //Prepares two sequences producing German and Spanish city names.
            let sequences = [
                "Germany": Observable.of("Berlin", "Münich", "Frankfurt"),
                "Spain": Observable.of("Madrid", "Barcelona", "Valencia")
            ]
            let observable = Observable
                .of("Germany", "Spain")
                .concatMap { country in
                    sequences[country] ?? .empty()
            }
            
            _ = observable.subscribe(onNext: { string in
                print(string)
            })
            /*
             --- Example of: concatMap ---
             Berlin
             Münich
             Frankfurt
             Madrid
             Barcelona
             Valencia
             */
        }
        
        //MARK: - merge()
        example(of: "merge()") {
            let left = PublishSubject<String>()
            let right = PublishSubject<String>()
            let source = Observable.of(left.asObservable(), right.asObservable())
            let observable = source.merge()
            let disposable = observable.subscribe(onNext: { value in
                print(value)
            })
            
            var leftValues = ["Berlin", "Munich", "Frankfurt"]
            var rightValues = ["Madrid", "Barcelona", "Valencia"]
            
            repeat {
                if arc4random_uniform(2) == 0 {
                    if !leftValues.isEmpty {
                        left.onNext("Left:  " + leftValues.removeFirst())
                    }
                } else if !rightValues.isEmpty {
                    right.onNext("Right: " + rightValues.removeFirst())
                }
            } while !leftValues.isEmpty || !rightValues.isEmpty
            
            disposable.dispose()
        }
    }
}
