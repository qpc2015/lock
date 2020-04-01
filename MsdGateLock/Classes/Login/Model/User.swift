//
//  User.swift
//  MsdGateLock
//
//  Created by xiaoxiao on 2017/5/24.
//  Copyright © 2017年 xiaoxiao. All rights reserved.
//

import Foundation
import ObjectMapper



class User:Mappable
{
    init(){}
    var buildId:Int = 0
    var userId:Int = 0
    var regTime:Date?
    
    
    
    func mapping(map: Map) {
        
        userId <- map["userId"]
        regTime <-  (map["regTime"], GameDateTransform())
    }

    required
    init?(map: Map) {
   
    }

}
