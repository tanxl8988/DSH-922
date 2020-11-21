//
//  APKAlbumCoverInfo.m
//  万能AIT
//
//  Created by Mac on 17/7/27.
//  Copyright © 2017年 APK. All rights reserved.
//

#import "APKAlbumCoverInfo.h"

@implementation APKAlbumCoverInfo

+ (APKAlbumCoverInfo *)dvrAlbumWithType:(APKFileType)type{

    APKAlbumCoverInfo *info = [[APKAlbumCoverInfo alloc] init];
    info.fileType = type;
    if (type == APKFileTypeCapture) {
        
        info.info = NSLocalizedString(@"照片", nil);
        info.image = [UIImage imageNamed:@"photo"];
        
    }else if (type == APKFileTypeVideo){
        
        info.info = NSLocalizedString(@"视频", nil);
        info.image = [UIImage imageNamed:@"video_nor"];

    }else if (type == APKFileTypeEvent){
        
        info.info = NSLocalizedString(@"事件", nil);
        info.image = [UIImage imageNamed:@"video_emergent"];
    }
    
    return info;
}

@end
