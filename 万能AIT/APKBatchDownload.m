//
//  APKBatchDownload.m
//  万能AIT
//
//  Created by Mac on 17/7/28.
//  Copyright © 2017年 APK. All rights reserved.
//

#import "APKBatchDownload.h"
#import "APKMOCManager.h"
#import "APKPhotosTool.h"
#import "LocalFileInfo.h"
#import "APKPhotosTool.h"

@interface APKBatchDownload ()

@property (strong,nonatomic) NSMutableArray *downloadFiles;
@property (copy,nonatomic) APKBatchDownloadCompletionHandler completionHandler;
@property (copy,nonatomic) APKDVRFileDownloadProgressHandler progress;
@property (copy,nonatomic) APKBatchDownloadGlobalProgressHandler globalPregress;
@property (strong,nonatomic) APKDVRFileDownloadTask *downloadTask;
@property (nonatomic) BOOL isCanceled;
@property (nonatomic) NSInteger numberOfTasks;

@end

@implementation APKBatchDownload

#pragma mark - private method

- (void)setupNewDownloadTask{
    
    if (self.downloadFiles.count == 0 || self.isCanceled) {
        
        self.completionHandler();
        return;
    }
    
    APKDVRFile *file = self.downloadFiles.firstObject;
    NSInteger index = self.numberOfTasks - self.downloadFiles.count + 1;
    NSString *globalPregress = [NSString stringWithFormat:@"%@(%d/%d)",file.name,(int)index,(int)self.numberOfTasks];
    self.globalPregress(globalPregress);
    
    NSFileManager *fm = [NSFileManager defaultManager];
    NSString *savePath = [NSTemporaryDirectory() stringByAppendingPathComponent:file.name];//保存文件的路径
    __weak typeof(self) weakSelf = self;
    self.downloadTask = [APKDVRFileDownloadTask taskWithPriority:kDownloadPriorityNormal sourcePath:file.fileDownloadPath targetPath:savePath progress:^(float progress, NSString *info) {
        
        weakSelf.progress(progress,info);
        
    } success:^{
        
        PHAssetMediaType type = file.type == APKFileTypeCapture ? PHAssetMediaTypeImage : PHAssetMediaTypeVideo;
        NSURL *url = [NSURL URLWithString:savePath];
        [APKPhotosTool addFileWithUrl:url fileType:type successBlock:^(NSString *identifier) {//保存到系统dvr相册
            
            NSManagedObjectContext *context = [APKMOCManager sharedInstance].context;
            [context performBlock:^{
                
                //保存到coredata
                [LocalFileInfo createWithName:file.name type:file.type isFroontCamera:file.isFrontCamera  localIdentifier:identifier date:file.fullStyleDate context:context];
                [context save:nil];
                file.isDownloaded = YES;
                
                [fm removeItemAtPath:savePath error:nil];
                [weakSelf.downloadFiles removeObject:file];
                [weakSelf setupNewDownloadTask];
            }];
            
        } failureBlock:^(NSError *error) {
            
            [fm removeItemAtPath:savePath error:nil];
            [weakSelf.downloadFiles removeObject:file];
            [weakSelf setupNewDownloadTask];
        }];
        
    } failure:^{
        
        [fm removeItemAtPath:savePath error:nil];
        [weakSelf.downloadFiles removeObject:file];
        [weakSelf setupNewDownloadTask];
    }];
}

#pragma mark - public method

- (void)cancel{
    
    self.isCanceled = YES;
    [self.downloadTask cancel];
}

- (void)executeWithFileArray:(NSArray<APKDVRFile *> *)fileArray globalProgress:(APKBatchDownloadGlobalProgressHandler)globalProgress currentTaskProgress:(APKDVRFileDownloadProgressHandler)progress completionHandler:(APKBatchDownloadCompletionHandler)completionHandler{
    
    [self.downloadFiles setArray:fileArray];
    self.completionHandler = completionHandler;
    self.progress = progress;
    self.globalPregress = globalProgress;
    self.isCanceled = NO;
    self.numberOfTasks = fileArray.count;
    [self setupNewDownloadTask];
}

#pragma mark - getter

- (NSMutableArray *)downloadFiles{
    
    if (!_downloadFiles) {
        
        _downloadFiles = [[NSMutableArray alloc] init];
    }
    
    return _downloadFiles;
}

@end
