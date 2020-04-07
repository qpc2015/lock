//
//  TroubleRepairController.swift
//  MsdGateLock
//
//  Created by ox o on 2017/6/30.
//  Copyright © 2017年 xiaoxiao. All rights reserved.
//

import UIKit
import ContactsUI
import AddressBookUI

class TroubleRepairController: UITableViewController {
    
    @IBOutlet weak var contantTip: UILabel!
    @IBOutlet weak var personTip: UILabel!
    @IBOutlet weak var areaTip: UILabel!
    @IBOutlet weak var adressTip: UILabel!
    @IBOutlet weak var installTip: UILabel!
    @IBOutlet weak var numberTF: UITextField!
    @IBOutlet weak var nameTF: UITextField!
    @IBOutlet weak var areaLabel: UILabel!
    @IBOutlet weak var adressTF: UITextField!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var numListBtn: UIButton!
    @IBOutlet weak var tipView: UIView!
    @IBOutlet weak var tip1Label: UILabel!
    @IBOutlet weak var tip1DetailLabel: UILabel!
    @IBOutlet weak var tip2Label: UILabel!
    @IBOutlet weak var tip2DetailLabel: UILabel!
    
    var currentLockID : String?
    var seletedNumber : String?
    //    lazy var datePick : LYJDatePicker02 = {
    //        let datePick = LYJDatePicker02()
    //        return datePick
    //    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.globalBackColor
        self.title = "故障报修"
        setupUI()
    }
    
    //cell线
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if (self.tableView?.responds(to: #selector(setter: UITableViewCell.separatorInset)))!{
            tableView?.separatorInset = UIEdgeInsets.zero
        }
        
        if (tableView?.responds(to: #selector(setter: UIView.layoutMargins)))!{
            tableView?.layoutMargins = UIEdgeInsets.zero
        }
    }
}

extension TroubleRepairController{
    
    func setupUI(){
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "提交", style: .plain, target: self, action: #selector(TroubleRepairController.submitClick))
        
        contantTip.textColor = UIColor.textBlackColor
        personTip.textColor = UIColor.textBlackColor
        areaTip.textColor = UIColor.textBlackColor
        adressTip.textColor = UIColor.textBlackColor
        installTip.textColor = UIColor.textBlackColor
        
        numberTF.attributedPlaceholder = NSAttributedString.init(string: "请输入成员手机号", attributes: [NSAttributedString.Key.foregroundColor:UIColor.textGrayColor])
        nameTF.attributedPlaceholder = NSAttributedString.init(string: "请输入联系人姓名", attributes: [NSAttributedString.Key.foregroundColor:UIColor.textGrayColor])
        adressTF.attributedPlaceholder = NSAttributedString.init(string: "请输入您的详细地址", attributes: [NSAttributedString.Key.foregroundColor:UIColor.textGrayColor])
        
        numberTF.textColor = UIColor.textGrayColor
        nameTF.textColor = UIColor.textGrayColor
        adressTF.textColor = UIColor.textGrayColor
        areaLabel.textColor = UIColor.textGrayColor
        timeLabel.textColor = UIColor.textGrayColor
        
        numListBtn.backgroundColor = UIColor.textBlueColor
        numListBtn.addTarget(self, action: #selector(seletedAdressList), for: .touchUpInside)
        
        tipView.backgroundColor = UIColor.globalBackColor
        tip1Label.textColor = UIColor.textBlackColor
        tip1DetailLabel.textColor = UIColor.textGrayColor
        tip2Label.textColor = UIColor.textBlackColor
        tip2DetailLabel.textColor = UIColor.textGrayColor
    }
}


extension TroubleRepairController {
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 20.0
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 30.0
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        self.view.endEditing(true)
        if indexPath.row == 2 {
            setupAreaPickerView()
        }else if indexPath.row == 4 {
            seletedTimeClick(str: "安装时间")
        }
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if cell.responds(to: #selector(setter: UIView.layoutMargins)){
            cell.layoutMargins = UIEdgeInsets.zero
        }
        if cell.responds(to: #selector(setter: UITableViewCell.separatorInset)){
            cell.separatorInset = UIEdgeInsets.zero
        }
    }
}

extension TroubleRepairController : PickerDelegate{
    
    func setupAreaPickerView(){
        var contentArray = [LmyPickerObject]()
        let plistPath:String = Bundle.main.path(forAuxiliaryExecutable: "area.plist") ?? ""
        let plistArray = NSArray(contentsOfFile: plistPath)
        let proviceArray = NSArray(array: plistArray!)
        for i in 0..<proviceArray.count {
            var subs0 = [LmyPickerObject]()
            
            let cityzzz:NSDictionary = proviceArray.object(at: i) as! NSDictionary
            let cityArray:NSArray = cityzzz.value(forKey: "cities") as! NSArray
            for j in 0..<cityArray.count {
                var subs1 = [LmyPickerObject]()
                
                let areazzz:NSDictionary = cityArray.object(at: j) as! NSDictionary
                let areaArray:NSArray = areazzz.value(forKey: "areas") as! NSArray
                for m in 0..<areaArray.count {
                    let object = LmyPickerObject()
                    object.title = areaArray.object(at: m) as? String
                    subs1.append(object)
                }
                let citymmm:NSDictionary = cityArray.object(at: j) as! NSDictionary
                let cityStr:String = citymmm.value(forKey: "city") as! String
                let object = LmyPickerObject()
                object.title = cityStr
                subs0.append(object)
                object.subArray = subs1
            }
            let provicemmm:NSDictionary = proviceArray.object(at: i) as! NSDictionary
            let proviceStr:String? = provicemmm.value(forKey: "state") as! String?
            let object = LmyPickerObject()
            object.title = proviceStr
            object.subArray = subs0
            contentArray.append(object)
        }
        
        let picker = LmyPicker(delegate: self, style: .nomal)
        picker.contentArray = contentArray
        picker.show()
    }
    
    func chooseElements(picker: LmyPicker, content: [Int : Int]) {
        var str:String = ""
        if let array = picker.contentArray {
            var tempArray = array
            for i in 0..<content.keys.count {
                let value:Int! = content[i]
                if value < tempArray.count {
                    let obj:LmyPickerObject = tempArray[value]
                    let title = obj.title ?? ""
                    if str.count>0 {
                        str = str.appending("-\(title)")
                    }else {
                        str = title;
                    }
                    if let arr = obj.subArray {
                        tempArray = arr
                    }
                }
            }
            QPCLog( str)
            self.areaLabel.text = str
        }
    }
    
    func chooseDate(picker: LmyPicker, date: Date) {
        
    }
    
    func seletedTimeClick(str : String){
        
        weak var weakSelf = self
        
        let datepicker = WSDatePickerView.init(dateStyle: DateStyleShowYearMonthDayHourMinute) { (selectDate) in
            let dateStr = selectDate?.string_from(formatter: "yyyy-MM-dd HH:mm")
            QPCLog("选择的日期:\(String(describing: dateStr))")
            weakSelf?.timeLabel.text = dateStr
        }
        datepicker?.dateLabelColor = UIColor.textBlueColor
        datepicker?.datePickerColor = UIColor.textBlackColor
        datepicker?.doneButtonColor = UIColor.textBlueColor
        datepicker?.show()
        
        //        weak var weakSelf = self
        //        self.datePick.canButtonReturnB = {
        //            QPCLog("我要消失了哈哈哈哈哈哈")
        //            weakSelf!.datePick.removeFromSuperview()
        //        }
        //
        //        self.datePick.sucessReturnB = { returnValue in
        //            debugPrint("我要消失了哈哈哈哈哈哈\(returnValue)")
        //            self.timeLabel.text = returnValue
        //            weakSelf!.datePick.removeFromSuperview()
        //        }
        //        //需要初始化数据
        //        datePick.initData()
        //        datePick.frame = CGRect(x: 0, y: kScreenHeight - 314, width: kScreenWidth, height: 250)
        //        self.view.addSubview(datePick)
    }
}

//MARK:- CLICK
extension TroubleRepairController:CNContactPickerDelegate{
    
    @objc func submitClick(){
        
        guard numberTF.text?.count == 11 else {
            SVProgressHUD.showError(withStatus: "请您检查手机号是否正确,方便联系维修")
            return
        }
        guard (adressTF.text?.count)! > 0 else {
            SVProgressHUD.showError(withStatus: "请填写详细地址,方便联系维修")
            return
        }
        
        let req = BaseReq<InsertFaultReq>()
        req.action = GateLockActions.ACTION_InsertFault
        req.sessionId = UserInfo.getSessionId()!
        req.sign = LockTools.getSignWithStr(str: "oxo")
        req.data = InsertFaultReq.init(currentLockID!, userId: UserInfo.getUserId()!, faultUsername: self.nameTF.text!, faultUsertel: self.numberTF.text!, faultArea: self.areaLabel.text!, faultAddress: self.adressTF.text!, faultTime: self.timeLabel.text!)
        
        weak var weakSelf = self
        AjaxUtil<CommonResp>.actionPost(req: req) { (resp) in
            QPCLog(resp)
            SVProgressHUD.showSuccess(withStatus: resp.msg)
            weakSelf?.navigationController?.popViewController(animated: true)
        }
    }
    
    @objc func seletedAdressList(){
        
        if #available(iOS 9.0, *) {
            let pickerVC = CNContactPickerViewController()
            pickerVC.delegate = self
            self.present(pickerVC, animated: true, completion: nil)
        } else {
            let listVC = ABPeoplePickerNavigationController()
            listVC.peoplePickerDelegate = self
            self.present(listVC, animated: true, completion: nil)
        }
    }
    
    @available(iOS 9.0, *)
    func contactPicker(_ picker: CNContactPickerViewController, didSelect contact: CNContact) {
        QPCLog(contact.familyName) //姓
        QPCLog(contact.givenName) //名
        QPCLog(contact.phoneNumbers)
        
        for i in contact.phoneNumbers {
            
            let phoneNum = i.value.stringValue //电话号码
            seletedNumber = phoneNum
        }
        numberTF.text  = seletedNumber
        nameTF.text = contact.familyName + contact.givenName
    }
    
    @available(iOS 9.0, *)
    func contactPickerDidCancel(_ picker: CNContactPickerViewController) {
        QPCLog("点击了取消")
    }
}

extension TroubleRepairController:ABPeoplePickerNavigationControllerDelegate{
    
    func peoplePickerNavigationController(_ peoplePicker: ABPeoplePickerNavigationController, didSelectPerson person: ABRecord) {
        let phoneValues : ABMutableMultiValue? = ABRecordCopyValue(person, kABPersonPhoneProperty).takeRetainedValue()
        if phoneValues != nil{
            print("选中电话:")
            for i in 0..<ABMultiValueGetCount(phoneValues){
                let phoneLabel = ABMultiValueCopyLabelAtIndex(phoneValues, i).takeRetainedValue() as CFString
                // 转为本地标签名（能看得懂的标签名，比如work、home）
                let localizedPhoneLabel = ABAddressBookCopyLocalizedLabel(phoneLabel).takeRetainedValue() as String
                let value = ABMultiValueCopyValueAtIndex(phoneValues, i)
                let phone = value?.takeRetainedValue() as! String
                print("---\(localizedPhoneLabel):\(phone)")
            }
        }
    }
    
    func peoplePickerNavigationControllerDidCancel(_ peoplePicker: ABPeoplePickerNavigationController) {
        peoplePicker.dismiss(animated: true, completion: nil)
    }
}


