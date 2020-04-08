//
//  OrderInstallLockController.swift
//  MsdGateLock
//
//  Created by ox o on 2017/7/4.
//  Copyright © 2017年 xiaoxiao. All rights reserved.
//  预约安装门锁

import UIKit
import ContactsUI
import AddressBookUI

class OrderInstallLockController: UITableViewController {

    @IBOutlet weak var numberTip: UILabel!
    @IBOutlet weak var numberTF: UITextField!
    @IBOutlet weak var adressListBtn: UIButton!
    @IBOutlet weak var contantTip: UILabel!
    @IBOutlet weak var nameTF: UITextField!
    @IBOutlet weak var areaTip: UILabel!
    @IBOutlet weak var areaLabel: UILabel!
    @IBOutlet weak var detailTip: UILabel!
    @IBOutlet weak var detailAdressTF: UITextField!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var timeSeletedLabel: UILabel!
    @IBOutlet weak var infoBackView: UIView!
    @IBOutlet weak var title1: UILabel!
    @IBOutlet weak var info1: UILabel!
    @IBOutlet weak var title2: UILabel!
    @IBOutlet weak var info2: UILabel!
    var seletedNumber : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor.globalBackColor
        self.title = "预约门锁"
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

extension OrderInstallLockController{
    
    func setupUI(){
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "提交", style: .plain, target: self, action: #selector(OrderInstallLockController.commitOrderClick))
        
        numberTip.textColor = UIColor.textBlackColor
        contantTip.textColor = UIColor.textBlackColor
        areaTip.textColor = UIColor.textBlackColor
        detailTip.textColor = UIColor.textBlackColor
        timeLabel.textColor = UIColor.textBlackColor
        adressListBtn.backgroundColor = UIColor.textBlueColor
        numberTF.textColor = UIColor.textGrayColor
        numberTF.attributedPlaceholder = NSAttributedString.init(string: "请输入成员手机号", attributes: [NSAttributedString.Key.foregroundColor:UIColor.textGrayColor])
        nameTF.attributedPlaceholder = NSAttributedString.init(string: "请输入联系人姓名", attributes: [NSAttributedString.Key.foregroundColor:UIColor.textGrayColor])
        nameTF.textColor = UIColor.textGrayColor
        areaLabel.textColor = UIColor.textGrayColor
        detailAdressTF.textColor = UIColor.textGrayColor
        detailAdressTF.attributedPlaceholder = NSAttributedString.init(string: "请输入您的详细地址", attributes: [NSAttributedString.Key.foregroundColor:UIColor.textGrayColor])
        timeSeletedLabel.textColor = UIColor.textGrayColor
        infoBackView.backgroundColor = UIColor.globalBackColor
        title1.textColor = UIColor.textBlackColor
        title1.font = UIFont.boldSystemFont(ofSize: 14)
        info1.textColor = UIColor.textGrayColor
        title2.textColor = UIColor.textBlackColor
        title2.font = UIFont.boldSystemFont(ofSize: 14)
        info2.textColor = UIColor.textGrayColor
        
        adressListBtn.addTarget(self, action: #selector(OrderInstallLockController.seletedAdressList), for: .touchUpInside)
    }
}

extension OrderInstallLockController{
    
    @objc func commitOrderClick(){
        
        if numberTF.text!.count < 5{
            SVProgressHUD.showError(withStatus: "请您检查手机号是否正确,方便联系安装")
            return
        }
        if detailAdressTF.text?.count == 0{
            SVProgressHUD.showError(withStatus: "请填写详细地址,方便联系安装")
            return
        }
        
        let numberCode = self.numberTF.text?.replacingOccurrences(of: "-", with: "")
        let req = BaseReq<CommitOrderReq>()
        req.action = GateLockActions.ACTION_InsertReserved
        req.sessionId = UserInfo.getSessionId()!
        req.sign = LockTools.getSignWithStr(str: "oxo")
        req.data = CommitOrderReq.init(reservedUsername: self.nameTF.text!, reservedUserTel: numberCode!, reservedArea: self.areaLabel.text!, reservedAddress: self.detailAdressTF.text!, reservedTime: self.timeSeletedLabel.text!)
        AjaxUtil<CommonResp>.actionPost(req: req) { [weak self](resp) in
            QPCLog(resp)
            SVProgressHUD.showSuccess(withStatus: resp.msg)
            self?.navigationController?.popViewController(animated: true)
        }
    }
}

extension OrderInstallLockController{
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headView = UIView(frame: CGRect(x: 0, y: 0, width: kScreenWidth, height: 20))
        headView.backgroundColor = UIColor.globalBackColor
        
        let orderNum = UILabel()
        orderNum.textColor = UIColor.textGrayColor
        orderNum.text = "订单号: ********"
        orderNum.font = UIFont.systemFont(ofSize: 12)
        orderNum.isHidden = true
        headView.addSubview(orderNum)
        orderNum.snp.makeConstraints { (make) in
            make.left.equalTo(14)
            make.centerY.equalTo(headView)
        }
        
        let orderStatu = UILabel()
        orderStatu.textColor = UIColor.textBlackColor
        orderStatu.text = "待确认"
        orderStatu.font = UIFont.systemFont(ofSize: 12)
        orderStatu.isHidden = true
        headView.addSubview(orderStatu)
        orderStatu.snp.makeConstraints { (make) in
            make.right.equalTo(-14)
            make.centerY.equalTo(headView)
        }
        return headView
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 20
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 33
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

extension OrderInstallLockController : PickerDelegate{
    
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
        let datepicker = WSDatePickerView.init(dateStyle: DateStyleShowYearMonthDayHourMinute) { [weak self](selectDate) in
            guard let weakSelf = self else {return}
            let dateStr = selectDate?.string_from(formatter: "yyyy-MM-dd HH:mm")
            QPCLog("选择的日期:\(String(describing: dateStr))")
            weakSelf.timeSeletedLabel.text = dateStr
        }
        datepicker?.dateLabelColor = UIColor.textBlueColor
        datepicker?.datePickerColor = UIColor.textBlackColor
        datepicker?.doneButtonColor = UIColor.textBlueColor
        datepicker?.show()
    }
}

extension OrderInstallLockController:CNContactPickerDelegate{
    //通讯录
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

extension OrderInstallLockController :ABPeoplePickerNavigationControllerDelegate{
    
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

