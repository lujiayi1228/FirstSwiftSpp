//
//  RxLabelVC.swift
//  FirstSwiftApp
//
//  Created by weijieMac on 2018/9/4.
//  Copyright © 2018年 Mac. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class RxLabelVC: RootVC {
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configNaviView(title: "RxLabel")
        view.backgroundColor = whiteColor
        
        let label = UILabel(frame: CGRect(x: 20, y: 40, width: 300, height: 100))
        self.view.addSubview(label)
        
        //创建一个计时器(每0.1秒发送一个索引数)
        let timer = Observable<Int>.interval(0.1, scheduler: MainScheduler.instance)
        
        //将已经过去的时间格式化成想要的字符串，并绑定到label上
        timer.map{String(format: "%0.2d:%0.2d.%0.1d",
                         arguments:[($0 / 600)%600,($0 % 600)/10,$0 % 10])}
             .bind(to: label.rx.text)
             .disposed(by: disposeBag)
        
        let attLabel = UILabel(frame: CGRect(x: 20, y: 150, width: 300, height: 100))
        self.view.addSubview(attLabel)
        
        //此处可以共用一个Observable
//        let timerr = Observable<Int>.interval(0.1, scheduler: MainScheduler.instance)
        
        timer.map(formatTimeInterval)
              .bind(to: attLabel.rx.attributedText)
              .disposed(by: disposeBag)
    }
    
    func formatTimeInterval(ms: Int) -> NSMutableAttributedString {
        let string = String(format: "%0.2d:%0.2d.%0.1d",
                            arguments: [(ms / 600)%600,(ms % 600)/10,ms % 10])
        let attributeString = NSMutableAttributedString(string: string)
        attributeString.addAttribute(NSAttributedStringKey.font, value: UIFont(name: "HelveticaNeue-Bold", size: 16)!, range: NSMakeRange(0, 5))
        attributeString.addAttribute(NSAttributedStringKey.foregroundColor, value: whiteColor, range: NSMakeRange(0, 5))
        attributeString.addAttribute(NSAttributedStringKey.backgroundColor, value: UIColor.orange, range: NSMakeRange(0, 5))
        
        return attributeString
    }
    
}
