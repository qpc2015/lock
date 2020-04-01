//
//  UserInfoModel.swift
//  MsdGateLock
//
//  Created by ox o on 2017/7/18.
//  Copyright © 2017年 xiaoxiao. All rights reserved.
//

import UIKit
import ObjectMapper

class UserInfoReq: Mappable {

    var userTel : String = ""
    
    init(_ userTel : String){
        self.userTel = userTel
    }
    
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        userTel <- map["userTel"]
    }
    
    
    
}

class UserInfoResp: Mappable {
    var userName : String?
    var userTel : String?
    var userImage : String?
    var bluetoothMac : String?
    var userId : Int = 0
    
    func mapping(map: Map) {
        userName <- map["userName"]
        userTel <- map["userTel"]
        userImage <- map["userImage"]
        bluetoothMac <- map["bluetoothMac"]
        userId <- map["userId"]
    }
    
    required init?(map: Map) {}
    
    
}
