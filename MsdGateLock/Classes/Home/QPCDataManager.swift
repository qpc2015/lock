//
//  QPCDataManager.swift
//  FMDB
//
//  Created by ox o on 2017/8/19.
//  Copyright © 2017年 ox o. All rights reserved.
//

import UIKit


class QPCDataManager: NSObject {

    //定义一个单例对象（类对象）
    static let shareManager = QPCDataManager()
    let databaseFileName = "/Documents/lock.sqlite" //数据库名
    var pathToDatabase: String!  //数据库路径
    //定义管理数据库的对象
    var fmdb:FMDatabase!
    //锁列表表名
    let lockListTableName = "t_lock"
    //记录开锁日志 表名
    let lockLogTableName = "t_lockLog"
    //本地开锁日志 表名
    let localOpenTableName = "t_localOpen"
    //线程锁,通过加锁和解锁来保证所做操作数据的安全性
    let lock = NSLock()
    
    //1.重写父类的构造方法
    override init() {
        pathToDatabase = NSHomeDirectory().appendingFormat(databaseFileName)
        
        print("数据库的路径===" + pathToDatabase)
    }

    
    func openDatabase() -> Bool {
        if fmdb == nil {
            if FileManager.default.fileExists(atPath: pathToDatabase) {
                fmdb = FMDatabase(path: pathToDatabase)
            }
        }
        if fmdb != nil {
            if fmdb.open() {
                return true
            }
        }
        return false
    }
    
    //判断数据库中是否有当前数据(查找一条数据)
    func isHasDataInTable(tableName:String,lockID:String) -> Bool {
        
        let isHas = "select * from \(tableName) where lockID = ?"
        if openDatabase(){
            do{
                let set = try fmdb.executeQuery(isHas, values: [lockID])
                //查找当前行，如果数据存在，则接着查找下一行
                if set.next() {
                    return true
                }else {
                    return false
                }
            }catch {
                print(fmdb.lastErrorMessage())
            }
            fmdb.close()
        }
        
        return true
    }
    
    //删除某张表的所有数据
    func deleteTabelAllData(_ tableName:String){
        if openDatabase(){
            let deleteSql = "DELETE FROM \(tableName)"
            //更新数据库
            do {
                try fmdb.executeUpdate(deleteSql, values: nil)
            }catch {
                print(fmdb.lastErrorMessage())
            }
            fmdb.close()
        }
    }
 
}

//锁列表相关
extension QPCDataManager{
    //创建锁表
    func createHomeListTable() -> Bool{
        var creted = false
        if !FileManager.default.fileExists(atPath: pathToDatabase) {
            //传入路径，初始化数据库，若该路径没有对应的文件，则会创建此文件
            fmdb = FMDatabase(path: pathToDatabase!) //创建数据库
            if fmdb != nil {
                if fmdb.open() { //打开
                    /*
                     // 数据库中常见的几种类型
                     @"TEXT" //文本
                     @"INTEGER" //int long integer ...
                     @"REAL" //浮点
                     @"BLOB" //data
                     */
                    let createSql = "create table if not exists \(lockListTableName)(id INTEGER PRIMARY KEY AUTOINCREMENT, userId TEXT, lockId TEXT UNIQUE,remark TEXT,roleType INTEGER, starttime TEXT,endtime TEXT,bluetoothMac TEXT, bluetoothName TEXT,authstatus INTEGER DEFAULT 0,mainState INTEGER,backState INTEGER,battery TEXT)"
                    //执行sel语句进行数据库的创建
                    do {
                        try fmdb.executeUpdate(createSql, values: nil)
                    }catch {
                        print(fmdb.lastErrorMessage())
                    }
                    creted = true
                    fmdb.close()
                }
                else {
                    print("Could not open the database.")
                }
            }
        }
        return creted
    }
    
    //增加一条门锁信息
    func insertDataWith(model:UserLockListResp){
        //加锁操作
        lock.lock()
        if openDatabase(){
            //sel语句
            //(?,?)表示需要传的值
            let insetSql = "insert into \(lockListTableName)(userId, lockId, remark, roleType, starttime, endtime, bluetoothMac, bluetoothName, authstatus, mainState, backState, battery) values(?,?,?,?,?,?,?,?,?,?,?,?)"
            //更新数据库
            do {
                try fmdb.executeUpdate(insetSql, values: [model.userId,model.lockId,model.remark,model.roleType,model.starttime,model.endtime,model.bluetoothMac!,model.bluetoothName!,model.authstatus,model.mainState,model.backState,model.battery])
            }catch {
                print(fmdb.lastErrorMessage())
            }
            
            fmdb.close()
        }
        //解锁
        lock.unlock()
    }
    
    //增加一组门锁信息
    func insertTableWithModelArr(model:[UserLockListResp]) {
        for lock in model{
            self.insertDataWith(model: lock)
        }
    }
    
    //删处一条门锁信息
    func deleteDataWith(model:UserLockListResp) {
        //加锁操作
        lock.lock()
        //sel语句
        if openDatabase(){
            //where表示需要删除的对象的索引，是对应的条件
            let deleteSql = "delete from \(lockListTableName) where lockID = ?"
            //更新数据库
            do{
                try fmdb.executeUpdate(deleteSql, values: [model.lockId ?? ""])
            }catch {
                print(fmdb.lastErrorMessage())
            }
            fmdb.close()
        }
        //解锁
        lock.unlock()
    }
    
    //修改一条门锁信息
//    func updateDataWith(model:UserLockListResp,lockID:String) {
//
//        //加锁
//        lock.lock()
//        //where id
//        if openDatabase(){
//            let updateSql = "update \(lockListTableName) set userInviteStatus = ? where lockID = ?"
//            //更新数据库
//            do{
//                try fmdb.executeUpdate(updateSql, values: [model.authstatus ?? 0,lockID])
//            }catch {
//                print(fmdb.lastErrorMessage())
//            }
//            fmdb.close()
//        }
//
//        //解锁
//        lock.unlock()
//    }
    
    //查询其中对应id锁信息
    func fetchLockData(lockID:String) -> LockListResultModel?{
        
        //加锁
        lock.lock()
        var lockM : LockListResultModel?
        //where id
        if openDatabase(){
            let fetchLockSql = "select * from \(lockListTableName) where lockID = ?"
            //更新数据库
            do{
                let lockArr =  try fmdb.executeQuery(fetchLockSql, values: [lockID])
                if lockArr.next(){
                    lockM = LockListResultModel()
                    //给字段赋值
                    lockM?.userId = lockArr.string(forColumn: "userId")
                    lockM?.lockId = lockArr.string(forColumn: "lockId")!
                    lockM?.remark = lockArr.string(forColumn: "remark")
                    lockM?.roleType = Int(lockArr.int(forColumn: "roleType"))
                    lockM?.starttime = lockArr.string(forColumn: "starttime")
                    lockM?.endtime = lockArr.string(forColumn: "endtime")
                    lockM?.bluetoothName = lockArr.string(forColumn: "bluetoothName")
                    lockM?.bluetoothMac = lockArr.string(forColumn: "bluetoothMac")
                    lockM?.authstatus = Int(lockArr.int(forColumn: "authstatus"))
                    lockM?.mainState = Int(lockArr.int(forColumn: "mainState"))
                    lockM?.backState = Int(lockArr.int(forColumn: "backState"))
                    lockM?.battery = lockArr.string(forColumn: "battery")
                }
            }catch {
                print(fmdb.lastErrorMessage())
            }
            fmdb.close()
        }
        
        //解锁
        lock.unlock()
        
        return lockM
    }
    
    //查找全部锁列表
    func fetchAllData() ->[LockListResultModel]?{
        //用于承接所有数据的临时数组
        var tempArray = [LockListResultModel]()
        
        if openDatabase(){
            let fetchSql = "select * from \(lockListTableName)"
            
            do {
                let lockArr = try fmdb.executeQuery(fetchSql, values: nil)
                //循环遍历结果
                while lockArr.next() {
                    let model = LockListResultModel()
                    //给字段赋值
                    model.userId = lockArr.string(forColumn: "userId")
                    model.lockId = lockArr.string(forColumn: "lockId")!
                    model.remark = lockArr.string(forColumn: "remark")
                    model.roleType = Int(lockArr.int(forColumn: "roleType"))
                    model.starttime = lockArr.string(forColumn: "starttime")
                    model.endtime = lockArr.string(forColumn: "endtime")
                    model.bluetoothName = lockArr.string(forColumn: "bluetoothName")
                    model.bluetoothMac = lockArr.string(forColumn: "bluetoothMac")
                    model.authstatus = Int(lockArr.int(forColumn: "authstatus"))
                    model.mainState =  Int(lockArr.int(forColumn: "mainState"))
                    model.backState = Int(lockArr.int(forColumn: "backState"))
                    model.battery = lockArr.string(forColumn: "battery")
                    
                    tempArray.append(model)
                }
            }catch {
                print(fmdb.lastErrorMessage())
            }
            fmdb.close()
        }
        
        return tempArray
    }
    
}

//本地开门记录缓存
extension QPCDataManager{
    //创建本地开门
    func createLocalOpenLogTable() -> Bool{
        var creted = false
        if !FileManager.default.fileExists(atPath: pathToDatabase) {
            //传入路径，初始化数据库，若该路径没有对应的文件，则会创建此文件
            fmdb = FMDatabase(path: pathToDatabase!) //创建数据库
            if fmdb != nil {
                // Open the database.
                if fmdb.open() { //打开
                    
                    let createSql = "create table if not exists \(localOpenTableName)(id INTEGER PRIMARY KEY AUTOINCREMENT, lockId TEXT NOT NULL, logStatus INTEGER DEFAULT 1, logTime TEXT, memberName TEXT)"
                    //执行sel语句进行数据库的创建
                    do {
                        try fmdb.executeUpdate(createSql, values: nil)
                    }catch {
                        print(fmdb.lastErrorMessage())
                    }
                    creted = true
                    fmdb.close()
                }
                else {
                    print("Could not open the database.")
                }
            }
        }else{
            if openDatabase(){ //打开
                let createSql = "create table if not exists \(localOpenTableName)(id INTEGER PRIMARY KEY AUTOINCREMENT, lockId TEXT NOT NULL, logStatus INTEGER DEFAULT 1, logTime TEXT, memberName TEXT)"
                //执行sel语句进行数据库的创建
                do {
                    try fmdb.executeUpdate(createSql, values: nil)
                }catch {
                    print(fmdb.lastErrorMessage())
                }
                creted = true
                fmdb.close()
            }
            else {
                print("Could not open the database.")
            }
        }
        return creted
    }
    
    //增加一条门锁信息
    func insertLocalOpenLogWith(lockID:String,model:OpenLockList){
        //加锁操作
        lock.lock()
        if openDatabase(){
            //sel语句
            //(?,?)表示需要传的值
            let insetSql = "insert into \(localOpenTableName)(lockId, logStatus, logTime, memberName) values(?,?,?,?)"
            //更新数据库
            do {
                try fmdb.executeUpdate(insetSql, values: [lockID,model.logStatus,model.logTime,model.memberName])
            }catch {
                print(fmdb.lastErrorMessage())
            }
            
            fmdb.close()
        }
        //解锁
        lock.unlock()
    }
    
    //增加一组
    func insertLocalOpenTableWithModelArr(lockID:String,modelArr:[OpenLockList]) {
        for lockModel in modelArr{
            self.insertLocalOpenLogWith(lockID: lockID, model: lockModel)
        }
    }
    
    //删处一条门锁信息
    func deleteLocalOpenWith(lockID:String) {
        //加锁操作
        lock.lock()
        //sel语句
        if openDatabase(){
            //where表示需要删除的对象的索引，是对应的条件
            let deleteSql = "delete from \(localOpenTableName) where lockID = ?"
            //更新数据库
            do{
                try fmdb.executeUpdate(deleteSql, values: [lockID ?? ""])
            }catch {
                print(fmdb.lastErrorMessage())
            }
            fmdb.close()
        }
        //解锁
        lock.unlock()
    }
    
    //查找全部缓存
    func fetchAllLocalOpenData() ->[ThreeParam<String,Int,String>]?{
        //用于承接所有数据的临时数组
        var tempArray = [ThreeParam<String,Int,String>]()
        
        if openDatabase(){
            let fetchSql = "select * from \(localOpenTableName)"
            do {
                let lockArr = try fmdb.executeQuery(fetchSql, values: nil)
                //循环遍历结果
                while lockArr.next() {
                    //给字段赋值
                    let memberName = lockArr.string(forColumn: "memberName")
                    let openStatu = Int(lockArr.int(forColumn: "openStatu"))
                    let logTime = lockArr.string(forColumn: "logTime")
                    let model = ThreeParam.init(p1: memberName!, p2: openStatu, p3: logTime!)
                    QPCLog("我是缓存的开门记录--\(memberName)--\(openStatu)--\(logTime)")
                    tempArray.append(model)
                }
            }catch {
                print(fmdb.lastErrorMessage())
            }
            fmdb.close()
        }
        
        return tempArray
    }
    
}


//上传开门记录相关
extension QPCDataManager{
    //创建开门记录表
    func createLockLogTable() -> Bool{
        var creted = false
        if !FileManager.default.fileExists(atPath: pathToDatabase) {
            //传入路径，初始化数据库，若该路径没有对应的文件，则会创建此文件
            fmdb = FMDatabase(path: pathToDatabase!) //创建数据库
            if fmdb != nil {
                // Open the database.
                if fmdb.open() { //打开

                    let createSql = "create table if not exists \(lockLogTableName)(id INTEGER PRIMARY KEY AUTOINCREMENT, lockId TEXT NOT NULL,openStatu INTEGER DEFAULT 1,time TEXT)"
                    //执行sel语句进行数据库的创建
                    do {
                        try fmdb.executeUpdate(createSql, values: nil)
                    }catch {
                        print(fmdb.lastErrorMessage())
                    }
                    creted = true
                    fmdb.close()
                }
                else {
                    print("Could not open the database.")
                }
            }
        }else{
            if openDatabase(){ //打开
                let createSql = "create table if not exists \(lockLogTableName)(id INTEGER PRIMARY KEY AUTOINCREMENT, lockId TEXT NOT NULL,openStatu INTEGER DEFAULT 1,time TEXT)"
                //执行sel语句进行数据库的创建
                do {
                    try fmdb.executeUpdate(createSql, values: nil)
                }catch {
                    print(fmdb.lastErrorMessage())
                }
                creted = true
                fmdb.close()
            }
            else {
                print("Could not open the database.")
            }
        }
        return creted
    }
    
    //增加一条开门记录
    func insertOpenRecordWith(lockid:String,openStatu:Int,time:String){
        //加锁操作
        lock.lock()
        if openDatabase(){
            //sel语句
            //(?,?)表示需要传的值
            let insetSql = "insert into \(lockLogTableName)(lockId, openStatu,time) values(?,?,?)"
            //更新数据库
            do {
                try fmdb.executeUpdate(insetSql, values: [lockid,openStatu,time])
            }catch {
                print(fmdb.lastErrorMessage())
            }
            
            fmdb.close()
        }
        //解锁
        lock.unlock()
    }
    
    
    //查找全部开门记录
    func fetchAllOpenLockData() ->[ThreeParam<String,Int,String>]?{
        //用于承接所有数据的临时数组
        var tempArray = [ThreeParam<String,Int,String>]()
        
        if openDatabase(){
            let fetchSql = "select * from \(lockLogTableName)"
            do {
                let lockArr = try fmdb.executeQuery(fetchSql, values: nil)
                //循环遍历结果
                while lockArr.next() {
                    //给字段赋值
                   let lockID = lockArr.string(forColumn: "lockId")
                   let openStatu = Int(lockArr.int(forColumn: "openStatu"))
                   let time = lockArr.string(forColumn: "time")
                    let model = ThreeParam.init(p1: lockID!, p2: openStatu, p3: time!)
                    QPCLog("我是取出的开门记录--\(lockID)--\(openStatu)--\(time)")
                    tempArray.append(model)
                }
            }catch {
                print(fmdb.lastErrorMessage())
            }
            fmdb.close()
        }
        
        return tempArray
    }
    
}



