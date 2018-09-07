//
//  BaseControllers.swift
//  FirstSwiftApp
//
//  Created by weijieMac on 2018/8/10.
//  Copyright © 2018年 Mac. All rights reserved.
//

import Foundation
import UIKit

var baseNavigationControllers : [UINavigationController] = []
var baseViewControllers : [UIViewController] = []
var baseSelectedNavi : UINavigationController = UINavigationController.init()
var baseSelectedVC : UIViewController = UIViewController.init()

class BaseNavigationController: UINavigationController,
                                UIGestureRecognizerDelegate,
                                UINavigationControllerDelegate {
    
    override func viewDidLoad() {
            super.viewDidLoad()
        self.navigationBar.isHidden = true
        if (self.responds( to: #selector(getter:interactivePopGestureRecognizer))) {
            self.interactivePopGestureRecognizer?.delegate = self
            self.delegate = self
        }
    }
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        if (self.responds(to: #selector(getter: interactivePopGestureRecognizer))) {
            self.interactivePopGestureRecognizer?.isEnabled = true
            self.interactivePopGestureRecognizer?.delegate = self
        }
        super .pushViewController(viewController, animated: animated)
    }
    
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if gestureRecognizer == self.interactivePopGestureRecognizer {
            if(self.viewControllers.count<1 ||
                self.visibleViewController == self.viewControllers.first){
                return false
            }
        }
        return true
    }
    
}

@objc protocol MainViewLogicable {
    
}

extension MainViewLogicable where Self : NSObject {
    
    //显示引导页
    func windowShowGuideView() {
        self.show(vcName: "ViewController")
    }
    
    //显示首页
    func windowShowHomeView() {
        CustomTabbar.showTabbar()
    }
    
    //显示登录页
    func windowShowLoginView() {
        self.show(vcName: "ViewController")
    }
    
    func show(vcName:String) {
        let appdelegate = UIApplication.shared.delegate as! AppDelegate
        let window = appdelegate.window
        let rootVC = window?.rootViewController
        let nameSpace = Bundle.main.infoDictionary!["CFBundleExecutable"]
        guard let ns = nameSpace as? String else{
            return
        }
        guard (rootVC == nil || !rootVC!.isKind(of: NSClassFromString(ns+"."+vcName)!) ) else {
            return
        }
        let myClass: AnyClass? = NSClassFromString(ns + "." + vcName)
        guard let viewControllerClass = myClass as? UIViewController.Type else{
            return
        }
        
        let vc = viewControllerClass.init()
        window!.rootViewController = vc
        window!.makeKeyAndVisible()
    }
}

@objc protocol CustomNaviViewable : class {
    @objc func leftBtnClicked(sender:UIButton)
    @objc func rightBtnClicked(sender:UIButton)
}

extension CustomNaviViewable where Self : UIViewController {
    func configNaviView(title:String){
        let naviView = UIView.init(frame: CGRect.init(x: 0.0, y: 0.0, width: screenWidth, height: phoneTop+64.0))
        naviView.backgroundColor = whiteColor;
        self.view.addSubview(naviView)
        
        let leftBtn = UIButton.init(type:.custom)
        leftBtn.frame = CGRect.init(x: 8, y: 0, width: 44, height: 44)
        leftBtn.bottom = naviView.height
        leftBtn.addTarget(self, action: #selector(leftBtnClicked(sender:)), for:.touchUpInside)
        leftBtn.backgroundColor = UIColor.orange
        naviView.addSubview(leftBtn)
        
        let titleLabel = UILabel.init(frame: CGRect.init(x: leftBtn.right, y: phoneTop+20, width: screenWidth-(leftBtn.right * 2), height: naviView.height - phoneTop - 20))
        titleLabel.text = title
        titleLabel.backgroundColor = clearColor
        titleLabel.textColor = blackColor
        titleLabel.textAlignment = .center
        naviView.addSubview(titleLabel)
        
        let rightBtn = UIButton.init(type: .custom)
        rightBtn.frame = leftBtn.frame
        rightBtn.right = naviView.width - leftBtn.left
        rightBtn.addTarget(self, action: #selector(rightBtnClicked(sender:)), for: .touchUpInside)
        rightBtn.backgroundColor = UIColor.orange
        naviView.addSubview(rightBtn)
        
        let naviLine = UIView.init(frame: CGRect.init(x: 0.0, y: naviView.height, width: naviView.width, height: 1.0))
        naviLine.backgroundColor = colorRGBA(red: 220, green: 220, blue: 220, alpha: 1)
        naviView.addSubview(naviLine)
        
    }
}

class RootVC : UIViewController, CustomNaviViewable{
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = whiteColor
    }
    
    func leftBtnClicked(sender: UIButton) {
        let flag = (self.navigationController?.viewControllers.count)! > 2 || self.navigationController?.visibleViewController != self.navigationController?.viewControllers.first
        guard flag else {
            return
        }
        self.navigationController?.popViewController(animated: true)
    }
    
    func rightBtnClicked(sender: UIButton) {
        
    }
    
    
}
