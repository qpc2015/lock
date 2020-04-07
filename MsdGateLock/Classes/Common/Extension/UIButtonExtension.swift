//
//  UIButton-Extension.swift
//  WeiBo
//
//  Created by 覃鹏成 on 2017/6/7.
//  Copyright © 2017年 qinpengcheng. All rights reserved.
//

import UIKit


extension UIButton{
    // convenience : 便利,使用convenience修饰的构造函数叫做便利构造函数
    // 遍历构造函数通常用在对系统的类进行构造函数的扩充时使用
    /*
     遍历构造函数的特点
     1.遍历构造函数通常都是写在extension里面
     2.遍历构造函数init前面需要加载convenience
     3.在遍历构造函数中需要明确的调用self.init()
     */
    convenience init (imageName :String,bgImageName : String ){
        self.init()
        setImage(UIImage(named: imageName), for: UIControl.State.normal)
        setBackgroundImage(UIImage(named: bgImageName), for: .normal)
        setImage(UIImage(named: imageName + "_highlighted"), for: .highlighted)
        setBackgroundImage(UIImage(named: bgImageName + "_highlighted"), for: .highlighted)
        sizeToFit()
        
    }
    
    
    class func createBtn (title : String , bgColor : UIColor , font : CGFloat) -> UIButton {
        
        let btn = UIButton()
        btn.setTitle(title, for: .normal)
        btn.backgroundColor = bgColor
        btn.titleLabel?.font = UIFont.systemFont(ofSize: font)
        
        return btn
    }
    
    convenience init(title : String , bgColor : UIColor , font : CGFloat) {
        self.init()
        setTitle(title, for: .normal)
        backgroundColor = bgColor
        titleLabel?.font = UIFont.systemFont(ofSize: font)
    }
    
    
    
}
