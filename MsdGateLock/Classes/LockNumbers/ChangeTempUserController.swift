//
//  ChangeTempUserController.swift
//  MsdGateLock
//
//  Created by ox o on 2017/6/30.
//  Copyright © 2017年 xiaoxiao. All rights reserved.
//

import UIKit

class ChangeTempUserController: UITableViewController {

    @IBOutlet weak var repeatTip: UILabel!
    @IBOutlet weak var starTip: UILabel!
    @IBOutlet weak var endTip: UILabel!
    @IBOutlet weak var repeatLabel: UILabel!
    @IBOutlet weak var starTimeLabel: UILabel!
    @IBOutlet weak var endTimeLabel: UILabel!
    
//    lazy var datePick : LYJDatePicker02 = {
//        let datePick = LYJDatePicker02()
//        return datePick
//    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "设置时效"
        self.view.backgroundColor = UIColor.globalBackColor
        
        setupUI()
    }

  
}


extension ChangeTempUserController{
    
    func setupUI(){
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "确认", style: .plain, target: self, action: #selector(ChangeTempUserController.okClick))
        repeatTip.textColor = UIColor.textBlackColor
        starTip.textColor = UIColor.textBlackColor
        endTip.textColor = UIColor.textBlackColor
        
        repeatLabel.textColor = UIColor.textGrayColor
        starTimeLabel.textColor = UIColor.textGrayColor
        endTimeLabel.textColor = UIColor.textGrayColor
    }
    
    
}

//MARK:-  CLICK
extension ChangeTempUserController{
    
    func seletedTimeClick(str : String){
        
        weak var weakSelf = self
        
        let datepicker = WSDatePickerView.init(dateStyle: DateStyleShowYearMonthDayHourMinute) { (selectDate) in
            let dateStr = selectDate?.string_from(formatter: "yyyy-MM-dd HH:mm")
            QPCLog("选择的日期:\(String(describing: dateStr))")
            if str == "开始时间" {
                weakSelf!.starTimeLabel.text = dateStr
            }else if str == "结束时间"{
                weakSelf!.endTimeLabel.text = dateStr
            }
        }
        datepicker?.dateLabelColor = UIColor.textBlueColor
        datepicker?.datePickerColor = UIColor.textBlackColor
        datepicker?.doneButtonColor = UIColor.textBlueColor
        datepicker?.show()
        
//        weak var weakSelf = self
//        self.datePick.canButtonReturnB = {
//            
//            QPCLog("我要消失了哈哈哈哈哈哈")
//            weakSelf!.datePick.removeFromSuperview()
//        }
//        
//        
//        
//        self.datePick.sucessReturnB = { returnValue in
//            
//            debugPrint("我要消失了哈哈哈哈哈哈\(returnValue)")
//            if str == "开始时间" {
//                weakSelf!.starTimeLabel.text = returnValue
//            }else if str == "结束时间"{
//                weakSelf!.endTimeLabel.text = returnValue
//            }
//            weakSelf!.datePick.removeFromSuperview()
//            
//        }
//        //需要初始化数据
//        datePick.initData()
//        datePick.frame = CGRect(x: 0, y: kScreenHeight - 314, width: kScreenWidth, height: 250)
//        self.view.addSubview(datePick)
        
        
    }
    
    @objc func okClick(){
        navigationController?.popViewController(animated: true)
    }
}


//MARK:-  Delegat
extension ChangeTempUserController{
    


    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 28
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0{
            let timeLabel = UILabel(frame: CGRect(x: 0, y: 0, width: kScreenWidth, height: 28))
            timeLabel.font = UIFont.systemFont(ofSize: 12.0)
            timeLabel.textAlignment = .natural
            timeLabel.text = "      转换权限前，请为该成员设置开门权限有效期"
            timeLabel.textColor = UIColor.hex(hexString: "878787")
            return timeLabel
        }
        return nil
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            
        }else if indexPath.row == 1 {
            seletedTimeClick(str: "开始时间")
        }else if indexPath.row == 2 {
            seletedTimeClick(str: "结束时间")
        }
    }
}
