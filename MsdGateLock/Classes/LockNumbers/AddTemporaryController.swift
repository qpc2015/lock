//
//  swift
//  MsdGateLock
//
//  Created by ox o on 2017/6/26.
//  Copyright © 2017年 xiaoxiao. All rights reserved.
//

import UIKit
import ContactsUI
import AddressBookUI

class AddTemporaryController: UITableViewController {

    @IBOutlet weak var pTip: UILabel!
    @IBOutlet weak var phoneNumberTF: UITextField!
    @IBOutlet weak var addListBtn: UIButton!
    @IBOutlet weak var remarkTF: UITextField!
    @IBOutlet weak var bLabel: UILabel!
    @IBOutlet weak var starTip: UILabel!
    @IBOutlet weak var starTimeLabel: UILabel!
    @IBOutlet weak var endTip: UILabel!
    @IBOutlet weak var endTimeLabel: UILabel!
    var seletedNumber : String?
    var lockModel : UserLockListResp! //锁信息
    
//    lazy var datePick : LYJDatePicker02 = {
//        let datePick = LYJDatePicker02()
//        return datePick
//    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.globalBackColor
        self.title = "添加临时用户"
        setupUI()
    }

}

extension AddTemporaryController{
    
    func setupUI(){
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "确认", style: .plain, target: self, action: #selector(okClick))
        
        addListBtn.backgroundColor = UIColor.textBlueColor
        
        phoneNumberTF.textColor = UIColor.textGrayColor
        remarkTF.textColor = UIColor.textGrayColor
        starTimeLabel.textColor = UIColor.textGrayColor
        endTimeLabel.textColor = UIColor.textGrayColor        
        
        pTip.textColor = UIColor.textBlackColor
        bLabel.textColor = UIColor.textBlackColor
        starTip.textColor = UIColor.textBlackColor
        endTip.textColor = UIColor.textBlackColor
        
        addListBtn.addTarget(self, action: #selector(seletedAdressList), for: .touchUpInside)
    }
    
    
}

//MARK:- 响应事件
extension AddTemporaryController:CNContactPickerDelegate{
    
    func seletedTimeClick(str : String){
        self.remarkTF.resignFirstResponder()
        
        let datepicker = WSDatePickerView.init(dateStyle: DateStyleShowYearMonthDayHourMinute) { [weak self](selectDate) in
            guard let weakSelf = self else { return }
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
        
//        weak var weakSelf = self
//        self.datePick.canButtonReturnB = {
//            
//            QPCLog("我要消失了哈哈哈哈哈哈")
//            weakSelf!.datePick.removeFromSuperview()
//        }
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
    
    
   @objc fileprivate func okClick(){

    let dealNumber = phoneNumberTF.text?.replacingOccurrences(of: "-", with: "")
    guard dealNumber!.count == 11 else {
        SVProgressHUD.showError(withStatus: "请输入正确的手机号")
        return
    }
    
    let req = BaseReq<TwoParam<String,String>>()
    req.action = GateLockActions.ACTION_UserIdForAuth
    req.sessionId = UserInfo.getSessionId()!
    req.sign = LockTools.getSignWithStr(str: "oxo")
    req.data = TwoParam.init(p1:dealNumber! , p2: lockModel.lockId!)
    
        AjaxUtil<OneParam<String>>.actionPost(req: req) { [weak self](resp) in
            QPCLog(resp.data?.p1)
            self?.sendAuth(numberStr: dealNumber, userID: (resp.data?.p1)!)
        }
    
    }
    
    
    func sendAuth(numberStr : String?,userID : String){
        
        guard endTimeLabel.text != "0000-00-00 00:00" else {
            SVProgressHUD.showError(withStatus: "请选择时间")
            return
        }
        
        guard !LockTools.checkIsOvertimeWithLinestring(linestring: endTimeLabel.text!) else {
            SVProgressHUD.showError(withStatus: "请选择正确时间")
            return
        }
        
        //添加临时用户
        let timeStr = "1|\(String(describing: starTimeLabel.text!))|\(String(describing: endTimeLabel.text!))"
        let starTime = LockTools.stringToTimeYMDHmS(stringTime: starTimeLabel.text!)
        let endTime = LockTools.stringToTimeYMDHmS(stringTime: endTimeLabel.text!)
        let userTime = starTime + endTime
        
        //生成s,并上传
        let p = QPCKeychainTool.getEncryptPassWordWithKeyChain(lockID: lockModel.lockId!)
        let totalStr = userID + "0" + userTime
        QPCLog("\(totalStr)---\(p)")
        let aesStr = totalStr.aesEncrypt(key: p!)
        QPCLog("aesstr----\(String(describing: aesStr))")
        
        //添加授权用户
        let req = BaseReq<AddAuthUserReq>()
        req.action = GateLockActions.ACTION_SendAuth
        req.sessionId = UserInfo.getSessionId()!
        req.sign = LockTools.getSignWithStr(str: "oxo")
        req.data = AddAuthUserReq.init(UserInfo.getUserId()!,mobile : numberStr!,memberName : self.remarkTF.text ?? "", level: 2, lockId: lockModel.lockId!, permissions: timeStr, code: aesStr!)
        
        AjaxUtil<CommonResp>.actionPost(req: req) { [weak self](resp) in
            QPCLog(resp)
            SVProgressHUD.showSuccess(withStatus: resp.msg)
            //添加锁成功进入下一页
            self?.navigationController?.popViewController(animated: true)
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
        phoneNumberTF.text = seletedNumber
        remarkTF.text = contact.familyName + contact.givenName
    }
    
    @available(iOS 9.0, *)
    func contactPickerDidCancel(_ picker: CNContactPickerViewController) {
        QPCLog("点击了取消")
        
    }
}

extension AddTemporaryController:ABPeoplePickerNavigationControllerDelegate{
    
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
extension AddTemporaryController{
    
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
            label.text = "   \(lockModel.remark!)"
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
        if indexPath.section == 1{
            if indexPath.row == 0 {
                seletedTimeClick(str: "开始时间")
            }else if indexPath.row == 1 {
                seletedTimeClick(str: "结束时间")
            }
        }
    }
    
    
}
