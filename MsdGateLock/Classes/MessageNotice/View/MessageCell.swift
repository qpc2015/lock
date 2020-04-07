//
//  MessageCell.swift
//  MsdGateLock
//
//  Created by ox o on 2017/7/4.
//  Copyright © 2017年 xiaoxiao. All rights reserved.
//

import UIKit

class MessageCell: UITableViewCell {

    
    @IBOutlet weak var statuView: UIView!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var contantLabel: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    
        setupUI()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {

    }
    
}



extension MessageCell{
    
    func setupUI(){
        
        timeLabel.textColor = UIColor.textGrayColor
        contantLabel.textColor = UIColor.textBlackColor
        
        
    }
    
}
