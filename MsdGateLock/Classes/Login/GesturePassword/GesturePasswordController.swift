////
////  GesturePasswordControllerViewController.swift
////  MsdGateLock
////
////  Created by ox o on 2017/7/26.
////  Copyright © 2017年 xiaoxiao. All rights reserved.
////   手势密码验证
//
//import UIKit
//
//class GesturePasswordController: UIViewController {
//    
//    var lockView : PCCircleView! //解锁界面
//    var msgLabel : PCLockLabel! //提示label
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        self.view.backgroundColor = kGlobalBackColor
//        setupUI()
//    }
//
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        self.navigationController?.setNavigationBarHidden(true, animated: true)
//    }
//    
//    override func viewWillDisappear(_ animated: Bool) {
//        super.viewWillDisappear(animated)
//        self.navigationController?.setNavigationBarHidden(false, animated: true)
//    }
//}
//
//
//extension GesturePasswordController{
//    
//    func setupUI(){
//        let iconImageView = UIImageView(image: UIImage(named : "user1"))
//        iconImageView.layer.cornerRadius = 50
//        iconImageView.layer.masksToBounds = true
//        self.view.addSubview(iconImageView)
//        iconImageView.snp.makeConstraints { (make) in
//            make.top.equalTo(65)
//            make.centerX.equalTo(self.view)
//            make.width.equalTo(100)
//            make.height.equalTo(100)
//        }
//        
//        let numberLabel = UILabel()
//        numberLabel.text = UserInfo.getPhoneNumber()
//        numberLabel.textColor = kTextBlockColor
//        numberLabel.font = kGlobalTextFont
//        self.view.addSubview(numberLabel)
//        numberLabel.snp.makeConstraints { (make) in
//            make.top.equalTo(iconImageView.snp.bottom).offset(10)
//            make.centerX.equalTo(self.view)
//        }
//        
//        let gestureView = PCCircleView.init(cirCleViewCenterY: 0.6) 
//        gestureView?.delegate = self
//        gestureView?.type = CircleViewTypeVerify
//        self.lockView = gestureView
//        self.view.addSubview(gestureView!)
//        
//        let lockLabel = PCLockLabel()
//        lockLabel.frame = CGRect(x: 0, y: 0, width: kScreenWidth, height: 14)
//        lockLabel.center = CGPoint(x: kScreenWidth/2, y:(gestureView?.frame.minY)! - 30)
//        self.msgLabel = lockLabel
//        self.view.addSubview(msgLabel)
//        
//        
//        let changeVertStyleBtn = UIButton(type: .custom)
//        changeVertStyleBtn.setTitle("更改验证方式", for: .normal)
//        changeVertStyleBtn.setTitleColor(kTextBlueColor, for: .normal)
//        changeVertStyleBtn.titleLabel?.font = kGlobalTextFont
//        changeVertStyleBtn.addTarget(self, action: #selector(GesturePasswordController.changeVertStyleBtnDidClick), for: .touchUpInside)
//        self.view.addSubview(changeVertStyleBtn)
//        changeVertStyleBtn.snp.makeConstraints { (make) in
//            make.left.equalTo(45)
//            make.bottom.equalTo(-30)
//        }
//        
//        let changeUserBtn = UIButton(type: .custom)
//        changeUserBtn.setTitle("切换用户", for: .normal)
//        changeUserBtn.setTitleColor(kTextBlueColor, for: .normal)
//        changeUserBtn.titleLabel?.font = kGlobalTextFont
//        changeUserBtn.addTarget(self, action: #selector(GesturePasswordController.changeUserBtnDidClick), for: .touchUpInside)
//        self.view.addSubview(changeUserBtn)
//        changeUserBtn.snp.makeConstraints { (make) in
//            make.centerX.equalTo(self.view)
//            make.bottom.equalTo(-30)
//        }
//        
//        let forgetPassBtn = UIButton(type: .custom)
//        forgetPassBtn.setTitle("忘记密码", for: .normal)
//        forgetPassBtn.setTitleColor(kTextBlueColor, for: .normal)
//        forgetPassBtn.titleLabel?.font = kGlobalTextFont
//        forgetPassBtn.addTarget(self, action: #selector(GesturePasswordController.forgetPassBtnDidClick), for: .touchUpInside)
//        self.view.addSubview(forgetPassBtn)
//        forgetPassBtn.snp.makeConstraints { (make) in
//            make.right.equalTo(-45)
//            make.bottom.equalTo(-30)
//        }
//    }
//    
//}
//
//
//extension GesturePasswordController : CircleViewDelegate {
//    
//    func circleView(_ view: PCCircleView!, type: CircleViewType, didCompleteLoginGesture gesture: String!, result equal: Bool) {
//        if type == CircleViewTypeVerify {
//            if equal {
//                QPCLog("验证成功")
//                self.msgLabel.showNormalMsg("验证成功")
//                let homeNav = LockNavigationController(rootViewController: HomeViewController())
//                UIApplication.shared.keyWindow?.rootViewController = homeNav
//            }else{
//                self.msgLabel.showWarnMsgAndShake(gestureTextGestureVerifyError)
//            }
//        }
//    }
//}
//
//
////MARK:- CLICK
//extension GesturePasswordController {
//    
//    func changeVertStyleBtnDidClick(){
//        let seletedVeriVC = SetNumberPassController()
//        seletedVeriVC.title = "选择验证方式"
//        seletedVeriVC.seletedTitleArr = ["数字密码","指纹密码"]
//        navigationController?.pushViewController(seletedVeriVC, animated: true)
//    }
//    
//    func changeUserBtnDidClick(){
//        UserInfo.removeUserInfo()
//        UIApplication.shared.keyWindow?.rootViewController = LockNavigationController(rootViewController: LoginController())
//    }
//    
//    func forgetPassBtnDidClick(){
//        let numVC = ResetNumberController()
//        numVC.title = "重置手势密码"
//        navigationController?.pushViewController(numVC, animated: true)
//    }
//    
//}
//
