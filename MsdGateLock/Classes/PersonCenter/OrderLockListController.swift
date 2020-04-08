//
//  OrderLockController.swift
//  MsdGateLock
//
//  Created by 覃鹏成 on 2017/7/1.
//  Copyright © 2017年 xiaoxiao. All rights reserved.
//

import UIKit

class OrderLockListController: UITableViewController {

    var  listModel: [OrderLockResp]?
    //报修列表
    var repairList : [FaultListResp]?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor.globalBackColor
        
//        getOrderLockList()
        setupUI()
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

extension OrderLockListController{
    
    func setupUI(){
        self.tableView.rowHeight = 300
        
        if listModel != nil{
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "预约", style: .plain, target: self, action: #selector(OrderLockListController.orderClick))
        }
    }
    
    
//    func getOrderLockList(){
//        
//        let req = BaseReq<CommonReq>()
//        req.action = GateLockActions.ACTION_ReservedList
//        req.sessionId = UserInfo.getSessionId()!
//        req.sign = LockTools.getSignWithStr(str: "oxo")
//        req.data = CommonReq()
//        
//        weak var weakSelf = self
//        AjaxUtil<OrderLockResp>.actionArrPost(req: req) { (resp) in
//            QPCLog(resp.msg)
//            weakSelf?.listModel = resp.data
//            weakSelf?.tableView.reloadData()
//        }
//        
//    }
}

extension OrderLockListController{
    //继续预约
    @objc func orderClick(){
        let orderVC = UIStoryboard(name: "OrderInstallLockController", bundle: nil).instantiateViewController(withIdentifier: "OrderInstallLockController")
        self.navigationController?.pushViewController(orderVC, animated: true)
    }
}

extension OrderLockListController{
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if listModel != nil{
            return (listModel?.count)!
        }else if repairList != nil{
            return (repairList?.count)!
        }
        return 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentfier = "OrderListCell"
        var cell = tableView.dequeueReusableCell(withIdentifier: cellIdentfier) as? OrderListCell
        if cell == nil{
           cell = Bundle.main.loadNibNamed("OrderListCell", owner: nil, options: nil)?.last as? OrderListCell
            if self.listModel != nil{
                cell?.model = self.listModel?[indexPath.row]
            }else if self.repairList != nil{
                cell?.repairModel = self.repairList?[indexPath.row]
            }

            cell?.delegate = self
        }
        return cell!
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


extension OrderLockListController:OrderListCellDelegate{
    
    func orderListCellWithAlterBtnDidClick(btn: UIButton) {
//        QPCLog("点击了需改")
//        let alterVC = UIStoryboard(name: "OrderInstallLockController", bundle: nil).instantiateViewController(withIdentifier: "OrderInstallLockController")
//        navigationController?.pushViewController(alterVC, animated: true)
    }
    
    func orderListCellWithCancleBtnDidClick(btn: UIButton) {
        let alterVC = UIAlertController(title: "温馨提示", message: "您确定要取消订单吗", preferredStyle: .alert)
        let action1 = UIAlertAction(title: "取消", style: .cancel) { (action) in
            
        }
        
        let action2 = UIAlertAction(title: "确定", style: .default) { [weak self](action) in
            guard let weakSelf = self else {return}
            if weakSelf.title == "故障报修"{
                let req = BaseReq<CancelFaultReq>()
                req.sessionId = UserInfo.getSessionId()!
                req.action = GateLockActions.ACTION_UpdateFaultStatus
                req.sign = LockTools.getSignWithStr(str: "oxo")
                req.data = CancelFaultReq.init((weakSelf.repairList?.first?.faultId)!, faultStatus: 1)
                
                AjaxUtil<CommonResp>.actionPost(req: req, backJSON: { (resp) in
                    QPCLog(resp.msg)
                    SVProgressHUD.showSuccess(withStatus: resp.msg)
                    weakSelf.navigationController?.popViewController(animated: true)
                })
            }else{
                let req = BaseReq<CancelOrderReq>()
                req.sessionId = UserInfo.getSessionId()!
                req.action = GateLockActions.ACTION_CancelReserved
                req.sign = LockTools.getSignWithStr(str: "oxo")
                req.data = CancelOrderReq.init((weakSelf.listModel?.first?.reservedId)!)
                
                AjaxUtil<CommonResp>.actionPost(req: req, backJSON: { (resp) in
                    QPCLog(resp.msg)
                    SVProgressHUD.showSuccess(withStatus: resp.msg)
                    weakSelf.navigationController?.popViewController(animated: true)
                })
            }

        }
        alterVC.addAction(action1)
        alterVC.addAction(action2)
        present(alterVC, animated: true, completion: nil)
        
    }
}
