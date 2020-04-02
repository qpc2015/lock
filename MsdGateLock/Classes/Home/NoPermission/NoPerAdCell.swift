//
//  NoPerAdCell.swift
//  MsdGateLock
//
//  Created by ox o on 2017/7/19.
//  Copyright © 2017年 xiaoxiao. All rights reserved.
//

import UIKit

class NoPerAdCell: UITableViewCell {

    
    @IBOutlet weak var adImageView: UIImageView!
    
    @IBOutlet weak var detailContextLabel: UILabel!

    var model : ExplainModel? {
        didSet{
            adImageView.kf.setImage(with: URL(string: (model?.imageUrl)!), placeholder: nil, options: nil, progressBlock: nil)
            detailContextLabel.text = model?.context
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.detailContextLabel.textColor = kTextGrayColor
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
    }
    
}
