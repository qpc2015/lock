//
//  OTGPenerator.c
//  MsdGateLock
//
//  Created by ox o on 2017/8/10.
//  Copyright © 2017年 xiaoxiao. All rights reserved.
//

#include <stdio.h>
#include <stdint.h>
#include <string.h>
#include "hmacsha1.h"




/********************************
	Control the length of output
 *********************************/
long DIGITS_POWER[9]
// 0 1  2   3    4     5      6       7        8
= {  1,10,100,1000,10000,100000,1000000,10000000,100000000 };

/******************************************************************
	1.Generate hash :
 hash = HMAC_SHA_1(key, time)
	2.Take the last character's 4bits of hash as offset.
	3.The result is just made of the offset, offset + 1, offset + 2
 and offset + 3 bytes of hash.
 ******************************************************************/

long google_authenticator(uint8_t* key, long time){

    uint8_t hash[20], T[9];
    uint8_t offset, i;
    long binary, otp, copy;
    long t = (time - 0)/60;
    int size = 0, differ, pin = 1;
    
    /*************   60s period    ***************/
    sprintf(T,"%ld",t);
    
    hmac_sha1(key, 16, T, 8, hash);
    
    offset = hash[19] & 0x0f;
    binary = (long)(hash[offset] & 0x7f) << 24 |
    (long)(hash[offset + 1] & 0xff) << 16 |
    (long)(hash[offset + 2] & 0xff) << 8 |
    (long)(hash[offset + 3] & 0xff);
    otp = binary % DIGITS_POWER[6];
    copy = otp;
    while(copy>0){
        size++;
        copy/=10;
    }
    
    differ = 6 - size;
    for(i = 0; i< differ; i++){
        pin = pin * 10;
    }
    
    otp = otp * pin;
    
    return otp;
}


