//
//  UpdateLockModel.swift
//  MsdGateLock
//
//  Created by ox o on 2017/7/28.
//  Copyright © 2017年 xiaoxiao. All rights reserved.
//

import UIKit
import ObjectMapper

class UpdateLockReq: Mappable {
    
    var lockId : String = ""
    var remark : String = ""
    var address : String = ""
    var area : String = ""
    
    init(_ lockId : String,remark : String,address : String,area : String){
        self.lockId = lockId
        self.remark = remark
        self.address = address
        self.area = area
    }
    
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        lockId <- map["lockId"]
        remark <- map["remark"]
        address <- map["address"]
        area <- map["area"]
    }

}


class UpdateLockNickReq: Mappable {
    
    var lockId : String = ""
    var remark : String = ""
    
    init(_ lockId : String,remark : String){
        self.lockId = lockId
        self.remark = remark
    }
    
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        lockId <- map["lockId"]
        remark <- map["remark"]
    }
    
}


class UpdateLockAreaReq: Mappable {
    
    var lockId : String = ""
    var area : String = ""
    
    init(_ lockId : String,area : String){
        self.lockId = lockId
        self.area = area
    }
    
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        lockId <- map["lockId"]
        area <- map["area"]
    }
    
}


class UpdateLockAdressReq: Mappable {
    
    var lockId : String = ""
    var address : String = ""
    
    init(_ lockId : String,address : String){
        self.lockId = lockId
        self.address = address
    }
    
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        lockId <- map["lockId"]
        address <- map["address"]
    }
    
}


