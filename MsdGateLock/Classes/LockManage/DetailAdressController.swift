//
//  DetailAdressController.swift
//  MsdGateLock
//
//  Created by ox o on 2017/6/30.
//  Copyright © 2017年 xiaoxiao. All rights reserved.
//

import UIKit

class DetailAdressController: UIViewController {

    var cureentLockId : String!
    var adressTF : UITextField!
    var oldValue : String!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "修改详细地址"
        self.view.backgroundColor = UIColor.globalBackColor
        setupUI()
    }
}

extension DetailAdressController{
    
    func setupUI(){
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "完成", style: .plain, target: self, action: #selector(DetailAdressController.finishedClick))
        
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
        label.text = "详细地址"
        label.textColor = UIColor.textBlackColor
        label.font = kGlobalTextFont
        backView.addSubview(label)
        label.snp.makeConstraints { (make) in
            make.left.equalTo(14)
            make.centerY.equalTo(backView)
            make.width.equalTo(64)
        }
        
        let tf = UITextField()
        tf.placeholder = "请输入您的详细地址"
        tf.font = kGlobalTextFont
        tf.textColor = UIColor.textGrayColor
        tf.text = oldValue
        backView.addSubview(tf)
        self.adressTF = tf
        tf.snp.makeConstraints { (make) in
            make.left.equalTo(label.snp.right).offset(26)
            make.right.top.height.equalTo(backView)
        }
    }
}



extension DetailAdressController{
    
    @objc func finishedClick(){
        if (self.adressTF.text?.count)! > 0 ,self.adressTF.text != oldValue{
            let req = BaseReq<UpdateLockAdressReq>()
            req.action = GateLockActions.ACTION_UpdateLock
            req.sessionId = UserInfo.getSessionId()!
            req.sign = LockTools.getSignWithStr(str: "oxo")
            req.data = UpdateLockAdressReq.init(cureentLockId,address : adressTF.text!)
            
            weak var weakSelf = self
            AjaxUtil<CommonResp>.actionPost(req: req) { (resp) in
                SVProgressHUD.setDefaultMaskType(.none)
                SVProgressHUD.showSuccess(withStatus: resp.msg)
                weakSelf?.navigationController?.popViewController(animated: true)
            }
        }
    }
}
