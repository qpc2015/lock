//
//  OrderLockModel.swift
//  MsdGateLock
//
//  Created by ox o on 2017/7/27.
//  Copyright © 2017年 xiaoxiao. All rights reserved.
//

import UIKit
import ObjectMapper

class OrderLockReq: Mappable {

    var userId : Int = 0
    
    init(_ userId : Int){
        self.userId = userId
    }
    
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        userId <- map["userId"]

    }
    
}


class OrderLockResp: Mappable {
    
    var reservedId : Int = 0
    var orderStatus : Int = 0
    var reservedStatus : Int = 0
    var reservedUserName : String?
    var reservedUserTel : String?
    var reservedArea : String?
    var reservedAddress : String?
    var reservedTime : String?
    
    func mapping(map: Map) {
        reservedId <- map["reservedId"]
        orderStatus <- map["orderStatus"]
        reservedUserName <- map["reservedUserName"]
        reservedUserTel <- map["reservedUserTel"]
        reservedArea <- map["reservedArea"]
        reservedAddress <- map["reservedAddress"]
        reservedTime <- map["reservedTime"]
        reservedStatus <- map["reservedStatus"]
    }
    required init?(map: Map) {}
}


class CommitOrderReq: Mappable {
    
    var reservedUsername : String = ""
    var reservedUserTel : String = ""
    var reservedArea : String = ""
    var reservedAddress : String = ""
    var reservedTime : String = ""
    
    init(reservedUsername : String,reservedUserTel : String,reservedArea : String,reservedAddress : String,reservedTime : String){
        self.reservedUsername = reservedUsername
        self.reservedUserTel = reservedUserTel
        self.reservedArea = reservedArea
        self.reservedAddress = reservedAddress
        self.reservedTime = reservedTime
    }
    
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        reservedUsername <- map["reservedUsername"]
        reservedUserTel <- map["reservedUserTel"]
        reservedArea <- map["reservedArea"]
        reservedAddress <- map["reservedAddress"]
        reservedTime <- map["reservedTime"]
    }
    
}


class CancelOrderReq: Mappable {
    
    var reservedId : Int = 0
    
    init(_ reservedId : Int){
        self.reservedId = reservedId
    }
    
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        reservedId <- map["reservedId"]
    }
    
}
