//
//  RoleUserDetail.swift
//  MsdGateLock
//
//  Created by ox o on 2017/8/25.
//  Copyright © 2017年 xiaoxiao. All rights reserved.
//

import UIKit
import ObjectMapper

class RoleUserDetail: Mappable {

    var sourceName : String = ""
    var userTel : String = ""
    var startTime : String = ""
    var endTime : String = ""
    var isPermenant : Int = 0  //权限是否永久 2：永久 1：非永久
    
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        sourceName <- map["sourceName"]
        userTel <- map["userTel"]
        startTime <- map["startTime"]
        endTime <- map["endTime"]
        isPermenant <- map["isPermenant"]

    }
    
}

//上传加密秘钥
class UserKeyContentModel : Mappable {
    
    var ckey : String = ""
    var content  : String = ""
    var lockid : String = ""
    var tel : String = ""
    var isdel : Int = 0  //0：增加1：删除;缺省为增加
    
    init(_ ckey : String,content : String,lockid : String,tel : String,isdel : Int){
        self.ckey = ckey
        self.content = content
        self.lockid = lockid
        self.tel = tel
        self.isdel = isdel
    }
    
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        ckey <- map["ckey"]
        content <- map["content"]
        lockid <- map["lockid"]
        tel <- map["tel"]
        isdel <- map["isdel"]
    }
    
    
}



