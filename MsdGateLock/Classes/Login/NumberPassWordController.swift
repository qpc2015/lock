//
//  NumberPassWordController.swift
//  MsdGateLock
//
//  Created by ox o on 2017/6/22.
//  Copyright © 2017年 xiaoxiao. All rights reserved.
//  设置数字密码

import UIKit

class NumberPassWordController: UITableViewController {

    var isBingLock : String?
    var isHideBack : Bool = false
    var lockInitCode : String?
    
    @IBOutlet weak var firstPassWordTF: UITextField!
    @IBOutlet weak var secondTF: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "设置数字密码"
        self.view.backgroundColor = UIColor.globalBackColor
        setupUI()
    }


    private func setupUI(){
        firstPassWordTF.addTarget(self, action: #selector(firstTFValueChange), for: .editingChanged)
        secondTF.addTarget(self, action: #selector(secondTFValueChange), for: .editingChanged)
        if isHideBack {
            navigationItem.leftBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        }
    }
    
    @objc func firstTFValueChange(){
        if firstPassWordTF.text!.count > 4 {
            let str = (firstPassWordTF.text! as NSString).substring(to: 4)
            firstPassWordTF.text = str
        }
    }
    
    @objc func secondTFValueChange(){
        if (secondTF.text?.count == 4){
            if firstPassWordTF.text == secondTF.text{
                //保存数字密码
                QPCKeychainTool.saveNumberPassword(secondTF.text!)
                self.saveNumPassWithService(str: secondTF.text!)
                if (isBingLock == "绑定门锁") {
                    let vc = UIStoryboard(name: "LockInfoController", bundle: nil).instantiateViewController(withIdentifier: "lockCode") as! LockInfoController
                    vc.initCode = lockInitCode
                    navigationController?.pushViewController(vc, animated: true)
                }else{
                    navigationController?.popViewController(animated: true)
                }
            }else{
                SVProgressHUD.showError(withStatus: "请输入正确的验证码")
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



extension NumberPassWordController{
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 20.0
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == 0 {
              return 0.001
        }
        return 10.0
    }
    
}
