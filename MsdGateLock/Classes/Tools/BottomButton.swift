//
//  BottomButton.swift
//  MsdGateLock
//
//  Created by ox o on 2017/6/14.
//  Copyright © 2017年 xiaoxiao. All rights reserved.
//

import UIKit
import SnapKit

class BottomButton: UIButton {

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
//        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - 设置视图
    private func setupUI(){

        backgroundColor = UIColor.red
        imageView?.contentMode = .center


    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let widthH : CGFloat = (self.image(for: .normal)?.size.width)!
        
        // 设置imageView
        imageView?.frame = CGRect(x: (self.frame.width-widthH)*0.5, y: 8, width: widthH, height: widthH)
        // 设置title
        titleLabel?.frame = CGRect(x: 0, y: widthH + 10, width: self.frame.size.width, height: 14)
        // 设置tilte
        titleLabel?.textAlignment = .center
    }

}
