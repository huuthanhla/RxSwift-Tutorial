//
//  ViewController2.swift
//  raywenderlic-tutorial
//
//  Created by Zorot on 5/7/18.
//  Copyright © 2018 Zorot. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class ViewController2: UIViewController {
    
    var filterKey = BehaviorSubject<String?>(value: nil)

    @IBOutlet weak var textField: UITextField!
    
    let bag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        filterKey.skip(1).subscribe(onNext: { key in
            print("ViewController2: \(key ?? "nil")")
        }).disposed(by: bag)

        self.textField.rx
            .text
            .bind(to: self.filterKey).disposed(by: bag)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
