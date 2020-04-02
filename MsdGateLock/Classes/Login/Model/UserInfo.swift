//
//  UserInfo.swift
//  MsdGateLock
//
//  Created by ox o on 2017/7/11.
//  Copyright © 2017年 xiaoxiao. All rights reserved.
//

import UIKit

class UserInfo{

    static let userPhoneNumber = "phoneNumber"
    static let userSessionId = "sessionId"
    static let userId = "UserId"
    static let userImage = "userImage"
    static let userName = "userName"
    static let lastLockId = "lastLockId"
    static let OpenFinger = UserInfo.getPhoneNumber() ?? "" + "OpenFinger"   //开启指纹
//    static let roleType = "roleType"//用户类型
    
    static func removeUserInfo(){
        UserDefaults.standard.removeObject(forKey: UserInfo.userPhoneNumber)
        UserDefaults.standard.removeObject(forKey: UserInfo.userSessionId)
        UserDefaults.standard.removeObject(forKey: UserInfo.userId)
        UserDefaults.standard.removeObject(forKey: UserInfo.userName)
        UserDefaults.standard.removeObject(forKey: UserInfo.userImage)
        UserDefaults.standard.synchronize()
        
//        QPCKeychainTool.shareSingle.QkeyChain.clear()
//        QPCKeychainTool.deletedNumberPassword()   //用于测试

    }
    
    //保存最后使用的锁id
    static func saveLastLock(lockID : String){
        UserDefaults.standard.set(lockID, forKey: UserInfo.lastLockId)
        UserDefaults.standard.synchronize()
    }
    
    //读取最后使用的锁id
    static func getLastLock() -> String?{
        return UserDefaults.standard.object(forKey: UserInfo.lastLockId) as? String
    }
    
    //用户信息相关
    ///保存
    static func saveSessionId(sessionID : String){
        UserDefaults.standard.set(sessionID, forKey: UserInfo.userSessionId)
        UserDefaults.standard.synchronize()
    }
    
    static func saveUserId(userID : String) {
        UserDefaults.standard.set(userID, forKey: UserInfo.userId)
        UserDefaults.standard.synchronize()
    }
    
    static func savePhoneNumber(member : String){
        UserDefaults.standard.set(member, forKey: UserInfo.userPhoneNumber)
        UserDefaults.standard.synchronize()
    }
    
    static func saveUserImageStr(imgStr : String){
        UserDefaults.standard.set(imgStr, forKey: UserInfo.userImage)
        UserDefaults.standard.synchronize()
    }
    

    ///获取
    static func getSessionId() -> String?{
       return UserDefaults.standard.object(forKey: UserInfo.userSessionId) as? String
    }
    
    static func getUserIdToStr() -> String?{
        return UserDefaults.standard.object(forKey: UserInfo.userId) as? String
    }
    
    static func getUserId() -> Int?{
        guard UserDefaults.standard.object(forKey: UserInfo.userId) != nil else {
            return nil
        }
        return Int(UserDefaults.standard.object(forKey: UserInfo.userId) as! String)
    }
    
    
    static func getPhoneNumber() -> String?{
        return UserDefaults.standard.object(forKey: UserInfo.userPhoneNumber) as? String
    }
    
    static func getUserImageStr() -> String?{
        return UserDefaults.standard.object(forKey: UserInfo.userImage) as? String
    }
    
    //门锁初始化  
    //soleStr :num + bluetoothName
    static func saveLockIsSetupWithNumberAndBlueName(soleStr : String){
        UserDefaults.standard.set("1", forKey: soleStr + "setup")
    }
    
    static func deletedLockIsSetupWithNumberAndBlueName(soleStr : String){
        UserDefaults.standard.removeObject(forKey: soleStr + "setup")
    }

    
    static func getLockIsSetupWithNumberAndBlueName(soleStr : String) -> String?{
      return  UserDefaults.standard.object(forKey: soleStr + "setup") as? String
    }
    
    
    //记录lock下次同步时间
    static func saveLockIsTimeSynchWithBlueNameAndTime(blueName:String,time:Date){
        UserDefaults.standard.set(time, forKey: blueName + "isTimeSynch")
    }
    
    static func getLockIsTimeSynch(blueName : String) -> Date?{
       return  UserDefaults.standard.object(forKey: blueName + "isTimeSynch") as? Date
    }
    
    
    //保存指纹识别
    static func saveOpenFingerPrintStyle(isOpen:Bool){
        UserDefaults.standard.set(isOpen, forKey: UserInfo.OpenFinger)
    }
    
    //是否开启指纹识别验证
    static func isOpenFingerPrint() -> Bool{
        
        let defaultStyle = UserDefaults.standard.object(forKey: UserInfo.OpenFinger)
        guard defaultStyle != nil else {
            return false
        }
        let isOpen = defaultStyle as! Bool
        if isOpen{
            return true
        }
        return false
    }
    
}
