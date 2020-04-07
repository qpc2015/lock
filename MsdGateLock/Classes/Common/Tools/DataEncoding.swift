//
//  DataEncoding.swift
//  JPBLEDemo_Swift
//
//  Created by ox o on 2017/7/12.
//  Copyright © 2017年 yintao. All rights reserved.
//  门锁加密相关

import UIKit
import CryptoSwift



extension String  {
    
    //手机掩码把4-7位变为*号
    func phoneNumToAsterisk() -> String{
        return (self as NSString).replacingCharacters(in: NSMakeRange(3, 4), with: "****")
    }
    
    //a值生成(锁 ID 信息/锁蓝牙 mac 地址信息/锁密钥 这三部分的 hash 生成的信息 A)
    static func getA(lockId : String,blueMacAdress:String,lockSecretKey:String) -> String{
        let getAstr = "\(lockId)\(blueMacAdress)\(lockSecretKey)"
        QPCLog("a-\(getAstr)----\(getAstr.MD5())")
        return getAstr.MD5()
    }
    
    ///MD5加密
    func MD5() -> String
    {
        let data = (self as NSString).data(using: String.Encoding.utf8.rawValue)! as NSData
        let str = data.MD5().hexedString()
        let start = str.index(str.startIndex, offsetBy: 8)
        let end = str.index(str.endIndex, offsetBy: -8)
        let range = start..<end
        return str.substring(with: range)
    }
    
    //AES-ECB128加密
    /// AES加密
    ///
    /// - Parameters:
    ///   - key: key
    ///   - iv: iv
    /// - Returns: String
    func aesEncrypt(key: String) -> String? {
        var result: String?
//        let iv = ""
        do {
            // 用UTF8的编碼方式將字串轉成Data
            let data: Data = self.data(using: String.Encoding.utf8, allowLossyConversion: true)!
            
            // 用AES的方式將Data加密
            
            let aecEnc: AES = try AES(key: key.bytes, blockMode: ECB())
            let enc = try aecEnc.encrypt(data.bytes)
            
            // 用UTF8的編碼方式將解完密的Data轉回字串
            let encData: Data = Data(bytes: enc, count: enc.count)
            result = encData.hexadecimal()
        } catch {
            print("\(error.localizedDescription)")
        }
        
        return result
    }

    
    
    /// AES解密
    ///
    /// - Parameters:
    ///   - key: key
    ///   - iv: iv
    /// - Returns: String
    func aesDecrypt(key: String) -> String? {
        var result: String?
//        let iv = ""
        do {
            // 使16进制字串解碼後再轉换Data
            let data = self.hexadecimal()!
            
            // 用AES方式將Data解密
            
            let aesDec: AES = try AES(key: key.bytes,blockMode: ECB())
            let dec = try aesDec.decrypt(data.bytes)
            
            // 用UTF8的編碼方式將解完密的Data轉回字串
            let desData: Data = Data(bytes: dec, count: dec.count)
            result = String(data: desData, encoding: .utf8)
        } catch {
            print("\(error.localizedDescription)")
        }
        
        return result
    }

    
    ///Hex String to Data
    
    /// Create `Data` from hexadecimal string representation
    ///
    /// This takes a hexadecimal representation and creates a `Data` object. Note, if the string has any spaces or non-hex characters (e.g. starts with '<' and with a '>'), those are ignored and only hex characters are processed.
    ///
    /// - returns: Data represented by this hexadecimal string.
    
    func hexadecimal() -> Data? {
        var data = Data(capacity: self.count / 2)
        
        let regex = try! NSRegularExpression(pattern: "[0-9a-f]{1,2}", options: .caseInsensitive)
        regex.enumerateMatches(in: self, range: NSMakeRange(0, utf16.count)) { match, flags, stop in
            let byteString = (self as NSString).substring(with: match!.range)
            var num = UInt8(byteString, radix: 16)!
            data.append(&num, count: 1)
        }
        
        guard data.count > 0 else { return nil }
        
        return data
    }

    
}

extension Data {
    ///Data to Hex String
    /// Create hexadecimal string representation of `Data` object.
    ///
    /// - returns: `String` representation of this `Data` object.
    
    func hexadecimal() -> String {
        return map { String(format: "%02x", $0) }
            .joined(separator: "")
    }
}


extension NSData
{
    func hexedString() -> String
    {
        var string = String()
        let unsafePointer = bytes.assumingMemoryBound(to: UInt8.self)
        for i in UnsafeBufferPointer<UInt8>(start:unsafePointer, count: length)
        {
            string += Int(i).hexedString()
        }
        return string
    }
    
    func MD5() -> NSData
    {
        let result = NSMutableData(length: Int(CC_MD5_DIGEST_LENGTH))!
        let unsafePointer = result.mutableBytes.assumingMemoryBound(to: UInt8.self)
        CC_MD5(bytes, CC_LONG(length), UnsafeMutablePointer<UInt8>(unsafePointer))
        return NSData(data: result as Data)
    }
}


extension Int
{
    func hexedString() -> String
    {
        return NSString(format:"%02x", self) as String
    }
}
