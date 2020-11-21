//
//  APKAlbumCoverInfo.h
//  万能AIT
//
//  Created by Mac on 17/7/27.
//  Copyright © 2017年 APK. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "APKDVRFile.h"
#import <Photos/Photos.h>
#import <UIKit/UIKit.h>

@interface APKAlbumCoverInfo : NSObject

@property (nonatomic) APKFileType fileType;
@property (strong,nonatomic) PHAsset *asset;
@property (strong,nonatomic) UIImage *image;
@property (strong,nonatomic) NSString *info;

+ (APKAlbumCoverInfo *)dvrAlbumWithType:(APKFileType)type;

@end
