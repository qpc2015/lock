//
//  NickNameModel.swift
//  MsdGateLock
//
//  Created by ox o on 2017/7/21.
//  Copyright © 2017年 xiaoxiao. All rights reserved.
//

import UIKit
import ObjectMapper

class NickNameReq: Mappable {
    var userID : Int?
    var userName : String?
    
    init(_ userID : Int,_ name : String){
        self.userID = userID
        self.userName = name
    }
    
    required init?(map: Map) {}
    
    
    func mapping(map: Map) {
        userID <- map["userId"]
        userName <- map["userName"]
    }
    
}


