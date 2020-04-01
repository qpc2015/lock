//
//  ReviseRemarkController.swift
//  MsdGateLock
//
//  Created by ox o on 2017/6/26.
//  Copyright © 2017年 xiaoxiao. All rights reserved.
//

import UIKit

class ReviseRemarkController: UITableViewController {
    
    var userID : Int!
    var oldValue : String?
    var lockID : String?
    @IBOutlet weak var remark: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = kGlobalBackColor
        self.title = "修改备注"
        self.remark.text = oldValue
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "确认", style: .plain, target: self, action: #selector(ReviseRemarkController.okClick))
    }
}


extension ReviseRemarkController{
    
    @objc func okClick(){
        QPCLog("确认")
        if (remark.text?.count)! > 0 {
            let req = BaseReq<ThreeParam<String,Int,String>>()
            req.action = GateLockActions.ACTION_UpdateUserRemark
            req.sessionId = UserInfo.getSessionId()!
            req.sign = LockTools.getSignWithStr(str: "oxo")
            req.data = ThreeParam.init(p1: remark.text!, p2: userID, p3:lockID ?? "")
            
            weak var weakSelf = self
            AjaxUtil<CommonResp>.actionPost(req: req, backJSON: { (resp) in
                QPCLog(resp)
                weakSelf?.navigationController?.popViewController(animated: true)
            })
            
        }else{
            SVProgressHUD.showError(withStatus: "请填写正确备注")
        }

        
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 20.0
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.001
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
}
