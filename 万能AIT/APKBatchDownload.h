//
//  APKBatchDownload.h
//  万能AIT
//
//  Created by Mac on 17/7/28.
//  Copyright © 2017年 APK. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "APKDVRFile.h"
#import "APKDVRFileDownloadTask.h"

typedef void(^APKBatchDownloadCompletionHandler)(void);
typedef void(^APKBatchDownloadGlobalProgressHandler)(NSString *globalProgress);

@interface APKBatchDownload : NSObject

- (void)executeWithFileArray:(NSArray<APKDVRFile *> *)fileArray globalProgress:(APKBatchDownloadGlobalProgressHandler)globalProgress currentTaskProgress:(APKDVRFileDownloadProgressHandler)progress completionHandler:(APKBatchDownloadCompletionHandler)completionHandler;
- (void)cancel;

@end
