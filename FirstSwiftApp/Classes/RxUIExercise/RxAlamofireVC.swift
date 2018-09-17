//
//  RxAlamofireVC.swift
//  FirstSwiftApp
//
//  Created by weijieMac on 2018/9/13.
//  Copyright © 2018年 Mac. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift
import Alamofire

class RxAlamofireVC: RootVC {
    
    let disposeBag = DisposeBag()
    
    let url = URL(string: "https://www.douban.com/j/app/radio/channels")!
    
    var count = 0//记录请求发起次数
    
    lazy var startBtn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.frame = CGRect(x: 50, y: 100, width: 100, height: 30)
        btn.backgroundColor = UIColor.darkGray
        btn.setTitle("start", for: .normal)
        
        //需要搭配RxAlamofire文件
        btn.rx.tap.bind {self.count += 1}.disposed(by: disposeBag)
        
        btn.rx.tap.asObservable()
            .flatMap{[weak self] _ in
                request(.get,self!.url).responseJSON()
                    .takeUntil(self!.cancelBtn.rx.tap)
            }
            .subscribe(onNext:{
                response,data in
                //转json 方法一
                let json = data.value as! [String : Any]
                print(json)
                print("______\(self.count)")
            },onError: { error in
                print("请求失败！\(error)")
            }).disposed(by:disposeBag)

        return btn
    }()
    
    lazy var cancelBtn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.frame = CGRect(x: 100, y: 100, width: 100, height: 30)
        btn.setTitle("cancel", for: .normal)
        btn.backgroundColor = UIColor.darkGray
        btn.right = screenWidth - 50
        btn.rx.tap
            .bind {
                self.count -= 1
            }
            .disposed(by:disposeBag)
        return btn
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configNaviView(title: "RxAlamofire")
        
        unitOne()
    }
    
    func unitOne() {
        self.view.addSubview(self.startBtn)
        self.view.addSubview(self.cancelBtn)

    }
    
    func startBtnClicked() {
        
    }
}

