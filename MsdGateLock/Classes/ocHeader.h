//
//  ocHeader.h
//  MsdGateLock
//
//  Created by ox o on 2017/6/8.
//  Copyright © 2017年 xiaoxiao. All rights reserved.
//



#import <CommonCrypto/CommonDigest.h>
#import "SVProgressHUD.h"
#import "MJRefresh.h"
#import "BleManager.h"
#import "FMDB.h"
#import "WSDatePickerView.h"

long google_authenticator(uint8_t* key, long time);

//手势密码
#import "PCCircleView.h"
#import "PCCircleViewConst.h"
#import "PCLockLabel.h"

//极光推送
#import "JPUSHService.h"
// iOS10注册APNs所需头文件
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif
// 如果需要使用idfa功能所需要引入的头文件（可选）
#import <AdSupport/AdSupport.h>
