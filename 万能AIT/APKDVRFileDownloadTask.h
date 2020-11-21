//
//  APKDVRFileDownloadTask.h
//  AipcalApiSample
//
//  Created by Mac on 17/6/20.
//  Copyright © 2017年 APK. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    kDownloadPriorityLow,
    kDownloadPriorityNormal,
    kDownloadPriorityHigh,
} APKDVRFileDownloadTaskPriority;

typedef void(^APKDVRFileDownloadProgressHandler)(float progress,NSString *info);
typedef void(^APKDVRFileDownloadSuccessHandler)(void);
typedef void(^APKDVRFileDownloadFailureHandler)(void);
typedef void(^APKDVRFileCancelDownloadHandler)(void);

@interface APKDVRFileDownloadTask : NSObject

@property (nonatomic) APKDVRFileDownloadTaskPriority priority;
@property (strong,nonatomic) NSString *sourcePath;
@property (strong,nonatomic) NSString *targetPath;
@property (copy,nonatomic) APKDVRFileDownloadSuccessHandler success;
@property (copy,nonatomic) APKDVRFileDownloadFailureHandler failure;
@property (copy,nonatomic) APKDVRFileDownloadProgressHandler progress;
@property (copy,nonatomic) APKDVRFileCancelDownloadHandler cancelHandler;

//用该方法生成的任务会自动放到downloadManager中
+ (instancetype)taskWithPriority:(APKDVRFileDownloadTaskPriority)priority sourcePath:(NSString *)sourcePath targetPath:(NSString *)targetPath progress:(APKDVRFileDownloadProgressHandler)progress success:(APKDVRFileDownloadSuccessHandler)success failure:(APKDVRFileDownloadFailureHandler)failure;
- (void)cancel;

@end
