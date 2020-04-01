//
//  CommonParam.swift
//  MsdGateLock
//
//  Created by xiaoxiao on 2017/5/26.
//  Copyright © 2017年 xiaoxiao. All rights reserved.
//

import Foundation
import ObjectMapper

class EmptyParam:Mappable
{
    func mapping(map: Map) {
        
    }
    init(){}
    required init?(map: Map) {}
}

class OneParam<T>:Mappable {

    var p1:T?
    func mapping(map: Map) {
        p1 <- map["p1"]
    }
    init(p1:T){
        self.p1 = p1
    }
    required init?(map: Map) {}
}

class TwoParam<T1,T2>:Mappable{
    var p1:T1?
    var p2:T2?
    func mapping(map: Map) {
        p1 <- map["p1"]
        p2 <- map["p2"]
    }
    init(p1:T1,p2:T2){
        self.p1 = p1
        self.p2 = p2
    }
    required init?(map: Map) {}
}

class ThreeParam<T1,T2,T3>:Mappable{
    var p1:T1?
    var p2:T2?
    var p3:T3?
    
    func mapping(map: Map) {
        p1 <- map["p1"]
        p2 <- map["p2"]
        p3 <- map["p3"]
    }
    
    init(p1:T1,p2:T2,p3:T3){
        self.p1 = p1
        self.p2 = p2
        self.p3 = p3
    }
    required init?(map: Map) {}
}
