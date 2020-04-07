//
//  BaseResp.swift
//  MsdGateLock
//
//  Created by xiaoxiao on 2017/5/25.
//  Copyright © 2017年 xiaoxiao. All rights reserved.
//

import Foundation
import ObjectMapper
typealias CommonResp = BaseResp<EmptyParam>

class BaseResp<T :Mappable>:Mappable
{
    
    var id:Int  = 0
    var code:Int = 0
    var msg:String = ""
    var data:T?
  
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        
        id <- map["id"]
        code <- map["code"]
        msg  <- map["msg"]
        data <- map["data"]
      //  regTime <-  (map["regTime"], GameDateTransform())
    }
}



