//
//  UIView+Extension.swift
//  FirstSwiftApp
//
//  Created by weijieMac on 2018/8/10.
//  Copyright © 2018年 Mac. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

extension UIView {
    var left : CGFloat {
        set {
            self.frame.origin.x = newValue
        }
        get {
          return self.frame.origin.x
        }
    }
    
    var top : CGFloat {
        set {
            self.frame.origin.y = newValue
        }
        get {
            return self.frame.origin.y
        }
    }

    var width : CGFloat {
        set {
            self.frame.size.width = newValue
        }
        get {
            return self.frame.size.width
        }
    }
    
    var height : CGFloat {
        set {
            self.frame.size.height = newValue
        }
        get {
            return self.frame.size.height
        }
    }
    
    var right : CGFloat {
        set {
            self.left = newValue - self.width
        }
        get {
            return self.left + self.width
        }
    }
    
    var bottom : CGFloat {
        set {
            self.top = newValue - self.height
        }
        get {
            return self.top + self.height
        }
    }
    
    var centerX : CGFloat {
        set {
            self.center.x = newValue
        }
        get {
            return self.center.x
        }
    }
    
    var centerY : CGFloat {
        set {
            self.center.y = newValue
        }
        get {
            return self.center.y
        }
    }
    
    
    
}

extension Reactive where Base: UIView {

    public var backgroundColor: Binder<UIColor> {
        return Binder(self.base) { view, bgColor in
            view.backgroundColor = bgColor
        }
    }
    
}
