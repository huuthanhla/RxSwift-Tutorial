//
//  Utils.swift
//  RxSwift-Books
//
//  Created by Zorot on 4/30/18.
//  Copyright © 2018 Zorot. All rights reserved.
//

import Foundation
import RxSwift

public func example(of description: String, action: () -> Void) {
    print("\n--- Example of:", description, "---")
    action()
}

//MARK: - Helper functions
public enum FileReadError: Error {
    case fileNotFound, unreadable, encodingFailed
}

public func loadText(from name: String) -> Single<String> {
    return Single.create { single in
        let disposable = Disposables.create()
        guard let path = Bundle.main.path(forResource: name, ofType: "txt") else {
            single(.error(FileReadError.fileNotFound))
            return disposable
        }
        guard let data = FileManager.default.contents(atPath: path) else {
            single(.error(FileReadError.unreadable))
            return disposable
        }
        guard let contents = String(data: data, encoding: .utf8) else {
            single(.error(FileReadError.encodingFailed))
            return disposable
        }
        single(.success(contents))
        return disposable
    }
}
