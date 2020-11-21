//
//  APKCachingAssetThumbnail.m
//  Aigo
//
//  Created by Mac on 17/7/20.
//  Copyright © 2017年 APK. All rights reserved.
//

#import "APKCachingAssetThumbnail.h"

@interface APKCachingAssetThumbnail ()

@property (strong,nonatomic) PHCachingImageManager *cachingManager;
@property (strong,nonatomic) PHImageRequestOptions *options;
@property (assign) CGSize size;
@property (assign) PHImageContentMode contentMode;

@end

@implementation APKCachingAssetThumbnail

- (instancetype)initWithSize:(CGSize)size contentMode:(PHImageContentMode)contentMode options:(PHImageRequestOptions *)options{
    
    if (self = [super init]) {
        
        self.size = size;
        self.contentMode = contentMode;
        self.options = options;
    }
    
    return self;
}

#pragma mark - public method

- (void)executeWithAssets:(NSArray <PHAsset *>*)assets{
    
    [self.cachingManager startCachingImagesForAssets:assets targetSize:self.size contentMode:self.contentMode options:self.options];
}

- (void)requestThumbnailForAsset:(PHAsset *)asset completionHandler:(void (^)(UIImage *thumbnail))completionHandler{
    
    [self.cachingManager requestImageForAsset:asset targetSize:self.size contentMode:self.contentMode options:self.options resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
        
        completionHandler(result);
    }];
}

#pragma mark - getter

- (PHCachingImageManager *)cachingManager{
    
    if (!_cachingManager) {
        
        _cachingManager = [[PHCachingImageManager alloc] init];
    }
    return _cachingManager;
}


@end
