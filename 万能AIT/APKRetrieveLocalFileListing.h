//
//  APKRetrieveLocalFileListing.h
//  万能AIT
//
//  Created by Mac on 17/7/28.
//  Copyright © 2017年 APK. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "APKDVRFile.h"
#import "APKLocalFile.h"

typedef void(^APKRetrieveLocalFileListingCompletionHandler)(NSArray<APKLocalFile *> *fileArray,NSArray<PHAsset *> *assets);

@interface APKRetrieveLocalFileListing : NSObject

- (void)executeWithFileType:(APKFileType)fileType offset:(NSInteger)offset count:(NSInteger)count completionHandler:(APKRetrieveLocalFileListingCompletionHandler)completionHandler;

@end
