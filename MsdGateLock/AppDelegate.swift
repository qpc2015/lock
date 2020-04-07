//
//  AppDelegate.swift
//  MsdGateLock
//
//  Created by xiaoxiao on 2017/5/24.
//  Copyright © 2017年 xiaoxiao. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import Alamofire

@UIApplicationMain

class AppDelegate: UIResponder, UIApplicationDelegate{

    var window: UIWindow?
    
    lazy var reachability: NetworkReachabilityManager? = {
        return NetworkReachabilityManager(host: "lock.diadiade.com")
    }()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        
        //保存标识
        QPCKeychainTool.syncDeviceIdentifier()
        getRootController()
        setupBaseConfig(launchOptions: launchOptions)
        return true
    }
    
    func getRootController() {
        window = UIWindow(frame: UIScreen.main.bounds)
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
        window?.makeKeyAndVisible()
    }
    
    func setupBaseConfig(launchOptions: [UIApplication.LaunchOptionsKey : Any]?) {
        IQKeyboardManager.shared.enable = true
        //初始化程序语言
        LanguageHelper.shareInstance.initUserLanguage()
        //推送
        let entity = JPUSHRegisterEntity()
        entity.types = 1 << 0 | 1 << 1 | 1 << 2
        //通知类型（这里将声音、消息、提醒角标都给加上）
        JPUSHService.register(forRemoteNotificationConfig: entity, delegate: self)
        JPUSHService.setup(withOption: launchOptions,
                           appKey:"492bea3f208d2805ecb58159",
                           channel:"app store",
                           apsForProduction: false)
        //网络监控
        reachability?.startListening(onQueue: .main, onUpdatePerforming: { [weak self] status in
            switch status {
            case .notReachable:
                HomeViewController.isConnectNetWork = false
                self?.checkNoNetworkWithAlext()
                print("网络已断开")
            default:
                HomeViewController.isConnectNetWork = true
                print("网络已连接")
            }
        })
    }
    
    private func checkNoNetworkWithAlext(){
        let alertVC = UIAlertController(title: nil, message: "当前网络不可用,请检查网络是否连接", preferredStyle: .alert)
        let acSure = UIAlertAction(title: "确定", style: .default) { (UIAlertAction) in
            QPCLog("打开")
        }
        alertVC.addAction(acSure)
        self.window?.rootViewController?.present(alertVC, animated: true, completion: nil)
    }
}

//MARK:- 第三方初始化
extension AppDelegate: JPUSHRegisterDelegate{
    
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
    
    func jpushNotificationCenter(_ center: UNUserNotificationCenter!, openSettingsFor notification: UNNotification!) {

    }
    
    func jpushNotificationAuthorization(_ status: JPAuthorizationStatus, withInfo info: [AnyHashable : Any]!) {
        
    }
    
    //处于前台是接收到通知
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


