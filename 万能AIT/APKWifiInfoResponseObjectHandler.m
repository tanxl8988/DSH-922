//
//  APKWifiInfoResponseObjectHandler.m
//  万能AIT
//
//  Created by Mac on 17/8/1.
//  Copyright © 2017年 APK. All rights reserved.
//

#import "APKWifiInfoResponseObjectHandler.h"

@implementation APKWifiInfoResponseObjectHandler

- (void)handle:(id)responseObject successCommandHandler:(APKSuccessCommandHandler)successCommandHandler failureCommandHandler:(APKFailureCommandHandler)failureCommandHandler{
    
    NSData *data = responseObject;
    NSString *msg = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"%@",msg);
    NSArray *arr = [msg componentsSeparatedByString:@"\n"];
    if (arr.count > 0) {
        
        int rval = [arr.firstObject intValue];
        if (rval == 0) {
            
            NSString *wifiName = nil;
            NSString *wifiPassword = nil;
            for (NSString *element in arr) {
                
                if ([element containsString:@"SSID"]) {
                    
                    NSArray *infoArr = [element componentsSeparatedByString:@"="];
                    wifiName = infoArr.lastObject;
                    
                }else if ([element containsString:@"CryptoKey"]){
                    
                    NSArray *infoArr = [element componentsSeparatedByString:@"="];
                    wifiPassword = infoArr.lastObject;
                }
            }
            successCommandHandler(@{wifiName:wifiPassword});
            
        }else{
            
            failureCommandHandler(rval);
        }
        
    }else{
        
        failureCommandHandler(-1);
    }
}

@end
