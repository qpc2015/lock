//
//  AuthUserOpenListController.swift
//  MsdGateLock
//
//  Created by ox o on 2017/6/30.
//  Copyright © 2017年 xiaoxiao. All rights reserved.
//      授权用户开门记录

import UIKit

class AuthUserOpenListController: UIViewController {

    var tableView : UITableView!
    var headView : UIView!
    var isHiddenSub : Bool = false
    var currentLockID : String? //当前门锁id
    var lockTitle : String?
    var openLockModel : [OpenLockList]?
    var listIndex : Int = 1
    var subTitleStr  : String?
    //刷新
    let header = MJRefreshNormalHeader()
    var footer : MJRefreshAutoNormalFooter!
    var placeHolderView : UIView?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "开门记录"
        self.view.backgroundColor = UIColor.globalBackColor
    
        setupUI()  //底部视图
        setupPlaceHolderUI()   //占位视图
        header.beginRefreshing()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.openLockModel?.removeAll()
    }
}


extension AuthUserOpenListController{
    
    func setupUI(){
        
        headView = UIView(frame: CGRect(x: 0, y: 0, width: kScreenWidth, height: 59))
        headView.backgroundColor = UIColor.globalBackColor
        self.view.addSubview(headView)
        
        let homeLabel = UILabel()
        homeLabel.textColor = UIColor.textBlueColor
        homeLabel.text = lockTitle ?? "家"
        homeLabel.font = UIFont.systemFont(ofSize: 30)
        headView.addSubview(homeLabel)
        homeLabel.snp.makeConstraints { (make) in
            make.left.equalTo(14)
            make.top.equalTo(9)
        }
        
        let listLabel = UILabel()
        listLabel.textColor = UIColor.textBlackColor
        listLabel.text = "\(subTitleStr ?? "")的记录"
        listLabel.font = UIFont.systemFont(ofSize: 14)
        listLabel.isHidden = isHiddenSub
        headView.addSubview(listLabel)
        listLabel.snp.makeConstraints { (make) in
            make.right.equalTo(-12)
            make.bottom.equalTo(homeLabel)
        }
        
        let line = UIView()
        line.backgroundColor = UIColor.hex(hexString: "f0f0f0")
        headView.addSubview(line)
        line.snp.makeConstraints { (make) in
            make.left.equalTo(0)
            make.right.equalTo(0)
            make.height.equalTo(1)
            make.bottom.equalTo(0)
        }
        
        tableView = UITableView()
        tableView.rowHeight = 30
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
        self.view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.left.equalTo(0)
            make.right.equalTo(0)
            make.top.equalTo(0)
            make.bottom.equalTo(0)
        }
        
        tableView.tableHeaderView = headView
        
        header.setRefreshingTarget(self, refreshingAction: #selector(AuthUserOpenListController.reloadNewData))
        self.tableView.mj_header = header
        
        footer = MJRefreshAutoNormalFooter(refreshingTarget: self, refreshingAction: #selector(AuthUserOpenListController.reloadMoreData))
        self.tableView.mj_footer = footer
    }
    
    
    func setupPlaceHolderUI(){
        
        placeHolderView = UIView()
        placeHolderView?.backgroundColor = UIColor.globalBackColor
        self.view.addSubview(placeHolderView!)
        placeHolderView?.snp.makeConstraints { (make) in
            make.top.equalTo(0)
            make.left.equalTo(0)
            make.right.equalTo(0)
            make.bottom.equalTo(0)
        }
        
        let placeImgView = UIImageView(image: UIImage.init(named: "placeholderPic"))
        placeHolderView?.addSubview(placeImgView)
        placeImgView.snp.makeConstraints { (make) in
            make.centerX.equalTo(self.view)
            make.top.equalTo(80*kHeight6Scale)
        }
        
        let tipLabel = UILabel()
        tipLabel.text = "还未任何记录"
        tipLabel.textColor =  UIColor.hex(hexString: "999999")
        tipLabel.font = kGlobalTextFont
        placeHolderView?.addSubview(tipLabel)
        tipLabel.snp.makeConstraints { (make) in
            make.centerX.equalTo(self.view)
            make.top.equalTo(placeImgView.snp.bottom).offset(10*kHeight6Scale)
        }
    }
}

extension AuthUserOpenListController:UITableViewDelegate,UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        guard self.openLockModel != nil else {
            self.placeHolderView?.isHidden = false
            return 0
        }
        if (self.openLockModel?.count)! > 0{
            self.placeHolderView?.isHidden = true
        }
        return (self.openLockModel?.count)!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentfier = "OpenListCell"
        var cell = tableView.dequeueReusableCell(withIdentifier: cellIdentfier) as? OpenListCell
        if cell == nil{
            cell = Bundle.main.loadNibNamed("OpenListCell", owner: nil, options: nil)?.last as? UITableViewCell as? OpenListCell
        }
        cell?.openModel = self.openLockModel?[indexPath.row]
        return cell!
    }
}

//MARK:-  http
extension AuthUserOpenListController{
    //下拉刷新最新内容
    @objc func reloadNewData(){
        
        if isHiddenSub {
            let req =  BaseReq<LockAllLogReq>()
            req.action = GateLockActions.ACTION_GetLockLog
            req.sessionId = UserInfo.getSessionId() ?? ""
            //        let userID = UserDefaults.standard.object(forKey: UserInfo.userId) as? Int
            let lockId = currentLockID  ?? ""
            let limit = 20
            req.data = LockAllLogReq.init(lockId, start: 1, limit: limit)
            
            AjaxUtil<OpenLockList>.actionArrPost(req: req, backArrJSON: { (resp) in
                QPCLog(resp)
                if let lockModel = resp.data {
                    self.openLockModel = lockModel
                }
                self.tableView.reloadData()
                
                self.tableView.mj_header?.endRefreshing()
            })
        }else{
            let req =  BaseReq<LockInfoReq>()
            req.action = GateLockActions.ACTION_GetLockOneLog
            req.sessionId = UserInfo.getSessionId()!
            let userID = UserInfo.getUserId()
            let lockId = currentLockID
            let limit = 20
            req.data = LockInfoReq.init(userID!, lockId: lockId!, start: 1, limit: limit)
            
            weak var weakSelf = self
            AjaxUtil<OpenLockList>.actionArrPost(req: req, backArrJSON: { (resp) in
                
                QPCLog(resp)
                if let lockModel = resp.data {
                    weakSelf?.openLockModel = lockModel
                }
                weakSelf?.tableView.reloadData()
                
                self.tableView.mj_header?.endRefreshing()
            })
            
            
        }
    }
    
    @objc func reloadMoreData(){
        
        if isHiddenSub{
            listIndex += 1
            let req =  BaseReq<LockAllLogReq>()
            req.action = GateLockActions.ACTION_GetLockLog
            req.sessionId = UserInfo.getSessionId()!
            //        let userID = UserDefaults.standard.object(forKey: UserInfo.userId) as? Int
            let lockId = currentLockID
            let start = listIndex
            let limit = 20
            req.data = LockAllLogReq.init(lockId!, start: start, limit: limit)
            
            weak var weakSelf = self
            AjaxUtil<OpenLockList>.actionArrPost(req: req, backArrJSON: { (resp) in
                QPCLog(resp)
                if let lockModel = resp.data {
                    weakSelf?.openLockModel = (weakSelf?.openLockModel)! + lockModel
                }
                weakSelf?.tableView.reloadData()
                
                self.tableView.mj_footer?.endRefreshing()
            })
        }else{
            listIndex += 1
            let req =  BaseReq<LockInfoReq>()
            req.action = GateLockActions.ACTION_GetLockOneLog
            req.sessionId = UserInfo.getSessionId()!
            let userID = UserInfo.getUserId()
            let lockId = currentLockID
            let start = listIndex
            let limit = 20
            req.data = LockInfoReq.init(userID!, lockId: lockId!, start: start, limit: limit)
            
            weak var weakSelf = self
            AjaxUtil<OpenLockList>.actionArrPost(req: req, backArrJSON: { (resp) in
                
                QPCLog(resp)
                if let lockModel = resp.data {
                    weakSelf?.openLockModel = (weakSelf?.openLockModel)! + lockModel
                }
                weakSelf?.tableView.reloadData()
                
                self.tableView.mj_footer?.endRefreshing()
            })
            
            
        }

        

    }
    
    

    
}
