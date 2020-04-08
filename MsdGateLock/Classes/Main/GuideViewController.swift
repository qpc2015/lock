//
//  GuideViewController.swift
//  GuideViewExample
//
//  Created by ChuGuimin on 16/1/20.
//  Copyright © 2016年 cgm. All rights reserved.
//

import UIKit

class GuideViewController: UIViewController {
    
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var pageControl: UIPageControl!
    private let numOfPages = 3
    private var scrollView: UIScrollView = {
        let frame = CGRect(x: 0, y: 0, width: kScreenWidth, height: kScreenHeight)
        let scrollView = UIScrollView(frame: frame)
        scrollView.isPagingEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.scrollsToTop = false
        scrollView.bounces = false
        scrollView.contentOffset = CGPoint.zero
        return scrollView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // 将 scrollView 的 contentSize 设为屏幕宽度的3倍(根据实际情况改变)
        scrollView.contentSize = CGSize(width: kScreenWidth * CGFloat(numOfPages), height: kScreenHeight)
        scrollView.delegate = self
        for index  in 0..<numOfPages {
            let imageView = UIImageView(image: UIImage(named: "GuideImage\(index + 1)"))
            imageView.frame = CGRect(x: kScreenWidth * CGFloat(index), y: 0, width: kScreenWidth, height: kScreenHeight)
            scrollView.addSubview(imageView)
        }
        self.view.insertSubview(scrollView, at: 0)
        startButton.backgroundColor = UIColor.textBlueColor
        startButton.setTitleColor(UIColor.white, for: .normal)
        // 给开始按钮设置圆角
        startButton.layer.cornerRadius = 4.0
        // 隐藏开始按钮
        startButton.alpha = 0.0
        startButton.addTarget(self, action: #selector(GuideViewController.gotoLoginViewController), for: .touchUpInside)
    }
    
    // 隐藏状态栏
    override var prefersStatusBarHidden : Bool {
        return true
    }
    
    @objc private func gotoLoginViewController(){
        UIApplication.shared.keyWindow?.rootViewController = LockNavigationController(rootViewController: LoginController())
    }
}

// MARK: - UIScrollViewDelegate
extension GuideViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offset = scrollView.contentOffset
        // 随着滑动改变pageControl的状态
        pageControl.currentPage = Int(offset.x / view.bounds.width)
        
        // 因为currentPage是从0开始，所以numOfPages减1
        if pageControl.currentPage == numOfPages - 1 {
            UIView.animate(withDuration: 0.5, animations: {
                self.startButton.alpha = 1.0
            }) 
        } else {
            UIView.animate(withDuration: 0.2, animations: {
                self.startButton.alpha = 0.0
            }) 
        }
    }
}
