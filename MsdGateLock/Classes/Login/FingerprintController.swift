//
//  FingerprintController.swift
//  MsdGateLock
//
//  Created by ox o on 2017/6/21.
//  Copyright © 2017年 xiaoxiao. All rights reserved.
//  设置指纹识别

import UIKit

class FingerprintController: UIViewController {
    
//    @IBOutlet weak var iconImgView: UIImageView!
    @IBOutlet weak var phoneNumLabel: UILabel!
    @IBOutlet weak var fingerImg: UIImageView!

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)

    }

    override func viewDidLoad() {
        super.viewDidLoad()

//        setupUI()
        
        TouchIdManager.touchIdWithHand(fallBackTitle: "", succeed: {
            QPCLog("解锁成功")
            SVProgressHUD.showSuccess(withStatus: "指纹密码设置成功")
            UserInfo.saveOpenFingerPrintStyle(isOpen: true)
            self.navigationController?.popViewController(animated: true)
        }) { (error) in
            QPCLog(error.localizedDescription)
        }
        print(TouchIdManager.isSupportTouchID)
    }


    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }

}


//MARK:-  UI
extension FingerprintController{
    
    func setupUI(){
        self.phoneNumLabel.textColor = UIColor.textBlackColor
//        self.changeVeriStyleBtn.setTitleColor(UIColor.textBlueColor, for: .normal)
//        self.switchBtn.setTitleColor(UIColor.textBlueColor, for: .normal)
//        
//        changeVeriStyleBtn.addTarget(self, action: #selector(FingerprintController.changeVeriClick), for: .touchUpInside)
//        switchBtn.addTarget(self, action: #selector(FingerprintController.switchUserClick), for: .touchUpInside)
    }
    
}

//MARK:-  相应事件
extension FingerprintController{
    

    
}

