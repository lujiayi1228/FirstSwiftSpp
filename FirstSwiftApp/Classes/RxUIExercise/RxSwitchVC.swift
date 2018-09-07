//
//  RxSwitchVC.swift
//  FirstSwiftApp
//
//  Created by weijieMac on 2018/9/5.
//  Copyright © 2018年 Mac. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

class RxSwitchVC: RootVC {
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configNaviView(title: "RxSwitch")
        
//        unitOne()
//        unitTwo()
//        unitThree()
        unitFour()
    }
    
    //绑定switch开关
    func unitOne() {
        let switchBtn = UISwitch(frame: CGRect(x: 20, y: naviHeight+20, width: 100, height: 30))
        let label = UILabel(frame: CGRect(x: 0, y: switchBtn.bottom+20, width: screenWidth, height: 30))
        
        self.view.addSubview(switchBtn)
        self.view.addSubview(label)
        
        switchBtn.rx.isOn
            .map{"当前开关状态:\($0)"}
            .bind(to: label.rx.text)
            .disposed(by: disposeBag)
        
        switchBtn.rx.isOn.subscribe(onNext:{
            print("当前开关状态:\($0)")
            label.backgroundColor = $0 ? UIColor.cyan : whiteColor
        }).disposed(by: disposeBag)
    }
    
    //UISegmentedControl
    func unitTwo() {
        let segment = UISegmentedControl(items: ["First","Second","Third"])
        segment.frame = CGRect(x: 20, y: naviHeight+20, width: 200, height: 30)
        segment.selectedSegmentIndex = 0
        self.view.addSubview(segment)
        
        segment.rx.selectedSegmentIndex.subscribe(onNext: {
            print("当前索引:\($0)")
        }).disposed(by: disposeBag)
    }
    
    //UISegmentedControl绑定数据,  PS:此处view.rx.backgroundColor是自定义的reactive扩展
    func unitThree() {
        let segment = UISegmentedControl(items: ["First","Second","Third"])
        segment.frame = CGRect(x: 20, y: naviHeight+20, width: 200, height: 30)
        segment.selectedSegmentIndex = 0
        self.view.addSubview(segment)
        
        let colorView = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        colorView.center = self.view.center
        colorView.backgroundColor = UIColor.purple
        self.view.addSubview(colorView)
        
        let observable : Observable<UIColor> = segment.rx.selectedSegmentIndex.asObservable().map{
            let colors = [UIColor.purple,UIColor.cyan,UIColor.brown]
            return colors[$0]
        }

        observable.bind(to: colorView.rx.backgroundColor)
            .disposed(by: disposeBag)
    }
    
    //UIActivityIndicatorView 与 UIApplication
    func unitFour() {
        let switchBtn = UISwitch(frame: CGRect(x: 20, y: naviHeight+20, width: 100, height: 30))
        let activity = UIActivityIndicatorView(frame: CGRect(x: 100, y: switchBtn.bottom+20, width: 30, height: 30))
        activity.activityIndicatorViewStyle = .gray
        
        self.view.addSubview(switchBtn)
        self.view.addSubview(activity)
        
        switchBtn.rx.isOn
            .bind(to: activity.rx.isAnimating)
            .disposed(by: disposeBag)
        
        //状态栏菊花
        switchBtn.rx.value
            .bind(to: UIApplication.shared.rx.isNetworkActivityIndicatorVisible)
            .disposed(by: disposeBag)
    }
    
}
