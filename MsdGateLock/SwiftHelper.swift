//
//  SwiftHelper.swift
//  MsdGateLock
//
//  Created by xiaoxiao on 2017/5/24.
//  Copyright © 2017年 xiaoxiao. All rights reserved.
//

import Foundation
import ObjectMapper


func md5String(_ str:String) -> String{
    let  cStr = (str as NSString).utf8String
    let  buffer = UnsafeMutablePointer<UInt8>.allocate(capacity: 16)
    CC_MD5(cStr,(CC_LONG)(strlen(cStr!)), buffer)
    
    let md5String  = NSMutableString();
    for i in 0 ..< 16{
        md5String.appendFormat("%X2", buffer[i])
        
    }
    free(buffer)
    return  (md5String as String).lowercased()
}



func toJsonDateTime(_ date:Date)->String
{
    return String(format: "/Date(%.f+0800)/",date.timeIntervalSince1970*1000)
}


open class GameDateTransform: TransformType {
    public typealias Object = Date
    public typealias JSON = String
    
    public init() {}
 
    open func transformFromJSON(_ value: Any?) -> Date? {
        if let timeInt = value as? Double {
            return Date(timeIntervalSince1970: TimeInterval(timeInt))
        }
        
        if let timeStr = value as? String {
           ///todo### return Date(jsonDate:timeStr)
            return Date()
        }
        
        return nil
    }
    open func transformToJSON(_ value: Date?) -> String? {
        if let date = value {
            return toJsonDateTime(date)
        }
        return nil
    }
    open func transformToJSON(_ value: Date?) -> Double? {
        if let date = value {
            return Double(date.timeIntervalSince1970)
        }
        return nil
    }
}
