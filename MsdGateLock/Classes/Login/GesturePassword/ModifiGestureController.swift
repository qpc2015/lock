//
//  ModifiGestureController.swift
//  MsdGateLock
//
//  Created by ox o on 2017/7/27.
//  Copyright © 2017年 xiaoxiao. All rights reserved.
//

//import UIKit
//
//class ModifiGestureController: UIViewController {
//    
//    var msgLabel : PCLockLabel! //提示label
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        self.title = "修改手势密码"
//        self.view.backgroundColor = UIColor.globalBackColor
//
//        setupUI()
//    }
//
//
//}
//
//
//extension ModifiGestureController : CircleViewDelegate{
//    
//    func setupUI(){
//        
//        let gestureView = PCCircleView.init(cirCleViewCenterY: 0.5)!
//        gestureView.delegate = self
//        gestureView.type = CircleViewTypeVerify
//        self.view .addSubview(gestureView)
//        
//        let lockLabel = PCLockLabel()
//        lockLabel.frame = CGRect(x: 0, y: 0, width: kScreenWidth, height: 14)
//        lockLabel.center = CGPoint(x: kScreenWidth/2, y:gestureView.frame.minY - 50)
//        self.msgLabel = lockLabel
//        self.view.addSubview(msgLabel)
//        
//        self.msgLabel.showNormalMsg(gestureTextOldGesture)
//        
//    }
//    
//    
//    func circleView(_ view: PCCircleView!, type: CircleViewType, didCompleteLoginGesture gesture: String!, result equal: Bool) {
//        if type == CircleViewTypeVerify{
//            if equal {
//                //重新设置
////                let resetVC = SetGestureController()
////                resetVC.isReset = true
////                navigationController?.pushViewController(resetVC, animated: true)
//            }else{
//                self.msgLabel.showWarnMsgAndShake(gestureTextGestureVerifyError
//                )
//            }
//        }
//    }
//    
//}
