//
//  LockStateModel.swift
//  MsdGateLock
//
//  Created by ox o on 2017/8/23.
//  Copyright © 2017年 xiaoxiao. All rights reserved.
//

import UIKit
import ObjectMapper

class LockStateModel: Mappable {

    var lockId:String = ""
    var battery:Int = 0
    var mainState:Int = -1    // 0 已锁 1未锁
    var backState:Int = -1
    
    init(_ lockId:String,battery:Int,mainState:Int,backState:Int){
        self.lockId = lockId
        self.battery = battery
        self.mainState = mainState
        self.backState = backState
    }
    
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        lockId <- map["lockId"]
        battery <- map["battery"]
        mainState <- map["mainState"]
        backState <- map["backState"]
    }
    
}
