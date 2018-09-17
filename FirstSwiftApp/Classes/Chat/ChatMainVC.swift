//
//  ChatMainVC.swift
//  FirstSwiftApp
//
//  Created by weijieMac on 2018/8/21.
//  Copyright © 2018年 Mac. All rights reserved.
//

import Foundation
import UIKit
class ChatMainVC: RootVC {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configNaviView(title: "聊天")
        self.view.backgroundColor = whiteColor
        
        let a = add(2)
        let b = add(2)(3)
        let c = a(4)
        
        let d = sum(80)(2)
        let e = sum(80)(2)(4)
        
        print("\(a)\n\(b)\n\(c)\n\(d)\n\(e)")
    }
    
    //Currying 示例
    func add(_ number1:Int) -> (Int) -> Int {
//        return {number2 in
//            return number1 + number2
//        }
        return {
            return number1 + $0//$0相当于在block中取第一个参数，故效果同上
        }
    }
    
    //Currying 例子，别当真。。真要这么用~肯定很多人一脸懵逼
    func sum(_ number1:Int) -> (Int) -> (Int) ->Int {
        return { number2 in {number1 - number2 - $0} }//可以省略return
    }
    
}


