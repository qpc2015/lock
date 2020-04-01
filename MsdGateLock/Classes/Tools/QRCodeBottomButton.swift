//
//  QRCodeBottomButton.swift
//  MsdGateLock
//
//  Created by ox o on 2017/6/23.
//  Copyright © 2017年 xiaoxiao. All rights reserved.
//

import UIKit

class QRCodeBottomButton: UIButton {

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
    private func setupUI(){
        
        imageView?.contentMode = .center
        // 设置tilte
        titleLabel?.textAlignment = .center
        titleLabel?.font = UIFont.systemFont(ofSize: 14.0)
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let widthH : CGFloat = self.frame.size.width * 0.8
        
        // 设置imageView
        imageView?.frame = CGRect(x:self.frame.size.width * 0.1, y: 0, width: widthH, height: widthH)
        
        // 设置title
        titleLabel?.frame = CGRect(x: 0, y: widthH - 5, width: self.frame.size.width, height: self.frame.size.height-widthH)
    }
    
}
