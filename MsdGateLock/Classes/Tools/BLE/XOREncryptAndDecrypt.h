//
//  XOREncryptAndDecrypt.h
//  ECar
//
//  Created by xujingbao on 4/29/15.
//  Copyright (c) 2015 VLESS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XOREncryptAndDecrypt : NSObject
/**
 *  字符串加密
 *
 *  @param plainText 要加密的字符串
 *
 *  @return 加密后的字符串
 */
+ (NSString *)encryptForPlainText:(NSString *)plainText withSecretKey:(NSString *)secretKey;

@end
