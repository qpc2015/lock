//
//  ModifyNumPassViewController.swift
//  MsdGateLock
//
//  Created by ox o on 2017/7/27.
//  Copyright © 2017年 xiaoxiao. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift

class ModifyNumPassViewController: UIViewController {

    @IBOutlet weak var tipLabel: UILabel!
    var verifictCodeView : NumberVerificationCodeView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.globalBackColor
        self.title = "修改数字密码"
        setupUI()
    }

    func setupUI(){
        tipLabel.textColor = UIColor.textBlackColor
    
        verifictCodeView = NumberVerificationCodeView(frame: CGRect(x: 0, y: 50, width: kScreenWidth, height: 50))
        verifictCodeView.delegate = self
        view.addSubview(verifictCodeView)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        IQKeyboardManager.shared.enableAutoToolbar = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        IQKeyboardManager.shared.enableAutoToolbar = true
    }
}


extension ModifyNumPassViewController : NumberVerificationCodeViewDelegate {
    
    func verificationCodeDidFinishedInput(verificationCodeView: NumberVerificationCodeView, code: String) {
        QPCLog(code)
        if code == QPCKeychainTool.getNumberPassword() {
            let modifyVC = ResetNewPassController()
            modifyVC.isModify = true
            navigationController?.pushViewController(modifyVC, animated: true)
        }else{
            verifictCodeView.cleanVerificationCodeView()
        }
    }

    
    
}
