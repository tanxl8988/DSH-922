//
//  APKBatchDelete.m
//  万能AIT
//
//  Created by Mac on 17/7/28.
//  Copyright © 2017年 APK. All rights reserved.
//

#import "APKBatchDelete.h"
#import "APKDVRCommandFactory.h"

@interface APKBatchDelete ()

@property (copy,nonatomic) APKBatchDeleteProgressHandler progress;
@property (copy,nonatomic) APKBatchDeleteCompletionHandler completionHandler;
@property (strong,nonatomic) NSMutableArray *fileArray;

@end

@implementation APKBatchDelete

#pragma mark - private method

- (void)setupNewDeleteTask{
    
    APKDVRFile *file = self.fileArray.firstObject;
    NSString *fileName = [file.originalName stringByReplacingOccurrencesOfString:@"/" withString:@"$"];
    
    __weak typeof(self)weakSelf = self;
    [[APKDVRCommandFactory deleteCommandWithFileName:fileName] execute:^(id responseObject) {
        
        weakSelf.progress(file,YES);
        [weakSelf.fileArray removeObject:file];
        if (weakSelf.fileArray.count == 0) {
            
            weakSelf.completionHandler();
            
        }else{
            
            [weakSelf setupNewDeleteTask];
        }
        
    } failure:^(int rval) {
        
        weakSelf.progress(file,NO);
        [weakSelf.fileArray removeObject:file];
        if (weakSelf.fileArray.count == 0) {
            
            weakSelf.completionHandler();
            
        }else{
            
            [weakSelf setupNewDeleteTask];
        }
    }];
}

#pragma mark - public method

- (void)executeWithFileArray:(NSArray<APKDVRFile *> *)fileArray progress:(APKBatchDeleteProgressHandler)progress completionHandler:(APKBatchDeleteCompletionHandler)completionHandler{
    
    [self.fileArray setArray:fileArray];
    self.progress = progress;
    self.completionHandler = completionHandler;
    
    [self setupNewDeleteTask];
}

#pragma mark - getter

- (NSMutableArray *)fileArray{
    
    if (!_fileArray) {
        
        _fileArray = [[NSMutableArray alloc] init];
    }
    
    return _fileArray;
}

@end
