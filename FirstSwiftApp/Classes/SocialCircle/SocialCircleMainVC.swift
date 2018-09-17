//
//  SocialCircleMainVC.swift
//  FirstSwiftApp
//
//  Created by weijieMac on 2018/8/21.
//  Copyright © 2018年 Mac. All rights reserved.
//

import Foundation
import UIKit
import RxCocoa
import RxSwift

class SocialCircleMainVC: RootVC {
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configNaviView(title: "圈子")
        var a = "aaa"
        var b = "bbb"
        print("a = \(a),b = \(b)")
        
        swapTwoVaule(&a, &b)
        print("a = \(a),b = \(b)")
        
        let label = UILabel.init(frame: CGRect.init(x: 0, y: 0, width: screenWidth, height: 100))
        label.backgroundColor = UIColor.blue
        label.center = self.view.center
        label.textColor = UIColor.red
        label.text = "abc"
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 15)
        self.view.addSubview(label)
        
        
        
//        let observer: Binder<Int> = Binder(label) { (view,text) in
//            view.text = "\(text)"
//        }
        
        let observable = Observable<Int>.interval(1.0/60, scheduler: MainScheduler.instance)
        
        observable
            .map{CGFloat($0)}
            .bind(to: label.rx.fontSize)
            .disposed(by: disposeBag)
    }

}

extension Reactive where Base : UILabel {
    public var fontSize : Binder<CGFloat> {
        return Binder(self.base) { label, fontSize in
            label.font = UIFont.systemFont(ofSize: fontSize)
        }
    }
}

func swapTwoVaule<NewType>(_ first: inout NewType ,_ second: inout NewType) {
    let abc = first
    first = second
    second = abc
}
