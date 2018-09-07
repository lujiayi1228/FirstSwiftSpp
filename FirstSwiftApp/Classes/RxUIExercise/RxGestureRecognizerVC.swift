//
//  RxGestureRecognizerVC.swift
//  FirstSwiftApp
//
//  Created by weijieMac on 2018/9/6.
//  Copyright © 2018年 Mac. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

class RxGestureRecognizerVC : RootVC {
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configNaviView(title: "RxGestureRecognizer")
        
        unitOne()
    }
    
    func unitOne() {
        let swipe = UISwipeGestureRecognizer()
        swipe.direction = .up
        self.view.addGestureRecognizer(swipe)
        
        //写法一
//        swipe.rx.event
//            .subscribe(onNext:{ [weak self] recognizer in
//                let point = recognizer.location(in: recognizer.view)
//                self?.showAlert(title: "向上滑动", message: "\(point.x),\(point.y)")
//            })
//            .disposed(by: disposeBag)
        
        //写法二
        swipe.rx.event
            .bind{ [weak self] recognizer in
            let point = recognizer.location(in: recognizer.view)
            self?.showAlert(title: "向上滑动", message: "\(point.x),\(point.y)")
        }
            .disposed(by: disposeBag)
        
    }
    
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "确定", style: .cancel))
        self.present(alert, animated: true)
        
    }
    
}
