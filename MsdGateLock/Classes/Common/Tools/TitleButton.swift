//
//  TitleButton.swift
//  WeiBo
//
//  Created by 覃鹏成 on 2017/6/9.
//  Copyright © 2017年 qinpengcheng. All rights reserved.
//

import UIKit

class TitleButton: UIButton {

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setImage(UIImage(named : "down"), for: .normal)
        setImage(UIImage(named : "down"), for: .selected)
        setTitleColor(UIColor.white, for: .normal)
        sizeToFit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    
        titleLabel?.frame.origin.x = 0
        imageView?.frame.origin.x = (titleLabel?.bounds.size.width)! + 5
    }
    

}
