//
//  OrderListCell.swift
//  MsdGateLock
//
//  Created by 覃鹏成 on 2017/7/1.
//  Copyright © 2017年 xiaoxiao. All rights reserved.
//

import UIKit



protocol OrderListCellDelegate : NSObjectProtocol{
    func orderListCellWithAlterBtnDidClick(btn : UIButton)
    func orderListCellWithCancleBtnDidClick(btn : UIButton)
}

class OrderListCell: UITableViewCell {

    weak var delegate : OrderListCellDelegate?
    @IBOutlet weak var orderTip: UILabel!
    @IBOutlet weak var contactTip: UILabel!
    @IBOutlet weak var numberTip: UILabel!
    @IBOutlet weak var adressTip: UILabel!
    @IBOutlet weak var timeTip: UILabel!
    
    @IBOutlet weak var orderLabel: UILabel!
    @IBOutlet weak var contactLabel: UILabel!
    @IBOutlet weak var numberLabel: UILabel!
    @IBOutlet weak var adressLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var statuLabel: UILabel!
    
    @IBOutlet weak var alterBtn: UIButton!
    @IBOutlet weak var cancleBtn: UIButton!
    
    @IBOutlet weak var line1: UIView!
    @IBOutlet weak var line2: UIView!
    @IBOutlet weak var line3: UIView!
    @IBOutlet weak var line4: UIView!
    
    var  model: OrderLockResp?{
        didSet{
            orderLabel.text = "\(String(describing: model!.reservedId))"
            contactLabel.text = (model?.reservedUserName?.count)! > 0  ? model?.reservedUserName : "未填写"
            numberLabel.text = model?.reservedUserTel
            adressLabel.text = (model?.reservedArea)! + (model?.reservedAddress)!
            timeLabel.text = LockTools.stringToTimeYMD(stringTime: (model?.reservedTime)!)
            guard model?.orderStatus != nil else {
                self.statuLabel.text = ""
                return
            }
            let ordStatu = (model?.orderStatus)!
            switch ordStatu{
            case 0:
                self.statuLabel.text = "待确认"
            case 1:
                self.statuLabel.text = "已确认"
            case 2:
                self.statuLabel.text = "未订单完成"
            case 3:
                self.statuLabel.text = "订单取消"
            default:
                QPCLog("超出范围")
            }
        }
    }
    
    /*
     未确认=0,
     已确认=1,
     订单完成=2,
     订单取消=3
 
     */
    var repairModel : FaultListResp?{
        didSet{
            timeTip.text = "报修时间"
            orderLabel.text = "\(String(describing: (repairModel?.faultId)!))"
            contactLabel.text = (repairModel?.faultUsername.count)! > 0  ? repairModel?.faultUsername : "未填写"
            numberLabel.text = repairModel?.faultUsertel
            adressLabel.text = (repairModel?.faultArea)! + (repairModel?.faultAddress)!
            timeLabel.text = LockTools.stringToTimeYMD(stringTime: (repairModel?.faultTime)!)
            guard repairModel?.faultState != nil else {
                self.statuLabel.text = ""
                return
            }
            let ordStatu = (repairModel?.faultState)!
            switch ordStatu{
            case 0:
                self.statuLabel.text = "待确认"
            case 1:
                self.statuLabel.text = "已确认"
            case 2:
                self.statuLabel.text = "未订单完成"
            case 3:
                self.statuLabel.text = "订单取消"
            default:
                QPCLog("超出范围")
            }
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()

        setupUI()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {}
}

extension OrderListCell{
    
    func setupUI(){
        self.backgroundColor = UIColor.white
        
        orderTip.textColor = UIColor.textGrayColor
        contactTip.textColor = UIColor.textGrayColor
        numberTip.textColor = UIColor.textGrayColor
        adressTip.textColor = UIColor.textGrayColor
        timeTip.textColor = UIColor.textGrayColor
        orderLabel.textColor = UIColor.textBlackColor
        contactLabel.textColor = UIColor.textBlackColor
        numberLabel.textColor = UIColor.textBlackColor
        adressLabel.textColor = UIColor.textBlackColor
        timeLabel.textColor = UIColor.textBlackColor
        statuLabel.textColor = UIColor.textBlueColor
        alterBtn.backgroundColor = UIColor.textBlueColor
        cancleBtn.backgroundColor = UIColor.textBlueColor
        
        line1.backgroundColor = UIColor.hex(hexString: "f0f0f0")
        line2.backgroundColor = UIColor.hex(hexString: "f0f0f0")
        line3.backgroundColor = UIColor.hex(hexString: "f0f0f0")
        line4.backgroundColor = UIColor.hex(hexString: "f0f0f0")
        
        alterBtn.addTarget(self, action: #selector(OrderListCell.alterBtnClick(btn:)), for: .touchUpInside)
        cancleBtn.addTarget(self, action: #selector(OrderListCell.cancleBtnClick(btn:)), for: .touchUpInside)
    }
    
}


extension OrderListCell{
    
    @objc func alterBtnClick(btn : UIButton){
        delegate?.orderListCellWithAlterBtnDidClick(btn: btn)
    }
    
    @objc func cancleBtnClick(btn : UIButton){
        delegate?.orderListCellWithCancleBtnDidClick(btn: btn)
    }
}

