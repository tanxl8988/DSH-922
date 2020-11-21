//
//  APKGetLocalAlbumCoverInfo.m
//  万能AIT
//
//  Created by Mac on 17/7/27.
//  Copyright © 2017年 APK. All rights reserved.
//

#import "APKGetLocalAlbumCoverInfo.h"
#import "APKMOCManager.h"
#import "APKDVRFile.h"
#import "LocalFileInfo.h"
#import <Photos/Photos.h>

@interface APKGetLocalAlbumCoverInfo ()

@property (copy,nonatomic) void (^completionHandler)(NSArray<APKAlbumCoverInfo *> *infos);
@property (nonatomic) BOOL shouldRemoveKVO;
@property (strong,nonatomic) NSArray *sort;

@end

@implementation APKGetLocalAlbumCoverInfo

#pragma mark - life circle

- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (void)dealloc
{
    if (self.shouldRemoveKVO) {
        
        [[APKMOCManager sharedInstance] removeObserver:self forKeyPath:@"context"];
    }
}

#pragma mark - private method

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    
    if ([keyPath isEqualToString:@"context"]) {
        
        NSManagedObjectContext *context = [APKMOCManager sharedInstance].context;
        if (context) {
            
            [self retrieveData];
        }
    }
}

- (NSString *)albumInfoWithType:(APKFileType)type fileCount:(long)fileCount{
    
    NSString *info = nil;
    if (type == APKFileTypeCapture) {
        
        info = [NSString stringWithFormat:@"%@(%ld)",NSLocalizedString(@"照片", nil),fileCount];
        
    }else if (type == APKFileTypeVideo){
        
        info = [NSString stringWithFormat:@"%@(%ld)",NSLocalizedString(@"视频", nil),fileCount];
        
    }else if (type == APKFileTypeEvent){
        
        info = [NSString stringWithFormat:@"%@(%ld)",NSLocalizedString(@"事件", nil),fileCount];
    }
    
    return info;
}

- (UIImage *)albumImageWithType:(APKFileType)type{
    
    UIImage *image = nil;
    if (type == APKFileTypeCapture) {
        
        image = [UIImage imageNamed:@"photo"];
        
    }else if (type == APKFileTypeVideo){
        
        image = [UIImage imageNamed:@"video_nor"];
        
    }else if (type == APKFileTypeEvent){
        
        image = [UIImage imageNamed:@"video_emergent"];
    }
    
    return image;
}

- (void)retrieveData{
    
    NSManagedObjectContext *context = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
    [context setParentContext:[APKMOCManager sharedInstance].context];
    [context performBlock:^{
       
        NSMutableArray *infos = [[NSMutableArray alloc] init];
        for (NSNumber *number in self.sort) {
            
            APKFileType type = [number integerValue];
            APKAlbumCoverInfo *albumInfo = [[APKAlbumCoverInfo alloc] init];
            albumInfo.fileType = type;
            long fileCount = [LocalFileInfo getFileCountWithType:type context:context];
            albumInfo.info = [self albumInfoWithType:type fileCount:fileCount];
            albumInfo.image = [self albumImageWithType:type];
            if (fileCount > 0) {
                
                LocalFileInfo *info = [LocalFileInfo getFirstLocalFileInfoWithType:type context:context];
                if (info) {
                    
                    PHFetchResult *result = [PHAsset fetchAssetsWithLocalIdentifiers:@[info.localIdentifier] options:nil];
                    if (result.count > 0) {
                        
                        albumInfo.asset = result.firstObject;
                    }
                }
            }
            [infos addObject:albumInfo];
        }
        
        self.completionHandler(infos);
    }];
}

#pragma mark - public method

- (void)getLocalAlbumCoverInfoWithType:(APKFileType)fileType completionHandler:(void (^)(APKAlbumCoverInfo *))completionHandler{
    
    NSManagedObjectContext *context = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
    [context setParentContext:[APKMOCManager sharedInstance].context];
    [context performBlock:^{
        
        APKAlbumCoverInfo *albumInfo = [[APKAlbumCoverInfo alloc] init];
        albumInfo.fileType = fileType;
        long fileCount = [LocalFileInfo getFileCountWithType:fileType context:context];
        albumInfo.info = [self albumInfoWithType:fileType fileCount:fileCount];
        albumInfo.image = [self albumImageWithType:fileType];
        if (fileCount > 0) {
            
            LocalFileInfo *info = [LocalFileInfo getFirstLocalFileInfoWithType:fileType context:context];
            if (info) {
                
                PHFetchResult *result = [PHAsset fetchAssetsWithLocalIdentifiers:@[info.localIdentifier] options:nil];
                if (result.count > 0) {
                    
                    albumInfo.asset = result.firstObject;
                }
            }
        }
        
        completionHandler(albumInfo);
    }];
}

- (void)getLocalAlbumCoverInfo:(NSArray *)sort completionHandler:(void (^)(NSArray<APKAlbumCoverInfo *> *))completionHandler{
    
    self.sort = sort;
    self.completionHandler = completionHandler;
    NSManagedObjectContext *context = [APKMOCManager sharedInstance].context;
    if (context) {
        
        [self retrieveData];
        
    }else{
        
        self.shouldRemoveKVO = YES;
        [[APKMOCManager sharedInstance] addObserver:self forKeyPath:@"context" options:NSKeyValueObservingOptionNew context:nil];
    }
}

@end
