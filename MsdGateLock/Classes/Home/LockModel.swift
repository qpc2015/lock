//
//  LockModel.swift
//  FMDB
//
//  Created by ox o on 2017/8/19.
//  Copyright © 2017年 ox o. All rights reserved.
// 数据路返回模型

import UIKit

class LockListResultModel: NSObject {

    var lockId : String?
    var userId : String?
    var remark : String?
    var roleType : Int?
    var starttime : String?
    var endtime : String?
//    var roleRemark : String?
    var bluetoothName : String?
    var bluetoothMac : String?
    var authstatus : Int?
    var mainState : Int?
    var backState : Int?
    var battery : String?
    
    func initWithLockListModel(model : UserLockListResp){
        self.userId = model.userId
        self.lockId = model.lockId
        self.remark = model.remark
        self.roleType = model.roleType
        self.starttime = model.starttime
        self.endtime = model.endtime
        self.bluetoothName = model.bluetoothName
        self.bluetoothMac = model.bluetoothMac
        self.authstatus = model.authstatus
        self.mainState = model.mainState
        self.backState = model.backState
        self.battery = model.battery
    }
    
}





//    var userID:Int = 0
//    var lockID:String = ""
//    var userInviteStatus : Int = 0  //用户邀请状态
//    var lockBluetoothMac : String = ""
//    var bluetoothName : String = ""
//    var lockLastSyncTime : String = "" //上次同步日期时间
//    var startTime : String = "" //授权可开锁的开始时间
//    var endTime : String = "" // 授权可开锁的结束时间
//    var lockIsOpened : Bool = false  //是否打开过门锁,处理门锁和手机的时间同步
//
    
