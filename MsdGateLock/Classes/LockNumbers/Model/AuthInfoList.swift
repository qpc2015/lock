//
//  AuthInfoList.swift
//  MsdGateLock
//
//  Created by ox o on 2017/7/23.
//  Copyright © 2017年 xiaoxiao. All rights reserved.
//

import UIKit
import ObjectMapper

class AuthInfoListReq: Mappable {

    var userId : Int = 0
    var lockId : String = ""
    var roleType : Int = 1  //1查询授权用户   2 零食用户
    
    init(_ userId : Int,lockId : String,roleType : Int){
        self.userId = userId
        self.lockId = lockId
        self.roleType = roleType
    }
    
    required init?(map: Map) {}
    
    
    func mapping(map: Map) {
        userId <- map["userId"]
        lockId <- map["lockId"]
        roleType <- map["roleType"]
    }
    
}


class AuthInfoListResp: Mappable {
    
    var userId : String = ""
    var lockId : String = ""
    var roleType : Int = -1  //0拥有者 1查询授权用户   2 零食用户
    var sourceName : String = ""
    var userImage : String = ""
    var startTime : String = ""
    var endTime : String = ""
    var userTel : String = ""
    var isPermenant : Int = 0  //是否永久
    
    required init?(map: Map) {}
    
    
    func mapping(map: Map) {
        userId <- map["userId"]
        lockId <- map["lockId"]
        roleType <- map["roleType"]
        sourceName <- map["sourceName"]
        userImage <- map["userImage"]
        startTime <- map["startTime"]
        endTime <- map["endTime"]
        userTel <- map["userTel"]
        isPermenant <- map["isPermenant"]
    }
    
}


class AddAuthUserReq: Mappable {
    
    var ownerId : Int = 0
    var mobile : String = ""
    var memberName : String = ""
    var level : Int = 0
    var lockId : String = ""
    var permissions : String = ""
    var code : String = ""

    
    init(_ ownerId : Int,mobile : String,memberName : String,level : Int,lockId : String,permissions : String,code : String){
        self.ownerId = ownerId
        self.mobile = mobile
        self.memberName = memberName
        self.level = level
        self.lockId = lockId
        self.permissions = permissions
        self.code = code
    }
    
    required init?(map: Map) {}
    
    
    func mapping(map: Map) {
        ownerId <- map["ownerId"]
        mobile <- map["mobile"]
        memberName <- map["memberName"]
        level <- map["level"]
        lockId <- map["lockId"]
        permissions <- map["permissions"]
        code <- map["code"]
    }
    
}



