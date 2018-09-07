//
//  RxDatePickerVC.swift
//  FirstSwiftApp
//
//  Created by weijieMac on 2018/9/6.
//  Copyright © 2018年 Mac. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

class RxDatePickerVC: RootVC {
    
    //剩余时间
    let leftTime = Variable(TimeInterval(180))
    //当前倒计时是否结束
    let countDownStopped = Variable(true)
    
    let disposeBag = DisposeBag()
    
    lazy var dateFormatter : DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy年MM月dd日 HH:mm"
        return formatter
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configNaviView(title: "RxDatePicker")
        
//        unitOne()
        unitTwo()
    }
    
    //datePicker
    func unitOne() {
        let datePicker = UIDatePicker(frame: CGRect(x: 0, y: naviHeight, width: screenWidth, height: 300))
        let label = UILabel(frame: CGRect(x: 0, y: datePicker.bottom, width: screenWidth, height: 30))
        label.textAlignment = .center
        
        self.view.addSubview(datePicker)
        self.view.addSubview(label)
        
        datePicker.rx.date
            .map{ [weak self] in
                "当前选择时间: \(self!.dateFormatter.string(from: $0))"
        }
            .bind(to: label.rx.text)
            .disposed(by: disposeBag)
    }
    
    //倒计时
    func unitTwo() {
        let ctimer = UIDatePicker(frame: CGRect(x: 0, y: naviHeight, width: screenWidth, height: 300))
        ctimer.datePickerMode = .countDownTimer
        
        let btn = UIButton(type: .system)
        btn.frame = CGRect(x: 0, y: ctimer.bottom + 20, width: screenWidth, height: 30)
        btn.setTitleColor(UIColor.red, for: .normal)
        btn.setTitleColor(UIColor.darkGray, for: .disabled)
        
        self.view.addSubview(ctimer)
        self.view.addSubview(btn)
        
        //双向绑定，添加主线程是为了解决第一次波动表盘时不触发值改变事件的问题
        DispatchQueue.main.async {
            _ = ctimer.rx.countDownDuration <-> self.leftTime
        }
        
        Observable.combineLatest(leftTime.asObservable(), countDownStopped.asObservable()) {
            leftTimeValue, countDownStoppedValue in
            
            if countDownStoppedValue {
                return "开始"
            }else {
                return "倒计时开始，还有\(Int(leftTimeValue))秒..."
            }
        }
            .bind(to: btn.rx.title())
            .disposed(by: disposeBag)
        
        countDownStopped.asDriver().drive(ctimer.rx.isEnabled).disposed(by: disposeBag)
        countDownStopped.asDriver().drive(btn.rx.isEnabled).disposed(by: disposeBag)
        
        btn.rx.tap
            .bind{ [weak self] in
                self?.startClicked()
        }
            .disposed(by: disposeBag)
    }
    
    
    func startClicked() {
        countDownStopped.value = false
        
        //目前此方法倒计时结束时控制台会出现rxswift警告，大致意思是有循环的问题，需要注意。可能与版本有关
        Observable<Int>.interval(1, scheduler: MainScheduler.instance)
            .takeUntil(countDownStopped.asObservable().filter{$0})
            .subscribe{ event in
                self.leftTime.value -= 1
                if self.leftTime.value == 0 {
                    print("倒计时结束")
                    self.countDownStopped.value = true
                    self.leftTime.value = 180
                }
        }.disposed(by: disposeBag)
    }
}
