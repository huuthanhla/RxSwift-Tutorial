//
//  ViewController.swift
//  raywenderlic-tutorial
//
//  Created by Zorot on 5/2/18.
//  Copyright © 2018 Zorot. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class ViewController: UIViewController {
    
    var filterKey = BehaviorSubject<String?>(value: nil)
    let bag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        filterKey.skip(1).subscribe(onNext: { key in
            print("ViewController: \(key ?? "nil")")
        }).disposed(by: bag)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ViewController1", var vc1 = segue.destination as? ViewController1 {
            vc1.filterKey = self.filterKey
        } else if segue.identifier == "ViewController2", var vc2 = segue.destination as? ViewController2 {
            vc2.filterKey = self.filterKey
        }
    }

}

