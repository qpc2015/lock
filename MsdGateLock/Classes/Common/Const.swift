//
//  Const.swift
//  MsdGateLock
//
//  Created by ox o on 2017/6/13.
//  Copyright © 2017年 xiaoxiao. All rights reserved.
//


import UIKit


let kScreenHeight  = UIScreen.main.bounds.size.height
let kScreenWidth  = UIScreen.main.bounds.size.width 
let kScreenBounds  = UIScreen.main.bounds
let kWidth6Scale  = kScreenWidth / 375
let kHeight6Scale = kScreenHeight / 667

var kIsSreen5 : Bool {
    if kScreenWidth==320{
     return true
    }
    return false
}

///当前系统版本
let kVersion = (UIDevice.current.systemVersion as NSString).floatValue


///全局字体大小
let kGlobalTextFont = UIFont.systemFont(ofSize: 14)


///颜色转图片
func kCreateImageWithColor(color : UIColor) -> UIImage{
    let rect = CGRect(x: 0, y: 0, width: 1, height: 1)
    UIGraphicsBeginImageContext(rect.size)
    let context = UIGraphicsGetCurrentContext()
    context?.setFillColor(color.cgColor)
    context?.fill(rect)
    let image = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    return image!
}

//检测是否登录过
let str  = UserDefaults.standard.object(forKey: UserInfo.userSessionId) as? String
var isLogin : Bool = (str != nil && str != "")


///检测是否为手机号
func  kIsTelNumber(num:NSString)->Bool
    
{
    
    let  mobile = "^1((3[0-9]|4[57]|5[0-35-9]|7[0678]|8[0-9])\\d{8}$)"
    
    /**
     
     * 中国移动：China Mobile
     
     * 134,135,136,137,138,139,150,151,152,157,158,159,182,183,184,187,188,147,178,1705
     
     */
    
    let  CM = "(^1(3[4-9]|4[7]|5[0-27-9]|7[8]|8[2-478])\\d{8}$)|(^1705\\d{7}$)"
    
    /**
     
     * 中国联通：China Unicom
     
     * 130,131,132,155,156,185,186,145,176,1709
     
     */
    
    let  CU = "(^1(3[0-2]|4[5]|5[56]|7[6]|8[56])\\d{8}$)|(^1709\\d{7}$)"
    
    /**
     
     * 中国电信：China Telecom
     
     * 133,153,180,181,189,177,1700
     
     */
    
    let  CT = "(^1(33|53|77|8[019])\\d{8}$)|(^1700\\d{7}$)"
    
    let regextestmobile = NSPredicate(format: "SELF MATCHES %@",mobile)
    
    let regextestcm = NSPredicate(format: "SELF MATCHES %@",CM )
    
    let regextestcu = NSPredicate(format: "SELF MATCHES %@" ,CU)
    
    let regextestct = NSPredicate(format: "SELF MATCHES %@" ,CT)
    
    if ((regextestmobile.evaluate(with: num) == true)
        
        || (regextestcm.evaluate(with: num)  == true)
        
        || (regextestct.evaluate(with: num) == true)
        
        || (regextestcu.evaluate(with: num) == true))
        
    {
        
        return true
        
    }
    else
    {
        return false
    }
}



//MARK:- 自定义打印
func QPCLog<T>(_ message : T,file : String = #file, funcName : String = #function, lineNum : Int = #line){
    
    #if DEBUG
        
        let fileName = (file as NSString).lastPathComponent
        
        print("\(fileName):(\(lineNum))-\(message)")
        
    #endif
}
