//
//  UIBarButtonItem-Extension.swift
//  WeiBo
//
//  Created by 覃鹏成 on 2017/6/9.
//  Copyright © 2017年 qinpengcheng. All rights reserved.
//

import UIKit


extension UIBarButtonItem{
    
    convenience init(imageName : String){

        let btn = UIButton()
        btn.setImage(UIImage(named : imageName), for: .normal)
        btn.setImage(UIImage(named : imageName + "_highlighted"), for: .highlighted)
        btn.sizeToFit()
        self.init(customView : btn)
    }
    
    
    
}
