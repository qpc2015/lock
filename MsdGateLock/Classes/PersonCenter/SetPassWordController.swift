//
//  SetPassWordController.swift
//  MsdGateLock
//
//  Created by ox o on 2017/7/3.
//  Copyright © 2017年 xiaoxiao. All rights reserved.
//

import UIKit

class SetPassWordController: UIViewController {

    var tableView : UITableView!
    lazy var titleArr : [String] = ["数字密码","指纹密码"]
    var switchView = UISwitch()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "设置密码"
        self.view.backgroundColor = UIColor.globalBackColor
        setupUI()
        switchView.addTarget(self, action: #selector(SetPassWordController.switchDidClick), for: .valueChanged)
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
}

//MARK:- UI
extension SetPassWordController{
    
    func setupUI(){
        tableView = UITableView(frame: CGRect(x: 0, y: 20, width: kScreenWidth, height: kScreenHeight), style: .plain)
        tableView.isScrollEnabled = false
        tableView.backgroundColor = UIColor.globalBackColor
        tableView.rowHeight = 46
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        view.addSubview(tableView)
    }
    
    @objc func switchDidClick(){
        if switchView.isOn{
            if TouchIdManager.isSupportTouchID {
                navigationController?.pushViewController(FingerprintController(), animated: true)
            }else{
                let alterVC = UIAlertController(title: "温馨提示", message: "清先开启操作系统的指纹认证功能", preferredStyle: .alert)
                let alertAc = UIAlertAction(title: "确认", style: .cancel, handler: nil)
                alterVC.addAction(alertAc)
                self.present(alterVC, animated: true, completion: nil)
                switchView.isOn = false
            }
        }else{
            UserInfo.saveOpenFingerPrintStyle(isOpen: false)
        }
    }
}


//MARK:- DELEGATE
extension SetPassWordController: UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellId  = "SetPassWordCell"
        var cell = tableView.dequeueReusableCell(withIdentifier: cellId)
        if cell == nil {
            cell = UITableViewCell(style: .value1, reuseIdentifier: cellId)
            cell?.textLabel?.textColor = UIColor.textBlackColor
            cell?.textLabel?.font = kGlobalTextFont
        }
        cell?.textLabel?.text = titleArr[indexPath.row]
        if indexPath.row == 1{
            switchView.onTintColor = UIColor.textBlueColor
            cell?.accessoryView = switchView
        }else{
            cell?.accessoryType = .disclosureIndicator
        }
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        if indexPath.row == 0 {
            //数字密码
            if QPCKeychainTool.existNumberPassword(){
                let vc = UIStoryboard(name: "PassManageController", bundle: nil).instantiateViewController(withIdentifier: "PassManageController")
                vc.title = "数字密码"
                navigationController?.pushViewController(vc, animated: true)
            }else{
                //首次设置数字密码
                navigationController?.pushViewController(ResetNewPassController(), animated: true)
            }
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
