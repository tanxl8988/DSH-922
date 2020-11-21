//
//  APKDVRFileDownloadQueue.h
//  Aigo
//
//  Created by Mac on 17/7/12.
//  Copyright © 2017年 APK. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "APKDVRFileDownloadTask.h"

@interface APKDVRFileDownloadTaskQueue : NSObject

+ (instancetype)sharedInstance;
- (void)addTask:(APKDVRFileDownloadTask *)task;
- (void)removeTask:(APKDVRFileDownloadTask *)task;

@end
