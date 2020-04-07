//
//  ChangePhoneNumController.swift
//  MsdGateLock
//
//  Created by 覃鹏成 on 2017/7/1.
//  Copyright © 2017年 xiaoxiao. All rights reserved.
//

import UIKit

class ChangePhoneNumController: UIViewController {
    
    
    let memberLabel : UILabel = UILabel()
    let textTF : UITextField = UITextField()
    let verBtn : UIButton = UIButton(type: .custom)
    
    var timer : Timer?
    // 定义需要计时的时间
    var timeCount = 60
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.globalBackColor
        
        self.title = "验证旧手机"
        
        setupNavigationItem()
        
        setupUI()
    }
}


//MARK:- UI
extension ChangePhoneNumController{
    
    func setupNavigationItem(){
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "下一步", style: .plain, target: self, action: #selector(ResetNumberController.nextStep));
        
    }
    
    func setupUI(){
        
        textTF.becomeFirstResponder()
        
        let lineView = UIView(frame: CGRect(x: 0, y: 20, width: kScreenWidth, height: 46))
        lineView.backgroundColor = UIColor.white
        view.addSubview(lineView)
        
        let tipLabel = UILabel()
        tipLabel.textColor = UIColor.textBlackColor
        tipLabel.font = UIFont.systemFont(ofSize: 14)
        tipLabel.text = "验证码"
        lineView.addSubview(tipLabel)
        tipLabel.snp.makeConstraints { (make) in
            make.left.equalTo(14)
            make.centerY.equalTo(lineView)
        }
        
        textTF.attributedPlaceholder = NSAttributedString.init(string: "请输入您的短信验证码", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 14),NSAttributedString.Key.foregroundColor: UIColor.textGrayColor])
        textTF.borderStyle = .none
        textTF.keyboardType = .numberPad
        lineView.addSubview(textTF)
        textTF.snp.makeConstraints { (make) in
            make.left.equalTo(tipLabel.snp.right).offset(33)
            make.top.equalTo(lineView)
            make.bottom.equalTo(lineView)
            make.right.equalTo(70)
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
        verBtn.addTarget(self, action: #selector(sendVeriteCodeClick(btn:)), for: .touchUpInside)
        lineView.addSubview(verBtn)
        verBtn.snp.makeConstraints { (make) in
            make.right.equalTo(-14)
            make.centerY.equalTo(lineView)
            make.width.equalTo(57)
            make.height.equalTo(34)
        }
    }
    
    func nextStep(){
        
        weak var weakSelf = self
        if textTF.text?.count == 6 {
            
            let req = BaseReq<VertOlderNumReq>()
            req.action = GateLockActions.ACTION_ChangeMobile1
            req.sessionId = UserInfo.getSessionId()!
            req.sign = LockTools.getSignWithStr(str: "oxo")
            req.data = VertOlderNumReq(UserInfo.getPhoneNumber()!, code: textTF.text!)
            
            AjaxUtil<OneParam<Int>>.actionPost(req: req) { (resp) in
                QPCLog(resp)
                let vertNewVC = VertNewNumController()
                vertNewVC.stepId = resp.data?.p1
                weakSelf?.navigationController?.pushViewController(vertNewVC, animated: true)
            }
            
        }else{
            SVProgressHUD.showError(withStatus: "请输入正确验证码")
        }
    }
    
    @objc func sendVeriteCodeClick(btn : UIButton){
        btn.isEnabled = false
        
        self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(ChangePhoneNumController.timeFireMethod), userInfo: nil, repeats: true)
        
        getVertCodeTask(UserInfo.getPhoneNumber()!)
    }
    
    @objc func timeFireMethod(){
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
}



//MARK:-   http
extension ChangePhoneNumController{
    
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
    
    
}
