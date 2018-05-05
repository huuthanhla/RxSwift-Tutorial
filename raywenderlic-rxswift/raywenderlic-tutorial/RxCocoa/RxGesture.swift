//
//  RxGesture.swift
//  raywenderlic-tutorial
//
//  Created by Zorot on 5/6/18.
//  Copyright © 2018 Zorot. All rights reserved.
//

import Foundation
import RxGesture


fileprivate func noteRxGesture() {
    
    //MARK: - Attaching gestures
    /*RxGesture makes it dead simple to attach a gesture to a view:
    view.rx.tapGesture()
        .when(.recognized)
        .subscribe(onNext: { _ in
            print("view tapped")
        })
        .disposed(by: disposeBag)
     */
    //When you want to get rid of the recognizer, simply call dispose() on the Disposable object returned by the subscription.
    
    //MARK: - attach multiple gestures at once
    /*
    view.rx.anyGesture(.tap(), .longPress())
        .when(.recognized)
        .subscribe(onNext: { [weak view] gesture in
            if let tap = gesture as? UITapGestureRecognizer {
                print("view was tapped at \(tap.location(in: view!))")
            } else {
                print("view was long pressed")
            }
        })
        .disposed(by: disposeBag)
     */
    
    /*
     NOTE:
     The when(_:...) operator above lets you filter events based on the recognizer state to avoid processing events you’re not interested in.
     On iOS, the gesture extensions of UIView are:
     rx.tapGesture(),
     rx.swipeGesture(_:),
     rx.longPressGesture(),
     rx.screenEdgePanGesture(edges:),
     rx.pinchGesture(),
     rx.panGesture() and
     rx.rotationGesture()
     
     Swipe and Screen Edge Pan gestures
     require you to provide parameters to indicate the expected swipe direction or the
     screen edge for the recognizer to detect the gesture:
 
    view.rx.screenEdgePanGesture(edges: [.top, .bottom])
        .when(.recognized)
        .subscribe(onNext: { recognizer in
            // gesture was recognized
        })
        .disposed(by: disposeBag)
    */
    
    
    //MARK: - Current location
    /*
     Any gesture observable can be transformed to an observable of the location in the view of your choice with
     asLocation(in:), saving you from doing it manually:
 
    view.rx.tapGesture()
        .when(.recognized)
        .asLocation(in: .window)
        .subscribe(onNext: { location in
            // you now directly get the tap location in the window
        })
        .disposed(by: disposeBag)
    */
    
    //MARK: - Pan gestures
    /*
     When creating a pan gesture observable with the rx.panGesture() reactive extension,
     use the asTranslation(in:) operator to transform events and obtain a tuple of current translation and velocity.
     The operator lets you specify which of the gestured view, superview, window or any other views you want to obtain the relative translation for.
 
    view.rx.panGesture()
        .asTranslation(in: .superview)
        .subscribe(onNext: { translation, velocity in
            print("Translation=\(translation), velocity=\(velocity)")
        })
        .disposed(by: disposeBag)
        */
    
    //MARK: - Rotation gestures
    /*
    view.rx.rotationGesture()
        .asRotation()
        .subscribe(onNext: { rotation, velocity in
            print("Rotation=\(rotation), velocity=\(velocity)")
        })
        .disposed(by: disposeBag)
     */
    
    //MARK:- Automated view transform
    /*
     More complex interactions, such as the pan/pinch/rotate combination gesture in MapView,
     can be fully automated with the help of the transformGestures() reactive extension of UIView:
 
    view.rx.transformGestures()
        .asTransform()
        .subscribe(onNext: { [unowned view] (transform, velocity) in
            view.transform = transform
        })
        .disposed(by: disposeBag)
    */
    
    
    //MARK: - Advanced usage
    /*
    let panGesture = view.rx.panGesture()
        .share(replay: 1, scope: .whileConnected)
    panGesture
        .when(.changed)
        .asTranslation()
        .subscribe(onNext: { [unowned view] translation, _ in
            view.transform = CGAffineTransform(translationX: translation.x,
                                               y: translation.y)
        })
        .disposed(by: stepBag)
    panGesture
        .when(.ended)
        .subscribe(onNext: { _ in
            print("Done panning")
        })
        .disposed(by: stepBag)
 */
}
