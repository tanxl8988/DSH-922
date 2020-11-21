//
//  APKDVRFileDownloadQueue.m
//  Aigo
//
//  Created by Mac on 17/7/12.
//  Copyright © 2017年 APK. All rights reserved.
//

#import "APKDVRFileDownloadTaskQueue.h"
#import "AFNetworking.h"

@interface APKDVRFileDownloadTaskQueue ()

@property (strong,nonatomic) NSMutableArray *lowPriorityTasks;
@property (strong,nonatomic) NSMutableArray *normalPriorityTasks;
@property (strong,nonatomic) NSMutableArray *highPriorityTasks;
@property (strong,nonatomic) AFURLSessionManager *sessionManager;
@property (nonatomic) BOOL isBusy;

@end

@implementation APKDVRFileDownloadTaskQueue

static APKDVRFileDownloadTaskQueue *instance = nil;
+ (instancetype)sharedInstance{
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        instance = [[APKDVRFileDownloadTaskQueue alloc] init];
    });
    
    return instance;
}

#pragma mark - private method

- (float)progress:(NSProgress *)p{
    
    float progress = (float)p.completedUnitCount / (float)p.totalUnitCount;
    return progress;
}

- (NSString *)progressInfo:(NSProgress *)p{
    
    NSString *progressInfo = nil;
    if (p.totalUnitCount >= 1000000) {
        
        progressInfo = [NSString stringWithFormat:@"%.2fM/%.2fM",(float)p.completedUnitCount/1000000,(float)p.totalUnitCount/1000000];
        
    }else{
        
        progressInfo = [NSString stringWithFormat:@"%.fk/%.fk",(float)p.completedUnitCount/1000,(float)p.totalUnitCount/1000];
    }

    return progressInfo;
}

- (void)executeDownloadTask{
    
    APKDVRFileDownloadTask *task = nil;
    if (self.highPriorityTasks.count > 0) {
        
        task = [self.highPriorityTasks objectAtIndex:0];
        
    }else if (self.normalPriorityTasks.count > 0){
        
        task = [self.normalPriorityTasks objectAtIndex:0];
        
    }else if (self.lowPriorityTasks.count > 0){
        
        task = [self.lowPriorityTasks objectAtIndex:0];
    }
    
    if (!task) {
        
        self.isBusy = NO;
        return;
    }
    
    self.isBusy = YES;
    
    NSFileManager *fm = [NSFileManager defaultManager];
    if ([fm fileExistsAtPath:task.targetPath]) {//沙盒中已存在该文件
        
        task.success();
        [self removeTask:task];
        [self executeDownloadTask];
        return;
    }
    
    NSURL *url = [NSURL URLWithString:task.sourcePath];
    NSTimeInterval timeout = 8;
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:timeout];
    __weak typeof(self)weakSelf = self;
    NSURLSessionDownloadTask *downloadTask = [self.sessionManager downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
        
        float progress = [weakSelf progress:downloadProgress];
        NSString *progressInfo = [weakSelf progressInfo:downloadProgress];
        task.progress(progress,progressInfo);
        
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        
        NSURL *url = [NSURL fileURLWithPath:task.targetPath];//下载的目的路径
        return url;
        
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        
        if (error) {
            
            [fm removeItemAtURL:filePath error:nil];
            task.failure();
            
        }else{
            
            task.success();
        }
        
        [weakSelf removeTask:task];
        [weakSelf executeDownloadTask];//
    }];

    [downloadTask resume];
    
    task.cancelHandler = ^{
        
        [downloadTask cancel];
    };
}

#pragma mark - public method

- (void)removeTask:(APKDVRFileDownloadTask *)task{
    
    if (task.priority == kDownloadPriorityLow) {
        
        [self.lowPriorityTasks removeObject:task];
        
    }else if (task.priority == kDownloadPriorityNormal){
        
        [self.normalPriorityTasks removeObject:task];
        
    }else if (task.priority == kDownloadPriorityHigh){
        
        [self.highPriorityTasks removeObject:task];
    }
}

- (void)addTask:(APKDVRFileDownloadTask *)task{
    
    if (task.priority == kDownloadPriorityLow) {
        
        [self.lowPriorityTasks addObject:task];
        
    }else if (task.priority == kDownloadPriorityNormal){
        
        [self.normalPriorityTasks addObject:task];
        
    }else if (task.priority == kDownloadPriorityHigh){
        
        [self.highPriorityTasks addObject:task];
    }
    
    if (!self.isBusy) {
        
        [self executeDownloadTask];
    }
}

#pragma mark - getter

- (AFURLSessionManager *)sessionManager{
    
    if (!_sessionManager) {
        
        _sessionManager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    }
    
    return _sessionManager;
}

- (NSMutableArray *)lowPriorityTasks{
    
    if (!_lowPriorityTasks) {
        
        _lowPriorityTasks = [[NSMutableArray alloc] init];
    }
    
    return _lowPriorityTasks;
}

- (NSMutableArray *)normalPriorityTasks{
    
    if (!_normalPriorityTasks) {
        
        _normalPriorityTasks = [[NSMutableArray alloc] init];
    }
    
    return _normalPriorityTasks;
}

- (NSMutableArray *)highPriorityTasks{
    
    if (!_highPriorityTasks) {
        
        _highPriorityTasks = [[NSMutableArray alloc] init];
    }
    
    return _highPriorityTasks;
}

@end
