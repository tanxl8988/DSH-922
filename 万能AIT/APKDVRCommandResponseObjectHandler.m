//
//  APKDVRResponseObjectHandler.m
//  Aigo
//
//  Created by Mac on 17/6/30.
//  Copyright © 2017年 APK. All rights reserved.
//

#import "APKDVRCommandResponseObjectHandler.h"

@implementation APKDVRCommandResponseObjectHandler

- (void)handle:(id)responseObject successCommandHandler:(APKSuccessCommandHandler)successCommandHandler failureCommandHandler:(APKFailureCommandHandler)failureCommandHandler{
    
    NSData *data = responseObject;
    NSString *msg = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"%@",msg);
    NSArray *arr = [msg componentsSeparatedByString:@"\n"];
    if (arr.count > 0) {
        
        int rval = [arr.firstObject intValue];
        if (rval == 0) {
            
            successCommandHandler(nil);
            
        }else{
            
            failureCommandHandler(rval);
        }
        
    }else{
        
        failureCommandHandler(-1);
    }
}

@end
