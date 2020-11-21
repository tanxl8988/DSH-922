//
//  APKCachingAssetThumbnail.h
//  Aigo
//
//  Created by Mac on 17/7/20.
//  Copyright © 2017年 APK. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Photos/Photos.h>

@interface APKCachingAssetThumbnail : NSObject

- (instancetype)initWithSize:(CGSize)size contentMode:(PHImageContentMode)contentMode options:(PHImageRequestOptions *)options;
- (void)executeWithAssets:(NSArray <PHAsset *> *)assets;
- (void)requestThumbnailForAsset:(PHAsset *)asset completionHandler:(void (^)(UIImage *thumbnail))completionHandler;

@end
