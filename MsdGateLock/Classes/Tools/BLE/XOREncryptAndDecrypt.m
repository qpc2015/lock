//
//  XOREncryptAndDecrypt.m
//  ECar
//
//  Created by xujingbao on 4/29/15.
//  Copyright (c) 2015 VLESS. All rights reserved.
//
#import "XOREncryptAndDecrypt.h"

@implementation XOREncryptAndDecrypt

#pragma mark 加密字符串
+ (NSString *)encryptForPlainText:(NSString *)plainText withSecretKey:(NSString *)secretKey;
{
    NSMutableArray *hexArray1 = [[NSMutableArray alloc] initWithCapacity:0];
    for (int i=0; i < [plainText length]; i++)
    {
        NSString *ichar = [NSString stringWithFormat:@"%c", [plainText characterAtIndex:i]];
        
        [hexArray1 addObject:ichar];
    }

    NSMutableArray *hexArray2 = [[NSMutableArray alloc] initWithCapacity:0];
    for (int i=0; i < [plainText length]; i++)
    {
        NSString *ichar = [NSString stringWithFormat:@"%c", [secretKey characterAtIndex:0 ]];
        [hexArray2 addObject:ichar];
        ichar = [NSString stringWithFormat:@"%c", [secretKey characterAtIndex:1 ]];
        [hexArray2 addObject:ichar];
    }

    NSMutableString *str = [NSMutableString new];
    for (int i=0; i<[hexArray1 count]; i++ )
    {
        /*Convert to base 16*/
        int a=(unsigned char)strtol([[hexArray1 objectAtIndex:i] UTF8String], NULL, 16);
        int b=(unsigned char)strtol([[hexArray2 objectAtIndex:i] UTF8String], NULL, 16);

        char encrypted = a ^ b;
        [str appendFormat:@"%x",encrypted];
    }
    return str;
}

@end