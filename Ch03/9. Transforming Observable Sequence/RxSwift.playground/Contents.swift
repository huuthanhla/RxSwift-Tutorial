//: Please build the scheme 'RxSwiftPlayground' first

import RxSwift
import Foundation

/*:
 # Transforming Operators
 Operators that transform Next event elements emitted by an `Observable` sequence.
 ## `map`
 Applies a transforming closure to elements emitted by an `Observable` sequence, and returns a new `Observable` sequence of the transformed elements. [More info](http://reactivex.io/documentation/operators/map.html)
 ![](https://raw.githubusercontent.com/kzaher/rxswiftcontent/master/MarbleDiagrams/png/map.png)
 */

example(of: "map") {
    let disposeBag = DisposeBag()
    Observable.of(1,2,3).map {
        $0 * $0
        }.subscribe(onNext: {
            print($0)
        }).disposed(by: disposeBag)
}

/*:
 ----
 ## `flatMap` and `flatMapLatest`
 Transforms the elements emitted by an `Observable` sequence into `Observable` sequences, and merges the emissions from both `Observable` sequences into a single `Observable` sequence. This is also useful when, for example, when you have an `Observable` sequence that itself emits `Observable` sequences, and you want to be able to react to new emissions from either `Observable` sequence. The difference between `flatMap` and `flatMapLatest` is, `flatMapLatest` will only emit elements from the most recent inner `Observable` sequence. [More info](http://reactivex.io/documentation/operators/flatmap.html)
 ![](https://raw.githubusercontent.com/kzaher/rxswiftcontent/master/MarbleDiagrams/png/flatmap.png)
 */

example(of: "flatMap & flatMapLatest") {
    let disposeBag = DisposeBag()
    struct Player {
        let name: String
        let score: Variable<Int>
    }
    
    let thai = Player(name: "Thai", score: Variable(10))
    let hanh = Player(name: "Hanh", score: Variable(100))
    
    let currentPlayer = Variable(thai)
    currentPlayer.asObservable().flatMap {
        $0.score.asObservable()
        }.subscribe(onNext: {
            print($0)
        }).disposed(by: disposeBag)
    currentPlayer.value.score.value = 15
    thai.score.value = 20
    
    currentPlayer.value = hanh
    thai.score.value = 25
}

/*:
 ----
 ## `scan`
 Begins with an initial seed value, and then applies an accumulator closure to each element emitted by an `Observable` sequence, and returns each intermediate result as a single-element `Observable` sequence. [More info](http://reactivex.io/documentation/operators/scan.html)
 ![](https://raw.githubusercontent.com/kzaher/rxswiftcontent/master/MarbleDiagrams/png/scan.png)
 */

example(of: "scan & buffer") {
    /*
    let disposeBag = DisposeBag()
    Observable.of(10, 100, 1000).scan(1, accumulator: { (aggregateValue, newValue) -> Int in
        aggregateValue + newValue
    }).subscribe(onNext: {
        print($0)
    }).disposed(by: disposeBag)
 */
    let disposeBag = DisposeBag()
    let dartScore = PublishSubject<Int>()
    
    dartScore
        .scan(501, accumulator: -)
        .buffer(timeSpan: 0.0, count: 3, scheduler: MainScheduler.instance)
        .map {
            print($0, "=>", terminator: "")
            return $0.reduce(0, +)
        }
        .map {
            max($0, 0)
        }
        .subscribe(onNext: {
            print($0)
        })
        .disposed(by: disposeBag)
    
    dartScore.onNext(13)
    dartScore.onNext(300)
    dartScore.onNext(100)
    dartScore.onNext(100)
    
}

example(of: "reduce") {
    let disposeBag = DisposeBag()
    Observable.from([10, 100, 1000]).reduce(1, accumulator: { (aggregateValue, newValue) -> Int in
        aggregateValue + newValue
    }).subscribe(onNext: {
        print($0)
    }).disposed(by: disposeBag)
}
