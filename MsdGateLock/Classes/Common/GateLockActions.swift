//
//  GateLockActions.swift
//  MsdGateLock
//
//  Created by xiaoxiao on 2017/5/25.
//  Copyright © 2017年 xiaoxiao. All rights reserved.
//

import Foundation

class GateLockActions
{
    static let  ACTION_LOGIN = "msd.lock.login"
    static let  ACTION_SmsCode = "msd.lock.smsCode"  ///短信接口
    static let  ACTION_GetLockList = "msd.lock.getLockList"  ///获取首页锁列表
    static let  ACTION_GetLockOneLog = "msd.lock.getLockOneLog"  ///获取某把锁某人的开门记录信息
    static let  ACTION_GetLock = "msd.lock.getLock"  ///获取当前锁的首页信息
    static let  ACTION_GetLockLog = "msd.lock.getLockLog"  ///获取当前锁的所有开门记录
    static let  ACTION_GetUserInfo = "msd.lock.getUserInfo"  ///用户信息
    static let  ACTION_UpdateUser = "msd.lock.updateUserName"  ///修改用户信息
    static let  ACTION_ChangeMobile1 = "msd.lock.changeMobile1"  ///修改手机step1
    static let  ACTION_ChangeMobile2 = "msd.lock.changeMobile2"  ///修改用户手机step2
    static let  ACTION_AvatarUploadKey = "msd.lock.avatarUploadKey"  ///请求上传密钥
    static let  ACTION_UpdateUserAvatar = "msd.lock.updateUserAvatar"  ///用户头像更新
    static let  ACTION_ReservedList = "msd.lock.reservedList" //预约门锁列表接口
    static let  ACTION_InsertReserved = "msd.lock.insertReserved" //添加预约门锁
    static let  ACTION_CancelReserved = "msd.lock.CancelReserved" //取消预约接口
    static let  ACTION_NoPerHomeList = "msd.lock.lockImageList"  //非门锁用户首页
    static let  ACTION_CheckLock = "msd.lock.checkLock"  //检查锁是否存在或是否绑定
    static let  ACTION_AddLock = "msd.lock.addLock"  //添加门锁接口
    static let  ACTION_UserRoleInfo = "msd.lock.userRoleInfo"  //查询门锁人员
    static let  ACTION_UpdateUserRemark = "msd.lock.updateUserRemark"  //修改用户备注
    static let  ACTION_DeleteUser = "msd.lock.deleteUser"  //删除用户
    static let  ACTION_TransferAdmin = "msd.lock.transferAdmin"  //转让管理员
    static let  ACTION_UpdateExpireDate = "msd.lock.updateExpireDate"     //修改用户权限有效期
    static let  ACTION_SendAuth = "msd.lock.sendAuth"  //添加授权人员
    static let  ACTION_UserIdForAuth = "msd.lock.userIdForAuth"  //查询授权人员id
    static let  ACTION_ExistGroup = "msd.lock.existGroup"  //退出成员组
    static let  ACTION_GetRoleByUser = "msd.lock.getRoleByUser"  //查user详情
    static let  ACTION_Logout = "msd.lock.logout" //登出
    static let  ACTION_CheckSMS = "msd.lock.checkSMS" //检查短信接口
    static let  ACTION_GetLockInfo = "msd.lock.getLockInfo" //门锁详细信息接口
    static let  ACTION_UpdateLock = "msd.lock.updateLock" //修改门锁详细接口
    static let  ACTION_UpdateLockRemark = "msd.lock.updateLockRemark" //临时修改门锁备注
    static let  ACTION_FaultList = "msd.lock.faultList" //报修信息列表
    static let  ACTION_AddResetLock = "msd.lock.addResetLock"  //重置门锁
    static let  ACTION_InsertFault = "msd.lock.insertFault" //添加报销单
    static let  ACTION_UpdateFaultStatus = "msd.lock.updateFaultStatus" //取消报修接口
    static let  ACTION_AddScrapLock = "msd.lock.addScrapLock" //报废门锁
    static let  ACTION_AddLockLog = "msd.lock.addLockLog" //添加开(关)锁日志接口   
    static let  ACTION_AddLockBatteryAndState = "msd.lock.addLockBatteryAndState" //添加电量，正/反锁记录
    static let  ACTION_UpdateAuthStatus = "msd.lock.updateAuthStatus" //更新锁权限分配状态
    static let  ACTION_InRole = "msd.lock.inRole" //获取我接收到的邀请
    static let  ACTION_UserWaitLockRemove = "msd.lock.userWaitLockRemove" //待锁删除用户列表
    static let  ACTION_UpdateUserLockRemove = "msd.lock.updateUserLockRemove" //更新删除用户列表
   static let  ACTION_UserGetKeyContent = "msd.lock.userGetKeyContent" //获取秘钥
    static let  ACTION_UserKeyContent = "msd.lock.userKeyContent" //上传加密秘钥
    
    //h5
    static let  H5_Abount = "http://lockres.diadiade.com/about.html" //关于我们
    static let  H5_Message = "http://lockres.diadiade.com/message.html" //消息通知
    static let  H5_Instructions = "http://lockres.diadiade.com/instructions.html" //问题反馈
    static let  H5_Agreement = "http://lock.diadiade.com/msd.lock.getAgreeMent" //用户协议
    static let  H5_FeedBack = "http://lockres.diadiade.com/feedback.html" //使用说明
}
