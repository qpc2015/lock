//
//  AuthUserDetailController.swift
//  MsdGateLock
//
//  Created by ox o on 2017/6/26.
//  Copyright © 2017年 xiaoxiao. All rights reserved.
//

import UIKit

class AuthUserDetailController: UITableViewController {
    
    @IBOutlet weak var phoneNumberTip: UILabel!
    @IBOutlet weak var bzTip: UILabel!
//    @IBOutlet weak var timeTip: UILabel!
//    @IBOutlet weak var isPerpetualLabel: UILabel!//是否永久
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var remarkLabel: UILabel!
    @IBOutlet weak var openListBtn: UIButton!
    @IBOutlet weak var startip: UILabel!
    @IBOutlet weak var endTip: UILabel!
    @IBOutlet weak var starLabel: UILabel!
    @IBOutlet weak var endLabel: UILabel!
    
    var userModel : AuthInfoListResp!
    var lockModel : UserLockListResp!   //对应锁信息
    var userDetail : RoleUserDetail!
    //系统蓝牙管理对象
    var blueManager : BleManager?
    var oneSectionCount : Int = 0
    var isCurrentOwner : Bool? //当前用户是不是owner
    
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
    
    deinit {
        QPCLog("我被销毁了")
        if blueManager?.bleManagerDelegate != nil{
            blueManager?.bleManagerDelegate = nil
        }
    }
}

extension AuthUserDetailController{
    
    func getRoleByUser(){
        let req = BaseReq<TwoParam<String,Int>>()
        req.action = GateLockActions.ACTION_GetRoleByUser
        req.sessionId = UserInfo.getSessionId()!
        req.sign = LockTools.getSignWithStr(str: "oxo")
        req.data = TwoParam.init(p1: lockModel.lockId!, p2: Int(userModel.userId)!)
        
        weak var weakSelf = self
        AjaxUtil<RoleUserDetail>.actionPost(req: req) { (resp) in
            QPCLog(resp)
            weakSelf?.userDetail = resp.data
            weakSelf?.resetValue()
            weakSelf?.tableView.reloadData()
        }
    }
    
    func setupUI(){
        if isCurrentOwner! {
            if userModel.roleType != 0 {
                navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named : "more"), style: .plain, target: self, action: #selector(AuthUserDetailController.moreCick))
            }
        }

        phoneNumberTip.textColor = UIColor.textBlackColor
        bzTip.textColor = UIColor.textBlackColor
//        timeTip.textColor = UIColor.textBlackColor
        startip.textColor = UIColor.textBlackColor
        endLabel.textColor = UIColor.textBlackColor
        phoneLabel.textColor = UIColor.textGrayColor
        phoneLabel.textColor = UIColor.textGrayColor
        remarkLabel.textColor = UIColor.textGrayColor
        starLabel.textColor = UIColor.textGrayColor
        endLabel.textColor = UIColor.textGrayColor
//        isPerpetualLabel.textColor = UIColor.textGrayColor
        openListBtn.setTitleColor(UIColor.textBlackColor, for: .normal)
        openListBtn.addTarget(self, action: #selector(AuthUserDetailController.openListClick), for: .touchUpInside)
//        isPerpeSwitch.onTintColor = UIColor.textBlueColor
//        isPerpeSwitch.addTarget(self, action: #selector(AuthUserDetailController.seletedTimeClick(perpSwitch:)), for: .touchUpInside)
    }
    
    
    func resetValue(){
        self.title = "\(String(describing: userDetail.sourceName))的详情"
        
        phoneLabel.text = userDetail.userTel
        //memberName需要判断
        remarkLabel.text = userDetail.sourceName
        starLabel.text = LockTools.stringToTimeYMDHmStr(stringTime: userDetail.startTime)
        endLabel.text = LockTools.stringToTimeYMDHmStr(stringTime: userDetail.endTime)
        
        if self.userDetail.isPermenant == 2{
//            self.isPerpetualLabel.isHidden = false
            oneSectionCount = 0
            self.tableView .reloadData()
        }else{
//            self.isPerpetualLabel.isHidden = true
            oneSectionCount = 2
            self.tableView.reloadData()
        }
        //2:永久，1：时间段
//        isPerpeSwitch.isOn = false
//        if userDetail.isPermenant == 2{
//            isPerpeSwitch.isOn = true
//        }
//        seletedTimeClick(perpSwitch: isPerpeSwitch)
    }
}


//MARK:- 响应事件
extension AuthUserDetailController{
    
//    func seletedTimeClick(str : String){
//        
//        weak var weakSelf = self
//        
//        self.datePick.canButtonReturnB = {
//            weakSelf!.datePick.removeFromSuperview()
//        }
//        
//        self.datePick.sucessReturnB = { returnValue in
//            
//            if str == "开始时间" {
//                weakSelf!.starLabel.text = returnValue
//            }else if str == "结束时间"{
//                weakSelf!.endLabel.text = returnValue
//            }
//            weakSelf!.datePick.removeFromSuperview()
//            
//            //判断前后有值,后面的时间大于前面的时间就上传
//            if ((weakSelf?.starLabel.text?.characters.count)! > 0 && (weakSelf?.endLabel.text?.characters.count)!>0){
//                if LockTools.compareDate(starDate: (weakSelf?.starLabel.text)!, endDate: (weakSelf?.endLabel.text)!){
//                    self.updateExpireDate(isPermanent: 1, beginDate: (weakSelf?.starLabel.text)!, endDate: (weakSelf?.endLabel.text)!)
//                }else{
//                    SVProgressHUD.showError(withStatus: "请选择正确的时间")
//                }
//            }
//        }
//    
//        //需要初始化数据
//        datePick.initData()
//        datePick.frame = CGRect(x: 0, y: kScreenHeight - 314, width: kScreenWidth, height: 250)
//        self.view.addSubview(datePick)
//        
//    }
    
//    func seletedTimeClick(perpSwitch : UISwitch){
//        if perpSwitch.isOn {
//            oneSectionCount = 1
//            self.tableView .reloadData()
//            ///判断是否是onwer
//            if userModel.roleType != 0{
//                //设置为永久
//                self.updateExpireDate(isPermanent: 2, beginDate: nil, endDate: nil)
//            }
//        }else{
//            oneSectionCount = 3
//            self.tableView.reloadData()
//        }
//    }
    
    @objc func moreCick(){
        
        let altsheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
//        let action1 = UIAlertAction(title: "转让管理员", style: .default) { (action) in
//            QPCLog("转让管理员")
//            self.transferAdmin()
//            let transVC = TransferAdminController()
//            transVC.toptipStr = "请选择新的管理员"
//            self.navigationController?.pushViewController(transVC , animated: true)
//        }
//        let action2 = UIAlertAction(title: "转为临时用户", style: .default) {[weak self] (action) in
//                QPCLog("转为临时用户")
//            let chaneTempVC = UIStoryboard(name: "ChangeTempUserController", bundle: nil).instantiateViewController(withIdentifier: "ChangeTempUserController")
//            self!.navigationController?.pushViewController(chaneTempVC, animated: true)
//        }
        
        let action3 = UIAlertAction(title: "移除成员", style: .default) { (action) in
            self.deletedUserAction()
        }
        let action4 = UIAlertAction(title: "取消", style: .cancel) { (action) in
                QPCLog("取消")
        }

        altsheet.addAction(action3)
        altsheet.addAction(action4)
        present(altsheet, animated: true, completion: nil)
    }

    @objc func openListClick(){
        QPCLog("点击")
        let openListVC = AuthUserOpenListController()
        openListVC.isHiddenSub = false
        openListVC.currentLockID = lockModel.lockId
        openListVC.lockTitle = userDetail.sourceName
        openListVC.subTitleStr = userModel.sourceName
        navigationController?.pushViewController(openListVC, animated: true)
    }
}

//MARK:- 接口
extension AuthUserDetailController{
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
        weak var weakSelf = self
        AjaxUtil<CommonResp>.actionPost(req: req, backJSON: { (resp) in
            QPCLog(resp)
            weakSelf?.navigationController?.popViewController(animated: true)
        }) { (errorStr) in
            QPCLog(errorStr)
            SVProgressHUD.showError(withStatus: errorStr)
        }
    }
    
    //修改用户权限有效期 2：永久，1：时间段
//    func updateExpireDate(isPermanent: Int,beginDate: String?, endDate: String?){
//
//        if beginDate != nil{
//            let req = BaseReq<ExpireDateModel>()
//            req.action = GateLockActions.ACTION_UpdateExpireDate
//            req.sessionId = UserInfo.getSessionId()
//            req.sign = LockTools.getSignWithStr(str: "oxo")
//            req.data = ExpireDateModel.init(userModel.userId,lockId:lockModel.lockId!, isPermanent: isPermanent, beginDate: beginDate!, endDate: endDate!)
//            
//            AjaxUtil<CommonResp>.actionPost(req: req, backJSON: { (resp) in
//                QPCLog(resp)
//            }) { (errorStr) in
//                QPCLog(errorStr)
//            }
//            
//        }else{
//            let req = BaseReq<PerpeDateModel>()
//            req.action = GateLockActions.ACTION_UpdateExpireDate
//            req.sessionId = UserInfo.getSessionId()
//            req.sign = LockTools.getSignWithStr(str: "oxo")
//            req.data = PerpeDateModel.init(userModel.userId, isPermanent: isPermanent,lockid:lockModel.lockId!)
//            
//            AjaxUtil<CommonResp>.actionPost(req: req, backJSON: { (resp) in
//                QPCLog(resp)
//            }) { (errorStr) in
//                QPCLog(errorStr)
//                SVProgressHUD.showError(withStatus: errorStr)
//            }
//        }
//
//    }
    
//    func transferAdmin(){
//        let req = BaseReq<OneParam<Int>>()
//        req.action = GateLockActions.ACTION_TransferAdmin
//        req.sessionId = UserInfo.getSessionId()
//        req.sign = LockTools.getSignWithStr(str: "oxo")
//        req.data = OneParam.init(p1: self.userModel.userId)
//        
//        weak var weakSelf = self
//        AjaxUtil<CommonResp>.actionPost(req: req, backJSON: { (resp) in
//            QPCLog(resp)
//            weakSelf?.navigationController?.popToRootViewController(animated: true)
//        }) { (errorStr) in
//            QPCLog(errorStr)
//        }
//    }
    
}

//MARK:蓝牙相关
extension AuthUserDetailController : BleManagerDelegate{
    
    func setupBluetool(perName : String){
        //确定搜索的门锁名
        QPCLog("连接门锁编号为\(String(describing: perName))")
        UserDefaults.standard.set(perName, forKey: "per")
        
        blueManager = BleManager.shared()
        blueManager?.bleManagerDelegate = self
        
        if (blueManager?.powerOn)!{
            SVProgressHUD.show(withStatus: LanguageHelper.getString(key: "BlueTool_LockConnectLoading"))
            let didContantPer = blueManager?.connectedDevice()
            //查询当前是否有链接的设备,如有断开连接新设备
            if didContantPer != nil {
                if didContantPer?.name == perName {
                    self.deletedUser()
                }else{
                    blueManager?.disConnectDevice(didContantPer!)
                    blueManager?.searchBleDevices()
                }
            }else{
                blueManager?.searchBleDevices()
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
        blueManager?.sendCommand(withPort: "06050400", dataStr: userID)
    }
    
    func `return`(withData data: String!, isSucceed succeed: Bool, backData: String!){
        
        QPCLog("\(data)")
        //测试专用
        DispatchQueue.main.async(execute: {
            SVProgressHUD.dismiss()
        })
        weak var weakSelf = self
        if succeed {
            weakSelf?.deletedUserWithService(isNearBy: 1)
            SVProgressHUD.showSuccess(withStatus: "删除成功")
        }else{
            //通知service
            self.deletedUserWithService(isNearBy: 1)
//            DispatchQueue.main.async(execute: {
//                SVProgressHUD.showError(withStatus: data)
//            })
        }
    }
    
}


//MARK:-tabledatasoure
extension AuthUserDetailController{
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 1{
            return oneSectionCount
        }
        return 2
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0{
            return 60.0
        }else{
            if oneSectionCount == 0{
                return 46
            }else{
                return 0.01
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == 0{
            return 20.0
        }
        //2:永久，1：时间段
        if (self.userDetail == nil) || self.userDetail.isPermenant == 2{
            if kIsSreen5 {
               return 234
            }else{
              return (218 + 112) * kHeight6Scale
            }

        }else{
            if kIsSreen5 {
                return 188
            }else{
                return 288 * kHeight6Scale
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0{
            let label = UILabel(frame: CGRect(x: 0, y: 0, width: kScreenWidth, height: 60))
            if userDetail != nil{
                label.text = "   \(lockModel.remark!)"
            }
            label.font = UIFont.systemFont(ofSize: 30.0)
            label.textColor = UIColor.textBlueColor
            return label
        }else{
            if oneSectionCount == 0 {
                let head = UIView(frame: CGRect(x: 0, y: 0, width: kScreenWidth, height: 46))
                head.backgroundColor = UIColor.white
                
                let tipLabel = UILabel(frame: CGRect(x: 25, y: 16, width: 150, height: 14))
                tipLabel.text = "开门权限有效期"
                tipLabel.font = kGlobalTextFont
                tipLabel.textColor = UIColor.textBlackColor
                head.addSubview(tipLabel)
                
                let yongjiu = UILabel(frame: CGRect(x: kScreenWidth - 47, y: 16, width: 150, height: 14))
                yongjiu.text = "永久"
                yongjiu.font = kGlobalTextFont
                yongjiu.textColor = UIColor.textGrayColor
                head.addSubview(yongjiu)
                
                return head
            }
            return nil
        }
        
//            if isCurrentOwner! {
//                let timeLabel = UILabel(frame: CGRect(x: 0, y: 0, width: kScreenWidth, height: 60))
//                timeLabel.font = UIFont.systemFont(ofSize: 12.0)
//                timeLabel.textAlignment = .natural
//                timeLabel.text = "      开门权限有效期"
//                timeLabel.textColor = UIColor.hex(hexString: "878787)
//                return timeLabel
//            }


    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        QPCLog(indexPath)
        if indexPath.section == 0{
            if indexPath.row == 1{
                let reviseVC = UIStoryboard(name: "ReviseRemarkController", bundle: nil).instantiateViewController(withIdentifier: "ReviseRemarkController") as! ReviseRemarkController
                reviseVC.userID =  Int(userModel.userId)
                reviseVC.oldValue = userModel.sourceName
                reviseVC.lockID = lockModel.lockId
                navigationController?.pushViewController(reviseVC, animated: true)
                QPCLog(reviseVC)
            }
        }
//        else if indexPath.section == 1{
//            SVProgressHUD.showError(withStatus: "此信息不可修改,如有需要请删除重新添加")
//            if indexPath.row == 1 {
//                seletedTimeClick(str: "开始时间")
//            }else if indexPath.row == 2 {
//                seletedTimeClick(str: "结束时间")
//            }
//        }
    }
    
}
