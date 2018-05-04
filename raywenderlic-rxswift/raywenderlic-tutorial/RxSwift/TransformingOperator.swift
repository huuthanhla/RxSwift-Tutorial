//
//  TransformingOperator.swift
//  RxSwift-Books
//
//  Created by Zorot on 5/1/18.
//  Copyright © 2018 Zorot. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

fileprivate struct Student {
    var score: BehaviorSubject<Int>
}

class TransformingOperator {
    
    class func test() {
        //MARK: toArray()
        example(of: "toArray") {
            let disposeBag = DisposeBag()
            Observable.of("A", "B", "C")
                .toArray()
                .subscribe(onNext: {
                    print($0) })
                .disposed(by: disposeBag)
            
            //--- Example of: toArray ---
            //["A", "B", "C"]
        }
        
        //MARK: - map()
        example(of: "map") {
            let disposeBag = DisposeBag()
            let formatter = NumberFormatter()
            formatter.numberStyle = .spellOut
            Observable<NSNumber>.of(123, 4, 56)
                .map {
                    formatter.string(from: $0) ?? ""
                }
                .subscribe(onNext: {
                    print($0)
                })
                .disposed(by: disposeBag)
            
            /*
             --- Example of: map ---
             one hundred twenty-three
             four
             fifty-six
             */
        }
        
        example(of: "enumerated and map") {
            let disposeBag = DisposeBag()
            Observable.of(1, 2, 3, 4, 5, 6)
                .enumerated()
                .map { index, integer in
                    index > 2 ? integer * 2 : integer
                }
                .subscribe(onNext: {
                    print($0)
                })
                .disposed(by: disposeBag)
            /*
             --- Example of: enumerated and map ---
             1
             2
             3
             8
             10
             12
             */
        }
        
        //MARK: - flatMap
        example(of: "flatMap") {
            let disposeBag = DisposeBag()
            let ryan = Student(score: BehaviorSubject(value: 80))
            let charlotte = Student(score: BehaviorSubject(value: 90))
            let student = PublishSubject<Student>()
            student
                .flatMap { $0.score }
                .subscribe(onNext: {
                    print($0)
                })
                .disposed(by: disposeBag)
            
            student.onNext(ryan) // print: 80
            ryan.score.onNext(85) // print: 85
            student.onNext(charlotte) // print: 90
            ryan.score.onNext(95) // print: 95
            
            /*
             This is because flatMap keeps up with each and every observable it creates,
             one for each element added onto the source observable.
             Now change charlotte’s score by adding the following code,
             just to verify that both observables are being monitored and changes projected
             */
            charlotte.score.onNext(100) //print: 100
        }
        
        //MARK: -  flatMapLatest
        /*
         - flatMapLatest is actually a combination of two operators, map and switchLatest
         - flatMapLatest works just like flatMap to reach into an observable element to access its observable property,
           it applies a transform and projects the transformed value onto a new sequence for each element of the source observable.
         
         NOTE:
         - So you may be wondering when would you use flatMap for flatMapLatest?
           Probably the most common use case is using flatMapLatest with networking operations.
         - imagine that you’re implementing a type-ahead search. As the user types each letter, s, w, i, f, t,
           you’ll want to execute a new search and ignore results from the previous one. flatMapLatest is how you do that.
         */
        
        example(of: "flatMapLatest") {
            let disposeBag = DisposeBag()
            let ryan = Student(score: BehaviorSubject(value: 80))
            let charlotte = Student(score: BehaviorSubject(value: 90))
            let student = PublishSubject<Student>()
            student
                .flatMapLatest { $0.score }
                .subscribe(onNext: {
                    print($0)
                })
                .disposed(by: disposeBag)
            
            student.onNext(ryan) //print: 80
            ryan.score.onNext(85) //print: 85
            student.onNext(charlotte) //print: 90
            ryan.score.onNext(95) // It will not be printed out
            
            /*
             Changing ryan’s score here will have no effect. It will not be printed out. This is
             because flatMapLatest has already switched to the latest observable, for charlotte.
             */
            
            charlotte.score.onNext(100) // print: 100
            
        }
        
        //MARK: - materialize and dematerialize
        /*
         Observing events
         There may be times when you want to convert an observable into an observable of its events.
         One typical scenario where this is useful is when you do not have control over an observable
         that has observable properties, and you want to handle error events to avoid terminating outer sequences.
         */
        
        example(of: "materialize and dematerialize") {
            enum MyError: Error {
                case anError
            }
            let disposeBag = DisposeBag()
            let ryan = Student(score: BehaviorSubject(value: 80))
            let charlotte = Student(score: BehaviorSubject(value: 100))
            let student = BehaviorSubject(value: ryan)
            let studentScore = student
                .flatMapLatest { $0.score }
            studentScore
                .subscribe(onNext: {
                    print($0) })
                .disposed(by: disposeBag) // print: 80
            ryan.score.onNext(85) //print: 85
            ryan.score.onError(MyError.anError) // print: Unhandled error happened: anError
            ryan.score.onNext(90) // It will not be printed out
            student.onNext(charlotte) // It will not be printed out
            
            // because: studentScore observable terminates, as does the outer student observable.
            
        }
        
        /*
         Using the materialize operator, you can wrap each event emitted by an observable in an observable.
         */
        example(of: "materialize") {
            enum MyError: Error {
                case anError
            }
            let disposeBag = DisposeBag()
            let ryan = Student(score: BehaviorSubject(value: 80))
            let charlotte = Student(score: BehaviorSubject(value: 100))
            let student = BehaviorSubject(value: ryan)
            let studentScore = student
                .flatMapLatest { $0.score.materialize() } // it is now an Observable<Event<Int>>
            studentScore
                .subscribe(onNext: {
                    print($0) })
                .disposed(by: disposeBag) // print: next(80)
            ryan.score.onNext(85) //print: next(85)
            ryan.score.onError(MyError.anError) // print: error(anError)
            ryan.score.onNext(90) // It will not be printed out
            student.onNext(charlotte) // print: next(100)
            
        }
        
        /*
         However, now you’re dealing with events, not elements.
         That’s were dematerialize comes in. It will convert a materialized observable back into its original form.
         */
        
        example(of: "dematerialize") {
            enum MyError: Error {
                case anError
            }
            let disposeBag = DisposeBag()
            let ryan = Student(score: BehaviorSubject(value: 80))
            let charlotte = Student(score: BehaviorSubject(value: 100))
            let student = BehaviorSubject(value: ryan)
            let studentScore = student
                .flatMapLatest { $0.score.materialize() } // it is now an Observable<Event<Int>>
            studentScore
                .filter {
                    guard $0.error == nil else {
                        print($0.error!)
                        return false
                    }
                    return true
                }
                /* You use dematerialize to return the studentScore observable to its original form,
                   emitting scores and stop events, not events of scores and stop events. */
                .dematerialize()
                .subscribe(onNext: {
                    print($0) })
                .disposed(by: disposeBag) // print: 80
            ryan.score.onNext(85) //print: 85
            ryan.score.onError(MyError.anError) // print: anError
            ryan.score.onNext(90) // It will not be printed out
            student.onNext(charlotte) // print: 100
            
        }
        
        
        
    }
}


//MARK: - Transforming Operator in practice
fileprivate class ActivityController {
    private let repo = "ReactiveX/RxSwift"
    
    private let events = Variable<[Event]>([])
    private let bag = DisposeBag()
    private let eventsFileURL = cachedFileURL("events.plist")
    private let modifiedFileURL = cachedFileURL("modified.txt")
    private let lastModified = Variable<NSString?>(nil)
    
    fileprivate func fetchEvents(repo: String) {
        
        let response = Observable.from([repo])
            .map { urlString -> URL in
                return URL(string: "https://api.github.com/repos/\(urlString)/events")!
            }
            .map { [weak self] url -> URLRequest in
                var request = URLRequest(url: url)
                if let modifiedHeader = self?.lastModified.value {
                    request.addValue(modifiedHeader as String,
                                     forHTTPHeaderField: "Last-Modified")
                }
                return request
            }
            .flatMap { request -> Observable<(response: HTTPURLResponse, data: Data)> in
                return URLSession.shared.rx.response(request: request)
            }
            .share(replay: 1, scope: .whileConnected)
        
        response
            .filter { response, _ in
                return 200..<300 ~= response.statusCode
            }
            .map { _, data -> [[String: Any]] in
                guard let jsonObject = try? JSONSerialization.jsonObject(with: data, options: []),
                    let result = jsonObject as? [[String: Any]] else {
                        return []
                }
                return result
            }
            .filter { objects in
                return objects.count > 0
            }
            .map { objects in
                return objects.compactMap(Event.init)
            }
            .subscribe({ newEvents in
                //self?.processEvents(newEvents)
            })
            .disposed(by: bag)
        
        response
            .filter {response, _ in
                return 200..<400 ~= response.statusCode
            }
            .flatMap { response, _ -> Observable<NSString> in
                guard let value = response.allHeaderFields["Last-Modified"]  as? NSString else {
                    return Observable.empty()
                }
                return Observable.just(value)
            }
            .subscribe(onNext: { [weak self] modifiedHeader in
                guard let strongSelf = self else { return }
                strongSelf.lastModified.value = modifiedHeader
                try? modifiedHeader.write(to: strongSelf.modifiedFileURL, atomically: true,
                                          encoding: String.Encoding.utf8.rawValue)
            })
            .disposed(by: bag)
    }

}


func cachedFileURL(_ fileName: String) -> URL {
    return FileManager.default
        .urls(for: .cachesDirectory, in: .allDomainsMask)
        .first!
        .appendingPathComponent(fileName)
}




typealias AnyDict = [String: Any]

class Event {
    let repo: String
    let name: String
    let imageUrl: URL
    let action: String
    
    // JSON -> Event
    init?(dictionary: AnyDict) {
        guard let repoDict = dictionary["repo"] as? AnyDict,
            let actor = dictionary["actor"] as? AnyDict,
            let repoName = repoDict["name"] as? String,
            let actorName = actor["display_login"] as? String,
            let actorUrlString = actor["avatar_url"] as? String,
            let actorUrl  = URL(string: actorUrlString),
            let actionType = dictionary["type"] as? String
            else {
                return nil
        }
        
        repo = repoName
        name = actorName
        imageUrl = actorUrl
        action = actionType
    }
    
    // Event -> JSON
    var dictionary: AnyDict {
        return [
            "repo" : ["name": repo],
            "actor": ["display_login": name, "avatar_url": imageUrl.absoluteString],
            "type" : action
        ]
    }
}

//MARK: - share vs. shareReplay

/*
 in above example:
 - URLSession.rx.response(request:) sends your request to the server, and upon receiving the response,
   emits a .next event just once with the returned data, and then completes.
 - In this situation, if the observable completes and then you subscribe to it again,
   that will create a new subscription and will fire another identical request to the server.
 - To prevent situations like this, you use share(replay:, scope:).
   This operator keeps a buffer of the last replay emitted elements and feeds them to any newly subscribed observer.
   Therefore if your request has completed and a new observer subscribes to the shared sequence (via share(replay:, scope:)),
   it will immediately receive the response from the server that's being kept in the buffer.
 - There are two scopes available to choose from: .whileConnected and .forever.
   The former will buffer elements up to the point where it has no subscribers,
   and the latter will keep the buffered elements forever.
   That sounds nice, but consider the implications on how much memory is used by the app.
    + .forever: the buffered network response is kept forever. New subscribers get the buffered response.
    + .whileConnected: the buffered network response is kept until there are no more subscribers,
                       and is then discarded. New subscribers get a fresh network response.
 
 MARK: - NOTE: objects.flatMap(Event.init) and objects.map(Event.init)
 - diffirence between objects.flatMap(Event.init) and objects.map(Event.init):
 Event.init calls will return nil (init?(dictionary: AnyDict))
 so flatMap on those objects will remove any nil values, so you end up with an Observable that returns an array of Event objects (non-optional!).
 And since you removed the call to fatalError() in the Event.init function, your code is now safer.
 */





