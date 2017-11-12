//: Please build the scheme 'RxSwiftPlayground' first

import RxSwift

example(of: "Just") {
    let observable = Observable.just("Hello RxSwift")
    observable.subscribe({ (event) in
        print(event)
    })
}

example(of: "of") {
    let observable = Observable.of(1,2,3)
    observable.subscribe({
        print($0)
    })
    
}

example(of: "from") {
    let disposeBag = DisposeBag()
    let subscription = Observable.from([1,2,3]).subscribe(onNext: { (nextValue) in
        print("onNext: \(nextValue)")
    }, onError: { (error) in
        print("onError: \(error)")
    }, onCompleted: {
        print("onComplete")
    }, onDisposed: {
        print("onDispose")
    })
    subscription.disposed(by: disposeBag)
}

example(of: "error") {
    
}

