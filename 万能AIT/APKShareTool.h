//
//  APKShareTool.h
//  Innowa
//
//  Created by Mac on 17/5/2.
//  Copyright © 2017年 APK. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Photos/Photos.h>

typedef void(^APKLoadShareItemsCompletionHandler)(BOOL success,NSArray *items);

@interface APKShareTool : NSObject

+ (void)loadShareItemsWithLocalPhotoAssets:(NSArray *)assets completionHandler:(APKLoadShareItemsCompletionHandler)completionHandler;
+ (void)loadShareItemsWithLocalVideoAsset:(PHAsset *)asset completionHandler:(APKLoadShareItemsCompletionHandler)completionHandler;

@end
