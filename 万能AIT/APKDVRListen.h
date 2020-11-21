//
//  APKDVRListen.h
//  微米
//
//  Created by Mac on 17/9/11.
//  Copyright © 2017年 APK. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol APKDVRListenDelegate <NSObject>

- (void)APKDVRListenDidReceiveMessage:(NSString *)message;

@end

@interface APKDVRListen : NSObject

- (instancetype)initWithDelegate:(id<APKDVRListenDelegate>)delegate;
- (BOOL)startListen;
- (void)stopListen;

@end
