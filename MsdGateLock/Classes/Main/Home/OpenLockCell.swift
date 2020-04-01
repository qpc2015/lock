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
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        //取消选中
        self.selectionStyle = .none
        userNameLabel.textColor = kRGBColorFromHex(rgbValue: 0x9d9d9d)
        openStyleLabel.textColor = kRGBColorFromHex(rgbValue: 0x9d9d9d)
        timeLabel.textColor = kRGBColorFromHex(rgbValue: 0x9d9d9d)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
