//
//  NoPermissionController.swift
//  MsdGateLock
//
//  Created by ox o on 2017/6/21.
//  Copyright © 2017年 xiaoxiao. All rights reserved.
//

import UIKit
import CoreBluetooth

class NoPermissionController: UIViewController {
    
    fileprivate let cellID = "nopermiss"
    var tableView : UITableView?
    //系统蓝牙管理对象
    var blueManager = BleManager.shared()

    var stepTitle : String?
    var imgList : [ExplainModel]?

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "OXO智能门锁"
        setupNavigationBar()
        setupUI()
        getExplainList()
        blueManager?.bleManagerDelegate = self
    }
}


extension NoPermissionController{
    
    func setupUI(){
        
        self.view.backgroundColor = UIColor.globalBackColor
        
        let tableFrame = CGRect(x: 0, y: 0, width: kScreenWidth, height: kScreenHeight-65)
        let tableView = UITableView(frame:tableFrame, style: .grouped)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 200
        tableView.separatorStyle = .none
        tableView.register(UINib(nibName: "NoPerAdCell", bundle: nil), forCellReuseIdentifier: cellID)
        self.tableView = tableView
        self.view.addSubview(tableView)
        
        
        let bottomView = UIView()
        bottomView.backgroundColor = UIColor.white
        self.view.addSubview(bottomView)
        bottomView.snp.makeConstraints { (make) in
            make.left.equalTo(0)
            make.right.equalTo(0)
            make.bottom.equalTo(0)
            make.height.equalTo(49)
        }
        
        let topLine = UIView()
        topLine.backgroundColor = UIColor.hex(hexString: "e9e9e9")
        bottomView.addSubview(topLine)
        topLine.snp.makeConstraints { (make) in
            make.left.equalTo(0)
            make.right.equalTo(0)
            make.top.equalTo(0)
            make.height.equalTo(0.5)
        }
        
        
        //添加门锁
        let addLockBtn = UIButton.init(type: .custom)
        addLockBtn.setTitle("添加门锁", for: .normal)
        addLockBtn.titleLabel?.font = kGlobalTextFont
        addLockBtn.setTitleColor(UIColor.textBlueColor, for: .normal)
        addLockBtn.addTarget(self, action: #selector(NoPermissionController.addLockClick), for: .touchUpInside)
        bottomView.addSubview(addLockBtn)
        addLockBtn.snp.makeConstraints { (make) in
            make.left.equalTo(67)
            make.top.equalTo(0)
            make.bottom.equalTo(0)
        }
        
        //预约门锁
        let orderLockBtn = UIButton.init(type: .custom)
        orderLockBtn.setTitle("预约门锁", for: .normal)
        orderLockBtn.titleLabel?.font = kGlobalTextFont
        orderLockBtn.setTitleColor(UIColor.textBlueColor, for: .normal)
        orderLockBtn.addTarget(self, action: #selector(NoPermissionController.orderLockClick), for: .touchUpInside)
        bottomView.addSubview(orderLockBtn)
        orderLockBtn.snp.makeConstraints { (make) in
            make.right.equalTo(-67)
            make.top.equalTo(0)
            make.bottom.equalTo(0)
        }
        
    }
    
    private func setupNavigationBar(){
        
        navigationItem.leftBarButtonItem = UIBarButtonItem.init(image: UIImage(named : "message icon "), style: .plain, target: self, action: #selector(messageCenterClick))
        navigationItem.rightBarButtonItem =  UIBarButtonItem.init(image: UIImage(named : "user"), style: .plain, target: self, action: #selector(personCenterClick))
    }
    
    fileprivate func getExplainList(){
        let req = CommonReq()
        req.sessionId = UserInfo.getSessionId()!
        req.action = GateLockActions.ACTION_NoPerHomeList
        
        AjaxUtil<NoPermissHomeModel>.actionPost(req: req) {[weak self](resp) in
            QPCLog(resp)
            self?.stepTitle = resp.data?.title
            self?.imgList = resp.data?.imgList
            self?.tableView?.reloadData()
        }
    }
}

extension NoPermissionController : BleManagerDelegate{
    
    func discoveredDevicesArray(_ devicesArr: NSMutableArray!, withCBCentralManagerConnectState connectState: String!) {

    }
}


extension NoPermissionController{
    
    @objc func personCenterClick(){
        QPCLog("person")
        let vc = UIStoryboard(name: "Person", bundle: nil).instantiateViewController(withIdentifier: "personCenter")
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func messageCenterClick(){
        QPCLog("message")
        let webVC = LockWebViewContrller()
        webVC.urlStr = GateLockActions.H5_Message
        webVC.title = "消息通知"
        navigationController?.pushViewController(webVC, animated: true)
    }

    @objc func addLockClick(){
        if blueManager!.powerOn {
            let codeVC : QRCodeController = QRCodeController()
            self.navigationController?.pushViewController(codeVC, animated: true)
        }else{
            let alertVC = UIAlertController(title: "温馨提示", message: "设备蓝牙已关闭,是否现在打开", preferredStyle: .alert)
            let acSure = UIAlertAction(title: "打开", style: .default) { (UIAlertAction) in
                QPCLog("打开")
                let url = URL(string: "App-Prefs:root=Bluetooth")
                if UIApplication.shared.canOpenURL(url!){
                    UIApplication.shared.openURL(url!)
                }
            }
            let acCancle = UIAlertAction(title: "取消", style: .default) { (UIAlertAction) in
                QPCLog("点击了取消")
            }
            alertVC.addAction(acCancle)
            alertVC.addAction(acSure)
            self.present(alertVC, animated: true, completion: nil)
         }
        }
    
    @objc fileprivate func orderLockClick(){
        let req = BaseReq<CommonReq>()
        req.action = GateLockActions.ACTION_ReservedList
        req.sessionId = UserInfo.getSessionId()!
        req.sign = LockTools.getSignWithStr(str: "oxo")
        req.data = CommonReq()
        
        AjaxUtil<OrderLockResp>.actionArrPost(req: req) { [weak self](resp) in
            guard let weakSelf = self else{ return }
            if resp.data != nil,(resp.data?.count)! > 0 {
                let orderListVC = OrderLockListController()
                orderListVC.title = "预约门锁"
                orderListVC.listModel = resp.data
                weakSelf.navigationController?.pushViewController(orderListVC, animated: true)
            }else{
                let orderVC = UIStoryboard(name: "OrderInstallLockController", bundle: nil).instantiateViewController(withIdentifier: "OrderInstallLockController")
                weakSelf.navigationController?.pushViewController(orderVC, animated: true)
            }
        }
    }
}

extension NoPermissionController : UITableViewDelegate,UITableViewDataSource{

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.imgList?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headLabel = UILabel(frame: CGRect(x: 0, y: 0, width: kScreenWidth, height: 60))
        headLabel.text = "    \(self.stepTitle ?? "")"
        headLabel.textColor = UIColor.textBlackColor
        headLabel.font = UIFont.boldSystemFont(ofSize: 18)
        return headLabel
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID) as! NoPerAdCell
        cell.backgroundColor = UIColor.globalBackColor
        cell.model = self.imgList?[indexPath.row]
        return cell
    }
}





