//
//  MsdGlobals.swift
//  MsdGateLock
//
//  Created by xiaoxiao on 2017/5/25.
//  Copyright © 2017年 xiaoxiao. All rights reserved.
//

import Foundation
import UIKit
import Alamofire

import ObjectMapper


class MsdGlobals  {
     static let actionUrl: String = "http://lock.diadiade.com"
     static var gSessionID: String = ""
}


///todo###泛型应该放到方法里 但是swift好像是不支持，有待测试
class AjaxUtil<T :Mappable>{
    
    typealias BackJSON = (_ json:BaseResp<T>) -> Void
    typealias Failed = () -> Void
    
    //@escaping  如果一个闭包被作为一个参数传递给一个函数，并且在函数return之后才被唤起执行，那么这个闭包是逃逸闭包
    static func actionPost(  req:Mappable, backJSON: @escaping BackJSON ){
        actionPost(showTip:false,req:req,backJSON:backJSON)
    }
    
    static func actionPost(showTip:Bool, req:Mappable, backJSON: @escaping BackJSON ) {
        let requestJSON = req.toJSONString()!.data(using: String.Encoding.utf8)!
        
        if showTip{
        //todo### show Progressing ?
        }
        
        
        
        upload(requestJSON, to: MsdGlobals.actionUrl).responseString { (response) in
            if showTip{
                //todo### hide Progressing ?
            }
            
            switch response.result {
                case .success:
                    if let result = response.result.value
                    {
                        let resp  = Mapper<BaseResp<T>>().map(JSONString: result)!
                        
                        if (resp.code == 0) {
                            backJSON(resp)
                        } else {
                            Utils.showErrorMsg(errorCode: resp.code, errMsg: resp.msg)
                        }

                    }
                            case .failure(let error):
                Utils.showTip("请求超时或网络断开")
                print(error)
            
            }
        }
    }
}
