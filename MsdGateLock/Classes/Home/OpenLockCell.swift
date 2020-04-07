//
//  OpenLockCell.swift
//  MsdGateLock
//
//  Created by ox o on 2017/6/14.
//  Copyright © 2017年 xiaoxiao. All rights reserved.
//

import UIKit

class OpenLockCell: UITableViewCell {

    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var openStyleLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    var model : OpenLockList? {
        didSet{
            userNameLabel.text = model?.memberName
            if model?.logStatus == 1 {
                openStyleLabel.text = "手机开锁"
            }else{
                openStyleLabel.text = "其他开锁"
            }
            timeLabel.text = LockTools.stringToTimeStamp(stringTime: (model?.logTime)!)
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        //取消选中
        self.selectionStyle = .none
        userNameLabel.textColor = UIColor.hex(hexString: "9d9d9d")
        openStyleLabel.textColor = UIColor.hex(hexString: "9d9d9d")
        timeLabel.textColor = UIColor.hex(hexString: "9d9d9d")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
