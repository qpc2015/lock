//
//  LockNavigationController.swift
//  MsdGateLock
//
//  Created by ox o on 2017/6/15.
//  Copyright © 2017年 xiaoxiao. All rights reserved.
//

import UIKit



class LockNavigationController: UINavigationController {
    

    override func viewDidLoad() {
        super.viewDidLoad()

        initNavigation()
    }

    func initNavigation() {
        navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white, NSAttributedString.Key.font:UIFont.systemFont(ofSize: 18.0)]
        navigationBar.tintColor = UIColor.white
//        navigationBar.barTintColor = kNavigationBarColor
//        navigationBar.backgroundColor = kNavigationBarColor
        navigationBar.setBackgroundImage(kCreateImageWithColor(color: kNavigationBarColor), for: .default)
   
    }

    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        if viewControllers.count > 0{
            let backBtn : UIButton = UIButton(type: .custom)
            backBtn.setImage(UIImage(named : "arrow_back"), for: .normal)
            backBtn.setImage(UIImage(named : "arrow_back"), for: .highlighted)
//            backBtn.backgroundColor = UIColor.red
//            backBtn.size = CGSize.init(width: 40, height: 40)
            backBtn.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
//            backBtn.sizeToFit()
            backBtn.addTarget(self, action: #selector(LockNavigationController.back), for: .touchUpInside)
            let leftBtn = UIBarButtonItem.init(customView: backBtn)
//            let spacer = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
//            spacer.width = -20
            viewController.navigationItem.leftBarButtonItem = leftBtn
//            viewController.navigationItem.leftBarButtonItems = [spacer,leftBtn]
        }
       _ = [super .pushViewController(viewController, animated: animated)]
    }
    
    
    @objc func back(){
        popViewController(animated: true)
    }

}





