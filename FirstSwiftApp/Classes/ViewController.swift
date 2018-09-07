//
//  ViewController.swift
//  FirstSwiftApp
//
//  Created by weijieMac on 2018/8/9.
//  Copyright © 2018年 Mac. All rights reserved.
//

import UIKit

class ViewController: UIViewController,MainViewLogicable {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.view.backgroundColor = UIColor.purple
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.windowShowHomeView()
        let dic : [String : Any] = ["name":"huahua","age":10,"quest":"1"]
        let JSONString = "{\"name\":\"xiaoming\",\"age\":10,\"quest\":\"answers\"}"
        
        guard let jsonData = JSONString.data(using: .utf8) else {
            return
        }
        
        guard let obj = try? JSONDecoder().decode(Person.self, from: jsonData) else {
            return
        }
        
        print(obj.name)
        print(obj.age)
        print(obj.quest)
        
        print("----------------------------------------------------")
        
        guard let objct = try? JSONDecoder().decode(Person.self, from: JSONSerialization.data(withJSONObject: dic, options: [])) else {
            return
        }
        
        print(objct.name)
        print(objct.age)
        print(objct.quest)
    }

}

class Person: Codable {
    var name : String
    var age  : Int
    var quest: String
}

