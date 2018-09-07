//
//  RxSliderVC.swift
//  FirstSwiftApp
//
//  Created by weijieMac on 2018/9/6.
//  Copyright © 2018年 Mac. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

class RxSliderVC : RootVC {
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configNaviView(title: "RxSlider")
        
//        unitOne()
        unitTwo()
    }
    
    //UISlider
    func unitOne() {
        let slider = UISlider(frame: CGRect(x: 50, y: naviHeight+20, width: 200, height: 30))
        let label = UILabel(frame: CGRect(x: 0, y: slider.bottom+20, width: screenWidth, height: 30))
        
        self.view.addSubview(slider)
        self.view.addSubview(label)
        
        let observer = slider.rx.value
            .map{"当前值为:\($0)"}
            
        observer.subscribe( onNext:{
                print("\($0)")
//                label.text = $0
            })
            .disposed(by: disposeBag)
        
        //绑定可以写在subscribe中，但是那样就变成了set方法，而不是绑定
        observer.bind(to: label.rx.text).disposed(by: disposeBag)
    }
    
    //UIStepper
    func unitTwo() {
        let slider = UISlider(frame: CGRect(x: 50, y: naviHeight+20, width: 200, height: 30))
        let stepper = UIStepper(frame: CGRect(x: 50, y: slider.bottom+20, width: 100, height: 30))
        let label = UILabel(frame: CGRect(x: 0, y: stepper.bottom+20, width: screenWidth, height: 30))
        self.view.addSubview(slider)
        self.view.addSubview(stepper)
        self.view.addSubview(label)
        
        let observer = stepper.rx.value.map{"当前值为:\($0)"}
        observer.subscribe(onNext:{
            print("\($0)")
        }).disposed(by: disposeBag)
        
        observer.bind(to: label.rx.text)
            .disposed(by: disposeBag)
        
        stepper.rx.value.map{Float($0/10)}
            .bind(to: slider.rx.value)
            .disposed(by: disposeBag)
    }
}
