//
//  HomeMainVC.swift
//  FirstSwiftApp
//
//  Created by weijieMac on 2018/8/21.
//  Copyright © 2018年 Mac. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation

class HomeMainVC: RootVC ,MainViewLogicable{
    
//    lazy var whiteLayer = { () -> CALayer in
//        let layer = CALayer.init()
//        layer.frame = CGRect.init(x: 10, y: 10, width: 20, height: 20)
//        layer.backgroundColor = UIColor.orange.cgColor
//        return layer
//    }()
    
//    lazy var whiteLayer = { () -> AVPlayerLayer in
//        let player = AVPlayer.init(url: URL.init(string: "http://vdn.zhaowenxishi.com/dizhen/video/m/201808080957189521")!)
//        let layer = AVPlayerLayer.init(player: player)
//        layer.frame = CGRect.init(x: 10, y: 10, width: 20, height: 20)
//        player.play()
//        return layer
//    }()
    
    lazy var btn = { () -> UIView in
        let view = UIView.init(frame: CGRect.init(x: 0, y: 0, width: 100, height: 100))
        view.center = self.view.center
        view.backgroundColor = clearColor
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(self.click))
        view.addGestureRecognizer(tap)
//        view.layer.addSublayer(whiteLayer)
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configNaviView(title: "首页")
        CustomTabbar.shared().barDelegate = self
        self.view.backgroundColor = UIColor.red
        UIApplication.shared.keyWindow!.addSubview(btn)
//        whiteLayer.frame = btn.bounds
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    @objc func click(){
        
        UIView.animate(withDuration: 0.25, animations: {
            self.btn.layer.setAffineTransform(CGAffineTransform.identity)
        }, completion: nil)
    }
    
    override func rightBtnClicked(sender: UIButton) {
        super.rightBtnClicked(sender: sender)
        self.windowShowLoginView()
//        let heightS = screenHeight*1.0/self.btn.height
//
//        UIView.animate(withDuration: 1, animations: {
//            self.btn.layer.setAffineTransform(CGAffineTransform.init(a: heightS, b: 0, c: 0, d: heightS, tx: 0, ty: 0))
//        }) { (finish) in
//
//        }
    }
    
}

extension HomeMainVC : CustomTabbarDelegate{
    func tabbarDidSelectedVC(_ tabbar: CustomTabbar, with viewController: UIViewController) {
        print("tabbar:\(tabbar.selectedIndex)\nvc:\(viewController)")
    }
}
