//
//  SetNickNameController.swift
//  MsdGateLock
//
//  Created by 覃鹏成 on 2017/7/1.
//  Copyright © 2017年 xiaoxiao. All rights reserved.
//

import UIKit

protocol SetNickNameControllerDelegate : NSObjectProtocol{
    func resetNickNameDidFinished(newStr : String)
}

class SetNickNameController: UIViewController {
    
    var nickNameStr : String?
    var textfield : UITextField?
    weak var delegate : SetNickNameControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "设置昵称"
        self.view.backgroundColor = kGlobalBackColor
        
        setupUI()
    }

}


extension SetNickNameController{
    
    
    func setupUI(){
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "完成", style: .plain, target: self, action: #selector(SetNickNameController.finishedClick))
        
        let backView = UIView()
        backView.backgroundColor = UIColor.white
        view.addSubview(backView)
        backView.snp.makeConstraints { (make) in
            make.left.equalTo(view)
            make.right.equalTo(view)
            make.top.equalTo(20)
            make.height.equalTo(46)
        }
        

        
        let tf = UITextField()
        tf.text = self.nickNameStr
        tf.placeholder = "请输入您的昵称"
        tf.font = kGlobalTextFont
        tf.becomeFirstResponder()
        tf.textColor = kTextGrayColor
        backView.addSubview(tf)
        self.textfield = tf
        tf.snp.makeConstraints { (make) in
            make.left.equalTo(14)
            make.width.equalTo(200)
            make.centerY.equalTo(backView)
        }
        
    }
    
}



extension SetNickNameController{
    
    @objc func finishedClick(){
        if (self.textfield?.text?.count)! > 0{
            
            if (self.textfield?.text?.count)! <= 10{
              resetNickName()
            }else{
                SVProgressHUD.showError(withStatus: "请输入小于10位字符的昵称")
            }
        }
        
    }
    
    private func resetNickName(){
        let req = BaseReq<NickNameReq>()
        req.action = GateLockActions.ACTION_UpdateUser
        req.sessionId = UserInfo.getSessionId()!
        req.sign = LockTools.getSignWithStr(str: "")
        req.data = NickNameReq(UserInfo.getUserId()!, (self.textfield?.text)!)
        
        AjaxUtil<CommonResp>.actionPost(req: req) {[weak self] (resp) in
            QPCLog(resp.msg)
            SVProgressHUD.showSuccess(withStatus: resp.msg)
            if self?.delegate != nil {
                self?.delegate?.resetNickNameDidFinished(newStr: (self?.textfield?.text)!)
            }
            self?.navigationController?.popViewController(animated: true)
        }
        
    }

}
