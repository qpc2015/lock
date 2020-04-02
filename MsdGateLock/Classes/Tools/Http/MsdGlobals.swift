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
import SwiftyJSON

class MsdGlobals  {
     static let actionUrl: String = "http://lock.diadiade.com/msdlockapi/"
     static var scanLockId : String? ///扫描获得门锁id
//     static let actionUrl: String = "http://192.168.1.101/"   ///本地测试
//     static var gSessionID: String = ""
}


///todo###泛型应该放到方法里 但是swift好像是不支持，有待测试
class AjaxUtil<T: Mappable>{
    
    typealias BackJSON = (_ json:BaseResp<T>) -> Void
    typealias ListJSON = (_ arrJson:BaseArrResp<T>) -> Void
    typealias DataArrJSON = (_ dataArrJson:DataArrResp) -> Void
    typealias Failed = (_ errorStr:String) -> Void
    
    //发送不需要进度
    static func actionPost(req:Mappable, backJSON: @escaping BackJSON){
        actionPost(showTip:false,req:req,backJSON:backJSON)
    }
    
    //发送不需要进度添加error信息
    static func actionPost(req:Mappable, backJSON: @escaping BackJSON,failJSON: @escaping Failed ){
        actionPost(showTip:false,req:req,backJSON:backJSON,fail:failJSON)
    }
    
    //发送请求并显示进度
    static func actionPostAndProgress(req:Mappable, backJSON: @escaping BackJSON ){
        actionPost(showTip:true,req:req,backJSON:backJSON)
    }
    
    //发送请求数组回调
    class func actionArrPost(req:Mappable, backArrJSON: @escaping ListJSON){
        actionArrayPost(showTip:false,req: req, backJSON: backArrJSON)
    }
    
    //发送数组回调添加error信息
    static func actionArrPostWithError(req:Mappable, backArrJSON: @escaping ListJSON,failJSON: @escaping Failed ){
        actionArrayPost(req: req, backJSON: backArrJSON, fail: failJSON)
    }
    
    //发送数组回调并显示进度
    class func actionArrPostAndProgress(req:Mappable, backArrJSON: @escaping ListJSON){
        actionArrayPost(showTip:true,req: req, backJSON: backArrJSON)
    }
    
    //
    static func actionDataArrPostWithError(req:Mappable, backArrJSON: @escaping DataArrJSON,failJSON: @escaping Failed ){
        actionPostWithDataArr(showTip: false, req: req, backJSON: backArrJSON, fail: failJSON)
    }
    
    //发送请求(字典型回调)
    private class func actionPost(showTip:Bool, req:Mappable, backJSON: @escaping BackJSON) {
        
        let requestJSON = req.toJSONString()!.data(using: String.Encoding.utf8)!
        
        if showTip{
            //todo### show Progressing ?
            SVProgressHUD.show()
        }
        
        AF.upload(requestJSON, to: MsdGlobals.actionUrl).responseJSON{ response in
            if showTip{
                //todo### hide Progressing ?
                SVProgressHUD.dismiss()
            }
            
            QPCLog("请求response:\(response)--\(req))")
            switch response.result {
            case .success:
//                response.result
                do {
                    try print(response.result.get())
                } catch {
                    print(error)
                }
                
//                if let result = response.result.data
//                {
//                    let resp  = Mapper<BaseResp<T>>().map(JSONObject: result)
//                    if (resp?.code == 0) {
//                        backJSON(resp!)
//                    }else if resp?.code == -11{
//                        QPCLog("-----------------------\(req)")
//                        SVProgressHUD.showError(withStatus: "您的信息已过期请重新登录")
//                        UserInfo.removeUserInfo()
//                        UIApplication.shared.keyWindow?.rootViewController = LockNavigationController(rootViewController: LoginController())
//                    }else {
////                        Utils.showErrorMsg(errorCode: (resp?.code)!, errMsg: (resp?.msg)!)
//                        Utils.showTip((resp?.msg)!)
//                    }
//
//                }
            case .failure(let error):
                Utils.showTip("请求超时或网络断开")
                
            }
        }
    }
    
    //发送请求(字典型回调)
    private class func actionPost(showTip:Bool, req:Mappable, backJSON: @escaping BackJSON, fail:@escaping Failed) {
        
        let requestJSON = req.toJSONString()!.data(using: String.Encoding.utf8)!

        if showTip{
            //todo### show Progressing ?
            SVProgressHUD.show()
        }
        
//        upload(requestJSON, to: MsdGlobals.actionUrl).responseJSON{ response in
//            if showTip{
//                //todo### hide Progressing ?
//                SVProgressHUD.dismiss()
//            }
//
//            QPCLog("请求response:\(response)-\(req)")
//            switch response.result {
//            case .success:
//                if let result = response.result.value
//                {
//                    let resp  = Mapper<BaseResp<T>>().map(JSONObject: result)
//                    if (resp?.code == 0) {
//                        backJSON(resp!)
//                    }else if resp?.code == -11{
//                        SVProgressHUD.showError(withStatus: "您的信息已过期请重新登录")
//                        UserInfo.removeUserInfo()
//                        UIApplication.shared.keyWindow?.rootViewController = LockNavigationController(rootViewController: LoginController())
//                    }else {
////                        Utils.showErrorMsg(errorCode: (resp?.code)!, errMsg: (resp?.msg)!)
//                        fail((resp?.msg)!)
//                    }
//
//                }
//            case .failure(let error):
//                Utils.showTip("请求超时或网络断开")
//                fail(error.localizedDescription)
//
//            }
//        }
    }
    
    //处理此类数据{"code":0,"data":["111111111111","111111111111"],"id":1,"msg":"ok"}
    private class func actionPostWithDataArr(showTip:Bool, req:Mappable, backJSON: @escaping DataArrJSON, fail:@escaping Failed) {
        
        let requestJSON = req.toJSONString()!.data(using: String.Encoding.utf8)!
        
        if showTip{
            //todo### show Progressing ?
            SVProgressHUD.show()
        }
        
        AF.upload(requestJSON, to: MsdGlobals.actionUrl).responseJSON{ response in
            if showTip{
                //todo### hide Progressing ?
                SVProgressHUD.dismiss()
            }
            
            QPCLog("请求response:\(response)-\(req)")
            switch response.result {
            case .success(let value):
                    QPCLog(value)
                    let resp  = Mapper<DataArrResp>().map(JSONObject: value)
                    if (resp?.code == 0) {
                        backJSON(resp!)
                    }else if resp?.code == -11{
                        SVProgressHUD.showError(withStatus: "您的信息已过期请重新登录")
                        UserInfo.removeUserInfo()
                        UIApplication.shared.keyWindow?.rootViewController = LockNavigationController(rootViewController: LoginController())
                    }else {
                        //                        Utils.showErrorMsg(errorCode: (resp?.code)!, errMsg: (resp?.msg)!)
                        fail((resp?.msg)!)
                    }
            case .failure(let error):
                Utils.showTip("请求超时或网络断开")
                fail(error.localizedDescription)
                
            }
        }
    }

    
    //发送请求(数组型数据)
    private class func actionArrayPost(showTip:Bool, req:Mappable, backJSON: @escaping ListJSON) {

        QPCLog("请求参数\(req)")
        
        let requestJSON = req.toJSONString()!.data(using: String.Encoding.utf8)!

        if showTip{
            //todo### show Progressing ?
            SVProgressHUD.setDefaultMaskType(.black)
            SVProgressHUD.show(withStatus: "加载中...")
        }

        AF.upload(requestJSON, to: MsdGlobals.actionUrl).responseJSON { response in
            if showTip{
                SVProgressHUD.dismiss(withDelay: 1)
            }
            QPCLog(response)
            switch response.result {
            case .success(let value):
                    let resp  = Mapper<BaseArrResp<T>>().map(JSONObject: value)
                    if (resp?.code == 0) {
                        backJSON(resp!)
                    }else if resp?.code == -11{
                        QPCLog("-----------------------\(req)")
                        SVProgressHUD.showError(withStatus: "您的信息已过期请重新登录")
                        UserInfo.removeUserInfo()
                        UIApplication.shared.keyWindow?.rootViewController = LockNavigationController(rootViewController: LoginController())
                    }else {
                        Utils.showErrorMsg(errorCode: (resp?.code)!, errMsg: (resp?.msg)!)
                    }
            case .failure(let error):
                Utils.showTip("请求超时或网络断开")
                QPCLog("error:\(error)")
                
            }
        }
    }
        
        
//        responseJSON{ response in
//            if showTip{
//                SVProgressHUD.dismiss(withDelay: 1)
//            }
//            QPCLog(response)
//            switch response.result {
//            case .success:
//                if let result = response.result.value
//                {
//                    let resp  = Mapper<BaseArrResp<T>>().map(JSONObject: result)
//                    if (resp?.code == 0) {
//                        backJSON(resp!)
//                    }else if resp?.code == -11{
//                        QPCLog("-----------------------\(req)")
//                        SVProgressHUD.showError(withStatus: "您的信息已过期请重新登录")
//                        UserInfo.removeUserInfo()
//                        UIApplication.shared.keyWindow?.rootViewController = LockNavigationController(rootViewController: LoginController())
//                    }else {
//                        Utils.showErrorMsg(errorCode: (resp?.code)!, errMsg: (resp?.msg)!)
//                    }
//
//                }
//            case .failure(let error):
//                Utils.showTip("请求超时或网络断开")
//                QPCLog("error:\(error)")
//
//            }
//        }
//    }
    
    
    //
    private class func actionArrayPost(req:Mappable, backJSON: @escaping ListJSON, fail:@escaping Failed) {
        
        QPCLog("请求参数\(req)")
        let requestJSON = req.toJSONString()!.data(using: String.Encoding.utf8)!
        
//        upload(requestJSON, to: MsdGlobals.actionUrl).responseJSON{ response in
//            QPCLog(response)
//            switch response.result {
//            case .success:
//                if let result = response.result.value
//                {
//                    let resp  = Mapper<BaseArrResp<T>>().map(JSONObject: result)
//                    if (resp?.code == 0) {
//                        backJSON(resp!)
//                    }else if resp?.code == -11{
//                        SVProgressHUD.showError(withStatus: "您的信息已过期请重新登录")
//                        UserInfo.removeUserInfo()
//                        UIApplication.shared.keyWindow?.rootViewController = LockNavigationController(rootViewController: LoginController())
//                    }else {
//                        fail((resp?.msg)!)
//                    }
//
//                }
//            case .failure(let error):
//                Utils.showTip("请求超时或网络断开")
//                fail("请求超时或网络断开")
//
//            }
//        }
    }
    

}


