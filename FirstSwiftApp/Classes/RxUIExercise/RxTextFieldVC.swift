//
//  RxTextFieldVC.swift
//  FirstSwiftApp
//
//  Created by weijieMac on 2018/9/4.
//  Copyright © 2018年 Mac. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

class RxTextFieldVC: RootVC {
    
    let disposedBag = DisposeBag()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configNaviView(title: "RxTextField")
    
//        unitOne()
            unitTwo()
        
    }
    
    //将内容绑定到其他控件上
    func unitOne(){
        let textField = UITextField(frame: CGRect(x: 10, y: 80, width: 200, height: 30))
        textField.borderStyle = .roundedRect
        self.view.addSubview(textField)
        
        //当文本框内容改变是，将内容输出到控制台上
        //.orEmpty 可以将String? 类型的ControlProperty 转成String,省的再去解包
        textField.rx.text.orEmpty.asObservable()
            .subscribe(onNext: {
                print("您输入的内容是：\($0)")
            })
            .disposed(by: disposedBag)
        
        //此写法同上
        //        textField.rx.text.orEmpty.changed
        //            .subscribe(onNext:{
        //                print("您输入的是:\($0)")
        //            })
        //            .disposed(by: disposedBag)
        
        let inputField = UITextField(frame: CGRect(x: 10, y: textField.bottom+10, width: 200, height: 30))
        inputField.borderStyle = .roundedRect
        self.view.addSubview(inputField)
        
        let outputField = UITextField(frame: CGRect(x: 10, y: inputField.bottom+10, width: 200, height: 30))
        outputField.borderStyle = .roundedRect
        self.view.addSubview(outputField)
        
        let label = UILabel(frame: CGRect(x: 20, y: outputField.bottom+10, width: 300, height: 30))
        self.view.addSubview(label)
        
        let button = UIButton(type: .system)
        button.frame = CGRect(x: 20, y: label.bottom+10, width: 40, height: 30)
        button.setTitle("提交", for: .normal)
        self.view.addSubview(button)
        
        //将普通序列转换成Driver  在主线程中操作，0.3秒内值若多次改变，取最后一次(就像节流阀一样，可用控制输出流速)
        let input = inputField.rx.text.orEmpty.asDriver().throttle(0.3)
        
        //内容绑定到另一个输入框
        input.drive(outputField.rx.text)
            .disposed(by: disposedBag)
        
        //内容绑定到另一个输入框中
        input.map{"当前字数:\($0.count)"}
            .drive(label.rx.text)
            .disposed(by: disposedBag)
        
        //根据内容字数决定按钮是否可用
        input.map{$0.count > 5}
            .drive(button.rx.isEnabled)
            .disposed(by: disposedBag)
        
        //可用通过传递空的observe，并配合控制台做调试
        input.map(printCount)
            .drive()
            .disposed(by: disposedBag)
    }
    
    //同时监听多个textField内容的变化
    func unitTwo(){
        
        let textField1 = UITextField(frame: CGRect(x: 10, y: 80, width: 200, height: 30))
        textField1.borderStyle = .roundedRect
        self.view.addSubview(textField1)
        
        let textField2 = UITextField(frame: CGRect(x: 10, y: textField1.bottom+10, width: 200, height: 30))
        textField2.borderStyle = .roundedRect
        self.view.addSubview(textField2)
        
        let label = UILabel(frame: CGRect(x: 0, y: textField2.bottom+40, width: screenWidth, height: 30))
        label.numberOfLines = 0
        self.view.addSubview(label)
        
        //combineLatest 绑定多个信号源,处理之后进行下一步
        Observable.combineLatest(textField1.rx.text.orEmpty,textField2.rx.text.orEmpty) {
            textValue1,textValue2 -> String in
            let str = "你输入的号码是:\(textValue1)-\(textValue2)"
            label.height = CGFloat(30*(str.count/30+1))//label自适应
            return str
        }
            .map{$0}
            .bind(to: label.rx.text)
            .disposed(by: disposedBag)
        
        //controlEvent监听控件事件
        textField1.rx.controlEvent(.editingDidBegin)
            .asObservable()
            .subscribe(onNext: { [weak self] (_) in //weakself
                print("textfield1开始编辑\(String(describing: self!))")
            }).disposed(by: disposedBag)
        
        textField1.rx.controlEvent(.editingDidEndOnExit)//键盘点击回车
            .asObservable()
            .subscribe(onNext: { _ in
                textField2.becomeFirstResponder()
            }).disposed(by: disposedBag)
        
        //textView独有代理封装
        let textView = UITextView(frame: CGRect(x: 0, y: label.bottom+10, width: screenWidth, height: 100))
        textView.backgroundColor = UIColor.blue
        self.view.addSubview(textView)
        
        textView.rx.didBeginEditing.subscribe(onNext: {
            print("开始编辑")
        }).disposed(by: disposedBag)
        
        textView.rx.didEndEditing.subscribe(onNext: {
            print("结束编辑")
        }).disposed(by: disposedBag)
        
        textView.rx.didChange.subscribe(onNext: {
            print("内容发生变化")
        }).disposed(by: disposedBag)
        
        textView.rx.didChangeSelection.subscribe(onNext: {
            print("选中部分发生变化")
        }).disposed(by: disposedBag)
        
        
    }

    func unitThree() {
        
    }
    
    func printCount(str:String){
        print("\(str.count)")
    }
}




















