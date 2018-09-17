//
//  RxTableViewVC.swift
//  FirstSwiftApp
//
//  Created by weijieMac on 2018/9/7.
//  Copyright © 2018年 Mac. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift
import UIKit

class RxTableViewVC: RootVC {
    
    let disposeBag = DisposeBag()
    
    lazy var tableView : UITableView = {
        let tab = UITableView(frame: CGRect(x: 0, y: naviHeight, width: self.view.width, height: screenHeight-naviHeight), style: .plain)
        tab.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        return tab
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configNaviView(title: "RxTableViewVC")
        
        self.view.addSubview(self.tableView)
        
        unitOne()
    }

    func unitOne() {
        let items = Observable.just([
            "文本输入框的用法",
            "开关按钮的用法",
            "进度条的用法",
            "文本标签的用法"
            ])
        
        items.bind(to: tableView.rx.items) { (tableView, row , element) in
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")!
            cell.textLabel?.text = "\(row):\(element)"
            cell.accessoryType = .detailButton
            return cell
        }.disposed(by: disposeBag)
        
        
        
        //选中事件
        self.tableView.rx.itemSelected.subscribe(onNext: { indexPath in
            print("选中项的indexPath是:\(indexPath)")
        }).disposed(by: disposeBag)
        
        self.tableView.rx.modelSelected(String.self).subscribe(onNext: { item in
            print("选中项的标题是:"+item)
        }).disposed(by: disposeBag)
        
        //取消选中事件,变更选中时,前一个cell状态会变更为取消选中
        tableView.rx.itemDeselected.subscribe(onNext: { indexPath in
            print("\(indexPath)取消选中")
        }).disposed(by: disposeBag)
        
        tableView.rx.modelDeselected(String.self).subscribe(onNext: { item in
            print(item + "取消选中")
        }).disposed(by: disposeBag)
        
        //cell删除事件，貌似只是响应了删除事件，却没有对数据源做处理，故暂不会真的删除，如手动调用tableview删除cell，将会报错
//        tableView.setEditing(true, animated: true)
        
//        tableView.rx.itemDeleted.subscribe(onNext:{ indexPath in
//            print("删除\(indexPath)")
//        }).disposed(by: disposeBag)
//
//        tableView.rx.modelDeleted(String.self).subscribe(onNext: { item in
//            print( item + "已删除")
//        }).disposed(by: disposeBag)
        
        //将两个信号绑定后统一处理，结果同上
//        Observable.zip(tableView.rx.itemDeleted ,tableView.rx.modelDeleted(String.self))
//            .bind{ indexPath, item in
//                print("~~删除项的indexpath：\(indexPath)\n~~删除项的item:\(item)")
//        }.disposed(by: disposeBag)
        
        //移动cell，前提是tableview可编辑
//        tableView.isEditing = true //tableView.setEditing(true, animated: true)
        tableView.rx.itemMoved.subscribe(onNext:{ sourceIndexPath, destinationIndex in
            print("cell原来的位置:\(sourceIndexPath)\ncell的新位置:\(destinationIndex)")
        }).disposed(by: disposeBag)
        
        //cell插入事件，需要通过tableview代理设置editstyle来激活加号的显现
//        tableView.rx
        tableView.rx.itemInserted.subscribe(onNext: { indexPath in
            print("插入项的indexpath为:\(indexPath)")
        }).disposed(by: disposeBag)
        
        //cell尾部附件Accessory（图标i）点击事件响应 //需要设置cell的accessorytype 为detail
        tableView.rx.itemAccessoryButtonTapped.subscribe(onNext:{ indexPath in
            print("点击Accessory:\(indexPath)")
        }).disposed(by: disposeBag)
        
        //cell将要显示出来的响应
        tableView.rx.willDisplayCell.subscribe(onNext:{cell, indexPath in
            print("\(indexPath)即将显示:\(cell)")
        }).disposed(by: disposeBag)
        
        
    }
}
