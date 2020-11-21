//
//  APKRetrieveDVRFileListing.h
//  Aigo
//
//  Created by Mac on 17/7/13.
//  Copyright © 2017年 APK. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "APKDVRFile.h"

typedef void(^APKRetrieveDVRFileListingSuccessHandler)(NSArray<APKDVRFile *> *fileArray);
typedef void(^APKRetrieveDVRFileListingFailureHandler)(void);

@interface APKRetrieveDVRFileListing : NSObject
@property (nonatomic,retain) NSMutableArray *frontArr;
@property (nonatomic,retain) NSMutableArray *rearArr;
@property (assign,nonatomic) BOOL isFrontCamera;

- (instancetype)initWithRetrieveFileType:(NSInteger)fileType;
- (void)retrieveFileListingWithOffset:(NSInteger)offset count:(NSInteger)count success:(APKRetrieveDVRFileListingSuccessHandler)success failure:(APKRetrieveDVRFileListingFailureHandler)failure;
- (NSArray *)syncWithDeletedFiles:(NSArray *)deletedFiles;

@end
