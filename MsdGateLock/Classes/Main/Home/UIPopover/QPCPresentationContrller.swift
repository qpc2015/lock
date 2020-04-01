//
//  QPCPresentationContrller.swift
//  WeiBo
//
//  Created by 覃鹏成 on 2017/6/9.
//  Copyright © 2017年 qinpengcheng. All rights reserved.
//

import UIKit

class QPCPresentationContrller: UIPresentationController {
    // MARK:- 对外提供属性
    var presentedFrame : CGRect = CGRect.zero
    
    fileprivate lazy var converView : UIView = UIView()
    
    
    override func containerViewWillLayoutSubviews() {
        
        super.containerViewWillLayoutSubviews()
        // 1.设置弹出View的尺寸
        presentedView?.frame = presentedFrame
        
        setupCoverView()
    }
    
    
    
}


//MARK: - UI
extension QPCPresentationContrller {
    
    func  setupCoverView() {
        converView.backgroundColor = UIColor(white: 0.8, alpha: 0.5)
        converView.frame = (containerView?.bounds)!
        containerView?.insertSubview(converView, at: 0)
        
       let tapGesture = UITapGestureRecognizer(target: self, action: #selector(QPCPresentationContrller.coverViewClick))
        converView.addGestureRecognizer(tapGesture)
    }
}

//MARK: - click
extension QPCPresentationContrller {
    func coverViewClick() {
    presentedViewController.dismiss(animated: true, completion: nil)
    }

}
