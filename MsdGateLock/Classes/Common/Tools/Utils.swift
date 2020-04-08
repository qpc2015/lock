//
//  Utils.swift
//  MsdGateLock
//
//  Created by xiaoxiao on 2017/5/25.
//  Copyright © 2017年 xiaoxiao. All rights reserved.
//

import Foundation
import UIKit
import RKDropdownAlert

class Utils{
    
    static func showTip(_ title:String){
        RKDropdownAlert.title(title, backgroundColor: UIColor.navigaBarColor, textColor: UIColor.white, time: 1)
    }
    
    static func showTip(_ view: UIView, errMsg: String) {
        RKDropdownAlert.title(errMsg, backgroundColor: UIColor.navigaBarColor, textColor: UIColor.white, time: 1)
    }
    
    static func showErrorMsg(_ view: UIView? = nil ,errorCode:Int, errMsg: String) {
        switch errorCode {
        case -1:
            if view == nil {
                showTip(errMsg)
            }else {
                showTip(view!, errMsg:errMsg)
            }
            
            //            RKDropdownAlert.title(errMsg, time: 1)
            
            break
        case -2:        //账号失效
            //不能打开指纹
          /*  if !CanOpenFingerLock() {
                AppDelegate.getInstance().navigationController?.popToRootViewController(animated: true)
            }else {    //能打开指纹
                OpenFingerLock()
            }*/
            
            break
        case -3:
            showTip("无效的商户")
            break
        case -4:
            showTip("商户已过期")
            break
        case -14:
            showTip("只有店主才有权限创建")
            break
        case -15:
            showTip("不能创建店主")
            break
        case -16:
            showTip("超过最大员工数，请联系管理员")
            break
        case -17:
            showTip("有同名帐号存在，请换一个帐号名称")
            break
        case -10003:
            showTip("订单已支付")
            break
        case -10004:
            showTip("商户没有开通被扫支付权限")
            break
        case -10005:
            showTip("二维码已过期，请用户在微信上刷新后再试")
            break
        case -10006:
            showTip("用户余额不足.请用户换卡支付")
            break
        case -10007:
            showTip("该卡不支持当前支付，提示用户换卡支付或绑新卡支付")
            break
        case -10008:
            showTip("商户订单号异常，请重新下单支付")
            break
        case -10009:
            showTip("订单已撤销 请重新支付")
            break
        case -10010:
            showTip("银行系统异常")
            break
        case -10011:
            showTip("用户支付中....")
            break
        case -10012:
            showTip("每个二维码仅限使用一次，请刷新再试")
            break
        case -10013:
            showTip("请扫描微信支付被扫条码/二维码")
            break
        case -10025:
            showTip("退款中..")
            break
        case -10026:
            showTip("已取消支付。")
            break
        case -10027:
            showTip("支付超时。")
            
            break
        case -30000 ... -20000:
            showTip(errMsg)
            break
        default:
            if view == nil {
                showTip(errMsg)
            }else {
                showTip(view!, errMsg:errMsg)
            }
            
            break
        }
        
    }
    

}
