//
//  UIFont+Extension.swift
//  FirstSwiftApp
//
//  Created by weijieMac on 2018/8/20.
//  Copyright © 2018年 Mac. All rights reserved.
//

import Foundation
import UIKit

extension UIFont {
    public class func initializeMethod(){
        let originalSelector = #selector(UIFont.systemFont(ofSize:))
        let swizzledSelector = #selector(UIFont.autoSystemFont(ofSize:))
        
        let originalMethod = class_getClassMethod(self, originalSelector)
        let swizzledMethod = class_getClassMethod(self, swizzledSelector)
        
        method_exchangeImplementations(originalMethod!, swizzledMethod!)
    }
    
    @objc open class func autoSystemFont(ofSize: CGFloat) {
        UIFont.autoSystemFont(ofSize: ofSize*1.0*screenWidth/375)
    }
}


