//
//  APKGetDVRFileListResponseObjectHandler.h
//  Aigo
//
//  Created by Mac on 17/7/5.
//  Copyright © 2017年 APK. All rights reserved.
//

#import "APKDVRCommandResponseObjectHandler.h"
#import "APKDVRFile.h"

@interface APKGetDVRFileListResponseObjectHandler : APKDVRCommandResponseObjectHandler

@property (nonatomic)APKFileType fileType;

@end
