//
//  APKPhotos.m
//  万能AIT
//
//  Created by Mac on 17/3/27.
//  Copyright © 2017年 APK. All rights reserved.
//

#import "APKPhotosTool.h"

#define CUSTOM_COLLECTION_NAME @"DVR"
#define CUSTOM_COLLECTION_IDENTIFIER @"APKCustomCollectionIdentifier"

@implementation APKPhotosTool

#pragma mark - public method

+ (void)saveImage:(UIImage *)image successBlock:(APKPhotosAddFileSuccessBlock)successBlock failureBlock:(APKPhotosAddFileFailureBlock)failureBlock{
    
    [self getCustomCollectionWithSuccessBlock:^(PHAssetCollection *assetCollection) {
        
        __block NSString *localIdentifier = nil;
        [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
            
            PHAssetChangeRequest *createAssetRequest = [PHAssetChangeRequest creationRequestForAssetFromImage:image];
            PHObjectPlaceholder *assetPlaceholder =  createAssetRequest.placeholderForCreatedAsset;
            PHAssetCollectionChangeRequest *collectionChangeRequest = [PHAssetCollectionChangeRequest changeRequestForAssetCollection:assetCollection];
            [collectionChangeRequest addAssets:@[assetPlaceholder]];
            localIdentifier = assetPlaceholder.localIdentifier;
            
        } completionHandler:^(BOOL success, NSError * _Nullable error) {
            
            if (success) {
                successBlock(localIdentifier);
            }else{
                failureBlock(error);
            }
        }];
        
    } failureBlock:^(NSError *error) {
        
        failureBlock(error);
    }];

}

+ (void)addFileWithUrl:(NSURL *)url fileType:(PHAssetMediaType)mediaType successBlock:(APKPhotosAddFileSuccessBlock)successBlock failureBlock:(APKPhotosAddFileFailureBlock)failureBlock{
    
    [self getCustomCollectionWithSuccessBlock:^(PHAssetCollection *assetCollection) {
        
        __block NSString *localIdentifier = nil;
        [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
            
            PHAssetChangeRequest *createAssetRequest = nil;
            if (mediaType == PHAssetMediaTypeImage) {
                createAssetRequest = [PHAssetChangeRequest creationRequestForAssetFromImageAtFileURL:url];
            }else if(mediaType == PHAssetMediaTypeVideo){
                createAssetRequest = [PHAssetChangeRequest creationRequestForAssetFromVideoAtFileURL:url];
            }
            
            PHObjectPlaceholder *assetPlaceholder =  createAssetRequest.placeholderForCreatedAsset;
            PHAssetCollectionChangeRequest *collectionChangeRequest = [PHAssetCollectionChangeRequest changeRequestForAssetCollection:assetCollection];
            [collectionChangeRequest addAssets:@[assetPlaceholder]];
            localIdentifier = assetPlaceholder.localIdentifier;

        } completionHandler:^(BOOL success, NSError * _Nullable error) {
            
            if (success) {
                successBlock(localIdentifier);
             }else{
                failureBlock(error);
            }
        }];
        
    } failureBlock:^(NSError *error) {
       
        failureBlock(error);
    }];
}

#pragma mark - private method

+ (void)getCustomCollectionWithSuccessBlock:(void (^)(PHAssetCollection *assetCollection))successBlock failureBlock:(void (^)(NSError *error))failureBlock{
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *identifier = [userDefaults stringForKey:CUSTOM_COLLECTION_IDENTIFIER];
    PHFetchResult *results = nil;
    if (identifier) {
        
        results = [PHAssetCollection fetchAssetCollectionsWithLocalIdentifiers:@[identifier] options:nil];
    }
    if (results.count > 0) {
        
        PHAssetCollection *assetCollection = results.firstObject;
        successBlock(assetCollection);
        
    }else{
        
        __block PHObjectPlaceholder *placeholder = nil;
        [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
            
            PHAssetCollectionChangeRequest *request = [PHAssetCollectionChangeRequest creationRequestForAssetCollectionWithTitle:CUSTOM_COLLECTION_NAME];
            placeholder = request.placeholderForCreatedAssetCollection;
            
        } completionHandler:^(BOOL success, NSError * _Nullable error) {
            
            if (success) {
                
                NSString *identifier = placeholder.localIdentifier;
                [userDefaults setObject:identifier forKey:CUSTOM_COLLECTION_IDENTIFIER];
                [userDefaults synchronize];
                
                PHFetchResult *results = [PHAssetCollection fetchAssetCollectionsWithLocalIdentifiers:@[identifier] options:nil];
                if (results.count > 0) {
                    
                    PHAssetCollection *assetCollection = results.firstObject;
                    successBlock(assetCollection);
                    
                }else{
                    
                    failureBlock(error);
                }
                
            }else{
                
                failureBlock(error);
            }
        }];
    }
}

@end
