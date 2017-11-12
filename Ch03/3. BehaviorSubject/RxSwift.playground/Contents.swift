//: Please build the scheme 'RxSwiftPlayground' first

import RxSwift

/*:
 ----
 ## BehaviorSubject
 Broadcasts new events to all subscribers, and the most recent (or initial) value to new subscribers.
 ![](https://raw.githubusercontent.com/kzaher/rxswiftcontent/master/MarbleDiagrams/png/behaviorsubject.png)
 */

example(of: "BehaviorSubject") {
    
    let disposeBag = DisposeBag()
    
    let subject = BehaviorSubject(value: "a")
    
    //new subscription with init value
    let firstSubscription = subject.subscribe(onNext: {
        print(#line, $0)
    })
    
    subject.onNext("b")
    
    //new subscription with recent value
    let secondSubscription = subject.subscribe(onNext: {
        print(#line, $0)
    })
    
    firstSubscription.disposed(by: disposeBag)
    secondSubscription.disposed(by: disposeBag)
}
