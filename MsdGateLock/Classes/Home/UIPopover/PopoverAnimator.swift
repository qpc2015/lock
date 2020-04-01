//
//  PopoverAnimator.swift
//  WeiBo
//
//  Created by 覃鹏成 on 2017/6/9.
//  Copyright © 2017年 qinpengcheng. All rights reserved.
//

import UIKit

class PopoverAnimator: NSObject {

    ///标记是弹出/弹入
    var isPresented : Bool = false
    var presentedFrame : CGRect = CGRect.zero
    
    var callBack : ((_ presented : Bool) -> ())?
    // MARK:- 自定义构造函数
    // 注意:如果自定义了一个构造函数,但是没有对默认构造函数init()进行重写,那么自定义的构造函数会覆盖默认的init()构造函数
    init(callBack : @escaping (_ presented : Bool) -> ()) {
        self.callBack = callBack
    }
}


// MARK:- 自定义转场代理的方法
extension PopoverAnimator : UIViewControllerTransitioningDelegate{
    
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        let presentation = QPCPresentationContrller(presentedViewController: presented, presenting: presenting)
        presentation.presentedFrame = presentedFrame
        return presentation
    }
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        isPresented = true
        callBack!(isPresented)
        return self
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        isPresented = false
        callBack!(isPresented)
        return self
    }
    
}


// MARK:- 弹出和消失动画代理的方法
extension PopoverAnimator : UIViewControllerAnimatedTransitioning{
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.5
    }
    
    /// 获取`转场的上下文`:可以通过转场上下文获取弹出的View和消失的View
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        isPresented ? animationForPresentedView(transitionContext) : animationForDismissedView(transitionContext)
    }
    
    /// 自定义弹出动画
    func animationForPresentedView(_ transitionContext: UIViewControllerContextTransitioning){
        let presentedView = transitionContext.view(forKey: .to)!
        transitionContext.containerView.addSubview(presentedView)
        
        presentedView.transform = CGAffineTransform(scaleX: 1.0, y: 0.0)
        presentedView.layer.anchorPoint = CGPoint(x: 0.5, y: 0)
        UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
            presentedView.transform = CGAffineTransform.identity
        }) { (Bool) in
            transitionContext.completeTransition(true)
        }
    }
    
    /// 自定义消失动画
    func animationForDismissedView(_ transitionContext: UIViewControllerContextTransitioning){
        let dismissView = transitionContext.view(forKey: UITransitionContextViewKey.from)!
        
        UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
            dismissView.transform = CGAffineTransform(scaleX: 1, y: 0.001)
        }) { (Bool) in
            dismissView.removeFromSuperview()
            transitionContext.completeTransition(true)
        }
    }
}

