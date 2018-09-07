//
//  RxTableViewDataSourcesVC.swift
//  FirstSwiftApp
//
//  Created by weijieMac on 2018/9/7.
//  Copyright © 2018年 Mac. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift
import RxDataSources

class RxTableViewDataSourceVC: RootVC {
    
    let disposeBag = DisposeBag()
    
    lazy var tableView : UITableView = {
        let tab = UITableView(frame: CGRect(x: 0, y: naviHeight, width: screenWidth, height: screenHeight - naviHeight), style: .plain)
        tab.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        return tab
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configNaviView(title: "RxTableViewDataSource")
        
        self.view.addSubview(tableView)
        
//        unitOne()
        unitTwo()
    }
    
    //使用自带的section
    func unitOne() {
        let items = Observable.just([
            //数组个数 = section个数
//            SectionModel(model: "", items:[
//                "UILabel的用法",
//                "UIText的用法",
//                "UIButton的用法"
//                ])
            SectionModel(model: "基本控件", items: [
                "UILable的用法",
                "UIText的用法",
                "UIButton的用法"
                ]),
            SectionModel(model: "高级控件", items: [
                "UITableView的用法",
                "UICollectionViews的用法"
                ])

            ])
        
        let dataSource = RxTableViewSectionedReloadDataSource<SectionModel<String,String>>(configureCell: {
            (dataSource,tv,indexPath,element) in
            let cell = tv.dequeueReusableCell(withIdentifier: "Cell")!
            cell.textLabel?.text = "\(indexPath.row):\(element)"
            return cell
        })
        
        //设置区头标题
        dataSource.titleForHeaderInSection = { ds, index in
            return ds.sectionModels[index].model
        }
        
        items
            .bind(to: tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
    }
    
    //使用自定义section
    func unitTwo() {
        let sections = Observable.just([
            //数组个数 = section 个数
//            MySection(header: "", items: [
//                "UILabel的用法",
//                "UIText的用法",
//                "UIButton的用法"
//                ])
            MySection(header: "基本控件", items: [
                "UILable的用法",
                "UIText的用法",
                "UIButton的用法"
                ]),
            MySection(header: "高级控件", items: [
                "UITableView的用法",
                "UICollectionViews的用法"
                ])
            ])
        
        let dataSource = RxTableViewSectionedAnimatedDataSource<MySection>(
            configureCell: { ds, tv, ip , item in
                let cell = tv.dequeueReusableCell(withIdentifier: "Cell") ?? UITableViewCell(style: .default, reuseIdentifier: "Cell")
                cell.textLabel?.text = "\(ip.row):\(item)"
                return cell
            },
            //设置区头标题,亦可写在外面
            titleForHeaderInSection: { ds , index in
                return ds.sectionModels[index].header
            }
        )
        
        sections
            .bind(to: tableView.rx.items(dataSource: dataSource))
            .disposed(by:disposeBag)
    }
}

struct MySection {
    var header : String
    var items : [Item]
}

extension MySection : AnimatableSectionModelType {
    typealias Item = String
    
    var identity: String {
        return header
    }
    
    init(original: MySection, items: [Item]) {
        self = original
        self.items = items
    }
}



