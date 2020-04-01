//
//  BleManager.h
//  BadyBlueSwift
//
//  Created by ox o on 2017/8/4.
//  Copyright © 2017年 ox o. All rights reserved.

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>

@protocol BleManagerDelegate<NSObject>
@optional

//返回已经搜索到的蓝牙设备数组
-(void)discoveredDevicesArray:(NSMutableArray *)devicesArr withCBCentralManagerConnectState:(NSString *)connectState;

//返回数据结果
-(void)returnWithData:(NSString *)data isSucceed:(BOOL)succeed backData:(NSString *)backData;

@end

@interface BleManager : NSObject

+(instancetype)sharedManager;
//1.搜索蓝牙设备
-(void)searchBleDevices;
//2.获取连接中的设备
- (CBPeripheral *)connectedDevice;
//3.断开一个设备
- (void)disConnectDevice:(CBPeripheral *)aCBPeripheral;
//4.连接一个指定设备
- (void)connectDevice:(CBPeripheral *)aCBPeripheral;
//5.发送指令
/**
    *port 指令接口   *datastr 数据
 */
-(void)sendCommandWithPort:(NSString *)port dataStr:(NSString *)data;
/** 发送完整指令 */
-(void)sendCommand:(NSString *)command;
//发送分包发送指令
- (void)sendCommandWithSubPackagePort:(NSString *)port dataStr:(NSString *)data;
//6.
-(void)stopSearchBle;

@property(nonatomic,assign) BOOL powerOn; //蓝牙是否打开
@property(nonatomic,strong) NSMutableArray *deviceArray;
@property(nonatomic,strong) CBCentralManager *cbCM;
@property(nonatomic,assign) BOOL isEncrypted;
@property (nonatomic,weak) id <BleManagerDelegate> bleManagerDelegate;

@end
