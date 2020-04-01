//
//  BaseReq.swift
//  MsdGateLock
//
//  Created by xiaoxiao on 2017/5/25.
//  Copyright © 2017年 xiaoxiao. All rights reserved.
//

import Foundation
import ObjectMapper

typealias CommonReq = BaseReq<EmptyParam>


class BaseReq<T :Mappable> :Mappable
{
    init(){}

    var id:Int  = 1
    var sessionId:String = ""
    var action:String = ""
    var sign:String = ""
    var data:T?
    
    required
    init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        
        id <- map["id"]
        sessionId <- map["sessionId"]
        action  <- map["action"]
        sign  <- map["sign"]
        data <- map["data"]
        //  regTime <-  (map["regTime"], GameDateTransform())
    }

}

class BaseArrReq<T :Mappable> :Mappable
{
    init(){}
    
    var id:Int  = 1
    var sessionId:String = ""
    var action:String = ""
    var sign:String = ""
    var data:[T]?
    
    required
    init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        
        id <- map["id"]
        sessionId <- map["sessionId"]
        action  <- map["action"]
        sign  <- map["sign"]
        data <- map["data"]
        //  regTime <-  (map["regTime"], GameDateTransform())
    }
    
}
