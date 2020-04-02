//
//  NumberPassVerifController.swift
//  MsdGateLock
//
//  Created by ox o on 2017/6/23.
//  Copyright © 2017年 xiaoxiao. All rights reserved.
//  数字密码验证

import UIKit
import IQKeyboardManagerSwift

class NumberPassVerifController: UIViewController {

    @IBOutlet weak var iconImgView: UIImageView!
    @IBOutlet weak var memberLabel: UILabel!
    var verifictCodeView : NumberVerificationCodeView!
    var isChangePhone : Bool = false  //是否属于更换手机验证
    var nPasswordStr : String?   //n秘钥
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = kGlobalBackColor
        setupUI()
        
        if !isChangePhone && UserInfo.isOpenFingerPrint()  {
            TouchIdManager.touchIdWithHand(fallBackTitle: "", succeed: {
                QPCLog("解锁成功")
                let homeNav = LockNavigationController(rootViewController: HomeViewController())
                UIApplication.shared.keyWindow?.rootViewController = homeNav
            }) { (error) in
                QPCLog(error.localizedDescription)
            }
            print(TouchIdManager.isSupportTouchID)
        }
        
        if isChangePhone {
            //请求n
            checkNPassword()
        }

    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        IQKeyboardManager.shared.enable = false
        IQKeyboardManager.shared.enableAutoToolbar = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.enableAutoToolbar = true
    }

}


//MARK:- 监听密码
extension NumberPassVerifController : NumberVerificationCodeViewDelegate{
    
    fileprivate func setupUI(){
        
        verifictCodeView = NumberVerificationCodeView(frame: CGRect(x: 0, y: 232, width: kScreenWidth, height: 50))
        verifictCodeView.delegate = self
        view.addSubview(verifictCodeView)
        
        iconImgView.kf.setImage(with: URL(string : UserInfo.getUserImageStr() ?? ""), placeholder: UIImage(named : "user1"), options: nil, progressBlock: nil)
        
        memberLabel.text = UserInfo.getPhoneNumber()
    }
    
    func verificationCodeDidFinishedInput(verificationCodeView: NumberVerificationCodeView, code: String) {
        QPCLog(QPCKeychainTool.getNumberPassword())
        //拉取Z然后解密看是否成功
        if isChangePhone {
            if self.nPasswordStr != nil ,(self.nPasswordStr?.count)! > 0{
                let deStr = code + code + code + code
                let resultStr = self.nPasswordStr!.aesDecrypt(key: deStr)
                QPCLog("---解锁秘钥后---\(String(describing: resultStr))")
                guard resultStr != nil else {
                    verifictCodeView.cleanVerificationCodeView()
                    return
                }
                if (resultStr!.count > 0) {
                    //保存数字密码
                    QPCKeychainTool.saveNumberPassword(code)
                    let homeNav = LockNavigationController(rootViewController: HomeViewController())
                    UIApplication.shared.keyWindow?.rootViewController = homeNav
                }else{
                    verifictCodeView.cleanVerificationCodeView()
                }
            }else{
                //请求n并重新解密N
                checkNPassword()
                verifictCodeView.cleanVerificationCodeView()
                SVProgressHUD.showError(withStatus: "请检查网络")
            }
            
        }else{
            if code == QPCKeychainTool.getNumberPassword() {
                let homeNav = LockNavigationController(rootViewController: HomeViewController())
                UIApplication.shared.keyWindow?.rootViewController = homeNav
                
            }else{
                verifictCodeView.cleanVerificationCodeView()
            }
        }

    }
    
    
    func checkNPassword(){
        //查询N
        let req =  BaseReq<UserGetKeyModel>()
        req.action = GateLockActions.ACTION_UserGetKeyContent
        req.sessionId = UserInfo.getSessionId()!
        req.data = UserGetKeyModel.init("N", lockid: "0")
        
        weak var weakSelf = self
        AjaxUtil<OneParam<String>>.actionPost(req: req) { (resp) in
            QPCLog(resp)
            weakSelf?.nPasswordStr = resp.data?.p1
        }

    }
}


//MARK:- 响应事件
extension NumberPassVerifController{

    //更改验证方式
//    @IBAction func changeVeritStyleClick(_ sender: Any) {
//        QPCLog("changeVertiClick")
//        let seletedVeriVC = SetNumberPassController()
//        seletedVeriVC.title = "选择验证方式"
//        seletedVeriVC.seletedTitleArr = ["手势密码","指纹密码"]
//        navigationController?.pushViewController(seletedVeriVC, animated: true)
//    }
    
    //切换用户
    @IBAction func exchangeUserClick(_ sender: Any) {
        
        UserInfo.removeUserInfo()
        UIApplication.shared.keyWindow?.rootViewController = LockNavigationController(rootViewController: LoginController())
    }
    
    //忘记密码
    @IBAction func forgetPasswordClick(_ sender: Any) {
        let numVC = ResetNumberController()
        numVC.title = "重置数字密码"
        navigationController?.pushViewController(numVC, animated: true)
    }
    
    
}
