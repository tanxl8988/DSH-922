//
//  APKDVRResponseObjectHandler.h
//  Aigo
//
//  Created by Mac on 17/6/30.
//  Copyright © 2017年 APK. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^APKSuccessCommandHandler)(id result);
typedef void(^APKFailureCommandHandler)(int rval);

@interface APKDVRCommandResponseObjectHandler : NSObject

- (void)handle:(id)responseObject successCommandHandler:(APKSuccessCommandHandler)successCommandHandler failureCommandHandler:(APKFailureCommandHandler)failureCommandHandler;

@end
