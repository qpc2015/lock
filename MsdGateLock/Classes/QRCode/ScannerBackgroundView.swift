//
//  ScannerBackgroundView.swift
//  BDHome
//
//  Created by Erwin on 16/6/17.
//  Copyright © 2016年 BDHome. All rights reserved.
//

import UIKit

class ScannerBackgroundView: UIView {
    
//    var inCodeBtn : UIButton?
    var flashBtn : UIButton!
    
    let topScale : CGFloat = 0.2
    //屏幕扫描区域视图
    let barcodeView = UIView(frame: CGRect(x: UIScreen.main.bounds.size.width * 0.2, y: kScreenHeight * 0.2, width: kScreenWidth * 0.6, height: kScreenWidth * 0.6))
    
    //扫描线
    let scanLine = UIImageView()
    
    var scanning : String!
    var timer = Timer()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        barcodeView.layer.borderWidth = 1.0
        barcodeView.layer.borderColor = UIColor.white.cgColor
        self.addSubview(barcodeView)
        
        //设置边角线
        createCornerLine()
        
        //设置扫描线
        scanLine.frame = CGRect(x: 0, y: 0, width: barcodeView.frame.size.width, height: 5)
        scanLine.image = UIImage(named: "QRCodeScanLine")
        
        //添加扫描线图层
        barcodeView.addSubview(scanLine)
        
        self.createBackGroundView()
        
        self.addObserver(self, forKeyPath: "scanning", options: .new, context: nil)
        
        timer = Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(moveScannerLayer(_:)), userInfo: nil, repeats: true)
   
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        if scanning == "start" {
            timer.fire()
        }else{
            timer.invalidate()
        }
    }
    
}

extension ScannerBackgroundView{
    
    func createCornerLine(){
        //左上
        let leftTopRow = createRowLine()
        barcodeView.addSubview(leftTopRow)
        leftTopRow.snp.makeConstraints { (make) in
            make.left.equalTo(barcodeView)
            make.top.equalTo(barcodeView.snp.top).offset(-1)
            make.height.equalTo(5)
            make.width.equalTo(19)
        }
        
        let leftTopLine = createRowLine()
        barcodeView.addSubview(leftTopLine)
        leftTopLine.snp.makeConstraints { (make) in
            make.left.equalTo(barcodeView)
            make.top.equalTo(barcodeView.snp.top).offset(-1)
            make.height.equalTo(19)
            make.width.equalTo(5)
        }
        
        //右上
        let rightTopRow = createRowLine()
        barcodeView.addSubview(rightTopRow)
        rightTopRow.snp.makeConstraints { (make) in
            make.right.equalTo(barcodeView)
            make.top.equalTo(barcodeView.snp.top).offset(-1)
            make.height.equalTo(5)
            make.width.equalTo(19)
        }
        
        let rightTopLine = createRowLine()
        barcodeView.addSubview(rightTopLine)
        rightTopLine.snp.makeConstraints { (make) in
            make.right.equalTo(barcodeView)
            make.top.equalTo(barcodeView.snp.top).offset(-1)
            make.height.equalTo(19)
            make.width.equalTo(5)
        }
        
        //左下
        let leftBottomRow = createRowLine()
        barcodeView.addSubview(leftBottomRow)
        leftBottomRow.snp.makeConstraints { (make) in
            make.left.equalTo(barcodeView)
            make.bottom.equalTo(barcodeView.snp.bottom).offset(-1)
            make.height.equalTo(5)
            make.width.equalTo(19)
        }
        
        let leftBottomLine = createRowLine()
        barcodeView.addSubview(leftBottomLine)
        leftBottomLine.snp.makeConstraints { (make) in
            make.left.equalTo(barcodeView)
            make.bottom.equalTo(barcodeView.snp.bottom).offset(-1)
            make.height.equalTo(19)
            make.width.equalTo(5)
        }
        
        //右下
        let rightBottomRow = createRowLine()
        barcodeView.addSubview(rightBottomRow)
        rightBottomRow.snp.makeConstraints { (make) in
            make.right.equalTo(barcodeView)
            make.bottom.equalTo(barcodeView.snp.bottom).offset(-1)
            make.height.equalTo(5)
            make.width.equalTo(19)
        }
        
        let rightBottomLine = createRowLine()
        barcodeView.addSubview(rightBottomLine)
        rightBottomLine.snp.makeConstraints { (make) in
            make.right.equalTo(barcodeView)
            make.bottom.equalTo(barcodeView.snp.bottom).offset(-1)
            make.height.equalTo(19)
            make.width.equalTo(5)
        }
}
    
    
    
    func  createBackGroundView() {
        
        let topView = UIView(frame: CGRect(x: 0, y: 0,  width: UIScreen.main.bounds.size.width, height: kScreenHeight * topScale))

        let bottomView : UIView!
        if kIsSreen5 {
            bottomView = UIView(frame: CGRect(x: 0, y: kScreenWidth * 0.6 + kScreenHeight * topScale, width: UIScreen.main.bounds.size.width, height: kScreenHeight * 0.23))
        }else{
            bottomView = UIView(frame: CGRect(x: 0, y: kScreenWidth * 0.6 + kScreenHeight * topScale, width: UIScreen.main.bounds.size.width, height: kScreenHeight * 0.25))
        }

        
        
        let leftView = UIView(frame: CGRect(x: 0, y: UIScreen.main.bounds.size.height * topScale, width: UIScreen.main.bounds.size.width * 0.2, height: UIScreen.main.bounds.size.width * 0.6))
        let rightView = UIView(frame: CGRect(x: UIScreen.main.bounds.size.width * 0.8, y: UIScreen.main.bounds.size.height * topScale, width: UIScreen.main.bounds.size.width * 0.2, height: UIScreen.main.bounds.size.width * 0.6))
        
        topView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.4)
        bottomView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.4)
        leftView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.4)
        rightView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.4)
        
        let label = UILabel(frame: CGRect(x: 0, y: 22, width: UIScreen.main.bounds.size.width, height: 21))
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = UIColor.white
        label.text = "对准锁内的二维码完成扫描"
        
        bottomView.addSubview(label)
        
        let btnWH = kScreenHeight * 0.12
        
        let bottomInView = UIView(frame: CGRect(x: 0, y: kScreenHeight * 0.88 - 64, width: kScreenWidth, height: btnWH))
//        bottomInView.backgroundColor = UIColor.blue
        bottomInView.backgroundColor = kRGBColorFromHex(rgbValue: 0x353535)
        self.addSubview(bottomInView)
        
        //输入编号
//        inCodeBtn = QRCodeBottomButton(frame: CGRect(x: 40, y: 0, width: kScreenWidth * 0.18, height: btnWH))
//        inCodeBtn?.setImage(UIImage(named: "manual_bottom"), for: .normal)
//        inCodeBtn?.setImage(UIImage(named: "manual_bottom"), for: .selected)
//        inCodeBtn!.setTitle("输入编号", for: .normal)
//        inCodeBtn?.setTitleColor(UIColor.white, for: .normal)
//        bottomInView.addSubview(inCodeBtn!)
        
        //手电筒
        flashBtn = QRCodeBottomButton(frame: CGRect(x: kScreenWidth*0.41, y: 0, width: kScreenWidth * 0.18, height: btnWH))
        flashBtn.setImage(UIImage(named: "shoudiantong"), for: .normal)
        flashBtn.setTitle("手电筒", for: .normal)
        bottomInView.addSubview(flashBtn)
        
        self.addSubview(topView)
        self.addSubview(bottomView)
        self.addSubview(leftView)
        self.addSubview(rightView)
    }
    
    //让扫描线滚动
    @objc func moveScannerLayer(_ timer : Timer) {
        scanLine.frame = CGRect(x: 0, y: 0, width: self.barcodeView.frame.size.width, height: 12);
        UIView.animate(withDuration: 2) {
            self.scanLine.frame = CGRect(x: self.scanLine.frame.origin.x, y: self.scanLine.frame.origin.y + self.barcodeView.frame.size.height - 10, width: self.scanLine.frame.size.width, height: self.scanLine.frame.size.height);
            
        }
        
    }
    
    //创建单一边角线
    func createRowLine()-> UIView{
        let line = UIView()
        line.backgroundColor = kTextBlueColor
        return line
    }
    
}
