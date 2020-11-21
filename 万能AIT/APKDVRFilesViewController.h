//
//  APKDVRFilesViewController.h
//  万能AIT
//
//  Created by Mac on 17/3/23.
//  Copyright © 2017年 APK. All rights reserved.
//

#import "APKBaseViewController.h"
#import "APKDVRFile.h"

@interface APKDVRFilesViewController : APKBaseViewController

@property (nonatomic) APKFileType fileType;
@property (copy,nonatomic) void (^updateLocalAlbumCoverBlock)(APKFileType fileType);

@end
