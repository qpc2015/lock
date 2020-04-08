//
//  TempUserDetailController.swift
//  MsdGateLock
//
//  Created by ox o on 2017/6/26.
//  Copyright © 2017年 xiaoxiao. All rights reserved.
// 临时用户详情

import UIKit

class TempUserDetailController: UITableViewController {
    
    @IBOutlet weak var memberTip: UILabel!
    @IBOutlet weak var bzTip: UILabel!
    @IBOutlet weak var starTip: UILabel!
    @IBOutlet weak var endTip: UILabel!
    
    @IBOutlet weak var memberLabel: UILabel!
    @IBOutlet weak var remarkLabel: UILabel!
    @IBOutlet weak var starTimeLabel: UILabel!
    @IBOutlet weak var endTimeLabel: UILabel!
    @IBOutlet weak var openListBtn: UIButton!
    
    var userModel : AuthInfoListResp!
    var lockModel : UserLockListResp!   //对应锁信息
    var userDetail : RoleUserDetail!
    //系统蓝牙管理对象
    var blueManager : BleManager!
    
//    lazy var datePick : LYJDatePicker02 = {
//        let datePick = LYJDatePicker02()
//        return datePick
//    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor.globalBackColor
        self.title = "\(String(describing: userModel.sourceName))的详情"
        self.setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        getRoleByUser()
    }
    
}


extension TempUserDetailController{
    
    func getRoleByUser(){
        let req = BaseReq<TwoParam<String,Int>>()
        req.action = GateLockActions.ACTION_GetRoleByUser
        req.sessionId = UserInfo.getSessionId()!
        req.sign = LockTools.getSignWithStr(str: "oxo")
        req.data = TwoParam.init(p1: lockModel.lockId!, p2: Int(userModel.userId)!)
        
        AjaxUtil<RoleUserDetail>.actionPost(req: req) { [weak self](resp) in
            QPCLog(resp)
            guard let weakSelf = self else {return}
            weakSelf.userDetail = resp.data
            weakSelf.resetValue()
            weakSelf.tableView.reloadData()
        }
    }
    
    func setupUI(){
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named : "more"), style: .plain, target: self, action: #selector(TempUserDetailController.moreCick))
        
        memberTip.textColor = UIColor.textBlackColor
        bzTip.textColor = UIColor.textBlackColor
        starTip.textColor = UIColor.textBlackColor
        endTip.textColor = UIColor.textBlackColor
        
        memberLabel.textColor = UIColor.textGrayColor
        remarkLabel.textColor = UIColor.textGrayColor
        starTimeLabel.textColor = UIColor.textGrayColor
        endTimeLabel.textColor = UIColor.textGrayColor
        
        openListBtn.setTitleColor(UIColor.textBlackColor, for: .normal)
        openListBtn.addTarget(self, action: #selector(TempUserDetailController.openListClick), for: .touchUpInside)
        
        

    }
    
    func resetValue(){
        memberLabel.text = userDetail.userTel
        remarkLabel.text = userDetail.sourceName
        //memberName需要判断
        remarkLabel.text = userDetail.sourceName
        starTimeLabel.text = LockTools.stringToTimeYMDHmStr(stringTime: userDetail.startTime)
        endTimeLabel.text = LockTools.stringToTimeYMDHmStr(stringTime: userDetail.endTime)
        
        self.title = "\(String(describing: userDetail.sourceName))的详情"
    }

}

extension TempUserDetailController{
    
    @objc func openListClick(){
        QPCLog("开门记录")
        let openListVC = AuthUserOpenListController()
        openListVC.isHiddenSub = false
        openListVC.currentLockID = lockModel.lockId
        openListVC.lockTitle = lockModel.remark
        openListVC.subTitleStr = userModel.sourceName
        navigationController?.pushViewController(openListVC, animated: true)
    }
    
    @objc func moreCick(){
        QPCLog(#function)
        let altsheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
//        let action1 = UIAlertAction(title: "转为授权用户", style: .default) { (action) in
//            QPCLog("转让授权用户")
//            let changeAuthVC = UIStoryboard(name: "ChangeAuthUserController", bundle: nil).instantiateViewController(withIdentifier: "ChangeAuthUserController")
//            weakSelf!.navigationController?.pushViewController(changeAuthVC, animated: true)
//        }

        let action2 = UIAlertAction(title: "移除成员", style: .default) { [weak self](action) in
            QPCLog("移除成员")
            self?.deletedUserAction()
        }
        
        let action3 = UIAlertAction(title: "取消", style: .cancel) { (action) in
            QPCLog("取消")
        }

        altsheet.addAction(action2)
        altsheet.addAction(action3)

        present(altsheet, animated: true, completion: nil)
    }
    
    //删除成员
    func deletedUserAction(){
        
        //如果用户在蓝牙附近,直接蓝牙删除,否则直接发送给service
        setupBluetool(perName: lockModel.bluetoothName!)
        
    }
    
    //通知服务器删除改用户, 1：在锁旁边（连上了蓝牙）2：不在锁旁边
    func deletedUserWithService(isNearBy : Int){
        let req = BaseReq<ThreeParam<String,String,Int>>()
        req.action = GateLockActions.ACTION_DeleteUser
        req.sessionId = UserInfo.getSessionId()!
        req.sign = LockTools.getSignWithStr(str: "oxo")
        req.data = ThreeParam.init(p1: self.userModel.userId, p2: lockModel.lockId!, p3: isNearBy)
        AjaxUtil<CommonResp>.actionPost(req: req, backJSON: { [weak self](resp) in
            QPCLog(resp)
            self?.navigationController?.popViewController(animated: true)
        }) { (errorStr) in
            QPCLog(errorStr)
            SVProgressHUD.showError(withStatus: errorStr)
        }
    }
    
    func seletedTimeClick(str : String){
        
        let datepicker = WSDatePickerView.init(dateStyle: DateStyleShowYearMonthDayHourMinute) { [weak self](selectDate) in
            let dateStr = selectDate?.string_from(formatter: "yyyy-MM-dd HH:mm")
            QPCLog("选择的日期:\(String(describing: dateStr))")
            if str == "开始时间" {
                self?.starTimeLabel.text = dateStr
            }else if str == "结束时间"{
                self?.endTimeLabel.text = dateStr
            }
        }
        datepicker?.dateLabelColor = UIColor.textBlueColor
        datepicker?.datePickerColor = UIColor.textBlackColor
        datepicker?.doneButtonColor = UIColor.textBlueColor
        datepicker?.show()
        
        
//        weak var weakSelf = self
//        self.datePick.canButtonReturnB = {
//            
//            QPCLog("我要消失了哈哈哈哈哈哈")
//            weakSelf!.datePick.removeFromSuperview()
//        }
//        
//        self.datePick.sucessReturnB = { returnValue in
//            
//            debugPrint("我要消失了哈哈哈哈哈哈\(returnValue)")
//            if str == "开始时间" {
//                weakSelf!.starTimeLabel.text = returnValue
//            }else if str == "结束时间"{
//                weakSelf!.endTimeLabel.text = returnValue
//            }
//            weakSelf!.datePick.removeFromSuperview()
//            
//        }
//        //需要初始化数据
//        datePick.initData()
//        datePick.frame = CGRect(x: 0, y: kScreenHeight - 314, width: kScreenWidth, height: 250)
//        self.view.addSubview(datePick)
        
    }
}


//MARK:蓝牙相关
extension TempUserDetailController : BleManagerDelegate{
    
    func setupBluetool(perName : String){
        //确定搜索的门锁名
        QPCLog("连接门锁编号为\(String(describing: perName))")
        UserDefaults.standard.set(perName, forKey: "per")
        
        blueManager = BleManager.shared()
        blueManager.bleManagerDelegate = self
        
        if blueManager.powerOn{
            SVProgressHUD.show(withStatus: LanguageHelper.getString(key: "BlueTool_LockConnectLoading"))
            let didContantPer = blueManager.connectedDevice()
            //查询当前是否有链接的设备,如有断开连接新设备
            if didContantPer != nil {
                if didContantPer?.name == perName {
                    self.deletedUser()
                }else{
                    blueManager.disConnectDevice(didContantPer!)
                    blueManager.searchBleDevices()
                }
            }else{
                blueManager.searchBleDevices()
            }
        }else{
            //通知service
            self.deletedUserWithService(isNearBy: 2)
        }
    }
    
    
    func discoveredDevicesArray(_ devicesArr: NSMutableArray?, withCBCentralManagerConnectState connectState: String?) {
        QPCLog(connectState ?? "")
        guard connectState != nil else {
            return
        }
        if connectState == "蓝牙已打开,请连接设备"{
            
        }else if (connectState?.contains("已连接蓝牙"))!{
            QPCLog("移除成员")
            self.deletedUser()
        }else if connectState == "连接失败"{
            //通知service
            self.deletedUserWithService(isNearBy: 2)
        }
    }
    
    func deletedUser(){
        let userID = userModel.userId
        blueManager.sendCommand(withPort: "06050400", dataStr: userID)
    }
    
    func `return`(withData data: String!, isSucceed succeed: Bool, backData: String!){
        QPCLog("\(data)")
        //测试专用
        DispatchQueue.main.async(execute: {
            SVProgressHUD.dismiss()
        })
        if succeed {
            self.deletedUserWithService(isNearBy: 1)
            SVProgressHUD.showSuccess(withStatus: "删除成功")
        }else{
            DispatchQueue.main.async(execute: {
                SVProgressHUD.showError(withStatus: data)
            })
        }
    }
}


//MARK:-tabledatasoure
extension TempUserDetailController{
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0{
            return 60.0
        }else if section == 1{
            return 0.01;
        }
        return 0;
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == 0 {
            return 20.0
        }
        if kIsSreen5 {
            return 190
        }else{
            return 264 * kHeight6Scale
        }
//        return 264 * kHeight6Scale
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0{
            let label = UILabel(frame: CGRect(x: 0, y: 0, width: kScreenWidth, height: 60))
            label.text = "   \(lockModel.remark!)"
            label.font = UIFont.systemFont(ofSize: 30.0)
            label.textColor = UIColor.textBlueColor
            return label
        }
//        else{
//            let timeLabel = UILabel(frame: CGRect(x: 0, y: 0, width: kScreenWidth, height: 60))
//            timeLabel.font = UIFont.systemFont(ofSize: 12.0)
//            timeLabel.textAlignment = .natural
//            timeLabel.text = "      请问该成员设置开门权限有效期"
//            timeLabel.textColor = UIColor.hex(hexString: "878787)
//            return timeLabel
//        }
        return nil
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        QPCLog(indexPath)
        if indexPath.section == 0{
            if indexPath.row == 1{
                let reviseVC = UIStoryboard(name: "ReviseRemarkController", bundle: nil).instantiateViewController(withIdentifier: "ReviseRemarkController") as! ReviseRemarkController
                reviseVC.oldValue = userModel.sourceName
                reviseVC.userID = Int(userModel.userId)
                reviseVC.lockID = lockModel.lockId
                navigationController?.pushViewController(reviseVC, animated: true)
                QPCLog(reviseVC)
            }
        }else if indexPath.section == 1{
//            SVProgressHUD.showError(withStatus: "此信息不可修改,如有需要请删除重新添加")
//            if indexPath.row == 0 {
//                seletedTimeClick(str: "开始时间")
//            }else if indexPath.row == 1 {
//                seletedTimeClick(str: "结束时间")
//            }
        }

    }
    
    
}
