//
//  QPCKeychainTool.swift
//  MsdGateLock
//
//  Created by ox o on 2017/9/5.
//  Copyright © 2017年 xiaoxiao. All rights reserved.
// 钥匙串储存相关

import UIKit
import KeychainSwift

class QPCKeychainTool{
    
    static let shareSingle = QPCKeychainTool()
    static let serviceName: String = "LockAppService"
    static var openPassWord: String = UserInfo.getPhoneNumber()! + "openLockSecretKey"  //开
    static var encryptPassWord: String = UserInfo.getPhoneNumber()! + "encryptSecretKey"  //授权
    static var secKey: String = UserInfo.getPhoneNumber()! + "GesturePassword"
    
    static let deviceId = "deviceIdentifier"   //设备id  一台仅一个
    static let numPass = UserInfo.getPhoneNumber()! + "phoneNum"    //数字密码
    let QkeyChain = KeychainSwift()
    
    //开门秘钥
    //删除仅用于测试
    static func deletedOpenPassWordWithKeyChain(lockID : String){
        QPCKeychainTool.shareSingle.QkeyChain.delete(lockID + QPCKeychainTool.openPassWord)
    }
    
    static func saveOpenPassWordWithKeyChain(openKey:String,lockID:String){
        QPCKeychainTool.shareSingle.QkeyChain.set(openKey, forKey: lockID + QPCKeychainTool.openPassWord)
    }
    
    static func getOpenPassWordWithKeyChain(lockID : String) -> String?{
        return QPCKeychainTool.shareSingle.QkeyChain.get(lockID + QPCKeychainTool.openPassWord)
    }
    
    
    //授权秘钥
    static func saveEncryptPassWordWithKeyChain(authKey:String,lockID : String){
        QPCKeychainTool.shareSingle.QkeyChain.set(authKey, forKey: lockID + QPCKeychainTool.encryptPassWord)
    }
    
    static func getEncryptPassWordWithKeyChain(lockID : String) -> String?{
        return QPCKeychainTool.shareSingle.QkeyChain.get(lockID + QPCKeychainTool.encryptPassWord)
    }
    
    
    ///清除手势密码密码
    static func deleteGesturePassword(){
        QPCKeychainTool.shareSingle.QkeyChain.delete(QPCKeychainTool.secKey)
    }
    
    ///是否有手势密码
    static func existGesturePassword() ->Bool {
        
        let password = QPCKeychainTool.shareSingle.QkeyChain.get(QPCKeychainTool.secKey)
        if password == nil || password == ""{
            return false
        }
        return true
    }
    
    ///保存手势密码
    static func saveGesturePassword(_ password:String) {
        QPCLog("保存的密码为\(password)")
        QPCKeychainTool.shareSingle.QkeyChain.set(password, forKey: QPCKeychainTool.secKey)
    }
    
    ///获得手势密码
    static func getGesturePassword() ->String? {
        return QPCKeychainTool.shareSingle.QkeyChain.get(QPCKeychainTool.secKey)
    }
    
    
    //数字密码相关
    ///保存
    static func saveNumberPassword(_ password:String) {
        QPCLog("保存的密码为\(password)")
        QPCKeychainTool.shareSingle.QkeyChain.set(password, forKey: numPass)
    }
    
    ///是否有数字密码
    static func existNumberPassword() ->Bool {
        
        let password = QPCKeychainTool.shareSingle.QkeyChain.get(numPass)
        if password == nil || password == ""{
            return false
        }
        return true
    }
    
    //获取数字密码
     static func getNumberPassword() ->String? {
        return QPCKeychainTool.shareSingle.QkeyChain.get(numPass)
    }
    
    //删除数字密码
     static func deletedNumberPassword(){
        QPCKeychainTool.shareSingle.QkeyChain.delete(numPass)
    }
    
    
    /**
     *  同步唯一设备标识 (生成并保存唯一设备标识,如已存在则不进行任何处理)
     */
     static func syncDeviceIdentifier() {
        let serviceId = QPCKeychainTool.shareSingle.QkeyChain.get(deviceId)
        if serviceId == nil || serviceId == ""{
            let myId = UIDevice.current.identifierForVendor?.uuidString
            QPCKeychainTool.shareSingle.QkeyChain.set(myId!, forKey: deviceId)
        }
    }
    
    /**
     *  返回唯一标识
     *
     *  @return 设备标识
     */
     static func getDeviceIdentifier() -> String?{
        var resultStr : String?
        //从钥匙串中获取唯一设备标识
        let deviceIdentifier = QPCKeychainTool.shareSingle.QkeyChain.get(deviceId)?.replacingOccurrences(of: "-", with: "")
        guard deviceIdentifier != nil else {
            QPCLog("未取出标识符")
            return nil
        }
        if deviceIdentifier!.count > 12 {
            resultStr = (deviceIdentifier! as NSString).substring(to: 12)
        }
        return resultStr
    }
    
    /**
     *  本应用是第一次安装
     *
     *  @return 是否是第一次安装
     */
     static func isFirstInstall() -> Bool{
        let deviceIdentifier = QPCKeychainTool.shareSingle.QkeyChain.get(deviceId)
        let myId = UIDevice.current.identifierForVendor?.uuidString
        
        if (deviceIdentifier == nil) || ( deviceIdentifier == myId) {
            return true
        }else{
            return false
        }
    }

}
