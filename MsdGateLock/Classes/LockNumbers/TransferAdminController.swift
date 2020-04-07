////
////  TransferAdminController.swift
////  MsdGateLock
////
////  Created by ox o on 2017/6/29.
////  Copyright © 2017年 xiaoxiao. All rights reserved.
////
//
//import UIKit
//
//class TransferAdminController: UIViewController {
//
//    var toptipStr : String!
//    let count : Int = 4
//    //系统蓝牙管理对象
//    var blueManager : BleManager!
//    //当前锁信息
//    var currentLockModel : UserLockListResp!
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        self.title = "转让管理员"
//        self.view.backgroundColor = UIColor.globalBackColor
//        
//        setupUI()
////        setupBluetool(perName: currentLockModel.bluetoothName!)
//        
//    }
//
//
//}
//
//extension TransferAdminController{
//    
//    
//    func setupUI(){
//        let itemHeight : CGFloat = 140.0
//        let collHeight  = CGFloat((count - 1) / 3 + 1) * itemHeight
//        let backView = UIView(frame: CGRect(x: 0, y: 0, width: kScreenWidth, height: collHeight+40.0))
//        backView.backgroundColor = UIColor.white
//        self.view.insertSubview(backView, at: 0)
//        
//        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "确认", style: .plain, target: self, action: #selector(TransferAdminController.okClick))
//        
//        let totalTempLabel = UILabel(frame: CGRect(x: 14, y: 0, width: kScreenWidth, height: 34))
//        totalTempLabel.backgroundColor = UIColor.white
//        totalTempLabel.text = toptipStr
//        totalTempLabel.textColor = UIColor.hex(hexString: "858585)
//        totalTempLabel.font = UIFont.systemFont(ofSize: 12)
//        view.addSubview(totalTempLabel)
//        
//        let line = UIView(frame: CGRect(x: 0, y: 34, width: kScreenWidth, height: 1))
//        line.backgroundColor = UIColor.hex(hexString: "f0f0f0)
//        view.addSubview(line)
//        
//        
//        //定义布局样式
//        let layout = UICollectionViewFlowLayout()
//        layout.scrollDirection = .vertical
//        layout.minimumLineSpacing = 0
////        let collHeight  = CGFloat((count - 1) / 3 + 1) * 155.0
//        
//        QPCLog(collHeight)
//        let leftMagin : CGFloat = 15.0
//        let collecWidth = kScreenWidth - 2*leftMagin
//        let collecFrame = CGRect(x: leftMagin, y: 35, width: collecWidth, height: collHeight)
//        
//        let spacing : CGFloat = 12.0
//        let itemWidth = (collecWidth - spacing * 2) / 3.0
//        layout.itemSize = CGSize(width: itemWidth, height: itemHeight)
//        
//        let collectionView = UICollectionView(frame: collecFrame, collectionViewLayout: layout)
//        collectionView.delegate = self
//        collectionView.dataSource = self
//        collectionView.backgroundColor = UIColor.white
//        collectionView.register(UINib(nibName:"TransferUserCell",bundle:nil), forCellWithReuseIdentifier: "TransferUserCell")
//        collectionView.selectItem(at: IndexPath.init(item: 0, section: 0), animated: false, scrollPosition: .top)
//        self.view.addSubview(collectionView)
//    }
//    
//    
//}
//
//
//
//extension TransferAdminController: UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout{
//    
//    func numberOfSections(in collectionView: UICollectionView) -> Int {
//        return 1
//    }
//    
//    /**
//     - returns: Section中Item的个数
//     */
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return count
//    }
//    
//    /**
//     - returns: 绘制collectionView的cell
//     */
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        
//        
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TransferUserCell", for: indexPath) as! TransferUserCell
//        
////        cell.imageView.kf.setImage(with: URL(string: "http://bbsatt.yineitong.com/forum/2011/03/25/110325164993a2105258f0d314.jpg"), placeholder: UIImage(named: "user1"), options: nil, progressBlock: nil, completionHandler: nil)
////        if indexPath.row == 0{
////            cell.isSelected = true
////        }
//        
//        return cell
//    }
//    
//    // #MARK: --UICollectionViewDelegate的代理方法
//    /**
//     Description:当点击某个Item之后的回应
//     */
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        print("(\(indexPath.section),\(indexPath.row))")
//        collectionView.cellForItem(at: indexPath)?.isSelected = true
//        
//
//    }
//    
//    //    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
//    //        return UIEdgeInsetsMake(0, 16, 0, 0)
//    //    }
//    
//}
//
//
////MARK:蓝牙相关
//extension TransferAdminController : BleManagerDelegate{
//    
//    func okClick(){
//        //        SVProgressHUD.showSuccess(withStatus: "转让权限成功")
//        //        navigationController?.popToRootViewController(animated: true)
//    }
//    
//    func setupBluetool(perName : String){
//        //确定搜索的门锁名
//        QPCLog("连接门锁编号为\(String(describing: perName))")
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
//        }
//    }
//    
//    
//    func discoveredDevicesArray(_ devicesArr: NSMutableArray?, withCBCentralManagerConnectState connectState: String?) {
//        QPCLog(connectState ?? "")
//        if connectState != nil,connectState == "蓝牙已打开,请连接设备"{
//            if devicesArr != nil && (devicesArr?.count)! > 0{
//                for per in devicesArr!{
////                    let pers = per as! CBPeripheral
//                    //                    QPCLog(pers.name)
//                }
//            }
//        }else if connectState != nil,(connectState?.contains("已连接蓝牙"))!{
//            let ownerKey = HYKeychainHelper.password(service: HYKeychainHelper.serviceName, account: HYKeychainHelper.openPassWord)
//            let A = String.getA(lockId: currentLockModel.bluetoothName!, blueMacAdress: currentLockModel.bluetoothMac!, lockSecretKey:ownerKey!)
//            let seletedNewTel = "18602132382"
//            let lockId = currentLockModel.lockId
//            let newBlueMac = "3CA308BA695F"
//            let userInfo = "\(seletedNewTel)\(newBlueMac)1"
//            blueManager.sendCommand(withPort: "05060500", dataStr: "\(lockId!)\(A)\(userInfo)")
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
//            //开门
//            HYKeychainHelper.set(password: backData.substring(to: index), service: HYKeychainHelper.serviceName, account: HYKeychainHelper.openPassWord)
//            //授权
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
//            
//        }else{
//            DispatchQueue.main.async(execute: {
//                SVProgressHUD.showError(withStatus: data)
//            })
//        }
//    }
//    
//}
//
