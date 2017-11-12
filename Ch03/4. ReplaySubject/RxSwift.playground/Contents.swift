
import RxSwift

/*:
 > This example also introduces using the `onNext(_:)` convenience method, equivalent to `on(.next(_:)`, which causes a new Next event to be emitted to subscribers with the provided `element`. There are also `onError(_:)` and `onCompleted()` convenience methods, equivalent to `on(.error(_:))` and `on(.completed)`, respectively.
 ----
 ## ReplaySubject
 Broadcasts new events to all subscribers, and the specified `bufferSize` number of previous events to new subscribers.
 ![](https://raw.githubusercontent.com/kzaher/rxswiftcontent/master/MarbleDiagrams/png/replaysubject.png)
 */

example(of: "ReplaySubject") {
    
    let disposeBag = DisposeBag()
    
    let subject = ReplaySubject<Int>.create(bufferSize: 3)
    
    subject.onNext(1)
    subject.onNext(2)
    subject.onNext(3)
    subject.onNext(4)
   
    subject.subscribe(onNext: {
        print($0)
    }).disposed(by: disposeBag)
    
    subject.onNext(5)
    
    subject.subscribe(onNext: {
        print("New subscription: \($0)")
    }).disposed(by: disposeBag)
    
    
    
}


