//: Please build the scheme 'RxSwiftPlayground' first

import RxSwift

/*:
 > Notice what's missing in these previous examples? A Completed event. `PublishSubject`, `ReplaySubject`, and `BehaviorSubject` do not automatically emit Completed events when they are about to be disposed of.
 ----
 ## Variable
 Wraps a `BehaviorSubject`, so it will emit the most recent (or initial) value to new subscribers. And `Variable` also maintains current value state. `Variable` will never emit an Error event. However, it will automatically emit a Completed event and terminate on `deinit`.
 */

example(of: "Variable") {
    let disposeBag = DisposeBag()
    let variable = Variable("A")
    variable.asObservable().subscribe {
        print($0)
        }
    .disposed(by: disposeBag)
    variable.value
    variable.value = "B"
    
}


