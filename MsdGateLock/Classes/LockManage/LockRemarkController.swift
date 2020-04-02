//
//  LockRemarkController.swift
//  MsdGateLock
//
//  Created by ox o on 2017/6/30.
//  Copyright © 2017年 xiaoxiao. All rights reserved.
//

import UIKit

class LockRemarkController: UIViewController {

    var cureentLockId : String?
    var remarkTF : UITextField!
    var oldValue : String!
    var isTemp : Bool = false  //判断是否来自临时用户
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "修改门锁备注"
        self.view.backgroundColor = kGlobalBackColor
        setupUI()
    }
}

extension LockRemarkController{
    
    func setupUI(){
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "完成", style: .plain, target: self, action: #selector(LockRemarkController.finishedClick))
        
        let backView = UIView()
        backView.backgroundColor = UIColor.white
        view.addSubview(backView)
        backView.snp.makeConstraints { (make) in
            make.left.equalTo(view)
            make.right.equalTo(view)
            make.top.equalTo(20)
            make.height.equalTo(46)
        }
        
        let label = UILabel()
        label.text = "门锁备注"
        label.textColor = kTextBlockColor
        label.font = kGlobalTextFont
        backView.addSubview(label)
        label.snp.makeConstraints { (make) in
            make.left.equalTo(14)
            make.centerY.equalTo(backView)
            make.width.equalTo(64)
        }
        
        let tf = UITextField()
        tf.placeholder = "输入您的门锁备注"
        tf.font = kGlobalTextFont
        tf.textColor = kTextGrayColor
        tf.text = oldValue
        backView.addSubview(tf)
        remarkTF = tf
        tf.snp.makeConstraints { (make) in
            make.left.equalTo(label.snp.right).offset(26)
            make.right.top.height.equalTo(backView)
        }
    }
}


extension LockRemarkController{
    
    @objc func finishedClick(){
        
        if  let remark = self.remarkTF.text,remark.count > 0{
            if isTemp{//临时用户修改信息
                let req = BaseReq<TwoParam<String,String>>()
                req.action = GateLockActions.ACTION_UpdateLockRemark
                req.sessionId = UserInfo.getSessionId()!
                req.sign = LockTools.getSignWithStr(str: "oxo")
                req.data = TwoParam.init(p1: cureentLockId ?? "", p2: remark)
                weak var weakSelf = self
                AjaxUtil<CommonResp>.actionPost(req: req) { (resp) in
                    SVProgressHUD.showSuccess(withStatus: resp.msg)
                    weakSelf?.navigationController?.popViewController(animated: true)
                }
            }else{
                let req = BaseReq<UpdateLockNickReq>()
                req.action = GateLockActions.ACTION_UpdateLock
                req.sessionId = UserInfo.getSessionId() ?? ""
                req.sign = LockTools.getSignWithStr(str: "oxo")
                req.data = UpdateLockNickReq.init(cureentLockId ?? "", remark: remark)
                
                weak var weakSelf = self
                AjaxUtil<CommonResp>.actionPost(req: req) { (resp) in
                    SVProgressHUD.showSuccess(withStatus: resp.msg)
                    weakSelf?.navigationController?.popViewController(animated: true)
                }
            }
        }else{
            SVProgressHUD.showError(withStatus: "备注内容为空")
        }
    }
    
}
