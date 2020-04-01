//
//  PersonTableController.swift
//  MsdGateLock
//
//  Created by ox o on 2017/6/15.
//  Copyright © 2017年 xiaoxiao. All rights reserved.
//

import UIKit

class PersonTableController: UITableViewController {
    
    @IBOutlet weak var iconImgView: UIImageView!
    @IBOutlet weak var nickName: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var lockPass: UILabel!
    @IBOutlet weak var orderLock: UILabel!
//    @IBOutlet weak var useInfo: UILabel!
    @IBOutlet weak var aboutUs: UILabel!
    @IBOutlet weak var loginOut: UILabel!
    var userInfo : UserInfoResp?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "个人中心"
        self.view.backgroundColor = kGlobalBackColor
        setupUI()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        getUserInfo()
    }

    //cell线
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if (self.tableView?.responds(to: #selector(setter: UITableViewCell.separatorInset)))!{
            tableView?.separatorInset = UIEdgeInsets.zero
        }
        
        if (tableView?.responds(to: #selector(setter: UIView.layoutMargins)))!{
            tableView?.layoutMargins = UIEdgeInsets.zero
        }
    }
}

extension PersonTableController{
    
    func setupUI(){
        nickName.textColor = kTextBlockColor
        phoneLabel.textColor = kTextBlockColor
        lockPass.textColor = kTextBlockColor
        orderLock.textColor = kTextBlockColor
//        useInfo.textColor = kTextBlockColor
        aboutUs.textColor = kTextBlockColor
        loginOut.textColor = kTextBlockColor
    }
}

//MARK:- 响应事件
extension PersonTableController{
    
    func gotoProfiel(){
        QPCLog("profile")
        let personVC = UIStoryboard(name: "PersonInfoController", bundle: nil).instantiateViewController(withIdentifier: "PersonInfoController") as! PersonInfoController
        personVC.model = self.userInfo
        navigationController?.pushViewController(personVC, animated: true)
    }
    
    func gotoLockPassword(){
        navigationController?.pushViewController(SetPassWordController(), animated: true)
    }
    
    func gotoOrderLock(){
        
        let req = BaseReq<CommonReq>()
        req.action = GateLockActions.ACTION_ReservedList
        req.sessionId = UserInfo.getSessionId()!
        req.sign = LockTools.getSignWithStr(str: "oxo")
        req.data = CommonReq()
        
        weak var weakSelf = self
        AjaxUtil<OrderLockResp>.actionArrPost(req: req) { (resp) in
            QPCLog(resp.msg)
            if resp.data != nil,(resp.data?.count)! > 0 {
                let orderListVC = OrderLockListController()
                orderListVC.title = "预约门锁"
                orderListVC.listModel = resp.data
                weakSelf?.navigationController?.pushViewController(orderListVC, animated: true)
            }else{
                let orderVC = UIStoryboard(name: "OrderInstallLockController", bundle: nil).instantiateViewController(withIdentifier: "OrderInstallLockController")
                weakSelf?.navigationController?.pushViewController(orderVC, animated: true)
            }
        }
    }
    
    func gotoInstructions(){
        let webVC = LockWebViewContrller()
        webVC.urlStr = GateLockActions.H5_Instructions
        webVC.title = "问题反馈"
        navigationController?.pushViewController(webVC, animated: true)
    }
    
    func gotoAbountMe(){
        let webVC = LockWebViewContrller()
        webVC.urlStr = GateLockActions.H5_Abount
        webVC.title = "关于我们"
        navigationController?.pushViewController(webVC, animated: true)
    }
    
//    func gotoFeedBack(){
//        let webVC = LockWebViewContrller()
//        webVC.urlStr = GateLockActions.H5_FeedBack
//        webVC.title = "使用说明"
//        navigationController?.pushViewController(webVC, animated: true)
//    }
    
    func gotoLogout(){
        QPCLog("Logout")
        let alertVC = UIAlertController(title: "退出登录", message: "亲,您确定退出", preferredStyle: .alert)
        let acSure = UIAlertAction(title: "确定", style: .destructive) { (UIAlertAction) in
            QPCLog("点击了确定")
            
            let req = BaseReq<CommonReq>()
            req.action = GateLockActions.ACTION_Logout
            req.sessionId = UserInfo.getSessionId()!
            
            AjaxUtil<CommonResp>.actionPost(req: req, backJSON: { (resp) in
                QPCLog(resp)
            })
            //清除
            UserInfo.removeUserInfo()
            UIApplication.shared.keyWindow?.rootViewController = LockNavigationController(rootViewController: LoginController())
        
        }
        let acCancle = UIAlertAction(title: "取消", style: .cancel) { (UIAlertAction) in
            QPCLog("点击了取消")
        }
        alertVC.addAction(acSure)
        alertVC.addAction(acCancle)
        self.present(alertVC, animated: true, completion: nil)
    }
}


//MARK:-  请求
extension PersonTableController{

    func getUserInfo(){
        let req =  BaseReq<UserInfoReq>()
        req.action = GateLockActions.ACTION_GetUserInfo
        req.sessionId = UserInfo.getSessionId()!
        req.sign = LockTools.getSignWithStr(str: "oxo")
        req.data = UserInfoReq.init(UserInfo.getPhoneNumber()!)
        weak var weakSelf = self
        QPCLog(NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask,true).last)
        AjaxUtil<UserInfoResp>.actionPost(req: req){
            (resp) in
            QPCLog(resp)
            let imageUrl  = URL(string: (resp.data?.userImage) ?? "")
            weakSelf!.iconImgView.kf.setImage(with: imageUrl, placeholder: UIImage(named : "user2"), options: nil, progressBlock: nil, completionHandler: nil)
            weakSelf!.nickName.text = resp.data?.userName
            weakSelf!.phoneLabel.text = resp.data?.userTel
            
            weakSelf?.userInfo = resp.data
            weakSelf?.tableView.rect(forSection: 0)
        }
    }
}

extension PersonTableController{
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.001;
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        
        if indexPath.section == 0 {
            gotoProfiel()
        }else if indexPath.section == 1{
            if indexPath.row == 0{
                gotoLockPassword()
            }else{
                gotoOrderLock()
            }
        }else if indexPath.section == 2{
            if indexPath.row == 0{
              gotoInstructions()
            }else{
            gotoAbountMe()
            }
        }else{
            gotoLogout()
        }
        
        
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if cell.responds(to: #selector(setter: UIView.layoutMargins)){
            cell.layoutMargins = UIEdgeInsets.zero
        }
        if cell.responds(to: #selector(setter: UITableViewCell.separatorInset)){
            cell.separatorInset = UIEdgeInsets.zero
        }
    }
    
    
}
