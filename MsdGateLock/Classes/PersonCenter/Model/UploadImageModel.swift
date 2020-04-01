//
//  UploadImageModel.swift
//  MsdGateLock
//
//  Created by ox o on 2017/7/21.
//  Copyright © 2017年 xiaoxiao. All rights reserved.
//

import UIKit
import ObjectMapper

class UploadImageModel:  Mappable{
    
    var userID : Int?
    var userName : String?
    
    
    required init?(map: Map) {}
    
    
    func mapping(map: Map) {
        userID <- map["userId"]
        userName <- map["userName"]
    }
    
    
}
