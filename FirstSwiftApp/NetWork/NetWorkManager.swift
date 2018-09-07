//
//  NetWorkManager.swift
//  FirstSwiftApp
//
//  Created by weijieMac on 2018/8/22.
//  Copyright © 2018年 Mac. All rights reserved.
//

import Foundation
import Alamofire

class NetWorkManager: NSObject {
    static let shared : NetWorkManager = NetWorkManager.init()
    var header : HTTPHeaders = [:]
    lazy private var hostUrl : String = {
        let plistPath = Bundle.main.path(forResource: "Info", ofType: "plist")
        let dic = NSDictionary.init(contentsOfFile: plistPath!)
        let isTestModel = dic!["IsTestModel"] as! Bool
        return isTestModel ? "isTest" : "notTest"
    }()
    
    override init() {
        super.init()
        //TODO:设置header
        header[""] = ""
    }
    
    func getData(urlPath:String,methodStr:HTTPMethod,params:Parameters?,response:@escaping (DataResponse<Any>) -> Void){//此处也可以传入headerparams，拼接定制header
        Alamofire.request(hostUrl+urlPath, method: methodStr, parameters: params, headers:header).responseJSON(completionHandler: response)
    }
}
