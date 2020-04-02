//
//  AuthUserLockManageController.swift
//  MsdGateLock
//
//  Created by ox o on 2017/7/3.
//  Copyright © 2017年 xiaoxiao. All rights reserved.
//

import UIKit

class AuthUserLockManageController: UIViewController {
    
    var tableView : UITableView!
    var currentLockID : String?
    var tipArr : [String?] = ["门锁备注","报修门锁"]
    var detailArr : [String?] = ["家","待确认"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "门锁管理"
        self.view.backgroundColor = kGlobalBackColor
        
        setupUI()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getLockInfo()
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


extension AuthUserLockManageController{
    
    
    func setupUI(){
        
        tableView = UITableView(frame: CGRect(x: 0, y: 20, width: kScreenWidth, height: kScreenHeight), style: .plain)
        tableView.isScrollEnabled = false
        tableView.backgroundColor = kGlobalBackColor
        tableView.rowHeight = 46
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        view.addSubview(tableView)
    }
    
    func getLockInfo(){
        let req =  BaseReq<LockSetInfoReq>()
        req.action = GateLockActions.ACTION_GetLockInfo
        req.sessionId = UserInfo.getSessionId() ?? ""
        req.data = LockSetInfoReq(currentLockID ?? "")
        
        weak var weakSelf = self
        AjaxUtil<LockSetInfoResp>.actionPost(req: req, backJSON: { (resp) in
            weakSelf?.detailArr[0]  = resp.data?.remark ?? ""
            weakSelf?.tableView.reloadData()
        })
    }
}

extension AuthUserLockManageController: UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellId  = "authUserLockCell"
        var cell = tableView.dequeueReusableCell(withIdentifier: cellId)
        if cell == nil {
            cell = UITableViewCell(style: .value1, reuseIdentifier: cellId)
            cell?.textLabel?.textColor = kTextBlockColor
            cell?.textLabel?.font = kGlobalTextFont
            cell?.detailTextLabel?.font = kGlobalTextFont
            cell?.detailTextLabel?.textColor = kTextGrayColor
            cell?.accessoryType = .disclosureIndicator
        }
        
        cell?.textLabel?.text = self.tipArr[indexPath.row]
        cell?.detailTextLabel?.text = self.detailArr[indexPath.row]
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.row == 0 {
            let lockremarkVC = LockRemarkController()
            lockremarkVC.oldValue = detailArr[0]
            lockremarkVC.cureentLockId = currentLockID
            navigationController?.pushViewController(lockremarkVC, animated: true)
        }else{
            let repairVC = UIStoryboard(name: "TroubleRepairController", bundle: nil).instantiateViewController(withIdentifier: "TroubleRepairController")
            navigationController?.pushViewController(repairVC, animated: true)
        }
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
