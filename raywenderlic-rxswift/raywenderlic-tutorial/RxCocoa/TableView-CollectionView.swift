//
//  TableView-CollectionView.swift
//  raywenderlic-tutorial
//
//  Created by Zorot on 5/6/18.
//  Copyright © 2018 Zorot. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class TableViewCollectionView {
    @IBOutlet var tableView: UITableView!
    let disposeBag = DisposeBag()
    
    //MARK: - Simple tableview
    func bindSimpleTableView() {
        
        let cities = Observable.of(["Lisbon", "Copenhagen", "London", "Madrid",
                                    "Vienna"])
        cities
            .bind(to: tableView.rx.items) {
                (tableView: UITableView, index: Int, element: String) in
                let cell = UITableViewCell(style: .default, reuseIdentifier:
                    "cell")
                cell.textLabel?.text = element
                return cell }
            .disposed(by: disposeBag)
        
        tableView.rx
            .modelSelected(String.self)
            .subscribe(onNext: { model in
                print("\(model) was selected")
            })
            .disposed(by: disposeBag)
        
        /*
         • modelSelected(_:), modelDeselected(_:), itemSelected, itemDeselected fire on item selection
         • itemAccessoryButtonTapped fire on accessory button tap
         • itemInserted, itemDeleted, itemMoved fire on events callbacks in table edit mode
         • willDisplayCell, didEndDisplayingCell fire every time related UITableViewDelegate callbacks fire.
         */
    }
    
    //MARK: - Multiple cell types
    
    func bindMultipleCellType() {
        //fake
        class TextCell: UITableViewCell {
            let titleLabel: UILabel = UILabel()
        }
        
        class ImagesCell: UITableViewCell {
            let leftImage: UIImageView = UIImageView()
            let rightImage: UIImageView = UIImageView()
        }
        
        
        enum MyModel {
            case text(String)
            case pairOfImages(UIImage, UIImage)
        }
        
        let observable = Observable<[MyModel]>.just([
            .text("Paris"),
            .pairOfImages(UIImage(named: "EiffelTower.jpg")!, UIImage(named:
                "LeLouvre.jpg")!),
            .text("London"),
            .pairOfImages(UIImage(named: "BigBen.jpg")!, UIImage(named:
                "BuckinghamPalace.jpg")!)
            ])
        observable.bind(to: tableView.rx.items) { (tableView: UITableView, index: Int, element: MyModel) in
            let indexPath = IndexPath(item: index, section: 0)
            switch element {
            case .text(let title):
                let cell = tableView.dequeueReusableCell(withIdentifier: "titleCell",
                                                         for: indexPath) as! TextCell
                cell.titleLabel.text = title
                return cell
            case .pairOfImages(let firstImage, let secondImage):
                let cell = tableView.dequeueReusableCell(withIdentifier:
                    "pairOfImagesCell", for: indexPath) as! ImagesCell
                cell.leftImage.image = firstImage
                cell.rightImage.image = secondImage
                return cell
            }
            }
            .disposed(by: disposeBag)
    }
    
    //MARK: - RxDataSources
}
