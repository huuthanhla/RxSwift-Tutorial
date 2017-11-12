//: Please build the scheme 'RxSwiftPlayground' first

import RxSwift


/*:
 ## PublishSubject
 Broadcasts new events to all observers as of their time of the subscription.
 ![](https://raw.githubusercontent.com/kzaher/rxswiftcontent/master/MarbleDiagrams/png/publishsubject.png "PublishSubject")
 */
example(of: "PublishSubject") {
    
    let subject = PublishSubject<String>()
    let disposeBag = DisposeBag()
    
    subject.subscribe {
        print($0)
    }
    .disposed(by: disposeBag)
    
    enum MyError: Error {
        case test
    }
    
    subject.onNext("Haha")
    //subject.onCompleted()
    //subject.onError(MyError.test)
    subject.on(.next("Hello world"))
    
    let newSubscription = subject.subscribe(onNext: {
        print("NewSubscription: \($0)")
    })
    
    subject.onNext("What's up man!!!")
    newSubscription.dispose()
    subject.onNext("still there?")
    
}
