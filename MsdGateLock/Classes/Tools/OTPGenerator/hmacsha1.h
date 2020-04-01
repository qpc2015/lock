//
//  hmacsha1.h
//  MsdGateLock
//
//  Created by ox o on 2017/8/10.
//  Copyright © 2017年 xiaoxiao. All rights reserved.
//

#ifndef hmacsha1_h
#define hmacsha1_h

#include <stdio.h>

void hmac_sha1(
               unsigned char *key,
               int key_length,
               unsigned char *data,
               int data_length,
               unsigned char *digest
               );

#endif /* hmacsha1_h */
