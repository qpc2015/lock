//
//  ResetNumber.swift
//  MsdGateLock
//
//  Created by ox o on 2017/7/24.
//  Copyright © 2017年 xiaoxiao. All rights reserved.
//

import UIKit
import ObjectMapper

//step1
class VertOlderNumReq : Mappable{
    
    var oldMobile : String?
    var code : String?
    
    init(_ oldMobile : String,code : String) {
        self.oldMobile = oldMobile
        self.code = code
    }
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        oldMobile <- map["oldMobile"]
        code <- map["code"]
    }
    
    
}



class ResetNumberReq: Mappable {

    var newMobile : String = ""
    var code : String = ""
    var oldMobile : String = ""
    var stepId : Int = 0
    
    init(_ newMobile : String,code : String,oldMobile : String,stepId : Int){
        self.newMobile = newMobile
        self.code = code
        self.oldMobile = oldMobile
        self.stepId = stepId
    }
    
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        newMobile <- map["newMobile"]
        code <- map["code"]
        oldMobile <- map["oldMobile"]
        stepId <- map["stepId"]
    }
    
}







