//
//  APKLocalFile.h
//  Aigo
//
//  Created by Mac on 17/7/20.
//  Copyright © 2017年 APK. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LocalFileInfo.h"
#import <Photos/Photos.h>

@interface APKLocalFile : NSObject

@property (strong,nonatomic) LocalFileInfo *info;
@property (strong,nonatomic) PHAsset *asset;

@end
