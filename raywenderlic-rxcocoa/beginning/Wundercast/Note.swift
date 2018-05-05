//
//  Note.swift
//  Wundercast
//
//  Created by Zorot on 5/4/18.
//  Copyright © 2018 Razeware LLC. All rights reserved.
//

import Foundation

//MARK: - catchErrorJustReturn
/*
 The catchErrorJustReturn operator will be explained later in this book. It’s required to prevent the observable from being disposed when you receive an error from the API. For instance, an invalid city name returns a 404 as an error for NSURLSession. In this case, you want to return an empty value so the app won’t stop working if it encounters an error.
 */

//MARK:- bind(to:)
/*
 The fundamental function of (chức năng cơ bản của) binding is bind(to:), and to bind an observable to another entity it's required that the receiver conforms to ObserverType
 
 It's important to remember that bind(to:) can be used also for other purposes (có thể được sử dụng cho các mục đích khác), not just to bind user interfaces to the underlaying (cơ bản) data
 To summarize, the function bind(to:) is a special and tailored (được điều chỉnh) version of function subscribe(); there are no side effects or special cases when calling bind(to:)
 */


//MARK: - ControlProperty and ControlEvent
/*
 ControlProperty is not new; you used it just a little while ago to bind the data to the
 correct user interface component using the dedicated rx extension.
 
 ControlEvent is used to listen for a certain event of the UI component, like the press of the “Return” button on the keyboard while editing a text field. A control event is available if the component uses UIControlEvents to keep track of its current status.
 */

//MARK: - Driver

/*
 Driver is a special observable with the same constraints as explained before, so it can’t error out. All processes are ensured to execute on the main thread, which avoids making UI changes on background threads.
 
 • asDriver(onErrorDriveWith:): With this function, you can handle the error manually and return a new sequence generated for this purpose only.
 • asDriver(onErrorRecover:): Can be used alongside (bên cạnh) another existing Driver. This will come in play to recover the current Driver that just encountered (đã gặp) an error.

 */
