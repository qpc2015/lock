//
//  ExpireDateModel.swift
//  MsdGateLock
//
//  Created by ox o on 2017/8/24.
//  Copyright © 2017年 xiaoxiao. All rights reserved.
//

import UIKit
import ObjectMapper

class ExpireDateModel: Mappable {
    
    var userId : Int = 0
    var lockId : String = ""
    var isPermanent : Int = 0  //2：永久，1：时间段
    var beginDate : String = ""
    var endDate : String = ""
    
    init(_ userId : Int,lockId : String,isPermanent : Int,beginDate : String,endDate : String){
        self.userId = userId
        self.isPermanent = isPermanent
        self.beginDate = beginDate
        self.endDate = endDate
        self.lockId = lockId
    }
    
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        userId <- map["userId"]
        isPermanent <- map["isPermanent"]
        beginDate <- map["beginDate"]
        endDate <- map["endDate"]
        lockId <- map["lockId"]
    }

}

class PerpeDateModel: Mappable {
    
    var userId : Int = 0
    var isPermanent : Int = 0  //2：永久，1：时间段
    var lockid : String = ""
    
    init(_ userId : Int,isPermanent : Int,lockid : String){
        self.userId = userId
        self.isPermanent = isPermanent
        self.lockid = lockid
    }
    
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        userId <- map["userId"]
        isPermanent <- map["isPermanent"]
        lockid <- map["lockid"]
    }
    
}



