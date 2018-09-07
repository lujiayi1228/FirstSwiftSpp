//
//  RxButtonVC.swift
//  FirstSwiftApp
//
//  Created by weijieMac on 2018/9/5.
//  Copyright © 2018年 Mac. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

class RxButtonVC: RootVC {
    
    let disposeBag = DisposeBag()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configNaviView(title: "RxButton")
        
//        unitOne()
//        unitTwo()
//        unitThree()
//        unitFour()
//        unitFive()
//        unitSix()
        unitSeven()
    }
    
    //绑定按钮点击方法
    func unitOne(){
        let button = UIButton(type: .custom)
        button.frame = CGRect(x: 40, y: naviHeight+20, width: 100, height: 30)
        button.backgroundColor = UIColor.orange
        button.setTitle("按钮", for: .normal)
        self.view.addSubview(button)
        
        //写法一
//        button.rx.tap.subscribe(onNext: { [weak self] in
//            self?.showMessage("unitOneClickAction")
//        }).disposed(by: disposeBag)
        
        //写法二
        button.rx.tap.bind{ [weak self] in
            self?.showMessage("unitOneClickAction")
        }.disposed(by: disposeBag)
    }
    
    //按钮标题的绑定
    func unitTwo(){
        let button = UIButton(type: .custom)
        button.frame = CGRect(x: 40, y: naviHeight+20, width: 100, height: 30)
        button.backgroundColor = UIColor.orange
        self.view.addSubview(button)
        
        let timer = Observable<Int>.interval(1, scheduler: MainScheduler.instance)
        timer.map{"计数:\($0)"}
            .bind(to: button.rx.title(for: .normal))
            .disposed(by: disposeBag)
    }
    
    //按钮富文本标题绑定
    func unitThree() {
        let button = UIButton(type: .custom)
        button.frame = CGRect(x: 40, y: naviHeight+20, width: 100, height: 30)
        button.backgroundColor = UIColor.orange
        self.view.addSubview(button)
        
        let timer = Observable<Int>.interval(1, scheduler: MainScheduler.instance)
        timer.map(formatTimeInterval)
            .bind(to: button.rx.attributedTitle(for: .normal))
            .disposed(by: disposeBag)
    }
    
    //按钮image绑定
    func unitFour() {
        let button = UIButton(type: .custom)
        button.frame = CGRect(x: 40, y: naviHeight+20, width: 100, height: 30)
        button.backgroundColor = UIColor.orange
        self.view.addSubview(button)
        
        let timer = Observable<Int>.interval(1, scheduler: MainScheduler.instance)
//        timer.map(changeButtonImage)
//            .bind(to: button.rx.image(for: .normal))
//            .disposed(by: disposeBag)
        
        //此方法同上，另，此方法中当只写了map方法，而未写后续绑定时，会报错，写完即可
        //Unable to infer complex closure return type; add explicit type to disambiguate
        timer.map({
            let imageName = $0%2 == 0 ? "sun_and_cloud_mini" : "sun_and_rain_mini"
            return UIImage(named: imageName)!
        }).bind(to: button.rx.image(for: .normal))
          .disposed(by: disposeBag)
    }
    
    //按钮backgroundImage绑定
    func unitFive(){
        let button = UIButton(type: .custom)
        button.frame = CGRect(x: 40, y: naviHeight+20, width: 100, height: 30)
        button.backgroundColor = UIColor.orange
        self.view.addSubview(button)
        
        Observable<Int>.interval(1, scheduler: MainScheduler.instance)
            .map({
                return UIImage(named: $0%2 == 0 ? "sun_and_cloud_mini" : "sun_and_rain_mini")
            })
            .bind(to: button.rx.backgroundImage(for: .normal))
            .disposed(by: disposeBag)
    }
    
    //switch 控制 button enable
    func unitSix(){
        let button = UIButton(type: .system)
        button.frame = CGRect(x: 40, y: naviHeight+20, width: 100, height: 30)
        button.setTitle("按钮", for: .normal)
        button.setTitleColor(UIColor.blue, for: .normal)
        self.view.addSubview(button)
        
        let switch1 = UISwitch(frame: button.frame)
        switch1.left = button.right + 20
        self.view.addSubview(switch1)
        
        button.rx.tap
            .bind{
                //这里应该可以再优化，完全使用绑定的概念实现
                switch1.isOn = !switch1.isOn
                button.isEnabled = switch1.isOn
            }
            .disposed(by: disposeBag)
        
        switch1.rx.isOn
            .bind(to: button.rx.isEnabled)
            .disposed(by: disposeBag)

    }
    
    func unitSeven() {
        var buttons : [UIButton] = []
        let whiteBG = creatImage(withColor: whiteColor)
        let blueBG = creatImage(withColor: UIColor.blue)
        
        
        for i in 0 ..< 3 {
            let button = UIButton(type: .custom)
            button.frame = CGRect(x: 10+110*i, y: Int(naviHeight+20), width: 100, height: 30)
            button.setTitle("按钮\(i)", for: .normal)
            button.setTitleColor(UIColor.blue, for: .normal)
            button.setTitleColor(whiteColor, for: .selected)
            button.setBackgroundImage(whiteBG, for: .normal)
            button.setBackgroundImage(blueBG, for: .selected)
            button.setBackgroundImage(whiteBG, for: .highlighted)
            button.layer.cornerRadius = 5
            button.layer.masksToBounds = true
            
            button.isSelected = i == 0
            self.view.addSubview(button)
            buttons.append(button)
        }
        
        let selectedButton = Observable.from(
            buttons.map{ button in button.rx.tap.map{button}}
        ).merge()//merge 将多个元素合并成一个序列
        
        for button in buttons {
            selectedButton.map{$0 == button}
                .bind(to: button.rx.isSelected)
                .disposed(by: disposeBag)
        }
        
    }
    
    func showMessage(_ text: String){
        let alert = UIAlertController(title: text, message: nil, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "确定", style: .cancel, handler: nil)
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    func formatTimeInterval(ms:NSInteger) -> NSMutableAttributedString {
        let str = String(format: "%0.2d:%0.2d.%0.1d",
                         arguments: [(ms/600)%600,(ms%600)/10,ms%10])
        let attStr = NSMutableAttributedString(string: str)
        attStr.addAttribute(.font, value: UIFont(name: "HelveticaNeue-Bold", size: 16)!, range: NSMakeRange(0, 5))
        attStr.addAttribute(.foregroundColor, value: whiteColor, range: NSMakeRange(0, 5))
        attStr.addAttribute(.backgroundColor, value: UIColor.cyan, range: NSMakeRange(0, 5))
        
        return attStr
    }
    
    func changeButtonImage(ms: NSInteger) -> UIImage {
        let imageName = ms%2 == 0 ? "sun_and_cloud_mini" : "sun_and_rain_mini"
        return UIImage(named: imageName)!
    }
}
