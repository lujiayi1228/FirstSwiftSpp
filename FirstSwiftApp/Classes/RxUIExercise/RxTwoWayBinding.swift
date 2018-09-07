//
//  RxTwoWayBinding.swift
//  FirstSwiftApp
//
//  Created by weijieMac on 2018/9/6.
//  Copyright © 2018年 Mac. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

class RxTwoWayBindingVC : RootVC {
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configNaviView(title: "RxTwoWayBinding")
        
        unitOne()
    }
    
    func unitOne() {
        let textField = UITextField(frame: CGRect(x: 30, y: naviHeight+30, width: 200, height: 30))
        let label = UILabel(frame: textField.frame)
        label.top = textField.bottom + 20
        self.view.addSubview(textField)
        self.view.addSubview(label)
        
        var userVM = UserViewModel()
        
        //原始写法
//        userVM.userName.asObservable()
//            .bind(to: textField.rx.text)
//            .disposed(by: disposeBag)
//
//        textField.rx.text.orEmpty
//            .bind(to: userVM.userName)
//            .disposed(by: disposeBag)
        
        //使用双向绑定符，会有返回值，双向绑定符在operators.swift文件中定义
        _ = textField.rx.textInput <-> userVM.userName
        
        userVM.userInfo
            .bind(to: label.rx.text)
            .disposed(by: disposeBag)
        
        
    }
    
    
    struct UserViewModel {
        let userName = Variable("guest")
        
        lazy var userInfo = {
            return self.userName.asObservable()
                .map{ $0 == "hangge" ? "您是管理员" : "您是普通用户"}
                .share(replay: 1)//让map只执行一次,即使多次订阅
        }()
    }
}
