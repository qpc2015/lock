//
//  LockSetInfoModel.swift
//  MsdGateLock
//
//  Created by ox o on 2017/7/27.
//  Copyright © 2017年 xiaoxiao. All rights reserved.
//

import UIKit
import ObjectMapper

class LockSetInfoReq: Mappable {

    var lockId:String = ""
    
    init(_ lockId:String){
        self.lockId = lockId
    }
    
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        lockId <- map["lockId"]
    }
}


class LockSetInfoResp:Mappable {
    
    var lockId : String = ""
    var remark : String = ""
    var address : String = ""
    var area : String = ""
    
    func mapping(map: Map) {
        lockId <- map["lockId"]
        remark <- map["remark"]
        address <- map["address"]
        area <- map["area"]
    }
    
    required init?(map: Map) {}
}
