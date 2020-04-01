//
//  FaultListModel.swift
//  MsdGateLock
//
//  Created by ox o on 2017/7/28.
//  Copyright © 2017年 xiaoxiao. All rights reserved.
//

import UIKit
import ObjectMapper

class FaultListReq: Mappable {
    
    var lockId : String = ""
    var userId : Int = 0
    
    init(_ lockId : String,userId : Int){
        self.lockId = lockId
        self.userId = userId
    }
    
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        lockId <- map["lockId"]
        userId <- map["userId"]
    }

}

class FaultListResp:Mappable {
    
    var faultAddress : String = ""
    var faultArea : String = ""
    var faultId : Int = 0
    var faultState : Int = 0
    var faultTime : String = ""
    var faultUsername : String = ""
    var faultUsertel : String = ""
    var userId : Int = 0
    
    func mapping(map: Map) {
        faultAddress <- map["faultAddress"]
        faultArea <- map["faultArea"]
        faultId <- map["faultId"]
        faultState <- map["faultState"]
        faultTime <- map["faultTime"]
        faultUsername <- map["faultUsername"]
        faultUsertel <- map["faultUsertel"]
        userId <- map["userId"]
    }
    
    required init?(map: Map) {}
}



class InsertFaultReq: Mappable {
    
    var lockId : String = ""
    var userId : Int = 0
    var faultUsername : String = ""
    var faultUsertel : String = ""
    var faultArea : String = ""
    var faultAddress : String = ""
    var faultTime : String = ""
    
    init(_ lockId : String,userId : Int,faultUsername : String,faultUsertel : String,faultArea : String,faultAddress : String,faultTime : String){
        self.lockId = lockId
        self.userId = userId
        self.faultUsername = faultUsername
        self.faultUsertel = faultUsertel
        self.faultArea = faultArea
        self.faultAddress = faultAddress
        self.faultTime = faultTime
    }
    
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        lockId <- map["lockId"]
        userId <- map["userId"]
        faultUsername <- map["faultUsername"]
        faultUsertel <- map["faultUsertel"]
        faultArea <- map["faultArea"]
        faultAddress <- map["faultAddress"]
        faultTime <- map["faultTime"]
    }
    
}


class CancelFaultReq: Mappable {
    
    var faultId : Int = 0
    var faultStatus : Int = 0
    
    init(_ faultId : Int,faultStatus : Int){
        self.faultId = faultId
        self.faultStatus = faultStatus
    }
    
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        faultId <- map["faultId"]
        faultStatus <- map["faultStatus"]
    }
    
}
