//
//  TempListCell.swift
//  MsdGateLock
//
//  Created by ox o on 2017/6/29.
//  Copyright © 2017年 xiaoxiao. All rights reserved.
//

import UIKit

class TempListCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var time1Label: UILabel!
    @IBOutlet weak var time2Label: UILabel!
    @IBOutlet weak var pastDueLabel: UILabel!
    
    
    var model : AuthInfoListResp? {
        didSet{
            guard let cellModel = model else {
                return
            }
            nameLabel.text = cellModel.sourceName
            if LockTools.checkIsOvertime(stringTime: cellModel.endTime){
                self.time1Label.isHidden = true
                self.time2Label.isHidden = true
                self.pastDueLabel.isHidden = false
            }else{
                self.time1Label.isHidden = false
                self.time2Label.isHidden = false
                self.pastDueLabel.isHidden = true
                time1Label.text = "起: \(String(describing: LockTools.stringToTimeYMD(stringTime: cellModel.startTime)))"
                time2Label.text = "止: \(String(describing: LockTools.stringToTimeYMD(stringTime: cellModel.endTime)))"
            }

        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        nameLabel.textColor = UIColor.hex(hexString: "1c1c1c")
        time1Label.textColor = UIColor.textGrayColor
        time2Label.textColor = UIColor.textGrayColor
        pastDueLabel.textColor = UIColor.textGrayColor
        pastDueLabel.isHidden = true
        
    }

}
