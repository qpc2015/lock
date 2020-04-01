//
//  ReviseLockController.swift
//  MsdGateLock
//
//  Created by ox o on 2017/6/22.
//  Copyright © 2017年 xiaoxiao. All rights reserved.
//

import UIKit

//class ReviseLockController: UITableViewController {
//
//    @IBOutlet weak var alterTF: UITextField!
//    
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        self.title = "修改门锁备注"
//        
//        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "完成", style: .plain, target: self, action: #selector(LockInfoController.flishClick))
//        
//        alterTF.becomeFirstResponder()
//    }
//    
//    
//}
//
//
//
//extension ReviseLockController{
//    
//    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        return 20.0
//    }
//    
//    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
//        return 0.01
//    }
//    
//    func flishClick(){
//        QPCLog(#function)
////        SVProgressHUD.showSuccess(withStatus: "备注修改成功!")
//        if ((alterTF.text?.characters.count)! > 1) && ((alterTF.text?.characters.count)! < 11){
//                navigationController?.popViewController(animated: true)
//        }else{
//            SVProgressHUD.showError(withStatus: "最大长度为10哦")
//        }
//
//    }
//}
