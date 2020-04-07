//
//  PassManageController.swift
//  MsdGateLock
//
//  Created by ox o on 2017/7/3.
//  Copyright © 2017年 xiaoxiao. All rights reserved.
//  密码管理

import UIKit

class PassManageController: UITableViewController {

    @IBOutlet weak var alterPass: UILabel!
    @IBOutlet weak var resetPass: UILabel!
    @IBOutlet weak var removePass: UILabel!
    @IBOutlet weak var defaltPass: UILabel!
    @IBOutlet weak var seletedImg: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor.globalBackColor
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

    }
}



extension PassManageController{
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        QPCLog(indexPath.row)
        tableView.deselectRow(at: indexPath, animated: true)
        
//        if title == "手势密码" {
//            
//            if indexPath.section == 1 {
//                seletedImg.isHidden = !seletedImg.isHidden
//
//            }else{
//                if indexPath.row == 0 {
//                    navigationController?.pushViewController(ModifiGestureController(), animated: true)
//                    
//                }else if indexPath.row == 1{
//                    let numVC = ResetNumberController()
//                    numVC.title = "重置手势密码"
//                    navigationController?.pushViewController(numVC, animated: true)
//                }
////                else{
////                    //删除密码
////                    if LoginKeyChainTool.existNumberPassword() {
////                        let numVC = ResetNumberController()
////                        numVC.title = "删除手势密码"
////                        navigationController?.pushViewController(numVC, animated: true)
////                    }else{
////                        SVProgressHUD.showError(withStatus: "密码还是要有的,不能再删了!")
////                    }
////
////                }
//            }
//        }else if title == "数字密码"{
            //数字密码修改/重置/删除

            if indexPath.row == 0 {
                navigationController?.pushViewController(ModifyNumPassViewController(), animated: true)
            }else if indexPath.row == 1{
                let numVC = ResetNumberController()
                numVC.title = "重置数字密码"
                navigationController?.pushViewController(numVC, animated: true)
            }
//                else{
//                    if GesturePasswordModel.existGesturePassword(){
//                        //删除密码
//                        let numVC = ResetNumberController()
//                        numVC.title = "删除数字密码"
//                        navigationController?.pushViewController(numVC, animated: true)
//                    }else{
//                        SVProgressHUD.showError(withStatus: "密码还是要有的,不能再删了!")  
//                    }
//
//                }
//        }else{
//            //指纹密码
//            if indexPath.section == 1 {
//                seletedImg.isHidden = !seletedImg.isHidden
//            }else{
//                
//            }
//        }
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if cell.responds(to: #selector(setter: UIView.layoutMargins)){
            cell.layoutMargins = UIEdgeInsets.zero
        }
        if cell.responds(to: #selector(setter: UITableViewCell.separatorInset)){
            cell.separatorInset = UIEdgeInsets.zero
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 19.0
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 1.0
    }
    
}



