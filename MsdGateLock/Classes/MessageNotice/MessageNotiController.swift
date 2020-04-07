//
//  MessageNotiController.swift
//  MsdGateLock
//
//  Created by ox o on 2017/7/4.
//  Copyright © 2017年 xiaoxiao. All rights reserved.
//

import UIKit

class MessageNotiController: UITableViewController {

    
    let cellID  = "messageCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "消息通知"
        self.view.backgroundColor = UIColor.globalBackColor
        tableView.rowHeight = 74
        tableView.register(UINib(nibName: "MessageCell", bundle: nil), forCellReuseIdentifier: cellID)
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


extension MessageNotiController{
    
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID)
        return cell!
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 160
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.001
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: kScreenWidth, height: 160))
        view.backgroundColor = UIColor.globalBackColor
        
        let head = UIView(frame: CGRect(x: 0, y: 0, width: kScreenWidth, height: 140))
        head.backgroundColor = UIColor.white
        view.addSubview(head)
        
        return view
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

