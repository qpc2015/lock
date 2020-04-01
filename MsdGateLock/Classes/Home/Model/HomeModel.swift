//
//  HomeModel.swift
//  MsdGateLock
//
//  Created by ox o on 2017/7/17.
//  Copyright © 2017年 xiaoxiao. All rights reserved.
//

import Foundation
import ObjectMapper


class BaseArrResp<T : Mappable>:Mappable {
    
    var id:Int  = 0
    var code:Int = 0
    var msg:String = ""
    var data:[T]?
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        
        id <- map["id"]
        code <- map["code"]
        msg  <- map["msg"]
        data <- map["data"]
    }
}


class DataArrResp:Mappable{
    
    var id:Int  = 0
    var code:Int = 0
    var msg:String = ""
    var data:[String]?
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        
        id <- map["id"]
        code <- map["code"]
        msg  <- map["msg"]
        data <- map["data"]
    }
}


class UserLockListReq:Mappable
{
    var userID:Int = 0
    
    init(_ userID:Int){
        self.userID = userID
    }
    
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        userID <- map["userId"]
    }
}

class UserLockListResp:Mappable {
    
    var lockId : String?
    var userId : String?
    var remark : String?
    var roleType : Int?
    var starttime : String?
    var endtime : String?
    var lastVisitTime : String?
    var roleRemark : String?
    var bluetoothName : String?
    var bluetoothMac : String?
    var authstatus : Int?  //1,4,8 4:待处理  8:已处理
    var mainState : Int?
    var backState : Int?
    var battery : String?
//    init(_ lockId : String,userId : Int,remark : String,roleType : Int,initTitme : String,lastVisitTime : String,roleRemark : String,bluetoothName : String,bluetoothMac : String,authstatus : Int){
//        self.userId = userId
//        self.lockId = lockId
//        self.remark = remark
//        self.roleType = roleType
//        self.initTitme = initTitme
//        self.lastVisitTime = lastVisitTime
//        self.roleRemark = roleRemark
//        self.bluetoothName = bluetoothName
//        self.bluetoothMac = bluetoothMac
//        self.authstatus = authstatus
//    }
    
    func mapping(map: Map) {
        lockId <- map["lockId"]
        userId <- map["userId"]
        remark <- map["remark"]
        roleType <- map["roleType"]
        starttime <- map["starttime"]
        endtime <- map["endtime"]
        lastVisitTime <- map["lastVisitTime"]
        roleRemark <- map["roleRemark"]
        bluetoothName <- map["bluetoothName"]
        bluetoothMac <- map["bluetoothMac"]
        authstatus <- map["authstatus"]
        mainState <- map["mainState"]
        backState <- map["backState"]
        battery <- map["battery"]
    }
    
    required init?(map: Map) {}
}


class LockInfoReq:Mappable
{
    var userID:Int = 0
    var lockID:String?
    var start:Int = 1
    var limit:Int = 10
    
    
    init(_ userID: Int,lockId: String,start: Int,limit: Int){
        self.userID = userID
        self.lockID = lockId
        self.start = start
        self.limit = limit
    }
    
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        userID <- map["userId"]
        lockID <- map["lockId"]
        start <- map["start"]
        limit <- map["limit"]
    }
    
}

//
class LockAllLogReq:Mappable
{
    var lockID:String?
    var start:Int = 1
    var limit:Int = 10
    
    
    init(_ lockId: String,start: Int,limit: Int){
        self.lockID = lockId
        self.start = start
        self.limit = limit
    }
    
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        lockID <- map["lockId"]
        start <- map["start"]
        limit <- map["limit"]
    }
    
}


class LockInfoResp:Mappable {
    
    var lockId : String?
    var lockBattery : String?
    var lockMainState : Int?
    var lockBackState : Int?
    var userId : Int?
    var openList : [OpenLockList]?
    
    
    func mapping(map: Map) {
        lockId <- map["lockId"]
        lockBattery <- map["lockBattery"]
        lockMainState <- map["lockMainState"]
        lockBackState <- map["lockBackState"]
        userId <- map["userId"]
        openList <- map["getLockLog"]
    }

    required init?(map: Map) {}
}



class OpenLockList: Mappable {

    var logStatus : Int?
    var logTime : String?
    var memberName : String?
    
    func mapping(map: Map) {
        logStatus <- map["logStatus"]
        logTime <- map["logTime"]
        memberName <- map["memberName"]
    }
    
    required init?(map: Map) {}
}


//获取秘钥
class UserGetKeyModel : Mappable {
    
    var ckey:String?
    var lockid:String?
    
    init(_ ckey:String,lockid:String){
        self.ckey = ckey
        self.lockid = lockid
    }
    
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        ckey <- map["ckey"]
        lockid <- map["lockid"]

    }
}




//待锁删除用户列表
class UpdateLockRemoveReq: Mappable {
    
    var idlist : [String]?
    var lockid : String!
    
    func mapping(map: Map) {
        idlist <- map["idlist"]
        lockid <- map["lockid"]
    }
    
    init(_ idlist : [String]?,lockid : String){
        self.idlist = idlist
        self.lockid = lockid
    }
    
    required init?(map: Map) {}
}

