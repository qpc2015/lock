//
//  NumberVerificationCodeView.swift
//  MsdGateLock
//
//  Created by ox o on 2017/6/27.
//  Copyright © 2017年 xiaoxiao. All rights reserved.
//

import UIKit

protocol NumberVerificationCodeViewDelegate {
    func verificationCodeDidFinishedInput(verificationCodeView:NumberVerificationCodeView,code:String)
}


class NumberVerificationCodeView: UIView {

    /// 代理回调
    var delegate:NumberVerificationCodeViewDelegate?
    
    /// 一堆框框的数组
    var textfieldarray = [UITextField]()
    
    /// 框框之间的间隔
    let margin:CGFloat = 20
    
    /// 框框的大小
    let numWidth:CGFloat = 46
    
    /// 框框个数
    var numOfRect = 4
    
    init(frame: CGRect,num: Int = 4,margin: CGFloat = 10){
        super.init(frame: frame)
        setupUI()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func cleanVerificationCodeView(){
        
        for tv in textfieldarray{
            tv.text = ""
        }
        textfieldarray.first?.becomeFirstResponder()
    }
    
}

// MARK: - UI
extension NumberVerificationCodeView{
    
    
    fileprivate func setupUI(){
         // 不允许用户直接操作验证码框
        self.isUserInteractionEnabled = false
        
        let leftMargin = (kScreenWidth - numWidth * CGFloat(numOfRect) - CGFloat(numOfRect - 1) * margin) / 2
        
        for i in 0..<numOfRect{
            let rect = CGRect(x: leftMargin + CGFloat(i)*(numWidth + margin), y: 0, width: numWidth, height: numWidth)
            let tf = createTextField(frame: rect)
            tf.tag = i
            textfieldarray.append(tf)
        }
        
        if numOfRect < 1{
            print("请输入大于1的数字")
            return
        }
        textfieldarray.first?.becomeFirstResponder()
    }
    
    private func createTextField(frame:CGRect)->UITextField{
        
        let tf = VerificationTF(frame: frame)
        tf.layer.borderColor = kRGBColorFromHex(rgbValue: 0xb6b6b6).cgColor
        tf.layer.borderWidth = 1
        tf.textAlignment = .center
        tf.font = UIFont.boldSystemFont(ofSize: 40)
        tf.textColor = kTextBlockColor
        tf.delegate = self
        tf.deleteDelegate = self
        tf.keyboardType = .numberPad
        addSubview(tf)
        return tf
    }
    
    
}


extension NumberVerificationCodeView : VerificationTFDeleteDelegate,UITextFieldDelegate{
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if !textField.hasText {
            
            let index = textField.tag
            
            textField.resignFirstResponder()
            
            if index == numOfRect - 1{
                
                textfieldarray[index].text = string
                //拼接结果
                var code = ""
                for tf in textfieldarray{
                    code += tf.text ?? ""
                }
                delegate?.verificationCodeDidFinishedInput(verificationCodeView: self, code: code)
                return false
            }
            
            textfieldarray[index].text = string
            textfieldarray[index + 1].becomeFirstResponder()
        }
        
        return false
    }
    
    ///监听到键盘删除键
    func didClickBackWard() {
        for i  in 1..<numOfRect{
            if !textfieldarray[i].isFirstResponder{
                continue
            }
            textfieldarray[i].resignFirstResponder()
            textfieldarray[i-1].becomeFirstResponder()
            textfieldarray[i-1].text = ""
        }
    }
    
    
}


