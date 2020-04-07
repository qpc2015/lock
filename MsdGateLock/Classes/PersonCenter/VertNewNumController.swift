//
//  VertNewNumController.swift
//  MsdGateLock
//
//  Created by 覃鹏成 on 2017/7/1.
//  Copyright © 2017年 xiaoxiao. All rights reserved.
//

import UIKit

class VertNewNumController: UIViewController {

    let memberLabel : UILabel = UILabel()
    let textTF : UITextField = UITextField()
    let numTF : UITextField = UITextField()
    let verBtn : UIButton = UIButton(type: .custom)
    
    var stepId : Int?
    
    var timer : Timer?
    // 定义需要计时的时间
    var timeCount = 60
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.globalBackColor
        
        self.title = "验证新手机"
        
        setupNavigationItem()
        
        setupUI()
    }
    
}


//MARK:- UI
extension VertNewNumController{
    
    func setupNavigationItem(){
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "完成", style: .plain, target: self, action: #selector(VertNewNumController.finishdClick));
    }
    
    func setupUI(){
        
        let lineView = UIView(frame: CGRect(x: 0, y: 20, width: kScreenWidth, height: 94))
        lineView.backgroundColor = UIColor.white
        view.addSubview(lineView)
        
        
        let newLabel = UILabel()
        newLabel.textColor = UIColor.textBlackColor
        newLabel.font = UIFont.systemFont(ofSize: 14)
        newLabel.text = "新手机"
        lineView.addSubview(newLabel)
        newLabel.snp.makeConstraints { (make) in
            make.left.equalTo(14)
            make.top.equalTo(11)
        }
        
        numTF.attributedPlaceholder = NSAttributedString.init(string: "请输入新手机号", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 14),NSAttributedString.Key.foregroundColor: UIColor.textGrayColor])
        numTF.borderStyle = .none
        numTF.keyboardType = .numberPad
        lineView.addSubview(numTF)
        numTF.addTarget(self, action: #selector(VertNewNumController.numberTfTextChange(tf:)), for: .editingChanged)
        numTF.snp.makeConstraints { (make) in
            make.left.equalTo(newLabel.snp.right).offset(26)
            make.centerY.equalTo(newLabel)
        }
        
        let line = UIView()
        line.backgroundColor = UIColor.hex(hexString: "f0f0f0")
        lineView.addSubview(line)
        line.snp.makeConstraints { (make) in
            make.left.equalTo(0)
            make.right.equalTo(0)
            make.centerY.equalTo(lineView)
            make.height.equalTo(2)
        }
        
        let tipLabel = UILabel()
        tipLabel.textColor = UIColor.textBlackColor
        tipLabel.font = UIFont.systemFont(ofSize: 14)
        tipLabel.text = "验证码"
        lineView.addSubview(tipLabel)
        tipLabel.snp.makeConstraints { (make) in
            make.bottom.equalTo(-14)
            make.left.equalTo(14)
        }
        
        textTF.attributedPlaceholder = NSAttributedString.init(string: "请输入您的短信验证码", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 14),NSAttributedString.Key.foregroundColor: UIColor.textGrayColor])
        textTF.borderStyle = .none
        textTF.keyboardType = .numberPad
        lineView.addSubview(textTF)
        textTF.snp.makeConstraints { (make) in
            make.left.equalTo(tipLabel.snp.right).offset(26)
            make.centerY.equalTo(tipLabel)
        }
        
        let norColor = UIColor.textBlueColor
        verBtn.setBackgroundImage(kCreateImageWithColor(color: norColor), for: .normal)
        verBtn.setTitleColor(UIColor.white, for: .normal)
        let disColor = UIColor.hex(hexString: "d7d7d7")
        verBtn.setBackgroundImage(kCreateImageWithColor(color: disColor), for: .disabled)
        verBtn.setTitleColor(UIColor.hex(hexString: "676767"), for: .disabled)
        verBtn.layer.cornerRadius = 4
        verBtn.layer.masksToBounds = true
        verBtn.setTitle("发送", for: .normal)
        verBtn.titleLabel?.font = kGlobalTextFont
        verBtn.addTarget(self, action: #selector(VertNewNumController.sendVeriteCodeClick(btn:)), for: .touchUpInside)
        verBtn.isEnabled = false
        lineView.addSubview(verBtn)
        verBtn.snp.makeConstraints { (make) in
            make.right.equalTo(-14)
            make.centerY.equalTo(tipLabel)
            make.width.equalTo(57)
            make.height.equalTo(34)
        }
    }
    
    
}


//MARK:- click
extension VertNewNumController{
    
    @objc func numberTfTextChange(tf : UITextField){
        if tf.text?.count == 11 {
            verBtn.isEnabled = true
        }else{
            verBtn.isEnabled = false
        }
    }
    
    @objc func finishdClick(){
        //todo 待测试
        if (numTF.text?.count != 11 && textTF.text?.count != 6){
            SVProgressHUD.showError(withStatus: "请输入正确的手机号码或验证码")
            return
        }
        let req =  BaseReq<ResetNumberReq>()
        req.action = GateLockActions.ACTION_ChangeMobile2
        req.sign = LockTools.getSignWithStr(str: "oxo")
        req.sessionId = UserInfo.getSessionId()!
        req.data = ResetNumberReq.init(self.numTF.text!, code: self.textTF.text!, oldMobile: UserInfo.getPhoneNumber()!, stepId: self.stepId!)
        
        weak var weakSelf = self
        AjaxUtil<CommonResp>.actionPost(req: req) { (resp) in
            SVProgressHUD.showSuccess(withStatus: resp.msg)
            //保存新手机号
            //清除
            UserInfo.removeUserInfo()
            UIApplication.shared.keyWindow?.rootViewController = LockNavigationController(rootViewController: LoginController())
        }
    }
    
    @objc fileprivate func sendVeriteCodeClick(btn : UIButton){
        
        if numTF.text?.count == 11 {
            btn.isEnabled = false
            
            self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(VertNewNumController.timeFireMethod), userInfo: nil, repeats: true)
            
            getVertCodeTask(numTF.text!)
        }else{
            SVProgressHUD.showError(withStatus: "请输入正确手机号码")
        }

    }
    
    @objc fileprivate func timeFireMethod(){
        // 每秒计时一次
        self.timeCount = (self.timeCount) - 1
        
        self.verBtn.setTitle("\(String(self.timeCount))s", for: .normal)
        // 时间到了取消时间源
        if self.timeCount <= 0 {
            self.timer?.invalidate()
            self.timeCount = 60
            self.verBtn.isEnabled = true
            self.verBtn.setTitle("发送", for: .normal)
        }
    }
    
    
    //获取验证码
    func getVertCodeTask(_ userTel: String){
        
        let req =  BaseReq<VerificatiReq>()
        req.action = GateLockActions.ACTION_SmsCode
        req.data = VerificatiReq(userTel)
        
        AjaxUtil<VerificatiResp>.actionPost(req: req){
            (resp) in
            SVProgressHUD.showSuccess(withStatus: resp.msg)
        }
    }
    
    //保存加密后的N
    func saveNumPassWithService(str : String){
        
        let req =  BaseReq<UserKeyContentModel>()
        req.action = GateLockActions.ACTION_UserKeyContent
        req.sessionId = UserInfo.getSessionId()!
        
        let nStr = UserInfo.getPhoneNumber()!
        //必须为126bt
        let keyStr = str + str + str + str
        let z = nStr.aesEncrypt(key: keyStr)
        QPCLog("-\(String(describing: z!))")
        req.data = UserKeyContentModel.init("N", content: z!, lockid: "0", tel: "0", isdel: 0)
        
        AjaxUtil<CommonResp>.actionPost(req: req, backJSON: { (resp) in
            QPCLog(resp.data?.msg)
        }) { (error) in
            QPCLog(error)
        }
    }
    
}
