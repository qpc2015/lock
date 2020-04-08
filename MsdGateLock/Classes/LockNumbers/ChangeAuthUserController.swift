//
//  ChangeAuthUserController.swift
//  MsdGateLock
//
//  Created by ox o on 2017/6/30.
//  Copyright © 2017年 xiaoxiao. All rights reserved.
//

import UIKit

class ChangeAuthUserController: UITableViewController {

    @IBOutlet weak var setVailTip: UILabel!
    @IBOutlet weak var starTip: UILabel!
    @IBOutlet weak var endTip: UILabel!
    @IBOutlet weak var isLongSwitch: UISwitch!
    @IBOutlet weak var starTimeLabel: UILabel!
    @IBOutlet weak var endTimeLabel: UILabel!
    
    var oneSectionCount : Int = 1
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "设置时效"
        
        setupUI()
    }

 
}


extension ChangeAuthUserController{
    
    func setupUI(){
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "确认", style: .plain, target: self, action: #selector(ChangeAuthUserController.affirmClick))
        
        setVailTip.textColor = UIColor.textBlackColor
        isLongSwitch.onTintColor = UIColor.textBlueColor
        
        starTip.textColor = UIColor.textBlackColor
        endTip.textColor = UIColor.textBlackColor
        
        starTimeLabel.textColor = UIColor.textGrayColor
        endTimeLabel.textColor = UIColor.textGrayColor
        
        isLongSwitch.addTarget(self, action: #selector(AddAuthorizaMemberController.seletedTimeClick(perpSwitch:)), for: .valueChanged)
    }
    
    
    
}


extension ChangeAuthUserController{

    @objc func affirmClick(){
        
        QPCLog("确认")
        
        navigationController?.popViewController(animated: true)
    }

    func seletedTimeClick(perpSwitch : UISwitch){
        if perpSwitch.isOn {
            oneSectionCount = 1
            self.tableView .reloadData()
        }else{
            oneSectionCount = 3
            self.tableView.reloadData()
        }
        
    }
    
    
    func seletedTimeClick(str : String){
        let datepicker = WSDatePickerView.init(dateStyle: DateStyleShowYearMonthDayHourMinute) { [weak self](selectDate) in
            guard let weakSelf = self else {return}
            let dateStr = selectDate?.string_from(formatter: "yyyy-MM-dd HH:mm")
            QPCLog("选择的日期:\(String(describing: dateStr))")
            if str == "开始时间" {
                weakSelf.starTimeLabel.text = dateStr
            }else if str == "结束时间"{
                weakSelf.endTimeLabel.text = dateStr
            }
        }
        datepicker?.dateLabelColor = UIColor.textBlueColor
        datepicker?.datePickerColor = UIColor.textBlackColor
        datepicker?.doneButtonColor = UIColor.textBlueColor
        datepicker?.show()
        
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
}


extension ChangeAuthUserController{
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 28
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.001
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let timeLabel = UILabel(frame: CGRect(x: 0, y: 0, width: kScreenWidth, height: 28))
        timeLabel.font = UIFont.systemFont(ofSize: 12.0)
        timeLabel.textAlignment = .natural
        timeLabel.text = "      转换权限前，请为该成员设置开门权限有效期"
        timeLabel.textColor = UIColor.textGrayColor
        return timeLabel
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return oneSectionCount
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 1 {
            seletedTimeClick(str: "开始时间")
        }else if indexPath.row == 2 {
            seletedTimeClick(str: "结束时间")
        }
    }
}
