//
//  LockManageController.swift
//  MsdGateLock
//
//  Created by ox o on 2017/6/30.
//  Copyright © 2017年 xiaoxiao. All rights reserved.
//

import UIKit

class LockManageController: UIViewController {
    
    var tableView : UITableView!
    let cellID : String = "LockManageCell"
    var titleArr : [[String]]  = [["门锁备注"],["所属区域","详细地址"],["报修门锁"]]
    var detailArr = [["家"],["上海市****","***号202室"]]
    var areaString : String!
    var currentLockModel : UserLockListResp!
    var isRepearList : Bool = false
    var repairLockStatu : String = ""
    var repairList : [FaultListResp]?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "门锁管理"
        self.view.backgroundColor = UIColor.globalBackColor
        self.setupNavigationItem()
        self.setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getLockInfo()
        
        getFaultList()
    }
    
    //cell线
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if (self.tableView?.responds(to: #selector(setter: UITableViewCell.separatorInset)))!{
            tableView?.separatorInset = UIEdgeInsets.zero
        }
        
        if (tableView?.responds(to: #selector(setter: UIView.layoutMargins)))!{
            tableView?.layoutMargins = UIEdgeInsets.zero
        }
    }
}

extension LockManageController{
    
    func setupNavigationItem(){
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named : "more"), style: .plain, target: self, action: #selector(LockManageController.moreCick))
    }
    
    func setupUI(){
        
        tableView = UITableView(frame: CGRect(x: 0, y: 0, width: kScreenWidth, height: 320), style: .grouped)
        tableView.isScrollEnabled = false
        tableView.backgroundColor = UIColor.globalBackColor
        tableView.rowHeight = 46
        tableView.delegate = self
        tableView.dataSource = self
        view.addSubview(tableView)
//        UITableViewCell()
//        tableView.register(, forCellReuseIdentifier: cellID)
        
//        let button = UIButton(type: .custom)
//        button.setTitle("报废门锁", for: .normal)
//        button.setTitleColor(UIColor.white, for: .normal)
//        button.layer.cornerRadius = 4
//        button.layer.masksToBounds = true
//        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
//        button.backgroundColor = UIColor.textBlueColor
//        button.addTarget(self, action: #selector(LockManageController.closeLock), for: .touchUpInside)
//        view.addSubview(button)
//        button.snp.makeConstraints { (make) in
//            make.left.equalTo(15)
//            make.right.equalTo(-15)
//            make.bottom.equalTo(-15)
//            make.height.equalTo(44)
//        }
    }
}

extension LockManageController{
    
    //报废门锁
    func closeLock(){
        let alertVC = UIAlertController(title: "警告", message: "报废门锁后,该门锁将无法绑定新用户请确认要报废门锁吗?", preferredStyle: .alert)

        let acSure = UIAlertAction(title: "确认", style: .default) { [weak self] UIAlertAction in
            let req = BaseReq<OneParam<String>>()
            req.sessionId = UserInfo.getSessionId()!
            req.action = GateLockActions.ACTION_AddScrapLock
            req.sign = LockTools.getSignWithStr(str: "oxo")
            req.data = OneParam.init(p1: (self?.currentLockModel?.lockId)!)
            
            AjaxUtil<CommonResp>.actionPost(req: req, backJSON: { (resp) in
                QPCLog(resp.msg)
                SVProgressHUD.showSuccess(withStatus: resp.msg)
                self?.navigationController?.popViewController(animated: true)
            })
            
        }
        let acCancle = UIAlertAction(title: "取消", style: .default) { (UIAlertAction) in
            QPCLog("点击了取消")
        }
        alertVC.addAction(acCancle)
        alertVC.addAction(acSure)
        self.present(alertVC, animated: true, completion: nil)
    }
    
    //恢复出厂设置
    func resetFactorySetting(){
        let alertVC = UIAlertController(title: "警告", message: "恢复出厂值后,所有用户信息都将丢失,若要继续使用该门锁,需要重新绑定确认要恢复出厂值吗?", preferredStyle: .alert)
        let acSure = UIAlertAction(title: "确认", style: .default) { [weak self] (UIAlertAction) in
            let resetVC = ChangeNumberCodeController()
            resetVC.title = "恢复出厂值"
            resetVC.lockModel = self?.currentLockModel
            resetVC.isFactorySetting = true
            self?.navigationController?.pushViewController(resetVC, animated: true)
        }
        let acCancle = UIAlertAction(title: "取消", style: .default) { (UIAlertAction) in
            QPCLog("点击了取消")
        }
        alertVC.addAction(acCancle)
        alertVC.addAction(acSure)
        self.present(alertVC, animated: true, completion: nil)
    }
    
    func getLockInfo(){
    let req =  BaseReq<LockSetInfoReq>()
    req.action = GateLockActions.ACTION_GetLockInfo
    req.sessionId = UserInfo.getSessionId()!
    req.data = LockSetInfoReq(currentLockModel.lockId!)
        
    AjaxUtil<LockSetInfoResp>.actionPost(req: req, backJSON: { [weak self](resp) in
        guard let weakSelf = self else{ return}
        weakSelf.detailArr[0][0]  = resp.data?.remark ?? ""
        weakSelf.detailArr[1][0] = resp.data?.area ?? ""
        weakSelf.detailArr[1][1] = resp.data?.address ?? ""
        weakSelf.tableView.reloadData()
        })
    }
    
    func getFaultList(){
        let req = BaseReq<FaultListReq>()
        req.action = GateLockActions.ACTION_FaultList
        req.sessionId = UserInfo.getSessionId()!
        req.sign = LockTools.getSignWithStr(str: "oxo")
        req.data = FaultListReq.init(currentLockModel.lockId!, userId: UserInfo.getUserId()!)
        
        AjaxUtil<FaultListResp>.actionArrPost(req: req) { [weak self](resp) in
            QPCLog(resp.data)
            guard let weakSelf = self else{ return}
            if resp.data != nil,(resp.data?.count)! > 0 {
                weakSelf.isRepearList = true
                weakSelf.repairList = resp.data
                let ordStatu = (resp.data?.first?.faultState)!
                switch ordStatu{
                case 0:
                    weakSelf.repairLockStatu = "待确认"
                case 1:
                    weakSelf.repairLockStatu = "已确认"
                case 2:
                    weakSelf.repairLockStatu = "未订单完成"
                case 3:
                    weakSelf.repairLockStatu = "订单取消"
                default:
                    QPCLog("超出范围")
                }
                weakSelf.tableView.reloadSections(NSIndexSet.init(index: 2) as IndexSet, with: .fade)
            }else{
                weakSelf.isRepearList = false
            }
        }
    }
    
    @objc func moreCick(){
        let altsheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let action1 = UIAlertAction(title: "更换手机", style: .default) { [weak self] (action) in
            let resetVC = ChangeNumberCodeController()
            resetVC.title = "更换手机"
            resetVC.lockModel = self?.currentLockModel
            self?.navigationController?.pushViewController(resetVC, animated: true)
        }
        let action2 = UIAlertAction(title: "恢复出厂值", style: .default) { [weak self] (action) in
            self?.resetFactorySetting()
        }
        let action3 = UIAlertAction(title: "报废门锁", style: .default) { [weak self] (action) in
//            QPCLog("报废门锁")
            self?.closeLock()
        }
        let action4 = UIAlertAction(title: "取消", style: .cancel) { (action) in
            QPCLog("取消")
        }
        altsheet.addAction(action1)
        altsheet.addAction(action2)
        altsheet.addAction(action3)
        altsheet.addAction(action4)
        present(altsheet, animated: true, completion: nil)
    }
}

//MARK:蓝牙相关
//extension LockManageController  : BleManagerDelegate{
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
//            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 10, execute: {
//                //10s隐藏提示框
//                SVProgressHUD.dismiss()
//            })
//            let didContantPer = blueManager.connectedDevice()
//            //查询当前是否有链接的设备,如有断开连接新设备
//            if didContantPer != nil {
//                if didContantPer?.name == perName {
//                    self.resetFactorySettingWithBlueTool()
//                }else{
//                    blueManager.disConnectDevice(didContantPer!)
//                    blueManager.searchBleDevices()
//                }
//            }else{
//                blueManager.searchBleDevices()
//            }
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
//                    _ = per as! CBPeripheral
//                    //                    QPCLog(pers.name)
//                }
//            }
//        }else if connectState != nil,(connectState?.contains("已连接蓝牙"))!{
//            self.resetFactorySettingWithBlueTool()
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
//            //需添加lockid确定锁的唯一性
//            //保存秘钥
//            QPCLog("------\(backData.substring(from: index))---\(backData.substring(to: index))")
//            //开门
//            QPCKeychainTool.saveOpenPassWordWithKeyChain(openKey: backData.substring(to: index), lockID: lockIdNstr)
//            //授权
//            QPCKeychainTool.saveEncryptPassWordWithKeyChain(authKey: backData.substring(from: index), lockID: lockIdNstr)
//            
//            
//            //根据数据进入下一界面
//            if QPCKeychainTool.existNumberPassword(){
//                let vc = UIStoryboard(name: "LockInfoController", bundle: nil).instantiateViewController(withIdentifier: "lockCode") as! LockInfoController
//                vc.initCode = initCode
//                self.navigationController?.pushViewController(vc, animated: true)
//            }else{
//                let vc = UIStoryboard(name: "NumberPassWordController", bundle: nil).instantiateViewController(withIdentifier: "numberPassWordVC") as! NumberPassWordController
//                vc.isBingLock = "绑定门锁"
//                vc.lockInitCode = initCode
//                self.navigationController?.pushViewController(vc, animated: true)
//            }
//            
//        }else{
//            if data.contains("有相同owner"){
//                let vc = UIStoryboard(name: "LockInfoController", bundle: nil).instantiateViewController(withIdentifier: "lockCode") as! LockInfoController
//                vc.initCode = initCode
//                self.navigationController?.pushViewController(vc, animated: true)
//            }else{
//                DispatchQueue.main.async(execute: {
//                    SVProgressHUD.showError(withStatus: data)
//                    self.scannerStar();
//                })
//            }
//            
//            
//        }
//    }
//    
//}

extension LockManageController: UITableViewDelegate,UITableViewDataSource,PickerDelegate{
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if cell.responds(to: #selector(setter: UIView.layoutMargins)){
            cell.layoutMargins = UIEdgeInsets.zero
        }
        if cell.responds(to: #selector(setter: UITableViewCell.separatorInset)){
            cell.separatorInset = UIEdgeInsets.zero
        }
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 1 {
            return 2
        }else{
            return 1
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: cellID)
        if cell == nil {
            cell = UITableViewCell(style: .value1, reuseIdentifier: cellID)
            cell?.textLabel?.textColor = UIColor.textBlackColor
            cell?.textLabel?.font = kGlobalTextFont
            cell?.detailTextLabel?.font = kGlobalTextFont
            cell?.detailTextLabel?.textColor = UIColor.textGrayColor 
            cell?.accessoryType = .disclosureIndicator
        }
        cell?.textLabel?.text = titleArr[indexPath.section][indexPath.row]
        if indexPath.section == 2 {
            cell?.detailTextLabel?.text = repairLockStatu
        }else{
            cell?.detailTextLabel?.text = detailArr[indexPath.section][indexPath.row]
        }
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 20.0
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.001
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.section == 0 {
            let nickVC = LockRemarkController()
            nickVC.oldValue = self.detailArr[0][0]
            nickVC.cureentLockId = currentLockModel?.lockId
            navigationController?.pushViewController(nickVC, animated: true)
        }else if indexPath.section == 1{
           if indexPath.row == 1 {
            let adressVC = DetailAdressController()
            adressVC.oldValue = self.detailArr[1][1]
            adressVC.cureentLockId = currentLockModel?.lockId
            navigationController?.pushViewController(adressVC, animated: true)
           }else{
                var contentArray = [LmyPickerObject]()
                let plistPath:String = Bundle.main.path(forAuxiliaryExecutable: "area.plist") ?? ""
                let plistArray = NSArray(contentsOfFile: plistPath)
                let proviceArray = NSArray(array: plistArray!)
                for i in 0..<proviceArray.count {
                    var subs0 = [LmyPickerObject]()
                    
                    let cityzzz:NSDictionary = proviceArray.object(at: i) as! NSDictionary
                    let cityArray:NSArray = cityzzz.value(forKey: "cities") as! NSArray
                    for j in 0..<cityArray.count {
                        var subs1 = [LmyPickerObject]()
                        
                        let areazzz:NSDictionary = cityArray.object(at: j) as! NSDictionary
                        let areaArray:NSArray = areazzz.value(forKey: "areas") as! NSArray
                        for m in 0..<areaArray.count {
                            let object = LmyPickerObject()
                            object.title = areaArray.object(at: m) as? String
                            subs1.append(object)
                        }
                        let citymmm:NSDictionary = cityArray.object(at: j) as! NSDictionary
                        let cityStr:String = citymmm.value(forKey: "city") as! String
                        let object = LmyPickerObject()
                        object.title = cityStr
                        subs0.append(object)
                        object.subArray = subs1
                    }
                    let provicemmm:NSDictionary = proviceArray.object(at: i) as! NSDictionary
                    let proviceStr:String? = provicemmm.value(forKey: "state") as! String?
                    let object = LmyPickerObject()
                    object.title = proviceStr
                    object.subArray = subs0
                    contentArray.append(object)
                }
                
                let picker = LmyPicker(delegate: self, style: .nomal)
                picker.contentArray = contentArray
                picker.show()
            }
        }else{
            if isRepearList{
                let orderListVC = OrderLockListController()
                orderListVC.title = "故障报修"
                orderListVC.repairList = repairList
                navigationController?.pushViewController(orderListVC, animated: true)
            }else{
                let repairVC = UIStoryboard(name: "TroubleRepairController", bundle: nil).instantiateViewController(withIdentifier: "TroubleRepairController") as! TroubleRepairController
                repairVC.currentLockID = currentLockModel?.lockId
                navigationController?.pushViewController(repairVC, animated: true)
            }
        }
    }
    
    func chooseElements(picker: LmyPicker, content: [Int : Int]) {
        var str:String = ""
        if let array = picker.contentArray {
            var tempArray = array
            for i in 0..<content.keys.count {
                let value:Int! = content[i]
                if value < tempArray.count {
                    let obj:LmyPickerObject = tempArray[value]
                    let title = obj.title ?? ""
                    if str.count>0 {
                        str = str.appending("-\(title)")
                    }else {
                        str = title;
                    }
                    if let arr = obj.subArray {
                        tempArray = arr
                    }
                }
            }
            areaString = str
            QPCLog(areaString)
            detailArr[1][0] = str
            tableView.reloadData()
            
            let req = BaseReq<UpdateLockAreaReq>()
            req.action = GateLockActions.ACTION_UpdateLock
            req.sessionId = UserInfo.getSessionId()!
            req.sign = LockTools.getSignWithStr(str: "oxo")
            req.data = UpdateLockAreaReq.init(currentLockModel.lockId!, area: areaString)
            AjaxUtil<CommonResp>.actionPost(req: req, backJSON: { (resp) in
                QPCLog(resp)
            })
        }
    }
    
    func chooseDate(picker: LmyPicker, date: Date) {
        
    }

    
}

