//
//  PopoverViewController.swift
//  WeiBo
//
//  Created by 覃鹏成 on 2017/6/9.
//  Copyright © 2017年 qinpengcheng. All rights reserved.
//

import UIKit

protocol PopoverViewControllerDelegate : NSObjectProtocol{
    func popViewDidSeletedIndex(index : Int)
}


class PopoverViewController: UIViewController {
    
    var listArr : [UserLockListResp]?
    
    weak var delegate : PopoverViewControllerDelegate?

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        tableView.rowHeight = 44.0
    }

}

//MARK:- tableview
extension PopoverViewController: UITableViewDataSource,UITableViewDelegate{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (listArr?.count) ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellId = "lockStyleCell"
        var cell = tableView.dequeueReusableCell(withIdentifier: cellId) as? LockStyleCell
        if cell == nil {
            cell = Bundle.main.loadNibNamed("LockStyleCell", owner: nil, options: nil)?.last as? UITableViewCell as? LockStyleCell
        }
        cell?.titleModel = listArr?[indexPath.row]
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        QPCLog(indexPath.row)
        delegate?.popViewDidSeletedIndex(index: indexPath.row)
    }
    
    
}
