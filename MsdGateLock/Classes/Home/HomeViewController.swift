//
//  swift
//  MsdGateLock
//
//  Created by ox o on 2017/6/12.
//  Copyright © 2017年 xiaoxiao. All rights reserved.
//

import UIKit
import Reachability

class HomeViewController: UIViewController {
    
    var isFirst : Bool = false
    @IBOutlet weak var lockTableView: UITableView!
    @IBOutlet weak var eleqLabel: UILabel!
    @IBOutlet weak var inLockLabel: UILabel!
    @IBOutlet weak var powerLabel: UILabel!
    @IBOutlet weak var openLockBtn: UIButton!
    @IBOutlet weak var doorListLabel: UILabel!
    @IBOutlet weak var moreBtn: UIButton!
    @IBOutlet weak var tipLockLabel: UILabel!
    @IBOutlet weak var lockNumbersBtn: BottomButton!
    @IBOutlet weak var lockSetBtn: BottomButton!
    @IBOutlet weak var centerLine: UIView!
    @IBOutlet weak var bottomLine: UIView!
    ///中间开锁按钮宽度约束
    @IBOutlet weak var tipLabelTop: NSLayoutConstraint!
    @IBOutlet weak var topLockLeftMagin: NSLayoutConstraint!
    @IBOutlet weak var powerRightMagin: NSLayoutConstraint!
    @IBOutlet weak var openBtnTopMagin: NSLayoutConstraint!
    //中间线距离按钮顶部间距
//    @IBOutlet weak var centerLineTopMagin: NSLayoutConstraint!
    var popOverView : PopoverViewController!   //顶部锁列表
    var lockListArr : [UserLockListResp]?   //所有所得数据
    var waitRemoveLockArr : [String]? //待锁删除用户列表
    var currentRemoveUserID : String?  //当前删除锁id
    @IBOutlet weak var openListTipLabel: UILabel!
    var currentSeleteLock : UserLockListResp?{
        didSet(old){
            let titleStr = currentSeleteLock?.remark
            titleBtn.setTitle(titleStr, for: .normal)
            titleBtn.sizeToFit()
        }
    }        //当前选中门锁
    var openLockModelArr : [OpenLockList]? //当前门锁记录
    var lockMessageArr : [InRoleModel]? //拉取授权结果集
    var resetNumTipNameArr = [String]() //重新更换手机需重新绑定锁名
    var nopermissVC : NoPermissionController?
    var tempBottomView : UIView?//临时用户底部视图
    @IBOutlet weak var lockUserBottomView: UIView!//开锁底部
    @IBOutlet weak var homeCenterView: UIView!
    var reachability: Reachability!
    var blueManager : BleManager!
    var dataManager = QPCDataManager.shareManager
    var userWithZstr : String!
    fileprivate lazy var titleBtn : TitleButton = TitleButton()
    var isConnectNetWork : Bool = false  //当前环境是否有网络
    lazy var popVerAnimatior : PopoverAnimator = PopoverAnimator(callBack: {[weak self] (isPresent) in
        self?.titleBtn.isSelected = isPresent
    })
    
    override func viewDidLoad() {
        super.viewDidLoad()
        do {
            try reachability = Reachability()
        } catch  {
            print(error)
        }
        //开始监听网络状态
        startListenNetStatuChange()
        //UI
        setupStyle()
        setupNavigationBarWithShowAdd()
        //检查创建门锁表
        _ = self.dataManager.createHomeListTable()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        _ = [super.viewWillAppear(animated)]
        //开启蓝牙
        setupBluetool()
        //获取锁列表
        guard UserInfo.getUserId() != nil else {
            SVProgressHUD.showError(withStatus: LanguageHelper.getString(key: "Global_LogBackinError"))
            return
        }
        //清除更换手机号用户
        self.resetNumTipNameArr.removeAll()
        //创建上传开门记录表
        _ = self.dataManager.createLockLogTable()
        //创建本地开门记录缓存
        _ = self.dataManager.createLocalOpenLogTable()
        ///适配5
        if kIsSreen5 {
            let widthHeight = CGFloat(264.0 * 0.7)
            openLockBtn.snp.makeConstraints({ (make) in
                make.width.equalTo(widthHeight)
                make.height.equalTo(widthHeight)
            })
            topLockLeftMagin.constant = 42 * kWidth6Scale
            powerRightMagin.constant = 41 * kWidth6Scale
            openBtnTopMagin.constant = 92 * kHeight6Scale
            tipLabelTop.constant = CGFloat(152.0 * 0.7)
        }
        //根据有无网络做不同操作
        if isConnectNetWork {
            getUserLockList(UserInfo.getUserId()!)
        }else{
          
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.resetNumTipNameArr.removeAll()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        reachability.stopNotifier()
    }
}


//MARK:- UI
extension HomeViewController{

    fileprivate func setupNavigationBarWithShowAdd(){

        navigationItem.leftBarButtonItem = UIBarButtonItem.init(image: UIImage(named : "message icon "), style: .plain, target: self, action: #selector(messageCenterClick))
        
        let item1 =  UIBarButtonItem.init(image: UIImage(named : "user"), style: .plain, target: self, action: #selector(personCenterClick))
        let item2 =  UIBarButtonItem.init(image: UIImage(named : "add"), style: .plain, target: self, action: #selector(addLockClick))
            navigationItem.rightBarButtonItems = [item1,item2]

        titleBtn.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        titleBtn.addTarget(self, action: #selector(titleViewClick(_:)), for: .touchUpInside)
        navigationItem.titleView = titleBtn
    }
    
    fileprivate func setupStyle(){
        lockTableView.rowHeight = 27
        lockTableView.separatorStyle = .none
        openListTipLabel.textColor = kTextGrayColor
        eleqLabel.textColor = kTextBlockColor
        inLockLabel.textColor = kTextBlockColor
        powerLabel.textColor = kTextBlockColor
        doorListLabel.textColor = kRGBColorFromHex(rgbValue: 0x282828)
        moreBtn.setTitleColor(kRGBColorFromHex(rgbValue: 0x282828), for: .normal)
        tipLockLabel.textColor = kTextBlueColor
        centerLine.backgroundColor = kRGBColorFromHex(rgbValue: 0xe9e9e9)
        bottomLine.backgroundColor = kRGBColorFromHex(rgbValue: 0xe9e9e9)
        //开锁按钮
        openLockBtn.setBackgroundImage(UIImage(named:"locking"), for: .selected)
//        openLockBtn.setBackgroundImage(UIImage(named:"press"), for: .highlighted)
        openLockBtn.addTarget(self, action: #selector(openLockClick(btn:)), for: .touchUpInside)
        //底部按钮
        lockNumbersBtn.setTitleColor(kTextBlueColor, for: .normal)
        lockNumbersBtn.setTitleColor(kTextBlueColor, for: .highlighted)
        lockNumbersBtn.addTarget(self, action: #selector(lockNumbersClick), for: .touchUpInside)
        lockSetBtn.setTitleColor(kRGBColorFromHex(rgbValue: 0x2282ff), for: .normal)
        lockSetBtn.setTitleColor(kRGBColorFromHex(rgbValue: 0x2282ff), for: .highlighted)
        lockSetBtn.addTarget(self, action: #selector(locksetClick), for: .touchUpInside)
        moreBtn.addTarget(self, action: #selector(moreClick), for: .touchUpInside)
        //设置临时用户底部
        setTempUserFootView()
    }
    
    //临时用户底部按钮
    fileprivate func setTempUserFootView(){
        let bottomView = UIView()
        bottomView.backgroundColor = UIColor.white
        bottomView.isHidden = true
        self.view.addSubview(bottomView)
        bottomView.snp.makeConstraints { (make) in
            make.left.equalTo(0)
            make.right.equalTo(0)
            make.bottom.equalTo(0)
            make.height.equalTo(49)
        }
        tempBottomView = bottomView
        
        let topLine = UIView()
        topLine.backgroundColor = kRGBColorFromHex(rgbValue: 0xe9e9e9)
        bottomView.addSubview(topLine)
        topLine.snp.makeConstraints { (make) in
            make.left.equalTo(0)
            make.right.equalTo(0)
            make.top.equalTo(0)
            make.height.equalTo(0.5)
        }
        //修改门锁备注
        let addLockBtn = UIButton.init(type: .custom)
        addLockBtn.setTitle("修改门锁备注", for: .normal)
        addLockBtn.titleLabel?.font = kGlobalTextFont
        addLockBtn.setTitleColor(kTextBlueColor, for: .normal)
        addLockBtn.addTarget(self, action: #selector(reviseLockMarkClick), for: .touchUpInside)
        bottomView.addSubview(addLockBtn)
        addLockBtn.snp.makeConstraints { (make) in
            make.left.equalTo(67)
            make.top.equalTo(0)
            make.bottom.equalTo(0)
        }
        //退出门锁组
        let orderLockBtn = UIButton.init(type: .custom)
        orderLockBtn.setTitle("退出门锁组", for: .normal)
        orderLockBtn.titleLabel?.font = kGlobalTextFont
        orderLockBtn.setTitleColor(kTextBlueColor, for: .normal)
        orderLockBtn.addTarget(self, action: #selector(outLockClick), for: .touchUpInside)
        bottomView.addSubview(orderLockBtn)
        orderLockBtn.snp.makeConstraints { (make) in
            make.right.equalTo(-67)
            make.top.equalTo(0)
            make.bottom.equalTo(0)
        }
    }
}

//MARK:- 接口调用
extension HomeViewController{
    
    //添加电量，正/反锁记录
    func addLockBatteryAndState(battery: Int,mainState: Int, backState: Int){
        let req = BaseReq<LockStateModel>()
        req.action = GateLockActions.ACTION_AddLockBatteryAndState
        req.sessionId = UserInfo.getSessionId()!
        req.sign = LockTools.getSignWithStr(str: "oxo")
        req.data = LockStateModel.init((currentSeleteLock?.lockId)!, battery: battery, mainState: mainState, backState: backState)
        weak var weakSelf = self
        AjaxUtil<CommonResp>.actionPost(req: req) { (resp) in
            QPCLog(resp)
            weakSelf?.getCurrentLockInfo()
        }
    }
    
    //更新锁权限分配状态为已绑定
    func updateAuthStatusCommand(lockid : String){
        let req = BaseReq<TwoParam<String,Int>>()
        req.action = GateLockActions.ACTION_UpdateAuthStatus
        req.sessionId = UserInfo.getSessionId()!
        req.data = TwoParam.init(p1: lockid, p2: 8)
        
        AjaxUtil<CommonReq>.actionPost(req: req) { (resp) in
            QPCLog(resp)
        }
    }
    
    //添加门锁日志
    func addLockLog(){
        let req = BaseArrReq<ThreeParam<String,Int,String>>()
        req.action = GateLockActions.ACTION_AddLockLog
        req.sessionId = UserInfo.getSessionId()!
        req.sign = LockTools.getSignWithStr(str: "oxo")
        req.data = self.dataManager.fetchAllOpenLockData()
        weak var weakSelf = self
        AjaxUtil<CommonResp>.actionPost(req: req) { (resp) in
            QPCLog(resp)
            weakSelf?.dataManager.deleteTabelAllData((weakSelf?.dataManager.lockLogTableName)!)
        }
    }
    
    //获取用户锁列表
    func getUserLockList(_ userID: Int){
        
        let req =  CommonReq()
        req.action = GateLockActions.ACTION_GetLockList
        req.sessionId = UserInfo.getSessionId()!
        req.sign = LockTools.getSignWithStr(str: "oxo")
        
        weak var weakSelf = self
        AjaxUtil<UserLockListResp>.actionArrPostWithError(req: req, backArrJSON: { (resp) in

            if let lockArr = resp.data,lockArr.count > 0 {
                if UserInfo.getLastLock() == nil{
                    //默认选中第一个
                    weakSelf?.currentSeleteLock = lockArr.first
                }else{
                    var lastIndex = 0
                    for index in 0 ..< lockArr.count{
                        if lockArr[index].lockId == UserInfo.getLastLock()!{
                            lastIndex = index
                        }
                    }
                    //取出上次最后一个,如果上次的未找到默认取第一个
                    weakSelf?.currentSeleteLock = lockArr[lastIndex]
                }

                weakSelf?.lockListArr = lockArr
                //这里判断是否显示+
                switch weakSelf?.currentSeleteLock?.roleType ?? 3{
                case 0,1:
                    self.openBtnTopMagin.constant = 92 * kHeight6Scale
                    self.tempBottomView?.isHidden = true
                    self.lockTableView.isHidden = false
                    self.lockUserBottomView.isHidden = false
                    self.homeCenterView.isHidden = false
                    
                    //查询是否设置过密码
                    if !QPCKeychainTool.existNumberPassword() {
                        weakSelf?.firstSetPassword()
                    }
                case 2:
                    self.tempBottomView?.isHidden = false
                    self.lockTableView.isHidden = true
                    self.lockUserBottomView.isHidden = true
                    self.homeCenterView.isHidden = true
                    self.openBtnTopMagin.constant = 152 * kHeight6Scale
                    //查询是否设置过密码
                    if !QPCKeychainTool.existNumberPassword() {
                        weakSelf?.firstSetPassword()
                    }
                default:
                    QPCLog("我是未知数")
                }
                
                //获取当前锁信息
                weakSelf?.getCurrentLockInfo()
                //筛选出未有密码的门锁
                for lockInfo in lockArr{
                    if lockInfo.roleType == 0 {
                        if QPCKeychainTool.getOpenPassWordWithKeyChain(lockID: lockInfo.lockId!) == nil{
                            weakSelf?.resetNumTipNameArr.append(lockInfo.remark!)
                        }
                    }
                }
                //如有发现未有本地门锁的给予弹窗
                if (weakSelf?.resetNumTipNameArr.count)! > 0 {
                    var totalStr = ""
                    for i in 0 ..< (weakSelf?.resetNumTipNameArr.count)!{
                        totalStr += "\(i+1)、\(String(describing: (weakSelf?.resetNumTipNameArr[i])!))"
                    }
                    //弹框
                    let alterVC = UIAlertController(title: "系统通知", message: "亲爱的门锁用户您好!\n为了保障您和家人的安全，作为管理员，更换手机后需要重新扫描门内二维码以绑定，\n以下门锁需要您重新绑定：\n\(totalStr)", preferredStyle: .alert)
                    let alertAc = UIAlertAction(title: "去设置", style: .default) { (action) in
                        let resetVC = ChangeNumberCodeController()
                        resetVC.title = "更换手机"
                        resetVC.lockModel = self.currentSeleteLock!
                        weakSelf!.navigationController?.pushViewController(resetVC, animated: true)
                        
                    }
                    let knowAc = UIAlertAction(title: "我知道了", style: .default, handler: { (action) in
                        QPCLog("点击了知道")
                    })
                    knowAc.setValue(kTextBlockColor, forKey: "_titleTextColor")
                    alterVC.addAction(alertAc)
                    alterVC.addAction(knowAc)
                    self.present(alterVC, animated: true, completion: nil)
                }
                
                //保存列表到到数据库
                weakSelf?.dataManager.deleteTabelAllData((weakSelf?.dataManager.lockListTableName)!)
                weakSelf?.dataManager.insertTableWithModelArr(model: resp.data!)
            }else{
                UIApplication.shared.keyWindow?.rootViewController = LockNavigationController(rootViewController: NoPermissionController())
            }
        }) { (errorStr) in
            
        }
    }
    
    //待锁删除用户列表
    func getUserWaitLockRemove(){
        let req = BaseReq<OneParam<String>>()
        req.action = GateLockActions.ACTION_UserWaitLockRemove
        req.sessionId = UserInfo.getSessionId()!
        req.sign = LockTools.getSignWithStr(str: "oxo")
        req.data = OneParam.init(p1: (currentSeleteLock?.lockId)!)
        
        weak var weakSelf = self
        AjaxUtil<CommonResp>.actionDataArrPostWithError(req: req, backArrJSON: { (resp) in
            QPCLog(resp)
            weakSelf?.waitRemoveLockArr = resp.data
        }) { (errorStr) in
            QPCLog(errorStr)
        }
    }
    
    //操作删除门锁内用户
    func sendCommandBlueToolToRemoveUser(){
        if (self.waitRemoveLockArr?.count)! > 0{
            for removeUserID in self.waitRemoveLockArr!{
                self.currentRemoveUserID = removeUserID
                blueManager.sendCommand(withPort: "06050400", dataStr: removeUserID)
            }
        }
    }
    
    //删除user更新状态
    func updateRemovedList(){
        let req = BaseReq<UpdateLockRemoveReq>()
        req.action = GateLockActions.ACTION_UpdateUserLockRemove
        req.sessionId = UserInfo.getSessionId()!
        req.sign = LockTools.getSignWithStr(str: "oxo")
        req.data = UpdateLockRemoveReq.init([currentRemoveUserID!], lockid: (currentSeleteLock?.lockId)!)
        
        AjaxUtil<CommonResp>.actionPost(req: req) { (resp) in
            QPCLog("删除更新成功")
        }
    }
    
    
    //获取我接收到的邀请
//    func getInRole(){
//        let req = BaseReq<OneParam<Int>>()
//        req.action = GateLockActions.ACTION_InRole
//        //用于测试 UserInfo.getSessionId()
//        req.sessionId = UserInfo.getSessionId()
//        //"5996c2a211c12013000ba08f"
//        req.data = OneParam.init(p1:1|2|4)
//        weak var weakSelf = self
//        AjaxUtil<InRoleModel>.actionArrPost(req: req) { (resp) in
//            QPCLog("--授权列表--\(resp)")
//            weakSelf?.lockMessageArr = resp.data
//        }
//    }
    
    func getCurrentLockInfo(){
        let req =  BaseReq<LockInfoReq>()
        req.action = GateLockActions.ACTION_GetLock
        req.sessionId = UserInfo.getSessionId()!
        let userID = UserInfo.getUserId()
        let lockId = currentSeleteLock?.lockId
        let start = 1
        let limit = 10
        req.data = LockInfoReq.init(userID!, lockId: lockId!, start: start, limit: limit)
        
        weak var weakSelf = self
        AjaxUtil<LockInfoResp>.actionPost(req: req){
            (resp) in
            if let lockModel = resp.data {
                //主锁
                if lockModel.lockMainState == 0 {
                    weakSelf?.eleqLabel.text = "主锁:  未锁"
                }else{
                    weakSelf?.eleqLabel.text = "主锁:  已锁"
                }
                //反锁
                if lockModel.lockBackState == 0 {
                    weakSelf?.inLockLabel.text = "反锁:  未锁"
                }else{
                    weakSelf?.inLockLabel.text = "反锁:  已锁"
                }
                //电量
                if lockModel.lockBattery?.count == nil{
                    weakSelf?.powerLabel.text = "电量: 100%"
                }else{
                    weakSelf?.powerLabel.text = "电量: \(String(describing: lockModel.lockBattery!))%"
                }
            }
            weakSelf?.openLockModelArr = resp.data?.openList
            //数组为空显示占位否则列表
            if weakSelf?.openLockModelArr != nil{
                if (weakSelf?.openLockModelArr?.count)! > 0 {
                    //右开门日志
                    weakSelf?.openListTipLabel.isHidden = true
                    weakSelf?.lockTableView.reloadData()
                    
                    weakSelf?.dataManager.deleteTabelAllData(self.dataManager.localOpenTableName)
                    weakSelf?.dataManager.insertLocalOpenTableWithModelArr(lockID:(resp.data?.lockId)!,modelArr:(weakSelf?.openLockModelArr)!)
                }else{
                    weakSelf?.openListTipLabel.isHidden = false
                }
            }else{
                weakSelf?.openListTipLabel.isHidden = false
            }
        }
        //保存最后使用的锁id
        UserInfo.saveLastLock(lockID: (currentSeleteLock?.lockId)!)
        //获取删除列表
        getUserWaitLockRemove()
    }
    
    //监听网路状态
    fileprivate func startListenNetStatuChange(){

        weak var weakSelf = self
        reachability.whenUnreachable = { reachability in
            weakSelf?.isConnectNetWork = false
            DispatchQueue.main.async {
                weakSelf?.checkNoNetworkWithAlext()
            }
        }
        // 网络可用或切换网络类型时执行
        reachability.whenReachable = { reachability in
            weakSelf?.isConnectNetWork = true
        }
        
        do {
            try reachability.startNotifier()
        }catch{
            QPCLog("Unable to start notifier")
        }
    }
    
}

//MARK:- 响应事件
extension HomeViewController{
    
    func firstSetPassword(){
        weak var weakSelf = self
        let alterVC = UIAlertController(title: "系统通知", message: "亲爱的门锁用户您好!\n您已被授权为门锁用户,请尽快设置属于您的开门密码", preferredStyle: .alert)
        let alertAc = UIAlertAction(title: "去设置", style: .default) { (action) in

                let vc = UIStoryboard(name: "NumberPassWordController", bundle: nil).instantiateViewController(withIdentifier: "numberPassWordVC") as! NumberPassWordController
                vc.isHideBack = true
                weakSelf?.navigationController?.pushViewController(vc, animated: true)
        }
        alterVC.addAction(alertAc)
        self.present(alterVC, animated: true, completion: nil)
    }
    
    //临时用户修改门锁备注
    @objc func reviseLockMarkClick(){
        let nickVC = LockRemarkController()
        nickVC.isTemp = true
        nickVC.oldValue = currentSeleteLock?.remark
        nickVC.cureentLockId = currentSeleteLock?.lockId
        navigationController?.pushViewController(nickVC, animated: true)
    }
    
    @objc fileprivate func outLockClick(){
        let alertVC = UIAlertController(title: nil, message: "您确定要退出当前门锁组", preferredStyle: .alert)
        let acSure = UIAlertAction(title: "确定", style: .default) { (UIAlertAction) in
            QPCLog("确定")
            self.exitGourpNumber()
        }
        let acCancle = UIAlertAction(title: "取消", style: .default) { (UIAlertAction) in
            QPCLog("点击了取消")
        }
        alertVC.addAction(acCancle)
        alertVC.addAction(acSure)
        self.present(alertVC, animated: true, completion: nil)
    }
    
    func exitGourpNumber(){
        let req =  BaseReq<OneParam<String>>()
        req.action = GateLockActions.ACTION_ExistGroup
        req.sessionId = UserInfo.getSessionId()!
        req.data = OneParam.init(p1: (self.currentSeleteLock?.lockId)!)
        
        AjaxUtil<CommonResp>.actionPost(req: req) { (resp) in
            QPCLog(resp)
            UIApplication.shared.keyWindow?.rootViewController = LockNavigationController(rootViewController: HomeViewController())
        }
    }
    
    @objc func moreClick(){
        let authVC = AuthUserOpenListController()
        authVC.isHiddenSub = true
        authVC.currentLockID = currentSeleteLock?.lockId
        authVC.lockTitle = self.currentSeleteLock?.remark
        navigationController?.pushViewController(authVC, animated: true)
    }
    
    @objc func openLockClick(btn : UIButton){
        btn.isSelected = !btn.isSelected
        if btn.isSelected {
            //连接蓝牙开门
            self.starSearchBlue()
        }
    }
    
    @objc func lockNumbersClick(){
//        if currentSeleteLock != nil{
            let lockNemVc = LockMembersController()
            lockNemVc.lockModel = currentSeleteLock
            lockNemVc.type = currentSeleteLock?.roleType
            navigationController?.pushViewController(lockNemVc, animated: true)
//        }
    }
    
    @objc func locksetClick(){
        //拥有者和授权用户
        let usertype = currentSeleteLock?.roleType
//        if usertype == 0{
//            let lockVC = LockManageController()
//            lockVC.currentLockModel = currentSeleteLock!
//            navigationController?.pushViewController(lockVC, animated: true)
//        }else if usertype == 1{
            let authVC = AuthUserLockManageController()
            authVC.currentLockID = currentSeleteLock?.lockId
            navigationController?.pushViewController(authVC, animated: true)
//        }
    }
    
    @objc func personCenterClick(){
        let vc = UIStoryboard(name: "Person", bundle: nil).instantiateViewController(withIdentifier: "personCenter")
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func messageCenterClick(){
        let webVC = LockWebViewContrller()
        webVC.urlStr = GateLockActions.H5_Message
        webVC.title = "消息通知"
        navigationController?.pushViewController(webVC, animated: true)
    }
    
    @objc func addLockClick(){
        if blueManager.powerOn {
            let codeVC : QRCodeController = QRCodeController()
            self.navigationController?.pushViewController(codeVC, animated: true)
        }else{
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
        }
    }
    
    @objc fileprivate func titleViewClick(_ titleBtn : TitleButton) {
        titleBtn.isSelected = !titleBtn.isSelected
        
        popOverView = PopoverViewController()
        popOverView.modalPresentationStyle = .custom
        popOverView.delegate = self
        popVerAnimatior.presentedFrame = CGRect(x: (kScreenWidth - 120) * 0.5, y: 50, width: 150, height: 180)
        popOverView.transitioningDelegate = popVerAnimatior
        popOverView.listArr = lockListArr  //添加数据
        present(popOverView, animated: true, completion: nil)
    }
}

extension HomeViewController:UITableViewDataSource,UITableViewDelegate,PopoverViewControllerDelegate{
    
    func popViewDidSeletedIndex(index: Int) {
        //判断是授权还是临时
        QPCLog("点击了\(index)")
        currentSeleteLock = lockListArr?[index]
        //根据选中锁的角色
        switch currentSeleteLock?.roleType ?? 3 {
        case 0,1:
            self.openBtnTopMagin.constant = 92 * kHeight6Scale
            self.tempBottomView?.isHidden = true
            self.lockTableView.isHidden = false
            self.lockUserBottomView.isHidden = false
            self.homeCenterView.isHidden = false
        case 2:
            self.tempBottomView?.isHidden = false
            self.lockTableView.isHidden = true
            self.lockUserBottomView.isHidden = true
            self.homeCenterView.isHidden = true
            self.openBtnTopMagin.constant = 152
        default:
            QPCLog("我是未知用户")
        }
        //从新获取数据锁信息
        getCurrentLockInfo()
        popOverView.dismiss(animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.openLockModelArr?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentfier = "openLock"
        var cell = tableView.dequeueReusableCell(withIdentifier: cellIdentfier) as? OpenLockCell
        if cell == nil{
            cell = Bundle.main.loadNibNamed("OpenLockCell", owner: nil, options: nil)?.last as? UITableViewCell as? OpenLockCell
        }
        cell!.model = self.openLockModelArr?[indexPath.row]
        return cell!
    }
}

//MARK: - CB
extension HomeViewController : BleManagerDelegate{
    
    func setupBluetool(){
        blueManager = BleManager.shared()
        blueManager.bleManagerDelegate = self
    }
    
    func starSearchBlue(){
        
        let per = (currentSeleteLock?.bluetoothName)!
        QPCLog("连接门锁编号为\(String(describing: per))")
        UserDefaults.standard.set(per, forKey: "per")
        
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
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 10 , execute: {
                    SVProgressHUD.dismiss()
                })
                let didContantPer = blueManager.connectedDevice()
                
                //查询当前是否有链接的设备,如有断开连接新设备
                if didContantPer != nil {
                    if didContantPer?.name == per {
                        self.openLockCheckCommand()
                    }else{
                        blueManager.disConnectDevice(didContantPer!)
                        blueManager.searchBleDevices()
                    }
                }else{
                    blueManager.searchBleDevices()
                }
        }
    }
    
    func openLockCheckCommand(){
        
        SVProgressHUD.show(withStatus: LanguageHelper.getString(key: "BlueTool_OpenLoading"))
        //0 owner 1 auth 2 temp
        if currentSeleteLock?.roleType == 0{
            //检查owner当前锁有没有开门秘钥
            if QPCKeychainTool.getOpenPassWordWithKeyChain(lockID: (currentSeleteLock?.lockId)!) != nil{
                    //判断有没有初始化过
                    let isSetup = UserInfo.getLockIsSetupWithNumberAndBlueName(soleStr: UserInfo.getPhoneNumber()! + (currentSeleteLock?.bluetoothName)!)
                    if isSetup == nil {
                        //时间初始化
                        bleToolTimeSetup()
                    }else{
                    let isTimeSynch = UserInfo.getLockIsTimeSynch(blueName: (currentSeleteLock?.bluetoothName)!)
                    if LockTools.checkIsOverTimeWithDate(date: isTimeSynch) {
                        //检测时间同步
                        blueManager.sendCommand(withPort: "07040100", dataStr: "07040100")
                    }else{
                        //直接开门
                        self.openLockCommand()
                    }
                }
            }else{
                weak var weakSelf = self
                //弹框
                let alterVC = UIAlertController(title: "系统通知", message: "亲爱的门锁用户您好！\n为了保障您和家人的安全，作为管理员，更换手机后需要重新扫描门内二维码进行绑定。", preferredStyle: .alert)
                let alertAc = UIAlertAction(title: "去设置", style: .default) { (action) in
                    let resetVC = ChangeNumberCodeController()
                    weakSelf!.navigationController?.pushViewController(resetVC, animated: true)
                }
                let knowAc = UIAlertAction(title: "我知道了", style: .default, handler: { (action) in
                    QPCLog("点击了知道")
                })
                knowAc.setValue(kTextBlockColor, forKey: "_titleTextColor")
                alterVC.addAction(alertAc)
                alterVC.addAction(knowAc)
                self.present(alterVC, animated: true, completion: nil)
            }
        }else{
            //user的p值从哪里拿到 4待处理,8已处理
            if currentSeleteLock?.authstatus == 4{
                //绑定user
                self.addUserWithBlueTool()
            }else{
                //查询user是否有开门秘钥
                 let openKey = QPCKeychainTool.getOpenPassWordWithKeyChain(lockID: (currentSeleteLock?.lockId)!)
                if openKey == nil{
                    weak var weakSelf = self
                    self.getZKeyContentWithS(completionHandler: { (s) in
                        //如果user用户本地没有开门pass重新绑定然后开门
                        let aesStr = QPCKeychainTool.getDeviceIdentifier()! + s
                        weakSelf?.blueManager.sendCommand(withSubPackagePort: "03030700", dataStr: aesStr)
                    })
                }else{
                    //判断user有没有初始化过
                    let isSetup = UserInfo.getLockIsSetupWithNumberAndBlueName(soleStr: UserInfo.getPhoneNumber()! + (currentSeleteLock?.bluetoothName)!)
                    if isSetup == nil {
                        //时间初始化
                        bleToolTimeSetup()
                    }else{
                        let isTimeSynch = UserInfo.getLockIsTimeSynch(blueName: (currentSeleteLock?.bluetoothName)!)
                        if LockTools.checkIsOverTimeWithDate(date: isTimeSynch) {
                            //检测时间同步
                            blueManager.sendCommand(withPort: "07040100", dataStr: "07040100")
                        }else{
                            //直接开门
                            self.openLockCommand()
                        }
                    }
                }
            }
        }
    }
    
    func bleToolTimeSetup(){
        //时间初始化
        let TestlockId = "0000000000"
        let lockPass = "0000000000000000"
        let setupTime = LockTools.getCurrentTime()
        let totalStr = "\(TestlockId)\(lockPass)\(setupTime)"
        QPCLog("timeSet----\(totalStr)")
        blueManager.sendCommand(withPort: "01010100", dataStr: totalStr)
    }
    
    //执行开门指令   0 user   owner 1
    func openLockCommand(){
        
        var isOwner = -1
        if currentSeleteLock?.roleType == 0{
            isOwner = 1 //owner开门
        }else{
            isOwner = 0  //user开门
        }
        var code : Int = 0
        //开门秘钥
        let privateKey =  (QPCKeychainTool.getOpenPassWordWithKeyChain(lockID: (currentSeleteLock?.lockId)!))!

        QPCLog("开门秘钥---\(privateKey)")
        //Int(Date().timeIntervalSince1970)
        let currentTime = Int(Date().timeIntervalSince1970)
        var privateKeyCString = privateKey.utf8CString
        privateKeyCString.withUnsafeMutableBytes { keyUMRBP in
            let a = keyUMRBP.baseAddress!.bindMemory(to: UInt8.self, capacity: keyUMRBP.count)
            code = google_authenticator(a, currentTime)
            QPCLog("我是验证码---\(code)--\(String(describing: a))----currentTime --\(currentTime)-")
        }
        func areKeysConsistent(_ key: UnsafeMutablePointer<UInt8>, _ keyLength: Int
            ) {
            print(key)
        }
        var codeStr = "\(code)"
        let count1 = (codeStr.count)
        for _ in count1 ..< 6 {
            codeStr = codeStr + "0"
        }
        
        let blueAdress = (QPCKeychainTool.getDeviceIdentifier())!
        let userInfo = "\(UserInfo.getUserIdToStr()!)\(blueAdress)"
        //属性owner  1,  user 0
        let totalStr = "\(userInfo)\(isOwner)\(codeStr)"
        blueManager.sendCommand(withPort: "04020600", dataStr: totalStr)
    }
    
    func discoveredDevicesArray(_ devicesArr: NSMutableArray?, withCBCentralManagerConnectState connectState: String?) {
        QPCLog(connectState ?? "")
        if connectState != nil,(connectState?.contains("已连接蓝牙"))!{
            QPCLog("我是唯一\(String(describing: QPCKeychainTool.getDeviceIdentifier()!))")
            self.openLockCheckCommand()
        }
    }
    
    func `return`(withData data: String!, isSucceed succeed: Bool, backData: String!){
        
        QPCLog("\(data)----\(backData!)")

        switch data! {
        case "初始化成功":
            // 记录已经初始化该锁
            UserInfo.saveLockIsSetupWithNumberAndBlueName(soleStr: UserInfo.getPhoneNumber()! + (currentSeleteLock?.bluetoothName)!)
            self.openLockCommand()
        case "需要时间同步":
            //时间同步
            let totalStr = "\(backData!)\(LockTools.getCurrentTime())"
            QPCLog("我是时间同步值---当前时间为\(totalStr)")
            blueManager.sendCommand(withPort: "07040102", dataStr: totalStr)
        case "不需要时间同步":
            self.openLockCommand()
        case "user绑定成功":
            //保存z
            self.savePassZeroWithS(str: self.userWithZstr)
            //保存开门L
            QPCKeychainTool.saveOpenPassWordWithKeyChain(openKey: backData, lockID: (currentSeleteLock?.lockId)!)
            //更新锁授权状态
            self.updateAuthStatusCommand(lockid: (currentSeleteLock?.lockId)!)
            self.openLockCommand()
        case "user绑定失败，用户已存在":
            self.openLockCommand()
        case "接收时间成功":
            //时间同步成功后,累加5天
            let currentTime = Date(timeIntervalSinceNow: 86400*5)
            QPCLog(LockTools.dateToStringWithDate(date: currentTime))
            UserInfo.saveLockIsTimeSynchWithBlueNameAndTime(blueName: (currentSeleteLock?.bluetoothName)!, time: currentTime)
            self.openLockCommand()
        case "时间被重置":
             self.bleToolTimeSetup()
        case "开门成功":
            Utils.showTip("开锁成功")
            let power = (backData as NSString).substring(to: 1)
            let mainStu = Int((backData as NSString).substring(with: NSMakeRange(4, 1)))
            let backStu = Int((backData as NSString).substring(with: NSMakeRange(3, 1)))
            QPCLog("当前电量:\(backData)---\(mainStu!)----\(backStu!)")
            let pow = Int(power)! * 10
            checkPowerIsLow(currentPower: pow)
            //开锁成功,恢复按钮
            self.openLockBtn.isSelected = false
            //保存锁日志
            self.dataManager.insertOpenRecordWith(lockid: (currentSeleteLock?.lockId)!, openStatu: 1, time: LockTools.getCurrentTimeWithDefault())
            self.addLockLog()
            self.addLockBatteryAndState(battery: pow, mainState: mainStu!, backState: backStu!)
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 10, execute: {
                self.sendCommandBlueToolToRemoveUser()
            })
            DispatchQueue.main.async(execute: {
                SVProgressHUD.dismiss()
            })
        case "删除成功","删除失败,不存在该用户":
            self.updateRemovedList()
        case "时间需要校正":
            //时间初始化
            bleToolTimeSetup()
        default:
            DispatchQueue.main.async(execute: {
                SVProgressHUD.showError(withStatus: data)
            })
            //开锁成功,恢复按钮
            self.openLockBtn.isSelected = false
        }
    }

    func addUserWithBlueTool(){
        //查询s
        let req =  BaseReq<UserGetKeyModel>()
        req.action = GateLockActions.ACTION_UserGetKeyContent
        req.sessionId = UserInfo.getSessionId()!
        req.data = UserGetKeyModel.init("S", lockid: (currentSeleteLock?.lockId)!)
        
        let userBlueMac = QPCKeychainTool.getDeviceIdentifier()
        weak var weakSelf = self
        AjaxUtil<OneParam<String>>.actionPost(req: req) { (resp) in
            QPCLog(resp)
            let s = resp.data?.p1
            let aesStr = userBlueMac! + s!
            QPCLog("aesStr--\(String(describing: aesStr))")
            guard s != nil else{
                SVProgressHUD.showError(withStatus: LanguageHelper.getString(key: "BlueTool_UserBingFail"))
                return
            }
            weakSelf?.userWithZstr = s!
            weakSelf?.blueManager.sendCommand(withSubPackagePort: "03030700", dataStr: aesStr)
        }
    }
    
    func savePassZeroWithS(str : String){
        //保存加密后的Z
        let req =  BaseReq<UserKeyContentModel>()
        req.action = GateLockActions.ACTION_UserKeyContent
        req.sessionId = UserInfo.getSessionId()!
        QPCLog("--\(QPCKeychainTool.getNumberPassword()!)")
        let nStr = QPCKeychainTool.getNumberPassword()!
        //必须为126bt
        let keyStr = nStr + nStr + nStr + nStr
        let z = str.aesEncrypt(key: keyStr)
        QPCLog("-\(String(describing: z!))")
        req.data = UserKeyContentModel.init("Z", content: z!, lockid: (currentSeleteLock?.lockId)!, tel: UserInfo.getPhoneNumber()!, isdel: 0)

        AjaxUtil<CommonResp>.actionPost(req: req, backJSON: { (resp) in
            QPCLog(resp.data?.msg)
        }) { (error) in
            QPCLog(error)
        }
    }
    
    //解密z获取授权s
    func getZKeyContentWithS(completionHandler: @escaping (_ sStr : String) -> Void){
        //查询z
        let req =  BaseReq<UserGetKeyModel>()
        req.action = GateLockActions.ACTION_UserGetKeyContent
        req.sessionId = UserInfo.getSessionId()!
        req.data = UserGetKeyModel.init("Z", lockid: (currentSeleteLock?.lockId)!)
        
        AjaxUtil<OneParam<String>>.actionPost(req: req, backJSON: { (resp) in
            QPCLog(resp)
            let Z = resp.data?.p1
            QPCLog("aesStr--\(String(describing: Z))")
            guard Z != nil else{
                return
            }
            let np = QPCKeychainTool.getNumberPassword()!
            let nStr = np + np + np + np
            let s = Z!.aesDecrypt(key: nStr)
            completionHandler(s!)

        }) { (errStr) in
           QPCLog(errStr)
        }
    }
    
    //检查电量是否过低
    func checkPowerIsLow(currentPower : Int){
        if currentPower <= 20 {
            let alterVC = UIAlertController(title: "系统通知", message: "门锁电量过低请及时更换电池", preferredStyle: .alert)
            let alertAc = UIAlertAction(title: "确定", style: .default) { (action) in
            }
            alterVC.addAction(alertAc)
            self.present(alterVC, animated: true, completion: nil)
        }
    }
    
    fileprivate func checkNoNetworkWithAlext(){
        let alertVC = UIAlertController(title: nil, message: "当前网络不可用,请检查网络是否连接", preferredStyle: .alert)
        let acSure = UIAlertAction(title: "确定", style: .default) { (UIAlertAction) in
            QPCLog("打开")
        }
        alertVC.addAction(acSure)
        self.present(alertVC, animated: true, completion: nil)
    }
}




