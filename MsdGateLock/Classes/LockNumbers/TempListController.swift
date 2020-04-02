//
//  TempListController.swift
//  MsdGateLock
//
//  Created by ox o on 2017/6/28.
//  Copyright © 2017年 xiaoxiao. All rights reserved.
//

import UIKit

class TempListController: UIViewController {
    
    var totalTempLabel : UILabel!
    var tableView : UITableView!
    var isOwner : Bool!
    var lockModel : UserLockListResp? //锁信息
    var userInfoArr : [AuthInfoListResp]?
    var count : Int = 0

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = kGlobalBackColor
        setupUI()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        getTempListData()
    }
    
    func setupUI(){
        
        totalTempLabel = UILabel(frame: CGRect(x: 0, y: 0, width: kScreenWidth, height: 33))
        totalTempLabel.text = "    临时用户 (0位)"
        totalTempLabel.backgroundColor = UIColor.white
        totalTempLabel.textColor = kRGBColorFromHex(rgbValue: 0x858585)
        totalTempLabel.font = UIFont.systemFont(ofSize: 12)
        view.addSubview(totalTempLabel)
        
//        let line = UIView(frame: CGRect(x: 0, y: 34, width: kScreenWidth, height: 1))
//        line.backgroundColor = kRGBColorFromHex(rgbValue: 0xf0f0f0)
//        view.addSubview(line)
        
//        let tableHeight : CGFloat = CGFloat(68 * count)
        let tableFrame = CGRect(x: 0, y: 34, width: kScreenWidth, height: kScreenHeight-77)
        tableView = UITableView(frame: tableFrame, style: .plain)
        tableView.bounces = false
        tableView.backgroundColor = UIColor.white
        tableView.rowHeight = 68
        tableView.delegate = self
        tableView.dataSource = self
        view.addSubview(tableView)
        
        tableView.register(UINib.init(nibName: "TempListCell", bundle: nil), forCellReuseIdentifier: "TempListCell")
        
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: kScreenWidth, height: 50))
        tableView.tableFooterView = footerView
        
        if isOwner {
            let addAuthNumberBtn =  UIButton(type: .custom)
            addAuthNumberBtn.titleLabel?.font = UIFont.systemFont(ofSize: 16)
            addAuthNumberBtn.setTitle("添加临时成员", for: .normal)
            addAuthNumberBtn.backgroundColor = kTextBlueColor
            addAuthNumberBtn.layer.cornerRadius = 4.0
            addAuthNumberBtn.layer.masksToBounds = true
            addAuthNumberBtn.addTarget(self, action: #selector(TempListController.addTemporaryNumbersClick(_:)), for: .touchUpInside)
            footerView.addSubview(addAuthNumberBtn)
            addAuthNumberBtn.snp.makeConstraints { (make) in
                make.centerX.equalTo(footerView)
                make.top.equalTo(footerView)
                make.width.equalTo(184)
                make.height.equalTo(50)
            }
        }
    }

    @objc func addTemporaryNumbersClick(_ btn: UIButton) {
        
        let addTemporaryVC = UIStoryboard(name: "AddTemporaryController", bundle: nil).instantiateViewController(withIdentifier: "AddTemporaryController") as! AddTemporaryController
        addTemporaryVC.lockModel = lockModel
        navigationController?.pushViewController(addTemporaryVC, animated: true)
        
    }
    
    func tempUserClick(_ index: Int) {
        let tempVC = UIStoryboard(name: "TempUserDetailController", bundle: nil).instantiateViewController(withIdentifier: "TempUserDetailController") as! TempUserDetailController
        tempVC.userModel = userInfoArr?[index]
        tempVC.lockModel = lockModel
        navigationController?.pushViewController(tempVC, animated: true)
    }
    
    func getTempListData(){
        let req = BaseReq<AuthInfoListReq>()
        req.action = GateLockActions.ACTION_UserRoleInfo
        req.sign = LockTools.getSignWithStr(str: "oxo")
        req.sessionId = UserInfo.getSessionId() ?? ""
        req.data = AuthInfoListReq(UserInfo.getUserId() ?? 0, lockId: lockModel?.lockId ?? "", roleType: 2)
        
        weak var weakSelf = self
        AjaxUtil<AuthInfoListResp>.actionArrPost(req: req) { (resp) in
            QPCLog(resp.data)
            weakSelf?.userInfoArr = resp.data
            weakSelf?.totalTempLabel.text = "    临时用户 (\(weakSelf?.userInfoArr?.count ?? 0)位)"
            weakSelf?.tableView.reloadData()
        }
    }
}

extension TempListController: UITableViewDelegate,UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userInfoArr?.count ?? 0
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        
        tempUserClick(indexPath.row)
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell : TempListCell = tableView.dequeueReusableCell(withIdentifier: "TempListCell") as! TempListCell
        cell.selectionStyle = .none
        cell.model = self.userInfoArr?[indexPath.row]

        return cell
    }
    
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        if cell.responds(to: #selector(setter: UIView.layoutMargins)){
            cell.layoutMargins = UIEdgeInsets.zero
        }
        if cell.responds(to: #selector(setter: UITableViewCell.separatorInset)){
            cell.separatorInset = UIEdgeInsets.zero
        }
    }
    
}
