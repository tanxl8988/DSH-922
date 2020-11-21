//
//  APKDVR.h
//  AITBrain
//
//  Created by Mac on 17/3/20.
//  Copyright © 2017年 APK. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "APKDVRSettingInfo.h"

typedef enum : NSInteger {
    kAPKDVRModalAosibi,//奥斯比
    kAPKDVRModalXiongFeng,//雄风
} APKDVRModal;

@interface APKDVR : NSObject

@property (assign,nonatomic) BOOL isConnected;
@property (assign,nonatomic) APKDVRModal modal;
@property (strong,nonatomic) APKDVRSettingInfo *settingInfo;
@property (strong,nonatomic) NSTimer *timer;

+ (instancetype)sharedInstance;
- (void)tryToUpdateConnectState;

@end
