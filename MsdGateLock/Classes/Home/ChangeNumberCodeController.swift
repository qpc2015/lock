//
//  ChangeNumberCodeController.swift
//  MsdGateLock
//
//  Created by ox o on 2017/9/6.
//  Copyright © 2017年 xiaoxiao. All rights reserved.
//  更换手机重新绑定

import UIKit
import AVFoundation
import Reachability

class ChangeNumberCodeController:  UIViewController,AVCaptureMetadataOutputObjectsDelegate {
    //扫描视图
    let cameraView = ScannerBackgroundView(frame:kScreenBounds)
    let captureSession = AVCaptureSession()
    //系统蓝牙管理对象
    var blueManager : BleManager!
    var initCode : String!  //初始化id
//    var currentLockBlueMac : String?  //当前锁blueAdress
    var lockPassStr : String!  //当前锁秘钥
    var lockIdNstr : String!  //当前锁id
    var dataManager = QPCDataManager.shareManager
    var isFactorySetting : Bool = false
    var lockModel : UserLockListResp!
    var reachability: Reachability
    
    override func viewDidLoad() {
        super.viewDidLoad()
        do {
            try reachability = Reachability()
        } catch {
            print(error)
        }
        
        self.view.backgroundColor = UIColor.clear
        self.view.addSubview(cameraView)
        
        if (self.title == "恢复出厂值"){
            startListenNetStatuChange()
        }
        
        let label = UILabel()
        label.text = "为了您的安全,管理员更换手机,需要重新\n扫描门锁内二维码"
        label.numberOfLines = 0
        label.textColor = UIColor.white
        label.font = kGlobalTextFont
        self.view.addSubview(label)
        label.snp.makeConstraints { (make) in
            make.centerX.equalTo(self.view)
            make.top.equalTo(20)
        }
        
        cameraView.flashBtn.addTarget(self, action: #selector(QRCodeController.flashLightClick), for: .touchUpInside)
        
        //初始化捕捉设备
        let captureDevice = AVCaptureDevice.default(for: .video)
        let input : AVCaptureDeviceInput
        //创建媒体数据输出流
        let output = AVCaptureMetadataOutput()
        
        //捕捉异常
        do{
            //创建输入流
            input = try AVCaptureDeviceInput(device: captureDevice!)
            //把输入流添加到回话
            captureSession.addInput(input)
            //吧输出流添加到会话
            captureSession.addOutput(output)
        }catch{
            QPCLog("异常\(error)")
        }
        
        //创建串行队列
        let dispatchQueue = DispatchQueue(label: "queue",attributes:[])
        
        //设置输出流的代理
        output.setMetadataObjectsDelegate(self, queue: dispatchQueue)
        
        //设置输出媒体的数据类型
        output.metadataObjectTypes = [AVMetadataObject.ObjectType.qr,AVMetadataObject.ObjectType.ean13,AVMetadataObject.ObjectType.ean8,AVMetadataObject.ObjectType.code128]
        //创建预览图层
        let videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        //设置预览图层的填充方式
        videoPreviewLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
        videoPreviewLayer.frame = kScreenBounds
        //将预览图层添加到预览视图上
        cameraView.layer.insertSublayer(videoPreviewLayer, at: 0)
        //设置扫描范围
        output.rectOfInterest = CGRect(x: 0.2, y: 0.2, width: 0.6, height: 0.6)

    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.scannerStar()
        navigationController?.navigationBar.barTintColor = kRGBColorFromHex(rgbValue: 0x353535)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.barTintColor = kNavigationBarColor
        reachability.stopNotifier()
    }
    

}


extension ChangeNumberCodeController{
    
    func scannerStar(){
        captureSession.startRunning()
        cameraView.scanning = "start"
    }
    
    func scannerStop(){
        captureSession.stopRunning()
        cameraView.scanning = "stop"
    }
    
    //扫描代理方法
    func captureOutput(_ captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [Any]!, from connection: AVCaptureConnection!) {
        weak var weakSelf = self
        
        if metadataObjects != nil && metadataObjects.count > 0{
            let metaData : AVMetadataMachineReadableCodeObject = metadataObjects.first as! AVMetadataMachineReadableCodeObject
            QPCLog(metaData.stringValue)
            
            DispatchQueue.main.async(execute: {
                
                guard let result = metaData.stringValue else{
                    return
                }
                //本地查询对应id锁信息
                weakSelf?.checkLockInfo(result)
            })
            captureSession.stopRunning()
        }
    }
}

//MARK:- CLICK
extension ChangeNumberCodeController{
    
    //检查网络
    fileprivate func startListenNetStatuChange(){
        weak var weakSelf = self
        
        reachability.whenUnreachable = { reachability in
            DispatchQueue.main.async {
                QPCLog("Not reachable")
               weakSelf?.checkNoNetworkWithAlext()
            }
        }
        
        do{
            try reachability.startNotifier()
        }catch{
            print("Unable to start notifier")
        }
    }
    
    private func checkNoNetworkWithAlext(){
        let alertVC = UIAlertController(title: nil, message: "当前网络不可用,请检查网络是否连接", preferredStyle: .alert)
        let acSure = UIAlertAction(title: "确定", style: .default) { (UIAlertAction) in
            QPCLog("打开")
        }
        alertVC.addAction(acSure)
        self.present(alertVC, animated: true, completion: nil)
    }
    
    //检测
    fileprivate func checkLockInfo(_ qrCodeStr : String){
        QPCLog(qrCodeStr)
        let totalStr = (qrCodeStr as NSString).substring(from: 10)
        let strArr = totalStr.components(separatedBy: "/")
        QPCLog(totalStr)
        lockIdNstr = strArr[0]
        lockPassStr = strArr[1]          //锁秘钥
        initCode = strArr[2]         //初始码

//        if dataManager.fetchLockData(lockID: lockIdNstr) != nil{
//            let lockResult = dataManager.fetchLockData(lockID: lockIdNstr)!
//            QPCLog("\(String(describing: lockResult.bluetoothMac))----\(String(describing: lockResult.bluetoothName))")
//            self.currentLockBlueMac = lockResult.bluetoothMac?.replacingOccurrences(of: ":", with: "")
            //蓝牙交互
            self.setupBluetool(perName: lockModel.bluetoothName!)
//        }else{
//            QPCLog("本地未查到对应id的锁")
//        }
        
//        }) { (errorStr) in
//            weakSelf?.scannerStar();
//            SVProgressHUD.showError(withStatus: errorStr)
//        }
        
    }
    
    
    func flashLightClick(btn : BottomButton){
        let device = AVCaptureDevice.default(for:.video)
        if device == nil {
            btn.isEnabled = false
            return
        }
        if device!.torchMode == AVCaptureDevice.TorchMode.off{
            do {
                try device?.lockForConfiguration()
            }catch{
                return
            }
            device?.torchMode = .on
            device?.unlockForConfiguration()
            btn.isSelected = true
        }else{
            do {
                try device?.lockForConfiguration()
            }catch{
                return
            }
            device?.torchMode = .off
            device?.unlockForConfiguration()
            btn.isSelected = false
        }
    }
    
    //此接口使用Owner 权限转移
    func resetBingOwner(){
        let currentLockBlueMac = lockModel.bluetoothMac?.replacingOccurrences(of: ":", with: "")
        let A = String.getA(lockId: lockIdNstr, blueMacAdress: currentLockBlueMac!, lockSecretKey: lockPassStr)
        //手机mac
        let userInfo = "\(UserInfo.getUserIdToStr()!)\(QPCKeychainTool.getDeviceIdentifier()!)1"
        blueManager.sendCommand(withPort: "05060500", dataStr: "\(lockIdNstr!)\(A)\(userInfo)")
    }
    
    //恢复出厂蓝牙
    func resetFactorySettingWithBlueTool(){
        let blueStr = "\(lockIdNstr!)\(lockPassStr!)\(LockTools.getCurrentTime())"
        blueManager.sendCommand(withPort: "01010100", dataStr: blueStr)
    }
    
    //重置门锁
    func resetLockWithServe(){
        
        let req = BaseReq<OneParam<String>>()
        req.action = GateLockActions.ACTION_AddResetLock
        req.sessionId = UserInfo.getSessionId()!
        req.sign = LockTools.getSignWithStr(str: "oxo")
        req.data = OneParam.init(p1:lockIdNstr)
        
        weak var weakSelf = self
        AjaxUtil<CommonResp>.actionPost(req: req, backJSON: { (resp) in
            QPCLog(resp)
            self.navigationController?.popToRootViewController(animated: true)
        }) { (errStr) in
            SVProgressHUD.showError(withStatus: errStr)
            //提示重置失败弹框
//            let alertVC = UIAlertController(title: "温馨提示", message: "本次门锁初始化出现故障,请拨打400进行报修", preferredStyle: .alert)
//            let acSure = UIAlertAction(title: "确定", style: .default) { (UIAlertAction) in
//                QPCLog("打开")
//
//            }
//            let acCancle = UIAlertAction(title: "取消", style: .default) { (UIAlertAction) in
//                QPCLog("点击了取消")
//            }
//            alertVC.addAction(acCancle)
//            alertVC.addAction(acSure)
//            weakSelf?.present(alertVC, animated: true, completion: nil)
        }
        
       }
    
}

//MARK:蓝牙相关
extension ChangeNumberCodeController  : BleManagerDelegate{
    
    func setupBluetool(perName : String){
        //确定搜索的门锁名
        QPCLog("连接门锁编号为\(String(describing: perName))")
        UserDefaults.standard.set(perName, forKey: "per")
        
        blueManager = BleManager.shared()
        blueManager.bleManagerDelegate = self
        
        if !(blueManager.powerOn) {
            let alertVC = UIAlertController(title: "温馨提示", message: "设备蓝牙已关闭,是否现在打开", preferredStyle: .alert)
            let acSure = UIAlertAction(title: "打开", style: .default) { (UIAlertAction) in
                QPCLog("打开")
                let url = URL(string: "App-Prefs:root=Bluetooth")
                if UIApplication.shared.canOpenURL(url!){
                    UIApplication.shared.openURL(url!)
                }
            }
            let acCancle = UIAlertAction(title: "取消", style: .default) { (UIAlertAction) in
                QPCLog("点击了取消")
            }
            alertVC.addAction(acCancle)
            alertVC.addAction(acSure)
            self.present(alertVC, animated: true, completion: nil)
        }else{
            SVProgressHUD.show(withStatus: LanguageHelper.getString(key: "BlueTool_LockConnectLoading"))
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 8, execute: {
                //10s隐藏提示框
                SVProgressHUD.dismiss()
            })
            let didContantPer = blueManager.connectedDevice()
            //查询当前是否有链接的设备,如有断开连接新设备
            if didContantPer != nil {
                if didContantPer?.name == perName {
                    if (self.title == "更换手机"){
                        self.resetBingOwner()
                    }else{
                        self.resetFactorySettingWithBlueTool()
                    }
                }else{
                    blueManager.disConnectDevice(didContantPer!)
                    blueManager.searchBleDevices()
                }
            }else{
                blueManager.searchBleDevices()
            }
            
        }
    }
    
    
    func discoveredDevicesArray(_ devicesArr: NSMutableArray?, withCBCentralManagerConnectState connectState: String?) {
        QPCLog(connectState ?? "")
        if connectState != nil,connectState == "蓝牙已打开,请连接设备"{
            if devicesArr != nil && (devicesArr?.count)! > 0{
                for per in devicesArr!{
                    _ = per as! CBPeripheral
                    //                    QPCLog(pers.name)
                }
            }
        }else if connectState != nil,(connectState?.contains("已连接蓝牙"))!{
            if (self.title == "更换手机"){
                self.resetBingOwner()
            }else{
                self.resetFactorySettingWithBlueTool()
            }
        }
    }
    
    func `return`(withData data: String!, isSucceed succeed: Bool, backData: String!){
        
        QPCLog("\(backData!)")
        switch data! {
        case "更改成功":
            let index = backData.index(backData.startIndex, offsetBy: 16)
            //需添加lockid确定锁的唯一性
            //保存秘钥
            QPCLog("------\(backData.substring(from: index))---\(backData.substring(to: index))")
            //开门
            QPCKeychainTool.saveOpenPassWordWithKeyChain(openKey: backData.substring(to: index), lockID: lockIdNstr)
            //授权
            QPCKeychainTool.saveEncryptPassWordWithKeyChain(authKey: backData.substring(from: index), lockID: lockIdNstr)
            //10s隐藏提示框
            SVProgressHUD.dismiss()
            SVProgressHUD.showSuccess(withStatus: "更换手机成功")
            self.navigationController?.popViewController(animated: true)
        case "写入成功":
            UserInfo.deletedLockIsSetupWithNumberAndBlueName(soleStr: UserInfo.getPhoneNumber()! + lockModel.bluetoothName!)
            QPCLog(UserInfo.getLockIsSetupWithNumberAndBlueName(soleStr: UserInfo.getPhoneNumber()! + lockModel.bluetoothName!))
            resetLockWithServe()
        case "写入失败":
          SVProgressHUD.showError(withStatus: "初始化失败!")
        case "校验失败":
          SVProgressHUD.showError(withStatus: "初始化失败!")
        default:
            DispatchQueue.main.async(execute: {
                SVProgressHUD.showError(withStatus: data)
            })
        }

    }
    
}
