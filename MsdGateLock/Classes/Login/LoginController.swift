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
    case AdminUser     ///管理员
    case Authorize      ///授权用户
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
    private var timer : Timer?
    private var timeCount = 60    // 定义需要计时的时间
    private var isreq = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
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
    
    private func setupUI(){
        numberLabel.textColor = UIColor.hex(hexString: "1c1c1c")
        veritLabel.textColor = UIColor.hex(hexString: "2f2f2f")
        numberBottmView.backgroundColor = UIColor.hex(hexString: "f0f0f0")
        verBottomView.backgroundColor = UIColor.hex(hexString: "f0f0f0")
        
        //不可点击状态
        let color : UIColor = UIColor.hex(hexString: "e3e3e3")
        verBtn.setBackgroundImage(kCreateImageWithColor(color: color ), for: .disabled)
        verBtn.setTitleColor(UIColor.hex(hexString: "7c7c7c"), for: .disabled)
        
        verBtn.setBackgroundImage(kCreateImageWithColor(color: UIColor.hex(hexString: "2282ff") ), for: .normal)
        verBtn.setTitleColor(UIColor.hex(hexString: "ffffff"), for: .normal)
        verBtn.addTarget(self, action: #selector(getVerificaCode), for: .touchUpInside)
        
        duiBtn.setImage(UIImage(named : "weixuanzhong"), for: .normal)
        duiBtn.setImage(UIImage(named : "selected"), for: .selected)
        duiBtn.addTarget(self, action: #selector(duiBtnClick(btn:)), for: .touchUpInside)
        
        let loginDisColor = UIColor.hex(hexString: "e3e3e3")
        loginBtn.setBackgroundImage(kCreateImageWithColor(color: loginDisColor), for: .disabled)
        loginBtn.setTitleColor(UIColor.hex(hexString: "7c7c7c"), for: .disabled)
        
        let loginAbleColor = UIColor.hex(hexString: "2282ff")
        loginBtn.setBackgroundImage(kCreateImageWithColor(color: loginAbleColor), for: .normal)
        loginBtn.setTitleColor(UIColor.hex(hexString: "ffffff"), for: .normal)
        
        usernameTF.addTarget(self, action: #selector(phoneNumChange(tf:)), for: .editingChanged)
        passwordTF.addTarget(self, action: #selector(vertCodeChange(tf:)), for: .editingChanged)
        
        verBtn.isEnabled = false
        loginBtn.isEnabled = false
        duiBtn.isSelected = true
        
        loginTipLabel.textColor = UIColor.hex(hexString: "878787")
        let serviceTap = UITapGestureRecognizer(target: self, action: #selector(serviceClick))
        serviceLabel.isUserInteractionEnabled = true
        serviceLabel.textColor = UIColor.textBlueColor
        serviceLabel.addGestureRecognizer(serviceTap)
        iconImgView.kf.setImage(with:URL(string : UserInfo.getUserImageStr() ?? ""), placeholder: UIImage(named : "user1"), options: nil, progressBlock: nil)
    }
    
    //MARK: - Click
    @objc private func serviceClick(){
        let webVC = LockWebViewContrller()
        webVC.urlStr = GateLockActions.H5_Agreement
        webVC.title = "服务条款"
        navigationController?.pushViewController(webVC, animated: true)
    }
    
    @objc private func getVerificaCode(){
        self.getVertCodeTask(self.usernameTF.text!)
        self.verBtn.isEnabled = false
        self.usernameTF.isEnabled = false
        self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timeFireMethod), userInfo: nil, repeats: true)
    }
    
    @objc private func timeFireMethod(){
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
    
    @objc private func duiBtnClick(btn : UIButton){
        btn.isSelected = !(btn.isSelected)
    }
    
    //输入框改变
    @objc private func phoneNumChange(tf : UITextField){
        if tf.text?.count == 11{
            verBtn.isEnabled = true
        }else{
            verBtn.isEnabled = false
            loginBtn.isEnabled = false
        }
    }
    
    @objc private func vertCodeChange(tf : UITextField){
        if usernameTF.text?.count == 11 && passwordTF.text?.count == 6{
            loginBtn.isEnabled = true
        }else{
            loginBtn.isEnabled = false
        }
    }
    
    @IBAction func LoginButtonLicked(_ sender: AnyObject) {
        if duiBtn.isSelected {
            self.gotoMainPage()
            if let num = usernameTF.text,let code =  passwordTF.text{
                loginTask(num, code)
            }else{
                SVProgressHUD.showError(withStatus: "请填写手机号或验证码")
            }
        }else{
            SVProgressHUD.showError(withStatus: "请您勾选用户协议")
        }
    }
    
    ///跳转主页
    private func gotoMainPage(){
        let homeVC = HomeViewController()
        homeVC.isFirst = true
        let homeNav = LockNavigationController(rootViewController: homeVC)
        UIApplication.shared.keyWindow?.rootViewController = homeNav
    }
    
    //MARK:- HTTP
    ///调用登录
    private func loginTask(_ account: String,_ pwd: String){
        let req =  BaseReq<LoginReq>()
        req.action = GateLockActions.ACTION_LOGIN
        req.data = LoginReq(account,pwd)
        
        AjaxUtil<LoginResp>.actionPostAndProgress(req: req){
            [weak self] (resp) in
            UserInfo.saveSessionId(sessionID: (resp.data?.SessionId)!)
            UserInfo.saveUserId(userID: (resp.data?.UserId)!)
            self?.isreq = (resp.data?.isreg)!
            self?.getUserInfo(resp.data?.SessionId ?? "", member: (self?.usernameTF.text)!)
        }
    }
    
    // MARK:- 获取验证码
    private func getVertCodeTask(_ userTel: String){
        let req =  BaseReq<VerificatiReq>()
        req.action = GateLockActions.ACTION_SmsCode
        req.data = VerificatiReq(userTel)
        
        AjaxUtil<VerificatiResp>.actionPost(req: req){
            (resp) in
            SVProgressHUD.setDefaultMaskType(.none)
            SVProgressHUD.showSuccess(withStatus: resp.msg)
        }
    }
    
    private func getUserInfo(_ sessionId : String,member : String){
        let req =  BaseReq<UserInfoReq>()
        req.action = GateLockActions.ACTION_GetUserInfo
        req.sessionId = sessionId
        req.data = UserInfoReq.init(member)
        QPCLog(NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask,true).last)
        AjaxUtil<UserInfoResp>.actionPost(req: req){
            [weak self] (resp) in
            guard let weakSelf = self else { return }
            //保存手机号,sessionID
            UserInfo.savePhoneNumber(member: member)
            UserInfo.saveUserImageStr(imgStr: (resp.data?.userImage)!)
            
            //判断是否是第一次登录,若是进入主页,不是判断
            if weakSelf.isreq == 2{
                if QPCKeychainTool.existNumberPassword(){
                    weakSelf.navigationController?.pushViewController(NumberPassVerifController(), animated: true)
                }else{
                    //判断有没有锁,有锁没有本地密码,进入验证重新拉取锁秘钥
                    weakSelf.getUserLockList(resp.data?.userId ?? 0)
                }
            }else{
                weakSelf.gotoMainPage()
            }
        }
    }
    
    //获取用户锁列表
    private func getUserLockList(_ userID: Int){
        let req =  CommonReq()
        req.action = GateLockActions.ACTION_GetLockList
        req.sessionId = UserInfo.getSessionId()!
        req.sign = LockTools.getSignWithStr(str: "oxo")
        
        AjaxUtil<UserLockListResp>.actionArrPost(req: req) { [weak self] (resp) in
            guard let weakSelf = self else { return }
            if let lockArr = resp.data,lockArr.count > 0 {
                let secNuberVC = NumberPassVerifController()
                secNuberVC.isChangePhone = true
                weakSelf.navigationController?.pushViewController(secNuberVC, animated: true)
            }else{
                weakSelf.gotoMainPage()
            }
        }
    }
}

