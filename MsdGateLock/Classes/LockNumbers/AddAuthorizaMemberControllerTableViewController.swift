//
//  AddAuthorizaMemberControllerTableViewController.swift
//  MsdGateLock
//
//  Created by ox o on 2017/6/26.
//  Copyright © 2017年 xiaoxiao. All rights reserved.
//

import UIKit
import ContactsUI
import AddressBookUI

class AddAuthorizaMemberController: UITableViewController {

    @IBOutlet weak var numberTF: UITextField!
    @IBOutlet weak var remarkTF: UITextField!
    @IBOutlet weak var addlistBtn: UIButton!
    @IBOutlet weak var isPerpetualSwitch: UISwitch!
    @IBOutlet weak var starLabel: UILabel!
    @IBOutlet weak var endLabel: UILabel!
    
    @IBOutlet weak var pLabel: UILabel!
    @IBOutlet weak var bLabel: UILabel!
    @IBOutlet weak var timesLabel: UILabel!
    @IBOutlet weak var starTop: UILabel!
    @IBOutlet weak var endTip: UILabel!
    var lockModel : UserLockListResp!   //对应锁信息

    var seletedNumber : String?
    var oneSectionCount : Int = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "添加授权成员"
        self.view.backgroundColor = UIColor.globalBackColor
        setupUI()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if (self.tableView?.responds(to: #selector(setter: UITableViewCell.separatorInset)))!{
            tableView?.separatorInset = UIEdgeInsets.zero
        }
        
        if (tableView?.responds(to: #selector(setter: UIView.layoutMargins)))!{
            tableView?.layoutMargins = UIEdgeInsets.zero
        }
    }
    
    func setupUI(){
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "确认", style: .plain, target: self, action: #selector(okClick))
        
        addlistBtn.backgroundColor = UIColor.textBlueColor
        isPerpetualSwitch.onTintColor = UIColor.textBlueColor
        
        numberTF.textColor = UIColor.textGrayColor
        remarkTF.textColor = UIColor.textGrayColor
        
        starLabel.textColor = UIColor.textGrayColor
        endLabel.textColor = UIColor.textGrayColor
        
        pLabel.textColor = UIColor.textBlackColor
        bLabel.textColor = UIColor.textBlackColor
        timesLabel.textColor = UIColor.textBlackColor
        starTop.textColor = UIColor.textBlackColor
        endTip.textColor = UIColor.textBlackColor
        
        tableView.bounces = false
        addlistBtn.addTarget(self, action: #selector(seletedAdressList), for: .touchUpInside)
        isPerpetualSwitch.addTarget(self, action: #selector(seletedTimeClick(perpSwitch:)), for: .valueChanged)
    }
}

//MARK:- 响应事件
extension AddAuthorizaMemberController:CNContactPickerDelegate{
    //选中循环次数
    func seletedRepeatCount(){
        
    }
    
    func seletedTimeClick(str : String){
        weak var weakSelf = self
        let datepicker = WSDatePickerView.init(dateStyle: DateStyleShowYearMonthDayHourMinute) { (selectDate) in
            let dateStr = selectDate?.string_from(formatter: "yyyy-MM-dd HH:mm")
            QPCLog("选择的日期:\(String(describing: dateStr))")
            if str == "开始时间" {
                weakSelf!.starLabel.text = dateStr
            }else if str == "结束时间"{
                weakSelf!.endLabel.text = dateStr
            }
        }
        datepicker?.dateLabelColor = UIColor.textBlueColor
        datepicker?.datePickerColor = UIColor.textBlackColor
        datepicker?.doneButtonColor = UIColor.textBlueColor
        datepicker?.show()
    }
    
    @objc func seletedTimeClick(perpSwitch : UISwitch){
        if perpSwitch.isOn {
            oneSectionCount = 1
            self.tableView .reloadData()
        }else{
            oneSectionCount = 3
            self.tableView.reloadData()
        }
    }
    
    @objc func okClick(){
        QPCLog("点击了确认")
        
        let numberStr = self.numberTF.text?.replacingOccurrences(of: "-", with: "")
        guard numberStr?.count == 11 else {
            SVProgressHUD.showError(withStatus: "请输入正确的手机号")
            return
        }
        
        let req = BaseReq<TwoParam<String,String>>()
        req.action = GateLockActions.ACTION_UserIdForAuth
        req.sessionId = UserInfo.getSessionId()!
        req.sign = LockTools.getSignWithStr(str: "oxo")
        req.data = TwoParam.init(p1:numberStr! , p2: lockModel.lockId!)
        
        weak var weakSelf = self
        AjaxUtil<OneParam<String>>.actionPost(req: req) { (resp) in
            QPCLog(resp.data?.p1)
            weakSelf?.sendAuth(numberStr: numberStr, userID: (resp.data?.p1)!)
        }
    }
    
    func sendAuth(numberStr : String?,userID : String){
        var timeStr : String!
        var userTime : String!
        
        if isPerpetualSwitch.isOn {
            timeStr = "2"
            userTime = "2017090100000021171001000000"
        }else{
            timeStr = "1|\(String(describing: starLabel.text!))|\(String(describing: endLabel.text!))"
            let starTime = LockTools.stringToTimeYMDHmS(stringTime: starLabel.text!)
            let endTime = LockTools.stringToTimeYMDHmS(stringTime: endLabel.text!)
            userTime = starTime + endTime
        }

        //生成s,并上传
        let p = QPCKeychainTool.getEncryptPassWordWithKeyChain(lockID: lockModel.lockId!)
        let totalStr = userID + "0" + userTime
        QPCLog("\(totalStr)---\(String(describing: p))")
        let aesStr = totalStr.aesEncrypt(key: p!)
        QPCLog("aesstr----\(String(describing: aesStr))")

        //添加授权用户
        let req = BaseReq<AddAuthUserReq>()
        req.action = GateLockActions.ACTION_SendAuth
        req.sessionId = UserInfo.getSessionId()!
        req.sign = LockTools.getSignWithStr(str: "oxo")
        req.data = AddAuthUserReq.init(UserInfo.getUserId()!,mobile : numberStr!,memberName : self.remarkTF.text!, level: 1, lockId: lockModel.lockId!, permissions: timeStr, code: aesStr!)
        weak var weakSelf = self

        AjaxUtil<CommonResp>.actionPost(req: req) { (resp) in
            QPCLog(resp)
            SVProgressHUD.showSuccess(withStatus: resp.msg)
            //添加锁成功进入下一页
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
        remarkTF.text = contact.familyName + contact.givenName
    }
    
    @available(iOS 9.0, *)
    func contactPickerDidCancel(_ picker: CNContactPickerViewController) {
        QPCLog("点击了取消")
    }
}

extension AddAuthorizaMemberController:ABPeoplePickerNavigationControllerDelegate{
    
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


//MARK:-tabledatasoure
extension AddAuthorizaMemberController{
    
    //控制是否显示时间
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 1{
            return oneSectionCount
        }
        return 2
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0{
            return 60.0
        }else if section == 1{
            return 18.0;
        }
        return 0;
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == 0{
            return 22.0
        }
        return 0.001
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0{
            let label = UILabel(frame: CGRect(x: 0, y: 0, width: kScreenWidth, height: 60))
            label.text = "   \(String(describing: lockModel.remark!))"
            label.font = UIFont.systemFont(ofSize: 30.0)
            label.textColor = UIColor.textBlueColor
            return label
        }else{
            let timeLabel = UILabel(frame: CGRect(x: 0, y: 0, width: kScreenWidth, height: 60))
            timeLabel.font = UIFont.systemFont(ofSize: 12.0)
            timeLabel.textAlignment = .natural
            timeLabel.text = "      请为该成员设置开门权限有效期"
            timeLabel.textColor = UIColor.hex(hexString: "878787")
            return timeLabel
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        QPCLog(indexPath.row)
        if indexPath.section == 1{
            if indexPath.row == 0 {
                
            }else if indexPath.row == 1 {
                seletedTimeClick(str: "开始时间")
            }else if indexPath.row == 2 {
                seletedTimeClick(str: "结束时间")
            }
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
