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
        /*
         NOTE:
         - merge() completes after its source sequence completes and all inner sequences have completed.
         - The order in which the inner sequences complete is irrelevant.
         - If any of the sequences emit an error, the merge() observable immediately relays the error, then terminates.
         
         - Notice that merge() takes a source observable, which itself emits observables sequences of the element type.
           This means that you could send a lot of sequences for merge() to subscribe to!
         - To limit the number of sequences subscribed to at once, you can use merge(maxConcurrent:)
         */
        
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
        
        //MARK: - combineLatest()
        /*
         NOTE:
         - Remember that combineLatest(_:_:resultSelector:) waits for all its observables to emit one element before starting to call your closure. It’s a frequent source of confusion and a good opportunity to use the startWith(_:) operator to provide an initial value for the sequences, which could take time to update.
         
         */
        
        example(of: "combineLatest") {
            let left = PublishSubject<String>()
            let right = PublishSubject<String>()
            let observable = Observable.combineLatest(left, right, resultSelector: { lastLeft, lastRight in
                "\(lastLeft) - \(lastRight)"
            })
            
            let disposable = observable.subscribe(onNext: { value in
                print(value)
            })
            print("> Sending a value to Left")
            left.onNext("Hello,")
            print("> Sending a value to Right")
            right.onNext("world")
            print("> Sending another value to Right")
            right.onNext("RxSwift")
            print("> Sending another value to Left")
            left.onNext("Have a good day,")
            
            disposable.dispose()
            /*
             --- Example of: combineLatest ---
             > Sending a value to Left
             > Sending a value to Right
             Hello, - world
             > Sending another value to Right
             Hello, - RxSwift
             > Sending another value to Left
             Have a good day, - RxSwift
             */
        }
        
        /*
         There are several variants in the combineLatest family of operators.
         They take between two and eight observable sequences as parameters. As mentioned above, sequences don’t need to have the same element type.
         
         This example demonstrates automatic updates of on-screen values when the user settings change. Think about all the manual updates you’ll remove with such patterns!.
         */
        
        example(of: "combine user choice and value") {
            let choice : Observable<DateFormatter.Style> = Observable.of(.short, .long)
            let dates = Observable.of(Date())
            
            let observable = Observable.combineLatest(choice, dates) {
                (format, when) -> String in
                let formatter = DateFormatter()
                formatter.dateStyle = format
                return formatter.string(from: when)
            }
            
            observable.subscribe(onNext: { value in
                print(value)
            }).disposed(by: bag)
            /*
             --- Example of: combine user choice and value ---
             5/2/18
             May 2, 2018
             */
        }
        
        /*
         A final variant of the combineLatest family takes a collection of observables and a combining closure, which receives latest values in an array. Since it’s a collection, all observables carry elements of the same type. Although less flexible than the multiple parameter variants, it is seldom-used but still handy to know about.
         
         Note: Last but not least, combineLatest completes only when the last of its inner sequences completes. Before that, it keeps sending combined values. If some sequences terminate, it uses the last value emitted to combine with new values from other sequences.
         */
        example(of: "combineLatest") {
            let left = PublishSubject<String>()
            let right = PublishSubject<String>()
            
            let observable = Observable.combineLatest([left, right], { strings  in
                strings.joined(separator: " ")
            })
            
            let disposable = observable.subscribe(onNext: { value in
                print(value)
            })
            print("> Sending a value to Left")
            left.onNext("Hello")
            print("> Sending a value to Right")
            right.onNext("world")
            print("> Sending another value to Right")
            right.onNext("RxSwift")
            print("> Sending another value to Left")
            left.onNext("Have a good day")
            
            disposable.dispose()
        }
        
        //MARK: - zip()
        /*
         The explanation lies in the way zip operators work. They wait until each of the inner observables emits a new value. If one of them completes, zip completes as well. It doesn’t wait until all of the inner observables are done! This is called indexed sequencing, which is a way to walk though sequences in lockstep.
         */
        example(of: "zip") {
            enum Weather {
                case cloudy
                case sunny
            }
            let left: Observable<Weather> = Observable.of(.sunny, .cloudy, .cloudy, .sunny)
            let right = Observable.of("Lisbon", "Copenhagen", "London", "Madrid","Vienna")
            
            let observable = Observable.zip(left, right, resultSelector: { weather, city in
                "It's \(weather) in \(city)"
            })
            observable.subscribe(onNext: { value in
                print(value)
            }).disposed(by: bag)
            
            /*
             --- Example of: zip ---
             It's sunny in Lisbon
             It's cloudy in Copenhagen
             It's cloudy in London
             It's sunny in Madrid
             */
        }
        
        //MARK: - withLatestFrom(_:)
        /*
         Simple and straightforward! withLatestFrom(_:) is useful in all situations where you want the current (latest)
         value emitted from an observable, but only when a particular trigger occurs.
         */
        
        example(of: "withLatestFrom") {
            let button = PublishSubject<Void>()
            let textField = PublishSubject<String>()
            let observable = button.withLatestFrom(textField)
            _ = observable.subscribe(onNext: { value in
                print(value)
            })
            textField.onNext("Par")
            textField.onNext("Pari")
            textField.onNext("Paris")
            button.onNext(())
            button.onNext(())
            
            /*
             --- Example of: withLatestFrom ---
             Paris
             Paris
             */
        }
        
        //MARK: - sample()
        /*
         A close relative to withLatestFrom(_:)
         
         */
        
        example(of: "sample") {
            let button = PublishSubject<Void>()
            let textField = PublishSubject<String>()
            let observable = textField.sample(button)
            _ = observable.subscribe(onNext: { value in
                print(value)
            })
            textField.onNext("Par")
            textField.onNext("Pari")
            textField.onNext("Paris")
            button.onNext(())
            button.onNext(())
            
            /*
             --- Example of: sample ---
             Paris
             */
        }
        /*
         NOTE:
         Notice that "Paris" now prints only once!
         This is because no new value was emitted by the text field between your two fake button presses.
         You could have achieved the same behavior by adding a distinctUntilChanged() to the withLatestFrom(_:) observable,
         but smallest possible operator chains are the Zen of RxTM.
         
         Note: Don’t forget that withLatestFrom(_:) takes the data observable as a parameter, while sample(_:) takes the trigger observable as a parameter. This can easily be a source of mistakes — so be careful!
         */
        
        //MARK: - amb(_:) - Switches
        /*
         - Think of “amb” as in “ambiguous” (mơ hồ)
         - The amb(_:) operator subscribes to left and right observables.
           It waits for any of them to emit an element, then unsubscribes from the other one. After that, it only relays elements from the first active observable. (nhận thằng mà có emit đầu tiên sau đó unsubcrible thằng còn lại)
           It really does draw its name from the term ambiguous: at first, you don’t know which sequence you’re interested in, and want to decide only when one fires.
         */
        
        example(of: "amb()") {
            let left = PublishSubject<String>()
            let right = PublishSubject<String>()
            let observable = right.amb(left)
            let disposable = observable.subscribe(onNext: { value in
                print(value)
            })
            // 2
            right.onNext("Copenhagen")
            left.onNext("Lisbon")
            left.onNext("London")
            left.onNext("Madrid")
            right.onNext("Vienna")
            disposable.dispose()
            
            /*
             --- Example of: amb() ---
             Copenhagen
             Vienna
             */
        }
        
        //MARK: - switchLatest()
        /*
         
         */
        
    }
}
