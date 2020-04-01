//
//  OpenListCell.swift
//  MsdGateLock
//
//  Created by ox o on 2017/6/30.
//  Copyright © 2017年 xiaoxiao. All rights reserved.
// 开门记录

import UIKit

class OpenListCell: UITableViewCell {

    @IBOutlet weak var openStyle: UILabel!
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    
    var openModel : OpenLockList? {
        didSet{
            if openModel?.logStatus == 1{
                openStyle.text = "手机开锁"
            }
            time.text = LockTools.stringToTimeStamp(stringTime: (openModel?.logTime)!)
            nameLabel.text = openModel?.memberName
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        openStyle.textColor = kTextGrayColor
        time.textColor = kTextGrayColor
        nameLabel.textColor = kTextGrayColor
    }

    override func setSelected(_ selected: Bool, animated: Bool) {

        // Configure the view for the selected state
    }
    
}
