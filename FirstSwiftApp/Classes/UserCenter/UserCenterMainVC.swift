//
//  UserCenterMainVC.swift
//  FirstSwiftApp
//
//  Created by weijieMac on 2018/8/21.
//  Copyright © 2018年 Mac. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

class UserCenterMainVC: RootVC {
    
    lazy var tableview = { () -> UITableView in
        let tab = UITableView.init(frame: screenFrame, style: .grouped)
        tab.top = 20
        tab.height -= tabbarHeight
        tab.height -= 20
        tab.register(UITableViewCell.self, forCellReuseIdentifier: "musicCell")
        tab.backgroundColor = UIColor.purple
//        tab.tableHeaderView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: 0, height: CGFloat.leastNormalMagnitude))
//        tab.dataSource = self as UITableViewDataSource
        tab.delegate = self as UITableViewDelegate
        return tab
    }()
    
    let musicListViewModel = RxUIExerciseModel()
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.cyan
        self.view.addSubview(self.tableview)
        
        musicListViewModel.data
            .bind(to: tableview.rx.items(cellIdentifier: "musicCell")) { _, music, cell in
                cell.textLabel?.text = music.name
        }.disposed(by: disposeBag)
        
        tableview.rx.modelSelected(RxUIExercise.self).subscribe(onNext: { model in
            let className = model.name + "VC"
            let nameSpace = Bundle.main.infoDictionary!["CFBundleExecutable"]
            guard let ns = nameSpace as? String else {
                return
            }
            let myClass: AnyClass? = NSClassFromString(ns + "." + className)
            guard let vcClass = myClass as? UIViewController.Type else {
                return
            }
            let vc = vcClass.init()
            self.navigationController?.pushViewController(vc, animated: true)
            
        }).disposed(by: disposeBag)
    }
}

extension UserCenterMainVC : UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.01
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView.init(frame: CGRect.init(x: 0, y: 0, width: 0, height: 0))
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}

extension UserCenterMainVC : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell.init()
        cell.backgroundColor = UIColor.blue
        return cell
    }
}

struct RxUIExerciseModel {
    let data = Observable.just([
        RxUIExercise(name: "RxLabel"),
        RxUIExercise(name: "RxTextField"),
        RxUIExercise(name: "RxButton"),
        RxUIExercise(name: "RxSwitch"),
        RxUIExercise(name: "RxSlider"),
        RxUIExercise(name: "RxTwoWayBinding"),
        RxUIExercise(name: "RxGestureRecognizer"),
        RxUIExercise(name: "RxDatePicker"),
        RxUIExercise(name: "RxTableView"),
        RxUIExercise(name: "RxTableViewDataSource")
        ])
}

struct RxUIExercise : CustomStringConvertible {
    let name   : String
    init(name:String) {
        self.name = name
    }
    
    var description : String {
        return "name:\(name)"
    }
    
}
