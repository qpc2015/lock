////
////  NumLockCodeViewController.swift
////  MsdGateLock
////
////  Created by ox o on 2017/6/21.
////  Copyright © 2017年 xiaoxiao. All rights reserved.
////
//
//import UIKit
//import CoreBluetooth
//
//class NumLockCodeViewController: UIViewController {
//
//    @IBOutlet weak var numTextfield: UITextField!
//    //系统蓝牙管理对象
//    var blueManager : BleManager!
//    var blueManagerIsOn : Bool?{
//        didSet{
//            if blueManagerIsOn! {
//                let alertVC = UIAlertController(title: "温馨提示", message: "设备蓝牙已关闭,是否现在打开", preferredStyle: .alert)
//                let acSure = UIAlertAction(title: "打开", style: .default) { (UIAlertAction) in
//                    QPCLog("打开")
//                    let url = URL(string: "App-Prefs:root=Bluetooth")
//                    if UIApplication.shared.canOpenURL(url!){
//                        UIApplication.shared.openURL(url!)
//                    }
//                }
//                let acCancle = UIAlertAction(title: "取消", style: .default) { (UIAlertAction) in
//                    QPCLog("点击了取消")
//                }
//                alertVC.addAction(acCancle)
//                alertVC.addAction(acSure)
//                self.present(alertVC, animated: true, completion: nil)
//            }
//        }
//    }
//    
//    var currentLockId : String?  //获取到当前锁id
//    var currentLockBlueMac : String?  //当前锁blueAdress
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        self.title = "输入门锁编码"
//        self.view.backgroundColor = UIColor.globalBackColor
//        
//        numTextfield.becomeFirstResponder()
//        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "下一步", style: .plain, target: self, action: #selector(NumLockCodeViewController.nextStep))
//    }
//
//    func nextStep(){
//        QPCLog(#function)
//        let lockid = numTextfield.text ?? ""
//        if lockid.characters.count > 0{
//            currentLockId = lockid
//            checkIsBindLock(lockid)
//        }else{
//            SVProgressHUD.showError(withStatus: "请输入正确的门锁编号")
//        }
//    }
//}
//
//
//extension NumLockCodeViewController{
//    
//    //检测
//    fileprivate func checkIsBindLock(_ lockid : String){
//        
//        let req = BaseReq<CheckLockIdReq>()
//        req.action = GateLockActions.ACTION_CheckLock
//        req.sessionId = UserInfo.getSessionId()
//        req.sign = LockTools.getSignWithStr(str: "oxo")
//        req.data = CheckLockIdReq(UserInfo.getUserId(), lockid)
//        
//        weak var weakSelf = self
//        AjaxUtil<TwoParam<String,String>>.actionPost(req: req){
//            (resp) in
//            SVProgressHUD.showSuccess(withStatus: resp.msg)
//            MsdGlobals.scanLockId = lockid   //记录绑定id
//            QPCLog("\(String(describing: resp.data?.p1))----\(resp.data?.p2)")
//            weakSelf?.currentLockBlueMac = resp.data?.p1?.replacingOccurrences(of: ":", with: "")
//            //蓝牙交互
//            weakSelf?.setupBluetool(perName: resp.data?.p2?.replacingOccurrences(of: " ", with: ""))
//        }
//    }
//}
//
//
//extension NumLockCodeViewController  : BleManagerDelegate{
//    
//    func setupBluetool(perName : String?){
//        //确定搜索的门锁名
//        QPCLog("连接门锁编号为\(perName)")
//        UserDefaults.standard.set(perName, forKey: "per")
//        
//        blueManager = BleManager.shared()
//        blueManager.bleManagerDelegate = self
//        
//        if !(blueManager.powerOn) {
//            let alertVC = UIAlertController(title: "温馨提示", message: "设备蓝牙已关闭,是否现在打开", preferredStyle: .alert)
//            let acSure = UIAlertAction(title: "打开", style: .default) { (UIAlertAction) in
//                QPCLog("打开")
//                let url = URL(string: "App-Prefs:root=Bluetooth")
//                if UIApplication.shared.canOpenURL(url!){
//                    UIApplication.shared.openURL(url!)
//                }
//            }
//            let acCancle = UIAlertAction(title: "取消", style: .default) { (UIAlertAction) in
//                QPCLog("点击了取消")
//            }
//            alertVC.addAction(acCancle)
//            alertVC.addAction(acSure)
//            self.present(alertVC, animated: true, completion: nil)
//        }else{
//            SVProgressHUD.show(withStatus: "门锁连接中...")
//            let didContantPer = blueManager.connectedDevice()
//            //查询当前是否有链接的设备,如有断开连接新设备
//            if didContantPer != nil {
//                blueManager.disConnectDevice(didContantPer!)
//            }
//            blueManager.searchBleDevices()
//            
//        }
//    }
//    
//    
//    func discoveredDevicesArray(_ devicesArr: NSMutableArray?, withCBCentralManagerConnectState connectState: String?) {
//        QPCLog(connectState ?? "")
//        if connectState != nil,connectState == "蓝牙已打开,请连接设备"{
//            if devicesArr != nil && (devicesArr?.count)! > 0{
//                for per in devicesArr!{
//                    let pers = per as! CBPeripheral
//                    QPCLog(pers.name)
//                }
//            }
//            
//        }else if connectState != nil,(connectState?.contains("已连接蓝牙"))!{
//            QPCLog("我是唯一\(String(describing: LoginKeyChainTool.getDeviceIdentifier()!))")
//            //todo 测试锁id  a值生成(锁 ID 信息/锁蓝牙 mac 地址信息/锁密钥 这三 部分的 hash 生成的信息 A)
//            let TestlockId = "1234567890"
//            let getAstr = "\(TestlockId)\(currentLockBlueMac!)abcdabcdabcdabcd"
//            let A = getAstr.MD5()
//            let userInfo = "\(UserInfo.getPhoneNumber())\(currentLockBlueMac!)"
//            QPCLog("\(A)--\(userInfo)")
//            blueManager.sendCommand(withPort: "02010500", dataStr: "\(TestlockId)\(A)\(userInfo)\(LockTools.getCurrentTime())")
//        }
//    }
//    
//    func `return`(withData data: String!, isSucceed succeed: Bool, backData: String!){
//        
//        QPCLog("\(backData!)")
//        //测试专用
//        DispatchQueue.main.async(execute: {
//            SVProgressHUD.dismiss()
//        })
//        
//        if succeed {
//            let index = backData.index(backData.startIndex, offsetBy: 16)
//            //保存秘钥
//            QPCLog("------\(backData.substring(from: index))---\(backData.substring(to: index))")
//            HYKeychainHelper.set(password: backData.substring(to: index), service: HYKeychainHelper.serviceName, account: HYKeychainHelper.openPassWord)
//            HYKeychainHelper.set(password: backData.substring(from: index), service: HYKeychainHelper.serviceName, account: HYKeychainHelper.encryptPassWord)
//            
//            //根据数据进入下一界面
//            if LoginKeyChainTool.existNumberPassword(){
//                let vc = UIStoryboard(name: "LockInfoController", bundle: nil).instantiateViewController(withIdentifier: "lockCode")
//                self.navigationController?.pushViewController(vc, animated: true)
//            }else{
//                let vc = UIStoryboard(name: "NumberPassWordController", bundle: nil).instantiateViewController(withIdentifier: "numberPassWordVC") as! NumberPassWordController
//                vc.isBingLock = "绑定门锁"
//                self.navigationController?.pushViewController(vc, animated: true)
//            }
//        }else{
//            DispatchQueue.main.async(execute: { 
//                SVProgressHUD.showError(withStatus: data)
//            })
//        }
//    }
//
//}
//
//
//
