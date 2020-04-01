//
//  ResetNewPassController.swift
//  MsdGateLock
//
//  Created by ox o on 2017/6/27.
//  Copyright © 2017年 xiaoxiao. All rights reserved.
//

import UIKit

class ResetNewPassController: UIViewController {

    
    @IBOutlet weak var newLabel: UILabel!
    @IBOutlet weak var okLabel: UILabel!
    @IBOutlet weak var newTF: UITextField!
    @IBOutlet weak var okTF: UITextField!
    var isModify : Bool = false  //是否是修改
    
    @IBOutlet weak var line: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "重置数字密码"
        self.view.backgroundColor = kGlobalBackColor
        setupUI()
        newTF.addTarget(self, action: #selector(ResetNewPassController.newTFValueChange(tf:)), for: .editingChanged)
        okTF.addTarget(self, action: #selector(ResetNewPassController.okTFValueChange(tf:)), for: .editingChanged)
    }
}


extension ResetNewPassController{
    
    func setupUI(){
        self.newTF.becomeFirstResponder()
        newLabel.textColor = kTextBlockColor
        okLabel.textColor = kTextBlockColor
        line.backgroundColor = kRGBColorFromHex(rgbValue: 0xf0f0f0)
    }
    
    @objc func newTFValueChange(tf : UITextField){
        if (tf.text?.count)!  > 4{
            tf.text = (tf.text! as NSString).substring(to: 4)
        }
    }
    
    @objc func okTFValueChange(tf : UITextField){
        if tf.text?.count == 4 {
            if (newTF.text == okTF.text){
                SVProgressHUD.showSuccess(withStatus: "修改密码成功")
                //保存密码
                QPCKeychainTool.saveNumberPassword(okTF.text!)
                self.saveNumPassWithService(str: okTF.text!)
                if isModify{
                   let index = self.navigationController?.viewControllers.index(of: self)
                    self.navigationController?.popToViewController((self.navigationController?.viewControllers[index! - 2])!, animated: true)
                }else{
                  navigationController?.popViewController(animated: true)
                }

            }else{
                SVProgressHUD.showError(withStatus: "请检查密码是否一致")
            }
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
