//
//  APKGetLocalAlbumCoverInfo.h
//  万能AIT
//
//  Created by Mac on 17/7/27.
//  Copyright © 2017年 APK. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "APKAlbumCoverInfo.h"
#import <UIKit/UIKit.h>

@interface APKGetLocalAlbumCoverInfo : NSObject

- (void)getLocalAlbumCoverInfo:(NSArray *)sort completionHandler:(void (^)(NSArray<APKAlbumCoverInfo *> *infos))completionHandler;
- (void)getLocalAlbumCoverInfoWithType:(APKFileType)fileType completionHandler:(void (^)(APKAlbumCoverInfo*info))completionHandler;

@end
