//
//  TransferUserCell.swift
//  MsdGateLock
//
//  Created by ox o on 2017/6/29.
//  Copyright © 2017年 xiaoxiao. All rights reserved.
//

import UIKit

class TransferUserCell: UICollectionViewCell {

    @IBOutlet weak var seletedImage: UIImageView!
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!

    @IBOutlet weak var imagHeight: NSLayoutConstraint!
    @IBOutlet weak var imageWidth: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        seletedImage.isHidden = true
        
        imageWidth.constant = 100 * kWidth6Scale
        imagHeight.constant = 100 * kWidth6Scale
        iconImageView.layer.cornerRadius = 50 * kWidth6Scale
        iconImageView.layer.masksToBounds = true

    }

   override var isSelected: Bool{
        get{
            return super.isSelected
        }
        set{
            if newValue {
                super.isSelected = true
                seletedImage.isHidden = false
            }else if newValue == false{
                super.isSelected = false
                seletedImage.isHidden = true
            }
        }
    }
    

}
