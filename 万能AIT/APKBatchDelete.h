//
//  APKBatchDelete.h
//  万能AIT
//
//  Created by Mac on 17/7/28.
//  Copyright © 2017年 APK. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "APKDVRFile.h"

typedef void(^APKBatchDeleteProgressHandler)(APKDVRFile *file,BOOL success);
typedef void(^APKBatchDeleteCompletionHandler)(void);

@interface APKBatchDelete : NSObject

- (void)executeWithFileArray:(NSArray<APKDVRFile *> *)fileArray progress:(APKBatchDeleteProgressHandler)progress completionHandler:(APKBatchDeleteCompletionHandler)completionHandler;

@end
