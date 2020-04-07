//
//  SetGestureController.swift
//  MsdGateLock
//
//  Created by ox o on 2017/6/23.
//  Copyright © 2017年 xiaoxiao. All rights reserved.
//

//import UIKit
//import CoreLocation
//
//class SetGestureController: UIViewController{
//    
//    var lockView : PCCircleView! //解锁界面
//    var msgLabel : PCLockLabel! //提示label
//    var isSetFirstPass : Bool = false //第一次设置为手势密码
//    var isReset : Bool = false
//    let tipLabel : UILabel = UILabel()
//    var previousString:String? = ""
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        self.title = "设置手势密码"
//        self.view.backgroundColor = UIColor.globalBackColor
//        setupUI()
//    }
//
//    //MARK: - 设置手势密码
//    fileprivate func setupUI(){
//        
////        tipLabel.frame = CGRect(x: 0, y: 83, width: kScreenWidth, height: 15)
////        tipLabel.textAlignment = .center
////        tipLabel.font = kGlobalTextFont
////        tipLabel.text = "请连接至少5个点"
////        tipLabel.textColor = UIColor.textBlueColor
////        self.view.addSubview(tipLabel)
//        
//        // 进来先清空存的密码
//        PCCircleViewConst.saveGesture(nil, key: gestureOneSaveKey)
//        
//        let gestureView = PCCircleView.init(cirCleViewCenterY: 0.5)!
//        gestureView.delegate = self
//        gestureView.type = CircleViewTypeSetting
//        self.lockView = gestureView
//        self.view .addSubview(gestureView)
//        
//        let lockLabel = PCLockLabel()
//        lockLabel.frame = CGRect(x: 0, y: 0, width: kScreenWidth, height: 14)
//        lockLabel.center = CGPoint(x: kScreenWidth/2, y:gestureView.frame.minY - 50)
//        self.msgLabel = lockLabel
//        self.view.addSubview(msgLabel)
//        
//        self.msgLabel.showNormalMsg(gestureTextBeforeSet)
//    }
//}
//
//extension SetGestureController : CircleViewDelegate{
//    
//    func circleView(_ view: PCCircleView!, type: CircleViewType, connectCirclesLessThanNeedWithGesture gesture: String!) {
//        
//        let gestureOne =  PCCircleViewConst.getGestureWithKey(gestureOneSaveKey)
//
//        // 看是否存在第一个密码
//        if (gestureOne?.characters.count)! > 3 {
//            QPCLog("提示再次绘制之前绘制的第一个手势密码")
//            self.msgLabel.showWarnMsgAndShake(gestureTextDrawAgainError)
//        } else {
//            QPCLog("密码长度不合法\(gesture)")
//            self.msgLabel.showWarnMsgAndShake(gestureTextConnectLess)
//        }
//        
//    }
//    
//    
//    func circleView(_ view: PCCircleView!, type: CircleViewType, didCompleteSetFirstGesture gesture: String!) {
//        QPCLog("获得第一个手势密码\(gesture)")
//        self.msgLabel.showNormalMsg(gestureTextDrawAgain)
//    }
//    
//    func circleView(_ view: PCCircleView!, type: CircleViewType, didCompleteSetSecondGesture gesture: String!, result equal: Bool) {
//        if equal {
//            QPCLog("密码设置成功")
//            self.msgLabel.showWarnMsg(gestureTextSetSuccess)
//            //保存密码
//            PCCircleViewConst.saveGesture(gesture, key: gestureFinalSaveKey)
//            
//            if isReset {
//                let index = self.navigationController?.viewControllers.index(of: self)
//                self.navigationController?.popToViewController((self.navigationController?.viewControllers[index! - 2])!, animated: true)
//            }else if isSetFirstPass{
//                LoginKeyChainTool.saveDefaultPasswordStyle(style: "1")
//                UIApplication.shared.keyWindow?.rootViewController = LockNavigationController(rootViewController: HomeViewController())
//            }else{
//                self.navigationController?.popViewController(animated: true)
//            }
//        }else{
//            QPCLog("两次密码不一致")
//            self.msgLabel.showWarnMsgAndShake(gestureTextDrawAgainError)
//        }
//    }
//    
//}
