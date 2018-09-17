//
//  UIViewController+Swizzling.swift
//  FirstSwiftApp
//
//  Created by weijieMac on 2018/9/12.
//  Copyright © 2018年 Mac. All rights reserved.
//

import Foundation
import UIKit
import Aspects

extension UIViewController {
    func SWViewDidLoad() {
        if self.isKind(of: UINavigationController.self) {
            return
        }
        print("++++++\(type(of: self))__SWViewDidLoad")
    }
    
    func SWViewDidAppear(_ animated: Bool) {
        if self.isKind(of: UINavigationController.self) {
            return
        }
        print("++++++\(type(of: self))__SWViewDidAppear")
    }
    
    func SWViewDidDisappear(_ animated: Bool) {
        if self.isKind(of: UINavigationController.self) {
            return
        }
        print("++++++\(type(of: self))__SWViewDidDisAppear")
    }
}

func viewControllerAopConfig() {
    let viewDidLoadBlock:@convention(block) (AspectInfo)-> Void = { aspectInfo in
        let instance = aspectInfo.instance() as? UIViewController
        instance?.SWViewDidLoad()
    }
    
    let viewDidAppearBlock:@convention(block) (AspectInfo, _ Animated: Bool)-> Void = { aspectInfo, animated in
        let instance = aspectInfo.instance() as? UIViewController
        instance?.SWViewDidAppear(animated)
    }
    
    let viewDidDisappearBlock:@convention(block) (AspectInfo, _ Animated: Bool)-> Void = { aspectInfo, animated in
        let instance = aspectInfo.instance() as? UIViewController
        instance?.SWViewDidDisappear(animated)
    }
    
    let viewDidLoadObject: AnyObject = unsafeBitCast(viewDidLoadBlock, to: AnyObject.self)
    let viewDidAppearObject: AnyObject = unsafeBitCast(viewDidAppearBlock, to: AnyObject.self)
    let viewDidDisappearObject : AnyObject = unsafeBitCast(viewDidDisappearBlock, to: AnyObject.self)
    
    
    do {
        try UIViewController.aspect_hook(#selector(UIViewController.viewDidLoad),
                                         usingBlock: viewDidLoadObject)
    } catch {
        print(error)
    }
    
    do {
        try UIViewController.aspect_hook(#selector(UIViewController.viewDidAppear(_:)),
                                         usingBlock: viewDidAppearObject)
        
    } catch {
        print(error)
    }
    
    do {
        try UIViewController.aspect_hook(#selector(UIViewController.viewDidDisappear(_:)),
                                         usingBlock: viewDidDisappearObject)
    } catch {
        print(error)
    }
}
