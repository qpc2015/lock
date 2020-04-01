//
//  NoPermissHomeModel.swift
//  MsdGateLock
//
//  Created by ox o on 2017/7/21.
//  Copyright © 2017年 xiaoxiao. All rights reserved.
//

import UIKit
import ObjectMapper

class NoPermissHomeModel: Mappable{

    var title : String?
    var imgList : [ExplainModel]?
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        title <- map["title"]
        imgList <- map["imgList"]
    }
    
}



class ExplainModel : Mappable {
    
    var ID : Int?
    var imageUrl : String?
    var context : String?
    
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        ID <- map["id"]
        imageUrl <- map["imgUrl"]
        context <- map["context"]
    }
    
    
}
