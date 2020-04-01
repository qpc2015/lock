//
//  AppDelegate.swift
//  MsdGateLock
//
//  Created by xiaoxiao on 2017/5/24.
//  Copyright © 2017年 xiaoxiao. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
var instance:AppDelegate!;

@UIApplicationMain

class AppDelegate: UIResponder, UIApplicationDelegate{

    var window: UIWindow?
    
    static func getInstance() -> AppDelegate {
        return instance!;
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        //保存标识
        QPCKeychainTool.syncDeviceIdentifier()
        // 得到当前应用的版本号
        let infoDictionary = Bundle.main.infoDictionary
        let currentAppVersion = infoDictionary!["CFBundleShortVersionString"] as! String
        
        // 取出之前保存的版本号
        let userDefaults = UserDefaults.standard
        let appVersion = userDefaults.string(forKey: "appVersion")
        
        if appVersion == nil || appVersion != currentAppVersion {
            QPCLog("--\(String(describing: appVersion))---当前版本\(currentAppVersion)")
            // 保存最新的版本号
            userDefaults.setValue(currentAppVersion, forKey: "appVersion")
            self.window?.rootViewController = GuideViewController()
            
        }else{
            if isLogin{
                //判断权限用户是否设置数字密码
                if (QPCKeychainTool.existNumberPassword()){
                    self.window?.rootViewController = LockNavigationController(rootViewController: NumberPassVerifController())
                }else{
                    self.window?.rootViewController = LockNavigationController(rootViewController: HomeViewController())
                }
            }else{
                window?.rootViewController = LockNavigationController(rootViewController: LoginController())
            }
        }
        IQKeyboardManager.shared.enable = true
        //初始化程序语言
        LanguageHelper.shareInstance.initUserLanguage()
        setupJpush(launchOptions: launchOptions)
        window?.makeKeyAndVisible()
        return true
    }
    
}

//MARK:- 第三方初始化
extension AppDelegate{
    
    
    func setupJpush(launchOptions: [UIApplication.LaunchOptionsKey : Any]?){
        if #available(iOS 10.0, *){
            let entiity = JPUSHRegisterEntity()
            entiity.types = Int(UNAuthorizationOptions.alert.rawValue |
                UNAuthorizationOptions.badge.rawValue |
                UNAuthorizationOptions.sound.rawValue)
            JPUSHService.register(forRemoteNotificationConfig: entiity, delegate: self)
        }else {
            let type = UIRemoteNotificationType.badge.rawValue |
                UIRemoteNotificationType.sound.rawValue |
                UIRemoteNotificationType.alert.rawValue
            JPUSHService.register(forRemoteNotificationTypes: type, categories: nil)
        }
        
        JPUSHService.setup(withOption: launchOptions,
                           appKey: "99b340b9a890a31180407e0b",
                           channel: "app store",
                           apsForProduction: false)
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        JPUSHService.registerDeviceToken(deviceToken)
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        JPUSHService.handleRemoteNotification(userInfo)
        completionHandler(.newData)
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
        JPUSHService.handleRemoteNotification(userInfo)
    }
    
}


extension AppDelegate : JPUSHRegisterDelegate{
    //处于前台是接收到通知
    @available(iOS 10.0, *)
    func jpushNotificationCenter(_ center: UNUserNotificationCenter!, willPresent notification: UNNotification!, withCompletionHandler completionHandler: ((Int) -> Void)!) {
        print(">JPUSHRegisterDelegate jpushNotificationCenter willPresent");
        let userInfo = notification.request.content.userInfo
        if (notification.request.trigger?.isKind(of: UNPushNotificationTrigger.self))!{
            JPUSHService.handleRemoteNotification(userInfo)
            //需要处理
            extrasOfNotificationWithUserinfo(userInfo: userInfo)
        }
        completionHandler(Int(UNAuthorizationOptions.alert.rawValue))// 需要执行这个方法，选择是否提醒用户，有Badge、Sound、Alert三种类型可以选择设置
    }
    //点击处理事件
    @available(iOS 10.0, *)
    func jpushNotificationCenter(_ center: UNUserNotificationCenter!, didReceive response: UNNotificationResponse!, withCompletionHandler completionHandler: (() -> Void)!) {
        print(">JPUSHRegisterDelegate jpushNotificationCenter didReceive");
        //需要处理
        let userInfo = response.notification.request.content.userInfo
        extrasOfNotificationWithUserinfo(userInfo: userInfo)
        if (response.notification.request.trigger?.isKind(of: UNPushNotificationTrigger.self))!{
            JPUSHService.handleRemoteNotification(userInfo)
        }
        completionHandler()
    }
    
    
    func extrasOfNotificationWithUserinfo(userInfo: [AnyHashable : Any]){
        QPCLog(userInfo)
        let webVC = LockWebViewContrller()
        webVC.urlStr = "https://www.baidu.com/"
        let navVC = self.window?.rootViewController as? LockNavigationController
        navVC?.pushViewController(webVC, animated: true)
    }

}


