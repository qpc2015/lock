//
//  LockMembersController.swift
//  MsdGateLock
//
//  Created by ox o on 2017/6/26.
//  Copyright © 2017年 xiaoxiao. All rights reserved.
//

import UIKit


class LockMembersController: UIViewController{
    
    @IBOutlet weak var authUserBtn: UIButton!
    @IBOutlet weak var tempUserBtn: UIButton!
    @IBOutlet weak var authUserLine: UIView!
    @IBOutlet weak var tempUserLine: UIView!
    @IBOutlet weak var line: UIView!
    var vc1 : AuthListController?
    var vc2 : TempListController?
    var lockModel : UserLockListResp?
    var type : Int?
    
    //正在显示的控制器
    var showingVC : UIViewController!
    //用来存放子控制器的view
    lazy var contentView : UIView = {
        let contentView = UIView(frame: CGRect(x: 0, y: 44, width: kScreenWidth, height: kScreenHeight-44))
        return contentView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = lockModel?.remark
        setupUI()
        if type == 1{
            setupNavigationItem()
        }
    }

}

extension LockMembersController{
    
    func setupNavigationItem(){
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named : "more"), style: .plain, target: self, action: #selector(LockMembersController.moreCick))
    }
    
    func setupUI(){
        
        authUserBtn.setTitleColor(UIColor.textBlackColor, for: .normal)
        authUserBtn.setTitleColor(UIColor.textBlueColor, for: .selected)
        tempUserBtn.setTitleColor(UIColor.textBlackColor, for: .normal)
        tempUserBtn.setTitleColor(UIColor.textBlueColor, for: .selected)
        authUserBtn.addTarget(self, action: #selector(LockMembersController.authUserDidClick(btn:)), for: .touchUpInside)
        tempUserBtn.addTarget(self, action: #selector(LockMembersController.tempUserDidClick(btn:)), for: .touchUpInside)
        
        authUserLine.isHidden = true
        tempUserLine.isHidden = true
        authUserLine.backgroundColor = UIColor.textBlueColor
        tempUserLine.backgroundColor = UIColor.textBlueColor
        line.backgroundColor = UIColor.hex(hexString: "f0f0f0")
        
        self.view.addSubview(contentView)
        
        //默认选中第一个
        authUserDidClick(btn: authUserBtn)
    }
    
    func initChileViewControllers(){
        if vc1 == nil{
            vc1 = AuthListController()
            vc1?.lockModel = lockModel
            addChild(vc1!)
        }
        
        if vc2  == nil{
            vc2  = TempListController()
            vc2?.lockModel = lockModel
            vc2?.isOwner = (type == 0)
            addChild(vc2!)
        }
        
        self.showingVC = self.children[0]
        self.contentView.addSubview(self.showingVC.view)
    }
    
    
}


//MARK:-  CLICK
extension LockMembersController{
    
    @objc func moreCick(){
        QPCLog("我一中枪")
        let altsheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
//        let action1 = UIAlertAction(title: "转让管理员", style: .default) { (action) in
//            QPCLog("转让管理员")
//            let transVC = TransferAdminController()
//            transVC.toptipStr = "请选择新的管理员"
//            transVC.currentLockModel = self.lockModel
//           self.navigationController?.pushViewController(transVC , animated: true)
//        }
        let action2 = UIAlertAction(title: "退出成员组", style: .default) { (action) in
             self.exitNumberGroup()
//            let trans2VC = TransferAdminController()
//            trans2VC.toptipStr = "退出成员组前，请委任新的管理员"
//            self.navigationController?.pushViewController(trans2VC, animated: true)
        }
        let action3 = UIAlertAction(title: "取消", style: .cancel) { (action) in
            QPCLog("取消")
        }
//        altsheet.addAction(action1)
        altsheet.addAction(action2)
        altsheet.addAction(action3)
        present(altsheet, animated: true, completion: nil)
    }

    
    @objc func authUserDidClick(btn : UIButton){
        btn.isSelected = !btn.isSelected
        if btn.isSelected {
            tempUserBtn.isSelected = false
            authUserLine.isHidden = false
            tempUserLine.isHidden = true
        }else{
            tempUserBtn.isSelected = true
            authUserLine.isHidden = true
            tempUserLine.isHidden = false
        }
        self.initChileViewControllers()
        self.showingVC.view.removeFromSuperview()
        self.showingVC = self.children[0]
        self.showingVC.view.frame = contentView.bounds
        contentView.addSubview(self.showingVC.view)
        
    }
    
    @objc func tempUserDidClick(btn : UIButton){
        btn.isSelected = !btn.isSelected
        if btn.isSelected {
            authUserBtn.isSelected = false
            tempUserLine.isHidden = false
            authUserLine.isHidden = true
        }else{
            authUserBtn.isSelected = true
            tempUserLine.isHidden = true
            authUserLine.isHidden = false
        }
        self.initChileViewControllers()
        self.showingVC.view.removeFromSuperview()
        self.showingVC = self.children[1]
        self.showingVC.view.frame = contentView.bounds
        contentView.addSubview(self.showingVC.view)
        
    }
    
    func exitNumberGroup(){
        
        let req =  BaseReq<OneParam<String>>()
        req.action = GateLockActions.ACTION_ExistGroup
        req.sessionId = UserInfo.getSessionId()!
        req.data = OneParam.init(p1: (lockModel?.lockId)!)
        
        AjaxUtil<CommonResp>.actionPost(req: req) { [weak self] resp in
            QPCLog(resp)
            self?.navigationController?.popViewController(animated: true)
        }
        
    }
}
