//
//  AuthIconCollectionCell.swift
//  MsdGateLock
//
//  Created by ox o on 2017/6/28.
//  Copyright © 2017年 xiaoxiao. All rights reserved.
//

import UIKit

class AuthIconCollectionCell: UICollectionViewCell {

    @IBOutlet weak var itemHeight: NSLayoutConstraint!
    
    @IBOutlet weak var itemWidth: NSLayoutConstraint!
    
    var isAdmin : Bool?{
        didSet(old){
            if isAdmin!{
                isAdminImgView.isHidden = false
                adminLabel.isHidden = false
            }else{
                isAdminImgView.isHidden = true
                adminLabel.isHidden = true
            }
        }
    }
    @IBOutlet weak var adminLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var isAdminImgView: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        adminLabel.textColor = kRGBColorFromHex(rgbValue: 0x474747)
        isAdminImgView.isHidden = true
        adminLabel.isHidden = true
        
        itemWidth.constant = 90 * kWidth6Scale
        itemHeight.constant = 90 * kWidth6Scale
        
        imageView.layer.cornerRadius = 45 * kWidth6Scale
        imageView.layer.masksToBounds = true
    }

}
