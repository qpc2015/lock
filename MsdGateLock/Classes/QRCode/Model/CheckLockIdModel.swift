//
//  CheckLockIdModel.swift
//  MsdGateLock
//
//  Created by ox o on 2017/7/22.
//  Copyright © 2017年 xiaoxiao. All rights reserved.
//

import UIKit
import ObjectMapper

class CheckLockIdReq: Mappable {

    var userID:Int = 0
    var lockID:String = ""
    
    init(_ userID:Int,_ lockID:String){
        self.userID = userID
        self.lockID = lockID
    }
    
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        userID <- map["userId"]
        lockID <- map["lockId"]
    }
    
}



class InsertLockReq: Mappable {
    
    var userId:Int = 0
    var lockId:String = ""
    var area:String = ""
    var address:String = ""
    var name:String = ""
    var point:String = ""
    var initCode:String = ""
    
    init(_ userID:Int,lockID:String,lockArea:String,lockAddress:String,name:String,latlon:String,initCode:String){
        self.userId = userID
        self.lockId = lockID
        self.area = lockArea
        self.address = lockAddress
        self.name = name
        self.point = latlon
        self.initCode = initCode
    }
    
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        userId <- map["userId"]
        lockId <- map["lockId"]
        area <- map["area"]
        address <- map["address"]
        name <- map["name"]
        point <- map["point"]
        initCode <- map["initCode"]
    }
    
}
