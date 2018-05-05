//
//  Action.swift
//  raywenderlic-tutorial
//
//  Created by Zorot on 5/6/18.
//  Copyright © 2018 Zorot. All rights reserved.
//

import Foundation
import Action
import RxCocoa
import RxSwift
/*
 • A trigger event signals that it’s time to do something.
 • A task is performed.
 • Immediately, later (or maybe never!), some value results from performing this task.
 
 In the middle sits the Action object. It does the following:
 • Provides an inputs observer to bind observable sequences to. You can also manually
 trigger new work.
 • Can observe an Observable<Bool> to determine its “enabled” status (in addition to whether it’s currently executing).
 • Calls your factory closure which performs / starts the work and returns an observable of results.
 • Exposes an elements observable sequence of all work results (a flatMap of all work observables).
 • Gracefully handles errors emitted by work observables.
 
 */
var button = UIButton()
let loginButton = UIButton()
let loginField = UITextField()
let passwordField = UITextField()
fileprivate let disposeBag = DisposeBag()
fileprivate func createAction() {
    
    //MARK: - Simple example
    /*
     The simplest example of an action takes no input,
     performs some work and completes without producing data:
     */
    let buttonAction: Action<Void, Void> = Action {
        print("Doing some work")
        return Observable.empty()
    }
    button.rx.action = buttonAction
    
    //MARK: - action which takes credentials, performs a network request
    let loginAction: Action<(String, String), Bool> = Action { credentials in
        let (login, password) = credentials
        print("login: \(login), pass: \(password)")
        // loginRequest returns an Observable<Bool>
        //return networkLayer.loginRequest(login, password)
        return Observable.empty()
    }
    let loginPasswordObservable =
        Observable.combineLatest(loginField.rx.text, passwordField.rx.text) {
            ($0, $1) }
    /*
     loginButton
     .withLatestFrom(loginPasswordObservable)
     .bind(to: loginAction.inputs)
     .disposed(by: disposeBag)
     */
    loginAction.elements
        .filter { $0 } // only keep "true" values
        .take(1)       // just interested in first successful login
        .subscribe({_ in
            // login complete, push the next view controller
        })
        .disposed(by: disposeBag)
    
    /*
     Errors get a special treatment to avoid breaking your subscriber sequences. There are
     two kinds of errors:
     • notEnabled - the action is already executing or disabled, and
     • underlyingError(error) - an error emitted by the underlying sequence.
     
     loginAction
     .errors
     .subscribe(onError: { error in
     if case .underlyingError(let err) = error {
     // update the UI to warn about the error
     } })
     .disposed(by: disposeBag)
     */
    
    
    //MARK:- Passing work items to cells
    /*
     Action helps solve a common problem: how to connect buttons in table view cells.
     Action to the rescue! When configuring a cell, you assign an action to a button. This way you don’t need to put actual work inside your cell subclasses, helping enforce a clean separation — even more important so if you’re using an MVVM architecture.
 
    observable.bind(to: tableView.rx.items) {
        (tableView: UITableView, index: Int, element: MyModel) in
        let cell = tableView.dequeueReusableCell(withIdentifier: "buttonCell",
                                                 for: indexPath)
        cell.button.rx.action = CocoaAction { [weak self] in
            // do something specific to this cell here
            return .empty()
        }
        return cell }
        .disposed(by: disposeBag)
    */
    
    //MARK: - Manual execution
    /*
    To manually execute an action, call its execute(_:) function, passing it an element of the action’s Input type:
    
    loginAction
        .execute(("john", "12345"))
        .subscribe(onNext: {
            // handle return of action execution here
        })
        .disposed(by: disposeBag)
     
     */
}
