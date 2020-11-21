//
//  APKPhotos.h
//  万能AIT
//
//  Created by Mac on 17/3/27.
//  Copyright © 2017年 APK. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Photos/Photos.h>

typedef void(^APKPhotosAddFileSuccessBlock)(NSString *identifier);
typedef void(^APKPhotosAddFileFailureBlock)(NSError *error);

@interface APKPhotosTool : NSObject

+ (void)addFileWithUrl:(NSURL *)url fileType:(PHAssetMediaType)mediaType successBlock:(APKPhotosAddFileSuccessBlock)successBlock failureBlock:(APKPhotosAddFileFailureBlock)failureBlock;

+ (void)saveImage:(UIImage *)image successBlock:(APKPhotosAddFileSuccessBlock)successBlock failureBlock:(APKPhotosAddFileFailureBlock)failureBlock;

@end
