//
//  LockTools.swift
//  MsdGateLock
//
//  Created by ox o on 2017/7/21.
//  Copyright © 2017年 xiaoxiao. All rights reserved.
//

import UIKit

class LockTools {
    
    //todo 按规则生成sign
    static func getSignWithStr(str : String) -> String{
        return str
    }

    /**
     保存图片到沙盒
     */
    static func saveImage(_ currentImage:UIImage) -> URL{
        //高保真压缩图片方法
        let imageData:Data = currentImage.jpegData(compressionQuality: 0.5)!
        
        //        NSTextAlignment.center
        let fullPath:String = NSHomeDirectory() + "/Documents/theFirstImage.png"
        
        //        var fm = NSFileManager.defaultManager()
        //        var b = fm.createFileAtPath(fullPath, contents: imageData, attributes: nil)
        
        let b = (try? imageData.write(to: URL(fileURLWithPath: fullPath as String), options: [])) != nil
        
        QPCLog(b ? "写入沙盒成功:\(fullPath)" : "写入沙盒失败")
        return URL(fileURLWithPath: fullPath)     //开始上传操作
        //        print(fullPath)
        
    }
    
    
    /**
     时间转化MM/dd  HH:mm
     
     */
    static func stringToTimeStamp(stringTime:String)->String {
        
        let f = DateFormatter()
        f.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        let d = f.date(from: stringTime)
        
        let forma : DateFormatter = DateFormatter()
        forma.dateFormat = "MM/dd  HH:mm"
        
        return forma.string(from:d!)
        
    }
    
    /**
     时间T转化 yyyy-MM-dd'T'HH:mm:ss -> 年/月/日
     
     */
    static func stringToTimeYMD(stringTime:String)->String {
        
        let f = DateFormatter()
        f.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        let d = f.date(from: stringTime)
        
        let forma : DateFormatter = DateFormatter()
        forma.dateFormat = "yyyy/MM/dd HH:mm"
        
        return forma.string(from:d!)
    }
    
//    /**
//     时间转化 yyyy-MM-dd HH:mm:ss -> 年/月/日
//     
//     */
//    static func stringToTimeYMD(stringTime:String)->String {
//        
//        let f = DateFormatter()
//        f.dateFormat = "yyyy-MM-dd HH:mm"
//        let d = f.date(from: stringTime)
//        
//        let forma : DateFormatter = DateFormatter()
//        forma.dateFormat = "yyyy/MM/dd HH:mm"
//        
//        return forma.string(from:d!)
//    }
    
    /**
     时间转化 yyyyMMddHHmmss
     
     */
    static func stringToTimeYMDHmS(stringTime:String)->String {
        let f = DateFormatter()
        var d : Date?
        if  stringTime.count > 17{
            f.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
            d  = f.date(from: stringTime)
        }else{
            f.dateFormat = "yyyy-MM-dd HH:mm"
            d  = f.date(from: stringTime)
        }
        let forma : DateFormatter = DateFormatter()
        forma.dateFormat = "yyyyMMddHHmmss"
        
        return forma.string(from:d!)
    }
    
    /**
     时间转化 yyyy-MM-dd HH:mm
     
     */
    static func stringToTimeYMDHmStr(stringTime:String)->String {
        let f = DateFormatter()
        var d : Date?
   
        f.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        d  = f.date(from: stringTime)
        let forma : DateFormatter = DateFormatter()
        forma.dateFormat = "yyyy-MM-dd HH:mm"
        return forma.string(from:d!)
    }
    
    
    /**
     获取当前时间 yyyyMMddHHmmss
     
     */
    static func getCurrentTime()->String {
        let now = Date()
        let f = DateFormatter()
        f.timeZone = TimeZone(abbreviation: "GMT+0800")
        f.dateFormat = "yyyyMMddHHmmss"
        let currentStr = f.string(from: now)
        return currentStr
    }
    
    /**
     获取当前时间 yyyy-MM-dd HH:mm:ss
     
     */
    static func getCurrentTimeWithDefault()->String {
        
        let now = Date()
        let f = DateFormatter()
        f.timeZone = TimeZone(abbreviation: "GMT+0800")
        f.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let currentStr = f.string(from: now)
        
        return currentStr
    }
    
    //比较两个日期的大小
    static func compareDate(starDate:String, endDate:String) ->Bool{
        
        let f = DateFormatter()
        f.dateFormat = "yyyy-MM-dd HH:mm"
        
        let star = f.date(from: starDate)
        let end = f.date(from: endDate)
        
        let result : ComparisonResult = (star?.compare(end!))!
        if result == ComparisonResult.orderedDescending{//end比star小
            return false
        }else{
            return true
        }
    }

    
    /**
     比较和当前时间是否过期
     */
    static func checkIsOvertime(stringTime:String)->Bool {
        
        let f = DateFormatter()
        f.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        let d = f.date(from: stringTime)
        
        let currentDate = Date()

        QPCLog(currentDate)
        
        let result : ComparisonResult = (d?.compare(currentDate))!
        if result == ComparisonResult.orderedDescending{
            return false
        }else{
            return true  //已过期
        }
        
    }
    
    /**
     比较和当前时间是否过期
     */
    static func checkIsOvertimeWithLinestring(linestring:String)->Bool {
        
        let f = DateFormatter()
        f.dateFormat = "yyyy-MM-dd HH:mm"
        let d = f.date(from: linestring)
        
        let currentDate = Date()
        
        QPCLog(currentDate)
        
        let result : ComparisonResult = (d?.compare(currentDate))!
        if result == ComparisonResult.orderedDescending{
            return false
        }else{
            return true  //已过期
        }
        
    }
    
    ///与当前值比较是否过期
    static func checkIsOverTimeWithDate(date : Date?)->Bool{
        guard date != nil else {
            return true
        }
        let currentDate = Date()
        
        let result : ComparisonResult = date!.compare(currentDate)
        if result == ComparisonResult.orderedDescending{
            return false
        }else{
            return true  //已过期
        }
    }
    
    
    //时间转字符串
    static func dateToStringWithDate(date : Date)->String{
        let  formater : DateFormatter = DateFormatter()
        formater.dateFormat = "yyyyMMddHHmmss"
        return formater.string(from: date)
    }
    
    /**
     时间str转化date 年月日
     */
    static func stringToDateWithStr(stringTime:String)->Date {
        let f = DateFormatter()
        f.dateFormat = "yyyyMMddHHmmss"
        let d = f.date(from: stringTime)
        return d!
    }
    

}

public extension Int {
    
    var currentTimeInterval : TimeInterval {
        return NSDate().timeIntervalSince1970
    }
    
    //MARK: 根据规则返回对应的字符串
    func getTimeString() -> String {
        if isToday {
            if minute < 5 {
                return "刚刚"
            } else if hour < 1 {
                return "\(minute)分钟之前"
            } else {
                return "\(hour)小时之前"
            }
        } else if isYesterday {
            return "昨天 \(self.yesterdayTimeStr())"
        } else if isYear {
            return noYesterdayTimeStr()
        } else {
            return yearTimeStr()
        }
    }
    
    fileprivate var selfDate : Date {
        return Date(timeIntervalSince1970: TimeInterval(self))
    }
    
    /// 距当前有几分钟
    var minute : Int {
        let dateComponent = Calendar.current.dateComponents([.minute], from: selfDate, to: Date())
        return dateComponent.minute!
    }
    
    /// 距当前有几小时
    var hour : Int {
        let dateComponent = Calendar.current.dateComponents([.hour], from: selfDate, to: Date())
        return dateComponent.hour!
    }
    
    /// 是否是今天
    var isToday : Bool {
        return Calendar.current.isDateInToday(selfDate)
    }
    
    /// 是否是昨天
    var isYesterday : Bool {
        return Calendar.current.isDateInYesterday(selfDate)
    }
    
    /// 是否是今年
    var isYear: Bool {
        let nowComponent = Calendar.current.dateComponents([.year], from: Date())
        let component = Calendar.current.dateComponents([.year], from: selfDate)
        return (nowComponent.year == component.year)
    }
    
    func yesterdayTimeStr() -> String {
        let format = DateFormatter()
        format.dateFormat = "HH:mm"
        return format.string(from: selfDate)
    }
    
    func noYesterdayTimeStr() -> String {
        let format = DateFormatter()
        format.dateFormat = "MM-dd HH:mm"
        return format.string(from: selfDate)
    }
    
    func yearTimeStr() -> String {
        let format = DateFormatter()
        format.dateFormat = "yyyy-MM-dd HH:mm"
        return format.string(from: selfDate)
    }
}
