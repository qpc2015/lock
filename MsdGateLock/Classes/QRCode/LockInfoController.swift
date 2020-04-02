//
//  LockInfoController.swift
//  MsdGateLock
//
//  Created by ox o on 2017/6/21.
//  Copyright © 2017年 xiaoxiao. All rights reserved.
//

import UIKit
import CoreLocation

class LockInfoController: UITableViewController {

    @IBOutlet weak var areaTF: UITextField!  ///所属区域
    @IBOutlet weak var detailAdressTF: UITextField!
    @IBOutlet weak var remarkTF: UITextField!
    var locationManager : CLLocationManager!
    var currentLocationStr : String?
    var initCode : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "完善门锁信息"
        areaTF.isEnabled = false
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "完成", style: .plain, target: self, action: #selector(LockInfoController.flishClick))
        detailAdressTF.addTarget(self, action: #selector(LockInfoController.detailAdressTFValueChange), for: .editingChanged)
        
        getCurrentLocation()
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

    func getCurrentLocation(){
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
    }
}

extension LockInfoController{
    
    @objc func flishClick(){

        let req = BaseReq<InsertLockReq>()
        req.action = GateLockActions.ACTION_AddLock
        req.sessionId = UserInfo.getSessionId()!
        req.sign = LockTools.getSignWithStr(str: "oxo")
        
        guard  let lockId = MsdGlobals.scanLockId else {
            return
        }
        guard areaTF.text?.count != 0 else {
            SVProgressHUD.showError(withStatus: "请选择所属区域")
            return
        }
        guard detailAdressTF.text?.count != 0 else {
            SVProgressHUD.showError(withStatus: "请填写详细地址")
            return
        }
        guard remarkTF.text != nil else {
            SVProgressHUD.showError(withStatus: "请填写门锁备注")
            return
        }
        
        req.data = InsertLockReq.init(UserInfo.getUserId()!, lockID: lockId, lockArea: areaTF.text!, lockAddress: detailAdressTF.text!, name: remarkTF.text!, latlon: currentLocationStr ?? "",initCode:initCode!)
        
        AjaxUtil<CommonResp>.actionPost(req: req) { (resp) in
            SVProgressHUD.showSuccess(withStatus: resp.msg)
            
            //切换权限用户界面
            ;            let homeNav = LockNavigationController(rootViewController: HomeViewController())
            UIApplication.shared.keyWindow?.rootViewController = homeNav
        }
    }
}


extension LockInfoController: CLLocationManagerDelegate{
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let currentLocation = locations.last else{
            return
        }
        QPCLog("--la--\(currentLocation.coordinate.latitude)--lo-\(currentLocation.coordinate.longitude)")
        currentLocationStr = "(\(currentLocation.coordinate.latitude) \(currentLocation.coordinate.longitude))"
        locationManager.stopUpdatingLocation()
    }
    
    @objc func detailAdressTFValueChange(){
        if (detailAdressTF.text?.count)! > 30 {
            let str = (detailAdressTF.text! as NSString).substring(to: 30)
            detailAdressTF.text = str
        }
    }
}


extension LockInfoController : PickerDelegate{
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if cell.responds(to: #selector(setter: UIView.layoutMargins)){
            cell.layoutMargins = UIEdgeInsets.zero
        }
        if cell.responds(to: #selector(setter: UITableViewCell.separatorInset)){
            cell.separatorInset = UIEdgeInsets.zero
        }
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0{
            let label = UILabel()
            label.font = UIFont.systemFont(ofSize: 12.0)
            label.textColor = kRGBColorFromHex(rgbValue: 0x878787)
            label.text = "      给你提供更良好的售后服务,请填写您的门锁地址"
            return label
        }
        return nil
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0{
            return 28.0
        }else{
            return 0.001
        }
    }
    
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 20.0
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.section == 0 && indexPath.row == 0 {
            self.view.endEditing(true)
            setupAreaPickerViewDidClick()
        }
    }
    
    func setupAreaPickerViewDidClick(){
        
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
            areaTF.text = str
        }
    }
    
    func chooseDate(picker: LmyPicker, date: Date) {
        
    }
}
