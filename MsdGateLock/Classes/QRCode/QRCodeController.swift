//
//  QRCodeController.swift
//  MsdGateLock
//
//  Created by ox o on 2017/6/15.
//  Copyright © 2017年 xiaoxiao. All rights reserved.
//

import UIKit
import AVFoundation

class QRCodeController: UIViewController,AVCaptureMetadataOutputObjectsDelegate {
    //扫描视图
    let cameraView = ScannerBackgroundView(frame:kScreenBounds)
    
    let captureSession = AVCaptureSession()
    //系统蓝牙管理对象
    var blueManager : BleManager!
    var initCode : String!  //初始化id
    var currentLockBlueMac : String?  //当前锁blueAdress
    var lockPassStr : String!  //当前锁秘钥
    var lockIdNstr : String!  //当前锁id
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "门锁二维码"
        self.view.backgroundColor = UIColor.clear
        self.view.addSubview(cameraView)
        
        cameraView.flashBtn.addTarget(self, action: #selector(QRCodeController().flashLightClick), for: .touchUpInside)
        
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
        output.metadataObjectTypes =  [AVMetadataObject.ObjectType.qr,AVMetadataObject.ObjectType.ean13,AVMetadataObject.ObjectType.ean8,AVMetadataObject.ObjectType.code128]
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
    }
    
    deinit {
        QPCLog("我被销毁了")
//        if blueManager != nil{
//            blueManager.bleManagerDelegate = nil
//        }
    }
}

extension QRCodeController{
    
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
                weakSelf?.checkIsBindLock(result)
                
            })
            captureSession.stopRunning()
        }
    }
}

//MARK:- CLICK
extension QRCodeController{
    //输入编码
//    func inCodeClick(){
//        navigationController?.pushViewController(NumLockCodeViewController(), animated: true)
//    }
    
    //检测
    fileprivate func checkIsBindLock(_ qrCodeStr : String){
        QPCLog(qrCodeStr)
        let totalStr = (qrCodeStr as NSString).substring(from: 10)
        let strArr = totalStr.components(separatedBy: "/")
        QPCLog(totalStr)
        lockIdNstr = strArr[0]
        lockPassStr = strArr[1]          //锁秘钥
        initCode = strArr[2]         //初始码
        let req = BaseReq<CheckLockIdReq>()
        req.action = GateLockActions.ACTION_CheckLock
        req.sessionId = UserInfo.getSessionId()!
        req.sign = LockTools.getSignWithStr(str: "oxo")
        req.data = CheckLockIdReq(UserInfo.getUserId()!, lockIdNstr!)
        QPCLog("\(lockIdNstr!)---\(lockPassStr!)--\(initCode!)")
        
        weak var weakSelf = self
        AjaxUtil<TwoParam<String,String>>.actionPost(req: req, backJSON: { (resp) in

                MsdGlobals.scanLockId = weakSelf?.lockIdNstr   //记录绑定id
                QPCLog("\(String(describing: resp.data?.p1))----\(String(describing: resp.data?.p2))")
                weakSelf?.currentLockBlueMac = resp.data?.p1?.replacingOccurrences(of: ":", with: "")
                //蓝牙交互
                weakSelf?.setupBluetool(perName: (resp.data?.p2!)!)

        }) { (errorStr) in
            weakSelf?.scannerStar();
            SVProgressHUD.showError(withStatus: errorStr)
        }
        
    }

    
    @objc func flashLightClick(btn : BottomButton){
        let device = AVCaptureDevice.devices(for: AVMediaType.video)
        if device.count > 0 {
            btn.isEnabled = false
            return
        }
        let device1 = device.first!
//        if device1.TorchMode == AVCaptureDevice.TorchMode.off{
//            do {
//                try device.lockForConfiguration()
//            }catch{
//                return
//            }
//            device.TorchMode = .on
//            device.unlockForConfiguration()
//            btn.isSelected = true
//        }else{
//            do {
//                try device.lockForConfiguration()
//            }catch{
//                return
//            }
//            device.TorchMode = .off
//            device.unlockForConfiguration()
//            btn.isSelected = false
//        }
    }
    
    func bingOwner(){
        let A = String.getA(lockId: lockIdNstr, blueMacAdress: currentLockBlueMac!, lockSecretKey: lockPassStr)
        let userInfo = "\(UserInfo.getUserIdToStr()!)\(QPCKeychainTool.getDeviceIdentifier()!)"
        blueManager.sendCommand(withPort: "02010500", dataStr: "\(lockIdNstr!)\(A)\(userInfo)\(LockTools.getCurrentTime())")
    }
}

//MARK:蓝牙相关
extension QRCodeController  : BleManagerDelegate{
    
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
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 10, execute: {
                //10s隐藏提示框
                SVProgressHUD.dismiss()
            })
            let didContantPer = blueManager.connectedDevice()
            //查询当前是否有链接的设备,如有断开连接新设备
            if didContantPer != nil {
                if didContantPer?.name == perName {
                    self.bingOwner()
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
//                for per in devicesArr!{
//                    _ = per as! CBPeripheral
//                    QPCLog(pers.name)
//                }
            }
        }else if connectState != nil,(connectState?.contains("已连接蓝牙"))!{ 
            self.bingOwner()
        }
    }
    
    func `return`(withData data: String!, isSucceed succeed: Bool, backData: String!){
        
        QPCLog("\(backData!)")
        //测试专用
        DispatchQueue.main.async(execute: {
            SVProgressHUD.dismiss()
        })
        
        if succeed {
            let index = backData.index(backData.startIndex, offsetBy: 16)
            //需添加lockid确定锁的唯一性
            //保存秘钥
            QPCLog("------\(backData.substring(from: index))---\(backData.substring(to: index))")
            //开门
            QPCKeychainTool.saveOpenPassWordWithKeyChain(openKey: backData.substring(to: index), lockID: lockIdNstr)
            //授权
            QPCKeychainTool.saveEncryptPassWordWithKeyChain(authKey: backData.substring(from: index), lockID: lockIdNstr)

            //根据数据进入下一界面
            if QPCKeychainTool.existNumberPassword(){
                let vc = UIStoryboard(name: "LockInfoController", bundle: nil).instantiateViewController(withIdentifier: "lockCode") as! LockInfoController
                vc.initCode = initCode
                self.navigationController?.pushViewController(vc, animated: true)
            }else{
                let vc = UIStoryboard(name: "NumberPassWordController", bundle: nil).instantiateViewController(withIdentifier: "numberPassWordVC") as! NumberPassWordController
                vc.isBingLock = "绑定门锁"
                vc.lockInitCode = initCode
                self.navigationController?.pushViewController(vc, animated: true)
            }
            
        }else{
            //有对应的owner就进入下一步
            if data.contains("有相同owner"){
                let vc = UIStoryboard(name: "LockInfoController", bundle: nil).instantiateViewController(withIdentifier: "lockCode") as! LockInfoController
                vc.initCode = initCode
                self.navigationController?.pushViewController(vc, animated: true)
            }else{
                DispatchQueue.main.async(execute: {
                    SVProgressHUD.showError(withStatus: data)
                    self.scannerStar();
                })
            }
            

        }
    }
    
}


