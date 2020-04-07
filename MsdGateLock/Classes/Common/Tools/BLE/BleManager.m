//
//  BleManager.m
//  BadyBlueSwift
//
//  Created by ox o on 2017/8/4.
//  Copyright © 2017年 ox o. All rights reserved.

#import "BleManager.h"
#import "BLEUtility.h"
#import "XOREncryptAndDecrypt.h"
#import "NSData+Hex.h"
#import "MsdGateLock-Swift.h"
#import <CommonCrypto/CommonDigest.h>

#define USER_DEFAULT  [NSUserDefaults standardUserDefaults]
#define BLE_SEND_MAX_LEN  80

@interface BleManager()<CBCentralManagerDelegate,CBPeripheralDelegate>
{
    CBPeripheral  *_connectedPeripheral;//连接中得设备
    NSString      *_encryptKey;
    NSMutableString *_totalReslut;  //用于拼接结果
    NSString        *_currentPort; //当前调用的接口
}
@end

@implementation BleManager
//单例对象
static BleManager *_manager;

+(instancetype)sharedManager{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _manager=[[BleManager alloc]init];
    });
    return _manager;
}

+(id)allocWithZone:(struct _NSZone *)zone
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _manager=[super allocWithZone:zone];
        
    });
    return _manager;
}

- (id)copyWithZone:(NSZone *)zone
{
    return _manager;
}
//////////////////////////////////////////////////////////////////////////
-(id)init{
    if (self = [super init]) {
        _cbCM = [[CBCentralManager alloc] initWithDelegate:self queue:nil];
        _deviceArray=[NSMutableArray arrayWithCapacity:0];
        // 十六进制随机数      %02d数据要大于或等于两列，如果不足前面补0
//        _encryptKey = [NSString stringWithFormat:@"%02d", [[[NSString alloc] initWithFormat:@"%1x", arc4random() % 100 + 1] intValue]];
    }
    return self;
}

//1.
//搜索蓝牙设备
-(void)searchBleDevices{
    [_cbCM scanForPeripheralsWithServices:nil options:nil];
}

//2.
//获得连接中的设备
- (CBPeripheral *)connectedDevice{
    return _connectedPeripheral;
}

//3.
//断开连接指定设备
- (void)disConnectDevice:(CBPeripheral *)aCBPeripheral;{
    [_cbCM cancelPeripheralConnection:aCBPeripheral];
}

//4.
//连接一个指定设备
- (void)connectDevice:(CBPeripheral *)aCBPeripheral{
    [_cbCM connectPeripheral:aCBPeripheral options:nil];
}

//5.
//发送指令
-(void)sendCommand:(NSString *)command{
    if (!_connectedPeripheral) {
        return;
    }
    [self writeCharacteristic:command forPeripheral:_connectedPeripheral];
}

-(void)sendCommandWithPort:(NSString *)port dataStr:(NSString *)data{
    if (!_connectedPeripheral) {
        return;
    }
    _currentPort = port;
    NSLog(@"dataStr ----%@",data);
    NSString *fullCommand = nil;
    if ([port isEqualToString:@"07040100"]){
        fullCommand  = [NSString stringWithFormat:@"%@%@$$",port,[self md5:data]];
        NSLog(@"full--------%@",fullCommand);
    }else{
        fullCommand = [NSString stringWithFormat:@"%@%@%@$$",port,data,[self md5:data]];
        NSLog(@"full--------%@",fullCommand);
    }

    [self writeCharacteristic:fullCommand forPeripheral:_connectedPeripheral];
    
}

//分包发送
- (void)sendCommandWithSubPackagePort:(NSString *)port dataStr:(NSString *)data{
    if (!_connectedPeripheral) {
        return;
    }
    _currentPort = port;
    NSLog(@"dataStr ----%@",data);
    NSString *fullCommand = [NSString stringWithFormat:@"%@%@%@$$",port,data,[self md5:data]];
    NSLog(@"full--------%@",fullCommand);
    [self sendMsgWithSubPackage:fullCommand Peripheral:_connectedPeripheral];
}

//6.
-(void)stopSearchBle{
    [_cbCM stopScan];
}

#pragma mark - CBCentralManagerDelegate   蓝牙状态
- (void)centralManagerDidUpdateState:(CBCentralManager *)central
{
    switch (central.state){
        case CBCentralManagerStatePoweredOn:
//            [self searchBleDevices];
            if ([self.bleManagerDelegate respondsToSelector:@selector(discoveredDevicesArray:withCBCentralManagerConnectState:)])
            {
                [self.bleManagerDelegate discoveredDevicesArray:_deviceArray withCBCentralManagerConnectState:@"蓝牙已打开,请连接设备"];
            }
            _powerOn=YES;
            break;
        case CBCentralManagerStateResetting:
//            [self searchBleDevices];
            if ([self.bleManagerDelegate respondsToSelector:@selector(discoveredDevicesArray:withCBCentralManagerConnectState:)])
            {
                [self.bleManagerDelegate discoveredDevicesArray:_deviceArray withCBCentralManagerConnectState:@"蓝牙复位"];
            }
            _powerOn=YES;
            break;
        case CBCentralManagerStatePoweredOff:
            _powerOn=NO;
            _connectedPeripheral=nil;
            [_deviceArray removeAllObjects];
            
            if ([self.bleManagerDelegate respondsToSelector:@selector(discoveredDevicesArray:withCBCentralManagerConnectState:)])
            {
                [self.bleManagerDelegate discoveredDevicesArray:_deviceArray withCBCentralManagerConnectState:@"请打开蓝牙"];
            }
            break;
        case CBCentralManagerStateUnauthorized:
            break;
        case CBCentralManagerStateUnknown:
            break;
        case CBCentralManagerStateUnsupported:
            break;
        default:
            break;
    }
}

#pragma mark - CBCentralManagerDelegate    已发现蓝牙设备
- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI
{
    NSLog(@"发现蓝牙设备%@--%@",peripheral.name,_deviceArray);
    if (peripheral.name.length > 0) {
//        NSString *str=[peripheral.name substringToIndex:4];
        NSString *CBper=[USER_DEFAULT objectForKey:@"per"];
        NSString *perName = [CBper stringByReplacingOccurrencesOfString:@" " withString:@""];
        NSLog(@"连接蓝牙名字---%@",perName);
        if ((![_deviceArray containsObject:peripheral])&&[perName isEqualToString:peripheral.name])
        {
            [_deviceArray addObject:peripheral];
            if (!_connectedPeripheral) {
                NSLog(@"++++++发送连接指令到%@",peripheral.name);
                [_cbCM connectPeripheral:peripheral options:nil];
            }
        }
        //代理把数组传给控制器显示
        if ([self.bleManagerDelegate respondsToSelector:@selector(discoveredDevicesArray:withCBCentralManagerConnectState:)]) {
            [self.bleManagerDelegate discoveredDevicesArray:_deviceArray withCBCentralManagerConnectState:nil];
        }
    }
}

#pragma mark - CBCentralManagerDelegate  已连接到蓝牙设备
- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral
{
    [_cbCM stopScan];
    NSLog(@"已连接到蓝牙%@",peripheral.name);
    _connectedPeripheral = peripheral;
    peripheral.delegate=self;
    [peripheral discoverServices:nil];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        if ([self.bleManagerDelegate respondsToSelector:@selector(discoveredDevicesArray:withCBCentralManagerConnectState:)]) {
            [self.bleManagerDelegate discoveredDevicesArray:_deviceArray withCBCentralManagerConnectState:[NSString stringWithFormat:@"已连接蓝牙:%@",peripheral.name]];
        }
//            if (!_isEncrypted) {
////                [self sendEncryptKey];//一定要延时，因为硬件那边的问题.
//            }
    });
}


#pragma mark - CBCentralManagerDelegate  连接失败
- (void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
{
    [_deviceArray removeAllObjects];
    _connectedPeripheral=nil;
    _isEncrypted=NO;
    [self searchBleDevices];
    if ([self.bleManagerDelegate respondsToSelector:@selector(discoveredDevicesArray:withCBCentralManagerConnectState:)]) {
        [self.bleManagerDelegate discoveredDevicesArray:_deviceArray withCBCentralManagerConnectState:@"连接失败"];
    }
}

#pragma mark - CBCentralManagerDelegate  已断开从机的链接
- (void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
{
    [_deviceArray removeAllObjects];
    _connectedPeripheral=nil;
    _isEncrypted=NO;
//    AppDelegate *app=[UIApplication sharedApplication].delegate;
    //退到后台要断开蓝牙的吧
//    if (!app.isExit) {
//        [self searchBleDevices];
//    }
    if ([self.bleManagerDelegate respondsToSelector:@selector(discoveredDevicesArray:withCBCentralManagerConnectState:)]) {
        [self.bleManagerDelegate discoveredDevicesArray:_deviceArray withCBCentralManagerConnectState:@"已断开连接"];
        
        if (_connectedPeripheral != nil){
            [_cbCM connectPeripheral:_connectedPeripheral options:nil];
        }else{
            [_cbCM scanForPeripheralsWithServices:nil options:nil];
        }
    }
    NSLog(@"断开连接,_isEncrypted=%d",_isEncrypted);
}


- (void)writeCharacteristic:(NSString *)str forPeripheral:(CBPeripheral *)p
{
    //清空返回指令
    _totalReslut = [[NSMutableString alloc] init];
    NSString *theString = [[str componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] componentsJoinedByString:@""];
    NSData *data = [theString dataUsingEncoding:(NSUTF8StringEncoding)];
    [BLEUtility writeCharacteristic:p sUUID:@"FFE0" cUUID:@"FFE1" data:data];
}

//分包发送蓝牙数据
-(void)sendMsgWithSubPackage:(NSString *)str
                  Peripheral:(CBPeripheral*)peripheral
{
    //清空返回指令
    _totalReslut = [[NSMutableString alloc] init];
    NSString *theString = [[str componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] componentsJoinedByString:@""];
    NSData *data = [theString dataUsingEncoding:(NSUTF8StringEncoding)];
    
    for (int i = 0; i < [data length]; i += BLE_SEND_MAX_LEN) {
        // 预加 最大包长度，如果依然小于总数据长度，可以取最大包数据大小
        if ((i + BLE_SEND_MAX_LEN) < [data length]) {
            NSString *rangeStr = [NSString stringWithFormat:@"%i,%i", i, BLE_SEND_MAX_LEN];
            NSData *subData = [data subdataWithRange:NSRangeFromString(rangeStr)];
            NSLog(@"%@",subData);
            [BLEUtility writeCharacteristic:peripheral sUUID:@"FFE0" cUUID:@"FFE1" data:subData];
            //根据接收模块的处理能力做相应延时
            usleep(20 * 1000);
        }
        else {
            NSString *rangeStr = [NSString stringWithFormat:@"%i,%i", i, (int)([data length] - i)];
            NSData *subData = [data subdataWithRange:NSRangeFromString(rangeStr)];
            [BLEUtility writeCharacteristic:peripheral sUUID:@"FFE0" cUUID:@"FFE1" data:subData];
            usleep(20 * 1000);
        }
    }
}


//开启订阅(开启监听数据)后才会执行下面方法-----didUpdateValueForCharacteristic
- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    NSString *result = [[NSString alloc] initWithData:characteristic.value encoding:NSUTF8StringEncoding];

    result = [result stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    result = [result stringByReplacingOccurrencesOfString:@" " withString:@""];
    result = [result stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    result = [result stringByReplacingOccurrencesOfString:@"AT" withString:@""];
    result = [result stringByReplacingOccurrencesOfString:@"-" withString:@""];
    result = [result stringByReplacingOccurrencesOfString:@"+RESET" withString:@""];
    result = [result stringByReplacingOccurrencesOfString:@"+SLEEP" withString:@""];
    if (result){
        NSLog(@"我是新数据%@", result);
    }

    if (result.length > 0){
        if ([_currentPort isEqualToString:@"02010500"]){
            //owner绑定
            [self bingOwnerWithStuta:result];
        }else if ([_currentPort isEqualToString:@"01010100"]){
            //时间初始化
            [self timeSetupWithResult:result];
        }else if ([_currentPort isEqualToString:@"03030700"]){
            //绑定user
            [self bingUserWithStuta:result];
        }else if ([_currentPort isEqualToString:@"04020600"]){
            [self openLockIsSuccess:result];
        }else if ([_currentPort isEqualToString:@"07040100"]){
            //时间同步检测
            [self checkIsTimeSynchronization:result];
        }else if([_currentPort isEqualToString:@"07040102"]){
            //时间同步
            [self timeSynchronization:result];
        }else if([_currentPort isEqualToString:@"06050400"]){
            //删除User
            [self deleteUser:result];
        }else if([_currentPort isEqualToString:@"05060500"]){
            //更改 Owner 权限
            [self resetOwnerAuth:result];
        }
    }else{
        return;
    }

}

//开启订阅(开启监听数据)后才会执行下面方法
- (void)peripheral:(CBPeripheral *)peripheral didUpdateNotificationStateForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    NSLog(@"收到蓝牙「FFE1特征」%@发出的数据:%@",characteristic.UUID.UUIDString, [[NSString alloc] initWithData:characteristic.value encoding:NSUTF8StringEncoding]);
//    unsigned char data[characteristic.value.length];
//    [characteristic.value getBytes:&data length:20];
}

#pragma mark - CBPeripheralDelegate   已搜索到Services
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error
{
    for (CBService *s in peripheral.services) {
        [peripheral discoverCharacteristics:nil forService:s];
    }
}

#pragma mark - CBPeripheralDelegate   已搜索到Characteristics
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error
{
    //开启订阅(开启监听数据)
    [BLEUtility setNotificationForCharacteristic:_connectedPeripheral sUUID:@"FFE0" cUUID:@"FFE1" enable:YES];
    [BLEUtility readCharacteristic:_connectedPeripheral sUUID:@"FFE0" cUUID:@"FFE1"];
    
}

#pragma mark----结果集处理
//绑定owener
- (void)bingOwnerWithStuta:(NSString *)result{
    
    [_totalReslut appendString:result];
    if (_totalReslut.length >= 16){
        NSInteger okResult = [[_totalReslut substringWithRange:NSMakeRange(9, 7)] integerValue];
//        NSLog(@"owner绑定结果okResult-------%zd----%@",okResult,_totalReslut);
        switch (okResult) {
            case 2010600:
                if (_totalReslut.length >= 64){
                    NSLog(@"总结果1 ---%@", _totalReslut);
                    NSString *backStr = [_totalReslut substringWithRange:NSMakeRange(16, 32)];
                    if ([self.bleManagerDelegate respondsToSelector:@selector(returnWithData:isSucceed:backData:)]) {
                        [self.bleManagerDelegate returnWithData:@"绑定成功" isSucceed:YES backData:backStr];
                    }
                    [_totalReslut deleteCharactersInRange:NSMakeRange(0, _totalReslut.length)];
                    NSLog(@"总结果2 ---%@", _totalReslut);
                }
                break;
            case 2010601:
                if (_totalReslut.length >= 32){
                    NSLog(@"总结果1 ---%@", _totalReslut);
                    if ([self.bleManagerDelegate respondsToSelector:@selector(returnWithData:isSucceed:backData:)]) {
                        [self.bleManagerDelegate returnWithData:@"有相同owner，绑定失败" isSucceed:NO backData:@""];
                    }
                    [_totalReslut deleteCharactersInRange:NSMakeRange(0, _totalReslut.length)];
                    NSLog(@"总结果2 ---%@", _totalReslut);
                }
                break;
            case 2010602:
                if (_totalReslut.length >= 32){
                    NSLog(@"总结果1 ---%@", _totalReslut);
                    if ([self.bleManagerDelegate respondsToSelector:@selector(returnWithData:isSucceed:backData:)]) {
                        [self.bleManagerDelegate returnWithData:@"A值错误，绑定失败" isSucceed:NO backData:@""];
                    }
                    [_totalReslut deleteCharactersInRange:NSMakeRange(0, _totalReslut.length)];
                    NSLog(@"总结果2 ---%@", _totalReslut);
                }
                break;
            case 2010603:
                if (_totalReslut.length >= 32){
                    NSLog(@"总结果1 ---%@", _totalReslut);
                    if ([self.bleManagerDelegate respondsToSelector:@selector(returnWithData:isSucceed:backData:)]) {
                        [self.bleManagerDelegate returnWithData:@"消息验证失败" isSucceed:NO backData:@""];
                    }
                    [_totalReslut deleteCharactersInRange:NSMakeRange(0, _totalReslut.length)];
                    NSLog(@"总结果2 ---%@", _totalReslut);
                }
                break;
            default:
                break;
        }
    }
}

- (void)bingUserWithStuta:(NSString *)result{
    [_totalReslut appendString:result];
    
    if (_totalReslut.length >= 16){
        NSInteger okResult = [[_totalReslut substringWithRange:NSMakeRange(9, 7)] integerValue];
        switch (okResult) {
            case 3030800:
                if (_totalReslut.length >= 48){
                    NSLog(@"总结果1 ---%@", _totalReslut);
                    NSString *backStr = [_totalReslut substringWithRange:NSMakeRange(16, 16)];
                    if ([self.bleManagerDelegate respondsToSelector:@selector(returnWithData:isSucceed:backData:)]) {
                        [self.bleManagerDelegate returnWithData:@"user绑定成功" isSucceed:YES backData:backStr];
                    }
                    [_totalReslut deleteCharactersInRange:NSMakeRange(0, _totalReslut.length)];
                    NSLog(@"总结果2 ---%@", _totalReslut);
                }
                break;
            case 3030801:
                if (_totalReslut.length >= 32){
                    NSLog(@"总结果1 ---%@", _totalReslut);
                    if ([self.bleManagerDelegate respondsToSelector:@selector(returnWithData:isSucceed:backData:)]) {
                        [self.bleManagerDelegate returnWithData:@"user绑定失败，用户已存在" isSucceed:NO backData:@""];
                        [SVProgressHUD showErrorWithStatus:@"user绑定失败，用户已存在"];
                    }
                    [_totalReslut deleteCharactersInRange:NSMakeRange(0, _totalReslut.length)];
                    NSLog(@"总结果2 ---%@", _totalReslut);
                }
                break;
            case 3030802:
                if (_totalReslut.length >= 32){
                    NSLog(@"总结果1 ---%@", _totalReslut);
                    if ([self.bleManagerDelegate respondsToSelector:@selector(returnWithData:isSucceed:backData:)]) {
                        [self.bleManagerDelegate returnWithData:@"绑定失败，用户已存满" isSucceed:NO backData:@""];
                        [SVProgressHUD showErrorWithStatus:@"绑定失败，该锁用户已存满"];
                    }
                    [_totalReslut deleteCharactersInRange:NSMakeRange(0, _totalReslut.length)];
                    NSLog(@"总结果2 ---%@", _totalReslut);
                }
                break;
            case 3030803:
                if (_totalReslut.length >= 32){
                    NSLog(@"总结果1 ---%@", _totalReslut);
                    if ([self.bleManagerDelegate respondsToSelector:@selector(returnWithData:isSucceed:backData:)]) {
                        [self.bleManagerDelegate returnWithData:@"消息验证失败" isSucceed:NO backData:@""];
                        [SVProgressHUD showErrorWithStatus:@"消息验证失败,请再发一次"];
                        
                    }
                    [_totalReslut deleteCharactersInRange:NSMakeRange(0, _totalReslut.length)];
                    NSLog(@"总结果2 ---%@", _totalReslut);
                }
                break;
            default:
                break;
        }
    }
    
}

//更改 Owner 权限
- (void)resetOwnerAuth:(NSString *)result{
    
    [_totalReslut appendString:result];
    if (_totalReslut.length >= 16){
        NSInteger okResult = [[_totalReslut substringWithRange:NSMakeRange(9, 7)] integerValue];
//        NSLog(@"owner绑定结果okResult-------%zd----%@",okResult,_totalReslut);
        switch (okResult) {
            case 5060600:
                if (_totalReslut.length >= 64){
                    NSLog(@"总结果1 ---%@", _totalReslut);
                    NSString *backStr = [_totalReslut substringWithRange:NSMakeRange(16, 32)];
                    if ([self.bleManagerDelegate respondsToSelector:@selector(returnWithData:isSucceed:backData:)]) {
                        [self.bleManagerDelegate returnWithData:@"更改成功" isSucceed:YES backData:backStr];
                    }
                    [_totalReslut deleteCharactersInRange:NSMakeRange(0, _totalReslut.length)];
                    NSLog(@"总结果2 ---%@", _totalReslut);
                }
                break;
            case 5060601:
                if (_totalReslut.length >= 32){
                    NSLog(@"总结果1 ---%@", _totalReslut);
                    if ([self.bleManagerDelegate respondsToSelector:@selector(returnWithData:isSucceed:backData:)]) {
                        [self.bleManagerDelegate returnWithData:@"更改失败,A值错误" isSucceed:NO backData:@""];
                    }
                    [_totalReslut deleteCharactersInRange:NSMakeRange(0, _totalReslut.length)];
                    NSLog(@"总结果2 ---%@", _totalReslut);
                }
                break;
            case 5060602:
                if (_totalReslut.length >= 32){
                    NSLog(@"总结果1 ---%@", _totalReslut);
                    if ([self.bleManagerDelegate respondsToSelector:@selector(returnWithData:isSucceed:backData:)]) {
                        [self.bleManagerDelegate returnWithData:@"消息验证失败" isSucceed:NO backData:@""];
                    }
                    [_totalReslut deleteCharactersInRange:NSMakeRange(0, _totalReslut.length)];
                    NSLog(@"总结果2 ---%@", _totalReslut);
                }
                break;
            default:
                break;
        }
    }
  
}

//初始化时间
- (void)timeSetupWithResult:(NSString *)result{
    [_totalReslut appendString:result];
    if (_totalReslut.length >= 32){
        NSLog(@"总结果1 ---%@", _totalReslut);
        NSString *backStr = [_totalReslut substringWithRange:NSMakeRange(8, 8)];
        if ([backStr isEqualToString:@"01010300"]){
            if ([self.bleManagerDelegate respondsToSelector:@selector(returnWithData:isSucceed:backData:)]) {
                [self.bleManagerDelegate returnWithData:@"初始化成功" isSucceed:YES backData:@""];
            }
        }else if([backStr isEqualToString:@"01010200"]){
            if ([self.bleManagerDelegate respondsToSelector:@selector(returnWithData:isSucceed:backData:)]) {
                [self.bleManagerDelegate returnWithData:@"写入成功" isSucceed:YES backData:@""];
            }
        }else if([backStr isEqualToString:@"01010201"]){
            if ([self.bleManagerDelegate respondsToSelector:@selector(returnWithData:isSucceed:backData:)]) {
                [self.bleManagerDelegate returnWithData:@"写入失败" isSucceed:NO backData:@""];
            }
        }else{
            if ([self.bleManagerDelegate respondsToSelector:@selector(returnWithData:isSucceed:backData:)]) {
                [self.bleManagerDelegate returnWithData:@"校验失败" isSucceed:NO backData:@""];
            }
        }
        [_totalReslut deleteCharactersInRange:NSMakeRange(0, _totalReslut.length)];
        NSLog(@"总结果2 ---%@", _totalReslut);
    }
}

//时间同步检测结果集
- (void)checkIsTimeSynchronization:(NSString *)result
{
    [_totalReslut appendString:result];
    if (_totalReslut.length >= 32){
        NSLog(@"总结果1 ---%@", _totalReslut);
        NSString *backStr = [_totalReslut substringWithRange:NSMakeRange(8, 8)];
        if ([backStr isEqualToString:@"07040200"]){
            if ([self.bleManagerDelegate respondsToSelector:@selector(returnWithData:isSucceed:backData:)]) {
                [self.bleManagerDelegate returnWithData:@"需要时间同步" isSucceed:YES backData:[BleManager getCurrentTimeStr]];
            }
        }else if ([backStr isEqualToString:@"07040201"]){
            if ([self.bleManagerDelegate respondsToSelector:@selector(returnWithData:isSucceed:backData:)]) {
                [self.bleManagerDelegate returnWithData:@"不需要时间同步" isSucceed:NO backData:@""];
            }
        }else{
            if ([self.bleManagerDelegate respondsToSelector:@selector(returnWithData:isSucceed:backData:)]) {
                [self.bleManagerDelegate returnWithData:@"校验失败" isSucceed:NO backData:@""];
            }
        }
        [_totalReslut deleteCharactersInRange:NSMakeRange(0, _totalReslut.length)];
        NSLog(@"总结果2 ---%@", _totalReslut);
    }
}

//确认时间同步
- (void)timeSynchronization:(NSString *)result{
    
    [_totalReslut appendString:result];
    if (_totalReslut.length >= 32){
        NSLog(@"总结果1 ---%@", _totalReslut);
        NSString *backStr = [_totalReslut substringWithRange:NSMakeRange(8, 8)];
        if ([backStr isEqualToString:@"07040300"]){
            if ([self.bleManagerDelegate respondsToSelector:@selector(returnWithData:isSucceed:backData:)]) {
                [self.bleManagerDelegate returnWithData:@"接收时间成功" isSucceed:YES backData:@""];
            }
        }else if ([backStr isEqualToString:@"07040301"]){
            if ([self.bleManagerDelegate respondsToSelector:@selector(returnWithData:isSucceed:backData:)]) {
                [self.bleManagerDelegate returnWithData:@"接收时间失败，即校验失败" isSucceed:NO backData:@""];
            }
        }
        [_totalReslut deleteCharactersInRange:NSMakeRange(0, _totalReslut.length)];
        NSLog(@"总结果2 ---%@", _totalReslut);
    }
    
}


//开锁结果处理
- (void)openLockIsSuccess:(NSString *)result{
    
    [_totalReslut appendString:result];
    
    if (_totalReslut.length >= 16){
        NSInteger okResult = [[_totalReslut substringWithRange:NSMakeRange(9, 7)] integerValue];
        switch (okResult) {
            case 4020700:
                if (_totalReslut.length >= 46){
                    NSLog(@"总结果1 ---%@", _totalReslut);
                    NSString *onceResult = [_totalReslut substringWithRange:NSMakeRange(16, 8)];
                    if ([onceResult isEqualToString:@"04020709"]){
                        NSString *power = [_totalReslut substringWithRange:NSMakeRange(24, 6)];
                        if ([self.bleManagerDelegate respondsToSelector:@selector(returnWithData:isSucceed:backData:)]) {
                            [self.bleManagerDelegate returnWithData:@"开门成功" isSucceed:YES backData:power];
                        }
                        [_totalReslut deleteCharactersInRange:NSMakeRange(0, _totalReslut.length)];
                        NSLog(@"总结果2 ---%@", _totalReslut);
                    }else if([onceResult isEqualToString:@"04020708"]){
                        if ([self.bleManagerDelegate respondsToSelector:@selector(returnWithData:isSucceed:backData:)]) {
                            [self.bleManagerDelegate returnWithData:@"时间被重置" isSucceed:NO backData:@""];
                        }
                        [_totalReslut deleteCharactersInRange:NSMakeRange(0, _totalReslut.length)];
                        NSLog(@"总结果2 ---%@", _totalReslut);
                    }else if([onceResult isEqualToString:@"04020707"]){
                        if ([self.bleManagerDelegate respondsToSelector:@selector(returnWithData:isSucceed:backData:)]) {
                            [self.bleManagerDelegate returnWithData:@"时间需要校正" isSucceed:NO backData:@""];
                        }
                        [_totalReslut deleteCharactersInRange:NSMakeRange(0, _totalReslut.length)];
                        NSLog(@"总结果2 ---%@", _totalReslut);
                    }else if([onceResult isEqualToString:@"04020706"]){
                        if ([self.bleManagerDelegate respondsToSelector:@selector(returnWithData:isSucceed:backData:)]) {
                            [SVProgressHUD showErrorWithStatus:@"时间已失效"];
                            [self.bleManagerDelegate returnWithData:@"当前用户有效时间已过期" isSucceed:NO backData:@""];
                        }
                        [_totalReslut deleteCharactersInRange:NSMakeRange(0, _totalReslut.length)];
                        NSLog(@"总结果2 ---%@", _totalReslut);
                    }else{
                        if ([self.bleManagerDelegate respondsToSelector:@selector(returnWithData:isSucceed:backData:)]) {
                            [self.bleManagerDelegate returnWithData:@"用户验证成功，动态密码错误" isSucceed:NO backData:@""];
                        }
                        [_totalReslut deleteCharactersInRange:NSMakeRange(0, _totalReslut.length)];
                        NSLog(@"总结果2 ---%@", _totalReslut);
                    }
                }
                break;
            case 4020701:
                if (_totalReslut.length >= 46){
                    NSLog(@"总结果1 ---%@", _totalReslut);
                    NSString *power = [_totalReslut substringWithRange:NSMakeRange(24, 6)];
                    if ([self.bleManagerDelegate respondsToSelector:@selector(returnWithData:isSucceed:backData:)]) {
                        [self.bleManagerDelegate returnWithData:@"开门失败" isSucceed:NO backData:power];
                    }
                    [_totalReslut deleteCharactersInRange:NSMakeRange(0, _totalReslut.length)];
                    NSLog(@"总结果2 ---%@", _totalReslut);
                }
                break;
            case 4020702:
                if (_totalReslut.length >= 33){
                    NSLog(@"总结果1 ---%@", _totalReslut);
                    if ([self.bleManagerDelegate respondsToSelector:@selector(returnWithData:isSucceed:backData:)]) {
                        [self.bleManagerDelegate returnWithData:@"消息验证失败" isSucceed:NO backData:@""];
                    }
                    [_totalReslut deleteCharactersInRange:NSMakeRange(0, _totalReslut.length)];
                    NSLog(@"总结果2 ---%@", _totalReslut);
                }
                break;
            default:
                [SVProgressHUD showErrorWithStatus:@"非法值"];
                break;
        }
    }else{
        if ([_totalReslut isEqualToString:@"0123456789$$"]){
            [SVProgressHUD showErrorWithStatus:@"该指令超出门锁接受范围"];
        }
    }
    
}


//删除user接口
- (void)deleteUser:(NSString *)result
{
    [_totalReslut appendString:result];
    if (_totalReslut.length >= 32){
        NSLog(@"总结果1 ---%@", _totalReslut);
        NSString *backStr = [_totalReslut substringWithRange:NSMakeRange(8, 8)];
        if ([backStr isEqualToString:@"06050500"]){
            if ([self.bleManagerDelegate respondsToSelector:@selector(returnWithData:isSucceed:backData:)]) {
                [self.bleManagerDelegate returnWithData:@"删除成功" isSucceed:YES backData:@""];
            }
        }else if ([backStr isEqualToString:@"06050501"]){
            if ([self.bleManagerDelegate respondsToSelector:@selector(returnWithData:isSucceed:backData:)]) {
                [self.bleManagerDelegate returnWithData:@"删除失败，擦除Flash失败" isSucceed:NO backData:@""];
            }
        }else if ([backStr isEqualToString:@"06050502"]){
            if ([self.bleManagerDelegate respondsToSelector:@selector(returnWithData:isSucceed:backData:)]) {
                [self.bleManagerDelegate returnWithData:@"删除失败,不存在该用户" isSucceed:NO backData:@""];
            }
        }else{
            if ([self.bleManagerDelegate respondsToSelector:@selector(returnWithData:isSucceed:backData:)]) {
                [self.bleManagerDelegate returnWithData:@"消息验证失败" isSucceed:NO backData:@""];
            }
        }
        [_totalReslut deleteCharactersInRange:NSMakeRange(0, _totalReslut.length)];
        NSLog(@"总结果2 ---%@", _totalReslut);
    }
}



#pragma mark----密码相关
- (NSString *) md5:(NSString *) input {
    const char *cStr = [input UTF8String];
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5( cStr, strlen(cStr), digest ); // This is the md5 call
    
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", digest[i]];
    
    NSString *reslut = [output substringWithRange:NSMakeRange(8, 16)];
    
    return  reslut;
}


+ (NSString *)getCurrentTimeStr{
    NSDate  *date = [NSDate date];
    NSDateFormatter *foratter = [[NSDateFormatter alloc] init];
    foratter.timeZone = [NSTimeZone timeZoneWithAbbreviation:@"GMT+0800"];
    [foratter setDateFormat:@"yyyyMMddHHmmss"];
    NSString *dateStr = [foratter stringFromDate:date];
    return dateStr;
}

//-(void)sendEncryptKey{
//    NSLog(@"_encryptKey--%@",_encryptKey);
//    //发送通信密码
//    [self writeCharacteristic:[NSString stringWithFormat:@"FEFE03E801%@EFEF", _encryptKey] forPeripheral:_connectedPeripheral];
//}

//- (NSString *)encrypt:(NSString *)str
//{
//    if ([[str substringWithRange:NSMakeRange(4, 4)] isEqualToString:@"03E8"] || ([str length] <= 12)) {
//        return str;
//    }
//
//    str = [str stringByReplacingOccurrencesOfString:@" " withString:@""];
//    str = [str stringByReplacingOccurrencesOfString:@"\n" withString:@""];
//
//    NSUInteger  startIndex = 8;
//    NSUInteger  endIndex = [str length] - 12 + startIndex;
//    // 位置
//    NSRange range = NSMakeRange(startIndex, endIndex - startIndex);
//    // 有效数据
//    NSString *dataStr = [str substringWithRange:range];
//    // 对有效位加密
//    NSString *encryptStr = [XOREncryptAndDecrypt encryptForPlainText:dataStr withSecretKey:_encryptKey];
//    // 把有效数据替换为加密后的
//    str = [str stringByReplacingCharactersInRange:range withString:encryptStr];
//    return str;
//}

@end
