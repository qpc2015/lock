//
//  LoginModel.swift
//  MsdGateLock
//
//  Created by xiaoxiao on 2017/5/27.
//  Copyright © 2017年 xiaoxiao. All rights reserved.
//

import Foundation
import ObjectMapper

class LoginReq:Mappable
{
    var userTel:String = ""
    var smsCode:String = ""
    
    init(_ userTel:String, _ code:String){
        self.userTel = userTel
        self.smsCode = code
    }
    
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        userTel <- map["userTel"]
        smsCode <- map["smsCode"]
    }
}


class LoginResp:Mappable {
    
    var SessionId:String!
    var UserId : String!
    var isreg:Int!   //  1未登录过  2已登录过
    
    func mapping(map: Map) {
            SessionId <- map["SessionId"]
            UserId <- map["UserId"]
            isreg <- map["isreg"]
    }
    
//    init(){}
    
    required init?(map: Map) {}
}



//获取验证码
class VerificatiReq:Mappable
{
    var userTel:String = ""
    
    init(_ userTel:String){
        self.userTel = userTel
    }
    
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        userTel <- map["userTel"]
    }
    
}


class VerificatiResp:Mappable {
    
    
    func mapping(map: Map) {

    }
    
    
    required init?(map: Map) {}
}

