//
//  APKRetrieveDVRFileListing.m
//  Aigo
//
//  Created by Mac on 17/7/13.
//  Copyright © 2017年 APK. All rights reserved.
//

#import "APKRetrieveDVRFileListing.h"
#import "APKDVRCommandFactory.h"
#import "APKDVRFileDownloadTask.h"
#import "APKMOCManager.h"
#import "LocalFileInfo.h"

@interface APKRetrieveDVRFileListing ()

@property (nonatomic) NSInteger fileType;
@property (strong,nonatomic) NSMutableArray *fileArray;
@property (nonatomic) NSInteger numberOfRetrievedFiles;

@end

@implementation APKRetrieveDVRFileListing

- (instancetype)initWithRetrieveFileType:(NSInteger)fileType{
    
    if (self = [super init]) {
        
        self.fileType = fileType;
        self.frontArr = [NSMutableArray array];
        self.rearArr = [NSMutableArray array];
    }
    
    return self;
}

- (void)dealloc
{
//    NSLog(@"%s",__func__);
}

#pragma mark - private 

- (void)retrieveFileListingWithFileType:(NSInteger)fileType success:(void(^)(void))success failure:(void(^)(int rval))failure{
    
    __weak typeof(self)weakSelf = self;
    [[APKDVRCommandFactory getFileListCommandWithFileType:fileType count:10 offset:self.numberOfRetrievedFiles isFrontCamera:self.isFrontCamera] execute:^(id responseObject) {
        
        NSArray *fileArray = responseObject;
        APKDVRFile *file = fileArray.firstObject;

        if (fileArray.count > 0) {
            
            if (weakSelf) {
                
                if ([file.name containsString:@"F."]){
                    [weakSelf.frontArr addObjectsFromArray:fileArray];
                    weakSelf.fileArray = [NSMutableArray arrayWithArray:weakSelf.frontArr];
                }
                else{
                    [weakSelf.rearArr addObjectsFromArray:fileArray];
                    weakSelf.fileArray = [NSMutableArray arrayWithArray:weakSelf.rearArr];
                }
                
//                [weakSelf.fileArray addObjectsFromArray:fileArray];
                weakSelf.numberOfRetrievedFiles += fileArray.count;
                [weakSelf retrieveFileListingWithFileType:fileType success:success failure:failure];
                
            }else{
            
                failure(-1);
            }
            
        }else{
            
            success();
        }
        
    } failure:^(int rval) {
        
        failure(rval);
    }];
}


- (void)loadDownloadStateForFileArray:(NSArray *)fileArray success:(APKRetrieveDVRFileListingSuccessHandler)success{
    
    NSManagedObjectContext *context = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
    [context setParentContext:[APKMOCManager sharedInstance].context];
    [context performBlock:^{
       
        for (APKDVRFile *file in fileArray) {
            
            LocalFileInfo *info = [LocalFileInfo retrieveLocalFileInfoWithName:file.name type:file.type context:context];
            file.isDownloaded = info ? YES : NO;
        }
        
        success(fileArray);
    }];
}

- (void)loadThumbnailForFileArray:(NSArray *)fileArray success:(APKRetrieveDVRFileListingSuccessHandler)success failure:(APKRetrieveDVRFileListingFailureHandler)failure{
    
    __block NSInteger count = fileArray.count;
    for (APKDVRFile *file in fileArray) {
        
        NSString *thumbnailName = [NSString stringWithFormat:@"thumb_%@",file.thumbnailDownloadPath.lastPathComponent];
        NSString *thumbnailPath = [NSTemporaryDirectory() stringByAppendingPathComponent:thumbnailName];
        __weak typeof(self)weakSelf = self;
        [APKDVRFileDownloadTask taskWithPriority:kDownloadPriorityLow sourcePath:file.thumbnailDownloadPath targetPath:thumbnailPath progress:^(float progress, NSString *info) {
            
        } success:^{
            
            file.thumbnailPath = thumbnailPath;
            count--;
            if (count == 0) {
                
                if ([APKMOCManager sharedInstance].context) {
                    
                    [weakSelf loadDownloadStateForFileArray:fileArray success:success];
                    
                }else{
                    
                    success(fileArray);
                }
            }
            
        } failure:^{
            
            count--;
            if (count == 0) {
                
                if ([APKMOCManager sharedInstance].context) {
                    
                    [weakSelf loadDownloadStateForFileArray:fileArray success:success];
                    
                }else{
                    
                    success(fileArray);
                }
            }
        }];
    }
}

- (NSArray *)fileArrayWithCount:(NSInteger)count{
    
    self.fileArray = self.isFrontCamera ? self.frontArr : self.rearArr;
    
    NSRange range;
    if (self.fileArray.count >= count) {
        
        range = NSMakeRange(0, count);
        
    }else{
        
        range = NSMakeRange(0, self.fileArray.count);
    }
    
    NSArray *fileArray = [self.fileArray subarrayWithRange:range];
    
    [self.fileArray removeObjectsInRange:range];
    
    return fileArray;
}

#pragma mark - public method

- (NSArray *)syncWithDeletedFiles:(NSArray *)deletedFiles{
    
    NSMutableArray *dfs = [deletedFiles mutableCopy];
    NSMutableIndexSet *indexSet = [[NSMutableIndexSet alloc] init];
    for (NSInteger i = 0; i < self.fileArray.count; i++) {
        
        APKDVRFile *file = self.fileArray[i];
        for (APKDVRFile *deletedFile in dfs) {
            
            if ([deletedFile.name isEqualToString:file.name]) {
                
                [indexSet addIndex:i];
                [dfs removeObject:deletedFile];
                break;
            }
        }
        
        if (dfs.count == 0) break;
    }
    
    [self.fileArray removeObjectsAtIndexes:indexSet];
    
    return dfs;
}

- (void)retrieveFileListingWithOffset:(NSInteger)offset count:(NSInteger)count success:(APKRetrieveDVRFileListingSuccessHandler)success failure:(APKRetrieveDVRFileListingFailureHandler)failure{
    
    if (offset == 0) {//第一次加载数据
        
        //offset == 0表示需要刷新列表，要重新获取数据
        [self.fileArray removeAllObjects];
        __weak typeof(self)weakSelf = self;
        void (^retrieveSuccess)(void) = ^{
            
            if (!weakSelf) {
                
                failure();
                return;
            }
            
            //排序
            NSComparator cmptr = ^(id obj1, id obj2){
                
                APKDVRFile *file1 = obj1;
                APKDVRFile *file2 = obj2;
                return [file1.fullStyleDate compare:file2.fullStyleDate];
            };
            [weakSelf.fileArray sortUsingComparator:cmptr];
            
            NSArray *fileArray = [weakSelf fileArrayWithCount:count];
            if (fileArray.count == 0) {
 
                success(fileArray);
                
            }else{
                
                [weakSelf loadThumbnailForFileArray:fileArray success:success failure:failure];//缩略图
            }
        };
        
        void (^retrieveFailure)(int val) = ^(int val){
            
            failure();
        };
        
        //command request
        self.numberOfRetrievedFiles = 0;
        if (self.fileType == APKFileTypeAll) {
            
            [self retrieveFileListingWithFileType:APKFileTypeVideo success:^{
                
                weakSelf.numberOfRetrievedFiles = 0;
                [weakSelf retrieveFileListingWithFileType:APKFileTypeEvent success:retrieveSuccess failure:retrieveFailure];
                
            } failure:retrieveFailure];
        
        }else{
            
            [self retrieveFileListingWithFileType:self.fileType success:retrieveSuccess failure:retrieveFailure];
        }
        
    }else{
        
        NSArray *fileArray = [self fileArrayWithCount:count];
        if (fileArray.count == 0) {
            
            success(fileArray);
            
        }else{
            
            [self loadThumbnailForFileArray:fileArray success:success failure:failure];
        }
    }
}

#pragma mark - getter 

- (NSMutableArray *)fileArray{
    
    if (!_fileArray) {
        
        _fileArray = [[NSMutableArray alloc] init];
    }
    
    return _fileArray;
}

@end
