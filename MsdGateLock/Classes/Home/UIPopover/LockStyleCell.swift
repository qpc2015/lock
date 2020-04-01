//
//  LockStyleCell.swift
//  MsdGateLock
//
//  Created by ox o on 2017/6/15.
//  Copyright © 2017年 xiaoxiao. All rights reserved.
//

import UIKit

class LockStyleCell: UITableViewCell {

    var titleModel : UserLockListResp? {
        didSet{
            guard titleModel != nil else {
                return
            }
            if (titleModel?.remark?.count)! > 0 {
                lockTitle.text = titleModel?.remark
            }else{
                lockTitle.text = titleModel?.roleRemark
            }

        }
    }
    
    @IBOutlet weak var lockTitle: UILabel!
    
    @IBOutlet weak var bottomLine: UIView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        lockTitle.textColor = kTextBlockColor
        bottomLine.backgroundColor = kRGBColorFromHex(rgbValue: 0xe9e9e9)

    }


    
}
