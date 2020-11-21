//
//  APKShareTool.m
//  Innowa
//
//  Created by Mac on 17/5/2.
//  Copyright © 2017年 APK. All rights reserved.
//

#import "APKShareTool.h"


@implementation APKShareTool

+ (void)loadShareItemsWithLocalPhotoAssets:(NSArray *)assets completionHandler:(APKLoadShareItemsCompletionHandler)completionHandler{
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSMutableArray *items = [[NSMutableArray alloc] init];
        PHImageRequestOptions *options = [PHImageRequestOptions new];
        options.resizeMode = PHImageRequestOptionsResizeModeFast;
        options.deliveryMode = PHImageRequestOptionsDeliveryModeHighQualityFormat;
        options.synchronous = YES;
        PHImageManager *imageManager = [PHImageManager defaultManager];
        
        for (PHAsset *asset in assets) {
            
            CGSize size = CGSizeMake(asset.pixelWidth, asset.pixelHeight);
            [imageManager requestImageForAsset:asset targetSize:size contentMode:PHImageContentModeAspectFill options:options resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
                [items addObject:result];
            }];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            completionHandler(YES,items);
        });
    });
}

+ (void)loadShareItemsWithLocalVideoAsset:(PHAsset *)asset completionHandler:(APKLoadShareItemsCompletionHandler)completionHandler{
    
    // get resource
    NSArray *resources = [PHAssetResource assetResourcesForAsset:asset];
    PHAssetResource *resource = nil;
    for (PHAssetResource *res in resources) {
        
        if (res.type == PHAssetResourceTypeVideo) {
            resource = res;
            break;
        }
    }
    if (!resource) {
        completionHandler(NO,nil);
        return;
    }
    
    //get save url
    NSString *path = [NSTemporaryDirectory() stringByAppendingPathComponent:resource.originalFilename];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:path]) {
        NSError *error = nil;
        [fileManager removeItemAtPath:path error:&error];
        if (error) {
            completionHandler(NO,nil);
        }
    }
    NSURL *url = [NSURL fileURLWithPath:path];
    
    //write video data to url
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        [[PHAssetResourceManager defaultManager] writeDataForAssetResource:resource toFile:url options:nil completionHandler:^(NSError * _Nullable error) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                if (!error) {
                    
                    NSArray *items = @[url];
                    completionHandler(YES,items);
                    
                }else{
                    
                    completionHandler(NO,nil);
                }
            });
        }];
    });
}


@end
