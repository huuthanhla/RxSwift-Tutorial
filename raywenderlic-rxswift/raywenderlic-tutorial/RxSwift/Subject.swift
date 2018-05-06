//
//  Subject.swift
//  RxSwift-Books
//
//  Created by Zorot on 5/1/18.
//  Copyright © 2018 Zorot. All rights reserved.
//

import Foundation
import RxSwift

class SubjectTest {
    /*
      - PublishSubject: Starts empty and only emits new elements to subscribers
      - BehaviorSubject: Starts with an initial value and replays it or the latest element to new subscribers
      - ReplaySubject: Initialized with a buffer size and will maintain a buffer of elements up to that size and replay it to new subscribers.
      - Variable: Wraps a BehaviorSubject, preserves its current value as state, and replays only the latest/initial value to new subscribers.
     */
    class func test() {
        let disposeBag = DisposeBag()
        
        //MARK: - PublishSubject
        example(of: "PublishSubject") {
            let subject = PublishSubject<String>()
            subject.onNext("Is anyone listening?")
            subject
                .subscribe(onNext: { string in
                    print(string)
                }).disposed(by: disposeBag)
            subject.on(.next("1"))
        }
        
        example(of: "binding two subject") {
            var sb1 = PublishSubject<String>()
            let sb2 = PublishSubject<String>()
            sb1 = sb2
            //sb2 = sb1
            sb1.subscribe(onNext: {string in
                print("sb1: \(string)")
            }).disposed(by: disposeBag)
            
            sb2.subscribe(onNext: {string in
                print("sb2: \(string)")
            }).disposed(by: disposeBag)
            
            sb2.onNext("Hello world")
            sb1.onNext("rxswift")
        }
        
    }
}
