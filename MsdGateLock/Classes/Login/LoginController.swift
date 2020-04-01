//
//  LoginController.swift
//  MsdGateLock
//
//  Created by xiaoxiao on 2017/5/25.
//  Copyright © 2017年 xiaoxiao. All rights reserved.
//

import UIKit
import ObjectMapper

enum UserType : Int {
    case AdminUser=0      ///管理员
    case Authorize=1      ///授权用户
    case Temporary       ///临时用户
    case Nopermission     ///未有权限用户
}

class LoginController: UIViewController {

    @IBOutlet weak var numberLabel: UILabel!
    @IBOutlet weak var veritLabel: UILabel!
    @IBOutlet weak var verBottomView: UIView!
    @IBOutlet weak var numberBottmView: UIView!
    @IBOutlet weak var iconImgView: UIImageView!
    @IBOutlet weak var usernameTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var verBtn: UIButton!
    @IBOutlet weak var duiBtn: UIButton!
    @IBOutlet weak var serviceLabel: UILabel!
    @IBOutlet weak var loginTipLabel: UILabel!
    
    @IBOutlet weak var tfLefMagin: NSLayoutConstraint!
    
    
    var timer : Timer?
    // 定义需要计时的时间
    var timeCount = 60
    var isreq = 0
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if kIsSreen5 {
            verBtn.bounds = CGRect(x: 0, y: 0, width: 66 * kWidth6Scale, height: 44 * kHeight6Scale)
            tfLefMagin.constant = 43 * kWidth6Scale
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }

}

//MARK:- UI
extension LoginController{
    
    fileprivate func setupUI(){
        
        numberLabel.textColor = kRGBColorFromHex(rgbValue: 0x1c1c1c)
        veritLabel.textColor = kRGBColorFromHex(rgbValue: 0x2f2f2f)
        numberBottmView.backgroundColor = kRGBColorFromHex(rgbValue: 0xf0f0f0)
        verBottomView.backgroundColor = kRGBColorFromHex(rgbValue: 0xf0f0f0)
        
        //不可点击状态
        let color : UIColor = kRGBColorFromHex(rgbValue: 0xe3e3e3)
        verBtn.setBackgroundImage(kCreateImageWithColor(color: color ), for: .disabled)
        verBtn.setTitleColor(kRGBColorFromHex(rgbValue: 0x7c7c7c), for: .disabled)

        let nomalColor : UIColor = kRGBColorFromHex(rgbValue: 0x2282ff)
        verBtn.setBackgroundImage(kCreateImageWithColor(color: nomalColor ), for: .normal)
        verBtn.setTitleColor(kRGBColorFromHex(rgbValue: 0xffffff), for: .normal)
        verBtn.addTarget(self, action: #selector(LoginController.getVerificaCode), for: .touchUpInside)

        duiBtn.setImage(UIImage(named : "weixuanzhong"), for: .normal)
        duiBtn.setImage(UIImage(named : "selected"), for: .selected)
        duiBtn.addTarget(self, action: #selector(LoginController.duiBtnClick(btn:)), for: .touchUpInside)
        
        let loginDisColor = kRGBColorFromHex(rgbValue: 0xe3e3e3)
        loginBtn.setBackgroundImage(kCreateImageWithColor(color: loginDisColor), for: .disabled)
        loginBtn.setTitleColor(kRGBColorFromHex(rgbValue: 0x7c7c7c), for: .disabled)
        
        let loginAbleColor = kRGBColorFromHex(rgbValue: 0x2282ff)
        loginBtn.setBackgroundImage(kCreateImageWithColor(color: loginAbleColor), for: .normal)
        loginBtn.setTitleColor(kRGBColorFromHex(rgbValue: 0xffffff), for: .normal)
        
        usernameTF.addTarget(self, action: #selector(LoginController.phoneNumChange(tf:)), for: .editingChanged)
        passwordTF.addTarget(self, action: #selector(LoginController.vertCodeChange(tf:)), for: .editingChanged)
        
        verBtn.isEnabled = false
        loginBtn.isEnabled = false
        duiBtn.isSelected = true

        loginTipLabel.textColor = kRGBColorFromHex(rgbValue: 0x878787)
        let serviceTap = UITapGestureRecognizer(target: self, action: #selector(LoginController.serviceClick))
        serviceLabel.isUserInteractionEnabled = true
        serviceLabel.textColor = kTextBlueColor
        serviceLabel.addGestureRecognizer(serviceTap)
        
        iconImgView.kf.setImage(with: URL(string : UserInfo.getUserImageStr() ?? ""), placeholder: UIImage(named : "user1"), options: nil, progressBlock: nil, completionHandler: nil)
    }
    
}

//MARK:- 事件处理
extension LoginController{
    
    @objc fileprivate func serviceClick(){
        let webVC = LockWebViewContrller()
        webVC.urlStr = GateLockActions.H5_Agreement
        webVC.title = "服务条款"
        navigationController?.pushViewController(webVC, animated: true)
    }
    
    @objc func getVerificaCode(){
        
        self.getVertCodeTask(self.usernameTF.text!)
        self.verBtn.isEnabled = false
        self.usernameTF.isEnabled = false
        
        self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(LoginController.timeFireMethod), userInfo: nil, repeats: true)
        
}
    
    @objc fileprivate func timeFireMethod(){
            // 每秒计时一次
            self.timeCount = (self.timeCount) - 1
            
            self.verBtn.setTitle("\(String(self.timeCount))秒", for: .normal)
            // 时间到了取消时间源
            if self.timeCount <= 0 {
                self.timer?.invalidate()
                self.timeCount = 60
                self.verBtn.isEnabled = true
                self.usernameTF.isEnabled = true
                self.verBtn.setTitle("发送", for: .normal)
            }
    }
    
    @objc fileprivate func duiBtnClick(btn : UIButton){
        
        btn.isSelected = !(btn.isSelected)
    }
  
    //输入框改变
    @objc fileprivate func phoneNumChange(tf : UITextField){
        if tf.text?.count == 11{
            verBtn.isEnabled = true
        }else{
            verBtn.isEnabled = false
            loginBtn.isEnabled = false
        }
        
    }
    
    @objc fileprivate func vertCodeChange(tf : UITextField){
        if usernameTF.text?.count == 11 && (passwordTF.text?.count)! == 6{
            loginBtn.isEnabled = true
        }else{
            loginBtn.isEnabled = false
        }
    }
    

    @IBAction func LoginButtonLicked(_ sender: AnyObject) {
        
        if duiBtn.isSelected {
            self.gotoMainPage()
//            loginTask(usernameTF.text!, passwordTF.text!)
        }else{
            SVProgressHUD.showError(withStatus: "请您勾选用户协议")
        }
    }
    
    
    ///检查更新
    func  checkUpgrade()
    {
        
    }
    
    ///跳转手势密码
//    func gotoGesturePassWordVC(){
//        navigationController?.pushViewController(GesturePasswordController(), animated: true)
//    }
    
    ///跳转主页
    func gotoMainPage()
    {
        let homeVC = HomeViewController()
        homeVC.isFirst = true
        let homeNav = LockNavigationController(rootViewController: homeVC)
        UIApplication.shared.keyWindow?.rootViewController = homeNav
    }
    
    ///跳转没有权限的用户界面
//    func gotoNopermissUserHomeVC(){
//        let noperNav = LockNavigationController(rootViewController: NoPermissionController())
//        UIApplication.shared.keyWindow?.rootViewController = noperNav
//    }
    

}

//MARK:- HTTP
extension LoginController{
    
    ///调用登录
    fileprivate func loginTask(_ account: String,_ pwd: String){
        
        let req =  BaseReq<LoginReq>()
        req.action = GateLockActions.ACTION_LOGIN
        req.data = LoginReq(account,pwd)
        
        weak var weakSelf = self
        AjaxUtil<LoginResp>.actionPostAndProgress(req: req){
            (resp) in
            
            UserInfo.saveSessionId(sessionID: (resp.data?.SessionId)!)
            UserInfo.saveUserId(userID: (resp.data?.UserId)!)
            weakSelf?.isreq = (resp.data?.isreg)!
            weakSelf?.getUserInfo(resp.data?.SessionId ?? "", member: self.usernameTF.text!)
        }
    }
    
    // MARK:- 获取验证码
    fileprivate func getVertCodeTask(_ userTel: String){
        
        let req =  BaseReq<VerificatiReq>()
        req.action = GateLockActions.ACTION_SmsCode
        req.data = VerificatiReq(userTel)
        
        AjaxUtil<VerificatiResp>.actionPost(req: req){
            (resp) in
//            SVProgressHUD.setDefaultMaskType(.none)
//            SVProgressHUD.showSuccess(withStatus: resp.msg)
        }
    }

    
    func getUserInfo(_ sessionId : String,member : String){
        let req =  BaseReq<UserInfoReq>()
        req.action = GateLockActions.ACTION_GetUserInfo
        req.sessionId = sessionId
        req.data = UserInfoReq.init(member)
        
        weak var weakSelf = self
        QPCLog(NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask,true).last)
        AjaxUtil<UserInfoResp>.actionPost(req: req){
            (resp) in
            //保存手机号,sessionID
            UserInfo.savePhoneNumber(member: member)
            UserInfo.saveUserImageStr(imgStr: (resp.data?.userImage)!)
            
//            UserDefaults.standard.set(resp.data?.userName, forKey: UserInfo.userName)
            //判断是否是第一次登录,若是进入主页,不是判断
            if weakSelf?.isreq == 2{
                if QPCKeychainTool.existNumberPassword(){
                    weakSelf?.navigationController?.pushViewController(NumberPassVerifController(), animated: true)
                }else{
                    //判断有没有锁,有锁没有本地密码,进入验证重新拉取锁秘钥
                    weakSelf?.getUserLockList(resp.data?.userId ?? 0)
                }
            }else{
                weakSelf?.gotoMainPage()
            }
//            else if GesturePasswordModel.existGesturePassword(){
//                weakSelf?.gotoGesturePassWordVC()
//            }
        }
        
    }
    
    //获取用户锁列表
    func getUserLockList(_ userID: Int){
        
        let req =  CommonReq()
        req.action = GateLockActions.ACTION_GetLockList
        req.sessionId = UserInfo.getSessionId()!
        req.sign = LockTools.getSignWithStr(str: "oxo")
        
        weak var weakSelf = self
        AjaxUtil<UserLockListResp>.actionArrPost(req: req) { (resp) in
            QPCLog(resp)
            if let lockArr = resp.data,lockArr.count > 0 {
                let secNuberVC = NumberPassVerifController()
                secNuberVC.isChangePhone = true
                weakSelf?.navigationController?.pushViewController(secNuberVC, animated: true)
            }else{
                self.gotoMainPage()
            }
        }

    }

    
}
