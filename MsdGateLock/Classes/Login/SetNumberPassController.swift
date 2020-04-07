//
//  SetNumberPassController.swift
//  MsdGateLock
//
//  Created by ox o on 2017/6/21.
//  Copyright © 2017年 xiaoxiao. All rights reserved.
// 设置密码类型 与 选择验证方式

import UIKit
import LocalAuthentication

class SetNumberPassController: UIViewController {
    
    var seletedTitleArr : [String] = []
    var tableView : UITableView?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if (self.tableView?.responds(to: #selector(setter: UITableViewCell.separatorInset)))!{
            tableView?.separatorInset = UIEdgeInsets.zero
        }
        
        if (tableView?.responds(to: #selector(setter: UIView.layoutMargins)))!{
            tableView?.layoutMargins = UIEdgeInsets.zero
        }
    }

    func setupUI(){
        tableView = UITableView(frame: kScreenBounds, style: .grouped)
        tableView?.backgroundColor = UIColor.hex(hexString: "f3f3f3")
        tableView?.separatorColor = UIColor.hex(hexString: "f0f0f0")
        tableView?.dataSource = self
        tableView?.delegate = self
        tableView?.rowHeight = 46.0
        self.view.addSubview(tableView!)
        
    }
}

extension SetNumberPassController:UITableViewDataSource,UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if cell.responds(to: #selector(setter: UIView.layoutMargins)){
            cell.layoutMargins = UIEdgeInsets.zero
        }
        if cell.responds(to: #selector(setter: UITableViewCell.separatorInset)){
            cell.separatorInset = UIEdgeInsets.zero
        }
    }

    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "passstyle")
        cell.backgroundColor = UIColor.white
        if indexPath.row == 0{
            cell.textLabel?.text = seletedTitleArr[0]
        }else{
            cell.textLabel?.text = seletedTitleArr[1]
        }
        return cell
    }
    

    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: false)
        if(indexPath.row == 0){
            if self.title=="选择验证方式" {
//                if seletedTitleArr[0] == "数字密码",LoginKeyChainTool.existNumberPassword(){
//                    self.navigationController?.pushViewController(NumberPassVerifController(), animated: true)
//                }else if seletedTitleArr[0] == "手势密码",GesturePasswordModel.existGesturePassword(){
//                    self.navigationController?.pushViewController(GesturePasswordController(), animated: true)
//                }else{
//                    SVProgressHUD.showError(withStatus: "您暂未设置此验证方式")
//                }
            }else if self.title == "设置密码类型"{
//                let setGestVC = SetGestureController()
//                setGestVC.isSetFirstPass = true
//                self.navigationController?.pushViewController(setGestVC, animated: true)
            }

        }else{//指纹
//            if self.title=="选择验证方式" {
//                if TouchIdManager.isSupportTouchID{
//                    navigationController?.pushViewController(FingerprintController(), animated: true)
//                }else{
//                    SVProgressHUD.showError(withStatus: "您手机暂未设置指纹解锁方式")
//                }
//            }else if self.title == "设置密码类型"{
//                SVProgressHUD.showError(withStatus: "请到手机通用设置")
//            }

        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 20
    }
}
