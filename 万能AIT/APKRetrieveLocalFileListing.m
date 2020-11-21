//
//  APKRetrieveLocalFileListing.m
//  万能AIT
//
//  Created by Mac on 17/7/28.
//  Copyright © 2017年 APK. All rights reserved.
//

#import "APKRetrieveLocalFileListing.h"
#import "APKMOCManager.h"
#import "LocalFileInfo.h"

@implementation APKRetrieveLocalFileListing

- (void)executeWithFileType:(APKFileType)fileType offset:(NSInteger)offset count:(NSInteger)count completionHandler:(APKRetrieveLocalFileListingCompletionHandler)completionHandler{
    
    NSManagedObjectContext *context = [APKMOCManager sharedInstance].context;
    [context performBlock:^{
        
        [LocalFileInfo retrieveLocalfileInfosWithType:fileType offset:offset count:count context:context completionHandler:^(NSAsynchronousFetchResult * _Nonnull result) {
            
            NSMutableArray *fileArray = [[NSMutableArray alloc] init];
            NSMutableArray *assets = [[NSMutableArray alloc] init];
            for (LocalFileInfo *info in result.finalResult) {
                
                PHAsset *asset = [PHAsset fetchAssetsWithLocalIdentifiers:@[info.localIdentifier] options:nil].firstObject;
                if (asset) {
                    
                    APKLocalFile *file = [[APKLocalFile alloc] init];
                    file.info = info;
                    file.asset = asset;
                    [fileArray addObject:file];
                    [assets addObject:asset];
                    
                }else{
                    
                    [context deleteObject:info];
                }
            }
            
            NSError *error = nil;
            if (![context save:&error]) {
                
                abort();
            }
            
            completionHandler(fileArray,assets);
        }];
    }];
}

@end
