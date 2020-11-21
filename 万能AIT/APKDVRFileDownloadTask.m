//
//  APKDVRFileDownloadTask.m
//  AipcalApiSample
//
//  Created by Mac on 17/6/20.
//  Copyright © 2017年 APK. All rights reserved.
//

#import "APKDVRFileDownloadTask.h"
#import "APKDVRFileDownloadTaskQueue.h"

@implementation APKDVRFileDownloadTask

#pragma mark - life circle

- (void)dealloc{
    
//    NSLog(@"%s",__func__);
}

#pragma mark - public method

+ (instancetype)taskWithPriority:(APKDVRFileDownloadTaskPriority)priority sourcePath:(NSString *)sourcePath targetPath:(NSString *)targetPath progress:(APKDVRFileDownloadProgressHandler)progress success:(APKDVRFileDownloadSuccessHandler)success failure:(APKDVRFileDownloadFailureHandler)failure{
    
    APKDVRFileDownloadTask *task = [[APKDVRFileDownloadTask alloc] init];
    task.priority = priority;
    task.sourcePath = sourcePath;
    task.targetPath = targetPath;
    task.success = success;
    task.failure = failure;
    task.progress = progress;
    [[APKDVRFileDownloadTaskQueue sharedInstance] addTask:task];
    return task;
}

- (void)cancel{
    
    if (self.cancelHandler) {
        
        self.cancelHandler();
        
    }else{
        
        self.failure();
        [[APKDVRFileDownloadTaskQueue sharedInstance] removeTask:self];
    }
}

@end
