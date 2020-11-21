//
//  APKLockRemainingTimeRecorder.h
//  万能AIT
//
//  Created by Mac on 18/2/1.
//  Copyright © 2018年 APK. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface APKLockRemainingTimeRecorder : NSObject

@property (assign,nonatomic) int remainingTime;

- (void)launchWithUpdateRemainingTimeHandler:(void (^)(int remainingTime))updateRemainingTimeHandler;
- (void)interrupt;

@end
