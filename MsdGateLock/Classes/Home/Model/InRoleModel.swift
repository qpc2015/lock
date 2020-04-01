//
//  InRoleModel.swift
//  MsdGateLock
//
//  Created by ox o on 2017/8/11.
//  Copyright © 2017年 xiaoxiao. All rights reserved.
//

import UIKit
import ObjectMapper

class InRoleModel: Mappable {
    
    var ID : Int = 0
    var ownerId : Int = 0
    var bluetoothMac : String = ""
    var permissions : String = ""
    var status : Int = 0
    var lockId : String = ""
    var level : Int = 0
    
    func mapping(map: Map) {
        ID <- map["id"]
        ownerId <- map["ownerId"]
        bluetoothMac <- map["bluetoothMac"]
        permissions <- map["permissions"]
        status <- map["status"]
        lockId <- map["lockId"]
        level <- map["level"]
    }
    
    required init?(map: Map) {}

}
