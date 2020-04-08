//
//  ResetNumberController.swift
//  MsdGateLock
//
//  Created by ox o on 2017/6/27.
//  Copyright © 2017年 xiaoxiao. All rights reserved.
//  重置数字密码&&手势密码

import UIKit

class ResetNumberController: UIViewController {

    let memberLabel : UILabel = UILabel()
    let textTF : UITextField = UITextField()
    let verBtn : UIButton = UIButton(type: .custom)
    
    var timer : Timer?
    // 定义需要计时的时间
    var timeCount = 60
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor.globalBackColor
        
        setupNavigationItem()
        
        setupUI()
    }

}


//MARK:- UI
extension ResetNumberController{
    
    func setupNavigationItem(){
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "下一步", style: .plain, target: self, action: #selector(ResetNumberController.nextStep));
        
    }
    
    func setupUI(){
        memberLabel.frame = CGRect(x: 14, y: 6, width: kScreenWidth, height: 20)
        memberLabel.text = "当前手机号: \(UserInfo.getPhoneNumber()!)"
        memberLabel.font = UIFont.systemFont(ofSize: 12)
        memberLabel.textColor = UIColor.textGrayColor
        view.addSubview(memberLabel)

        
        let lineView = UIView(frame: CGRect(x: 0, y: 28, width: kScreenWidth, height: 46))
        lineView.backgroundColor = UIColor.white
        view.addSubview(lineView)
        

        textTF.attributedPlaceholder = NSAttributedString.init(string: "请输入您的短信验证码", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 14),NSAttributedString.Key.foregroundColor: UIColor.textGrayColor])
        textTF.borderStyle = .none
        textTF.keyboardType = .numberPad
        lineView.addSubview(textTF)
        textTF.snp.makeConstraints { (make) in
            make.left.equalTo(14)
            make.top.equalTo(lineView)
            make.bottom.equalTo(lineView)
            make.right.equalTo(70)
        }
        
        let norColor = UIColor.textBlueColor
        verBtn.setBackgroundImage(kCreateImageWithColor(color: norColor), for: .normal)
        verBtn.setTitleColor(UIColor.white, for: .normal)
        let disColor = UIColor.hex(hexString: "d7d7d7")
        verBtn.setBackgroundImage(kCreateImageWithColor(color: disColor), for: .disabled)
        verBtn.setTitleColor(UIColor.hex(hexString: "0x676767"), for: .disabled)
        verBtn.layer.cornerRadius = 4
        verBtn.layer.masksToBounds = true
        verBtn.setTitle("发送", for: .normal)
        verBtn.titleLabel?.font = kGlobalTextFont
        verBtn.addTarget(self, action: #selector(ResetNumberController.sendVeriteCodeClick(btn:)), for: .touchUpInside)
        lineView.addSubview(verBtn)
        verBtn.snp.makeConstraints { (make) in
            make.right.equalTo(-14)
            make.centerY.equalTo(lineView)
            make.width.equalTo(57)
            make.height.equalTo(34)
        }
    }
    
    
}


//MARK:- click
extension ResetNumberController{
    
    @objc func nextStep(){
        
        if (textTF.text?.count != 6){
            SVProgressHUD.showError(withStatus: "请输入正确的6位验证码")
        }else{
            let req = BaseReq<TwoParam<String,String>>()
            req.action = GateLockActions.ACTION_CheckSMS
            req.data = TwoParam.init(p1: UserInfo.getPhoneNumber()!, p2: self.textTF.text!)
            AjaxUtil<CommonResp>.actionPost(req: req, backJSON: { [weak self](resp) in
                guard let weakSelf = self else {return}
                QPCLog(resp.msg)
                if weakSelf.title == "重置数字密码"{
                    let resetVC = ResetNewPassController()
                    resetVC.isModify = true
                    weakSelf.navigationController?.pushViewController(resetVC, animated: true)
                }
//                else if weakSelf?.title == "重置手势密码"{
//                    let resetG = SetGestureController()
//                    resetG.isReset = true
//                    weakSelf?.navigationController?.pushViewController(resetG, animated: true)
//                }
                else if weakSelf.title == "删除数字密码"{
                    //删除
//                    LoginKeyChainTool.deletedNumberPassword(phoneNum: <#String#>)
                    let vcIndex = weakSelf.navigationController?.viewControllers.index(of: weakSelf)!
                    weakSelf.navigationController?.popToViewController((weakSelf.navigationController?.viewControllers[vcIndex! - 2])!, animated: true)
                }
//                else if weakSelf?.title == "删除手势密码"{
//                    //删除
//                    QPCKeychainTool.deleteGesturePassword()
//                    let vcIndex = weakSelf?.navigationController?.viewControllers.index(of: self)!
//                    weakSelf?.navigationController?.popToViewController((weakSelf?.navigationController?.viewControllers[vcIndex! - 2])!, animated: true)
//                }
            })
        }
    }
    
    @objc fileprivate func sendVeriteCodeClick(btn : UIButton){
        btn.isEnabled = false
        
        self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(ResetNumberController.timeFireMethod), userInfo: nil, repeats: true)
        
        getVertCodeTask(UserInfo.getPhoneNumber()!)
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
    
}
