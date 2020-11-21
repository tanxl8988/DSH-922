//
//  APKDVRFilesViewController.m
//  万能AIT
//
//  Created by Mac on 17/3/23.
//  Copyright © 2017年 APK. All rights reserved.
//

#import "APKDVRFilesViewController.h"
#import "APKDVRFileCell.h"
#import "MBProgressHUD.h"
#import "MWPhotoBrowser.h"
#import "APKDVRPhotoCaptionView.h"
#import "APKVideoPlayer.h"
#import "APKAlertTool.h"
#import "APKDownloadInfoView.h"
#import "APKRetrieveDVRFileListing.h"
#import "APKDVRFileDownloadTask.h"
#import "APKMOCManager.h"
#import "APKBatchDownload.h"
#import "APKBatchDelete.h"
#import "APKDVRCommandFactory.h"
#import "APKPhotosTool.h"
#import "LocalFileInfo.h"

static NSString *cellIdentifier = @"dvrFileCell";
#define PageSize 1000

typedef enum : NSUInteger {
    kAPKRequestDVRFileStateNone,
    kAPKRequestDVRFileStateRefreshPage,//刷新页面（下拉刷新）
    kAPKRequestDVRFileStateLoadMore,//上拉加载更多
} APKRequestDVRFileState;

@interface APKDVRFilesViewController ()<APKDVRFileCellDelegate,UITableViewDelegate,UITableViewDataSource,MWPhotoBrowserDelegate,APKDVRPhotoCaptionViewDelegate>

@property (weak, nonatomic) IBOutlet UIBarButtonItem *selectButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *checkAllButton;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *flower;
@property (weak, nonatomic) IBOutlet UILabel *tipsLabel;
@property (strong,nonatomic) UIRefreshControl *refreshControl;
@property (strong,nonatomic) APKRetrieveDVRFileListing *retrieveFileListing;
@property (strong,nonatomic) NSMutableArray *dataSource;
@property (assign) APKRequestDVRFileState requestState;
@property (nonatomic) BOOL isNoMoreFiles;
@property (nonatomic) BOOL isCheckAll;
@property (strong,nonatomic) NSMutableArray *photos;
@property (weak,nonatomic) MWPhotoBrowser *photoBrowser;
@property (assign) BOOL haveRefreshedLocalFiles;
@property (strong,nonatomic) APKBatchDownload *batchDownload;
@property (strong,nonatomic) APKBatchDelete *batchDelete;
@property (strong,nonatomic) APKDVRFileDownloadTask *downloadTask;

@end

@implementation APKDVRFilesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSString *typeKey = @"照片";
    if (self.fileType == APKFileTypeVideo) {
        typeKey = @"视频";
    }else if (self.fileType == APKFileTypeEvent){
        typeKey = @"事件";
    }
    self.navigationItem.title = NSLocalizedString(typeKey, nil);
    
    self.selectButton.title = NSLocalizedString(@"选择", nil);
    self.checkAllButton.title = @"";
    self.checkAllButton.enabled = NO;
    self.tableView.rowHeight = 89;
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(refreshPage) forControlEvents:UIControlEventValueChanged];
//    [self.tableView addSubview:self.refreshControl];
    [self.tableView sendSubviewToBack:self.refreshControl];

    [self setupToolBar];
    
    __weak typeof(self)weakSelf = self;
    [[APKDVRCommandFactory setCommandWithProperty:@"Playback" value:@"enter"] execute:^(id responseObject) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [weakSelf refreshPage];
        });
        
    } failure:^(int rval) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [weakSelf refreshPage];
        });
    }];
}

- (void)requestFileList{
    
    NSInteger offset = self.dataSource.count;
    MBProgressHUD *hud = nil;
    if (offset == 0 && !self.refreshControl.isRefreshing) {
        
        hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    }
    __weak typeof(self)weakSelf = self;
    [self.retrieveFileListing retrieveFileListingWithOffset:offset count:PageSize success:^(NSArray<APKDVRFile *> *fileArray) {
        
        NSMutableArray *requestArr = [NSMutableArray array];
        NSArray *frontArr = fileArray;
        [requestArr addObjectsFromArray:frontArr];
        weakSelf.retrieveFileListing.isFrontCamera = NO;
        [weakSelf.retrieveFileListing retrieveFileListingWithOffset:offset count:PageSize success:^(NSArray<APKDVRFile *> *fileArray) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
//                long count = frontArr.count >= fileArray.count ? frontArr.count : fileArray.count;
//                for (int i = 0; i < count; i++) {
//
//                    if (frontArr.count > 0 && frontArr[i])
//                        [weakSelf.dataSource addObject:frontArr[i]];
//                    if (fileArray.count > 0 && fileArray[i])
//                        [weakSelf.dataSource addObject:fileArray[i]];
//                }
            
//                [weakSelf.dataSource addObjectsFromArray:fileArray];
                [requestArr addObjectsFromArray:fileArray];
                NSArray *sortArr = [weakSelf sortDVRFileWithFileDateAndFOrR:requestArr];
                [weakSelf.dataSource addObjectsFromArray:sortArr];
                [weakSelf.tableView reloadData];
                
                if (weakSelf.flower.isAnimating) [weakSelf.flower stopAnimating];
                if (weakSelf.refreshControl.isRefreshing) [weakSelf.refreshControl endRefreshing];
                if (hud) [hud hideAnimated:YES];
                weakSelf.requestState = kAPKRequestDVRFileStateNone;
                weakSelf.isNoMoreFiles = fileArray.count == 0 ? YES : NO;
            });
            
        } failure:^{
            
        }];
        

        
    } failure:^{
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            weakSelf.requestState = kAPKRequestDVRFileStateNone;
            if (weakSelf.flower.isAnimating) [weakSelf.flower stopAnimating];
            if (weakSelf.refreshControl.isRefreshing) [weakSelf.refreshControl endRefreshing];
            if (hud) [hud hideAnimated:YES];
        });
    }];
}


- (void)dealloc
{
    NSLog(@"%s",__func__);
    
    if (self.haveRefreshedLocalFiles) {
        
        self.updateLocalAlbumCoverBlock(self.fileType);
    }
    
    [[APKDVRCommandFactory setCommandWithProperty:@"Playback" value:@"exit"] execute:^(id responseObject) {
        
    } failure:^(int rval) {
        
    }];
}

#pragma mark - event response

- (void)clickDownloadButton:(UIButton *)sender{
    
    if (![APKMOCManager sharedInstance].context) {
        
        return;
    }
    
    NSMutableArray *fileArray = [[NSMutableArray alloc] init];
    for (NSIndexPath *indexPath in self.tableView.indexPathsForSelectedRows) {
        
        APKDVRFile *file = self.dataSource[indexPath.row];
        if (!file.isDownloaded) {
            
            [fileArray addObject:file];
        }
    }
    
    [self clickSelectButton:self.selectButton];
    if (fileArray.count > 0) {
        
        [self executeBatchDownloadWithFileArray:fileArray];
    }
}

- (void)clickDeleteButton:(UIButton *)sender{
    
    if (self.tableView.indexPathsForSelectedRows.count == 0) {
        
        return;
    }
    
    NSMutableArray *fileArray = [[NSMutableArray alloc] init];
    for (NSIndexPath *indexPath in self.tableView.indexPathsForSelectedRows) {
        
        APKDVRFile *file = self.dataSource[indexPath.row];
        if (!file.isLocked)
            [fileArray addObject:file];
    }
    
    [self clickSelectButton:self.selectButton];
    
    if (fileArray.count == 0)
        return;
    
    NSString *message = [NSString stringWithFormat:NSLocalizedString(@"删除%d个文件？", nil),(int)fileArray.count];
    [APKAlertTool showAlertInViewController:self title:nil message:message cancelHandler:nil confirmHandler:^(UIAlertAction *action) {
        
        [self executeBatchDeleteWithFileArray:fileArray];
    }];
}

- (IBAction)clickSelectButton:(UIBarButtonItem *)sender {
    
    if ([sender.title isEqualToString:NSLocalizedString(@"选择", nil)]) {
        
        self.tableView.editing = YES;
        sender.title = NSLocalizedString(@"取消", nil);
        self.checkAllButton.title = NSLocalizedString(@"全选", nil);
        self.checkAllButton.enabled = YES;
        self.isCheckAll = NO;
        
        [self.navigationController setToolbarHidden:NO];
        [self.navigationItem setHidesBackButton:YES];
        
    }else{
        
        self.tableView.editing = NO;
        sender.title = NSLocalizedString(@"选择", nil);
        self.checkAllButton.enabled = NO;
        self.checkAllButton.title = @"";
        
        [self.navigationController setToolbarHidden:YES];
        [self.navigationItem setHidesBackButton:NO];
    }
}

- (IBAction)clickCheckAllButton:(UIBarButtonItem *)sender {
    
    if (self.isCheckAll) {
        
        for (int i = 0; i < self.dataSource.count; i++) {
            
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
            [self.tableView deselectRowAtIndexPath:indexPath animated:NO];
        }
        
    }else{
        
        for (int i = 0; i < self.dataSource.count; i++) {
            
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
            [self.tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
        }
    }
    
    self.isCheckAll = !self.isCheckAll;
}

#pragma mark - private method

- (void)updateTipsLabel{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        if (self.isNoMoreFiles) {
            
            NSString *tips = [NSString stringWithFormat:NSLocalizedString(@"共有%d个文件", nil),(int)self.dataSource.count];
            self.tipsLabel.text = tips;
            
        }else{
            
            self.tipsLabel.text = nil;
        }
    });
}

- (void)executeBatchDeleteWithFileArray:(NSArray *)fileArray{
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    __weak typeof(self)weakSelf = self;
    [self.batchDelete executeWithFileArray:fileArray progress:^(APKDVRFile *file, BOOL success) {
        
        if (success) {
            
            NSInteger row = [weakSelf.dataSource indexOfObject:file];
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:0];
            dispatch_async(dispatch_get_main_queue(), ^{
            
                [weakSelf.dataSource removeObject:file];
                [weakSelf.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            });
        }
        
    } completionHandler:^{
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [weakSelf updateTipsLabel];
            [hud hideAnimated:YES];
        });
    }];
}

- (void)executeBatchDownloadWithFileArray:(NSArray *)fileArray{
    
    self.haveRefreshedLocalFiles = YES;

    __weak typeof(self)weakSelf = self;
    APKDownloadInfoView *downloadInfoView = [[NSBundle mainBundle] loadNibNamed:@"APKDownloadInfoView" owner:self options:nil].firstObject;
    [downloadInfoView showInView:self.view cancelHandler:^{
        
        [weakSelf.batchDownload cancel];
    }];
    
    [self.batchDownload executeWithFileArray:fileArray globalProgress:^(NSString *globalProgress) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            downloadInfoView.downloadInfoLabel.text = globalProgress;
        });
        
    } currentTaskProgress:^(float progress, NSString *info) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            downloadInfoView.progressView.progress = progress;
            NSString *progressInfo = [NSString stringWithFormat:@"%.1f%%",progress * 100.f];
            downloadInfoView.progressLabel.text = progressInfo;
            downloadInfoView.progressLabel2.text = info;
        });
        
    } completionHandler:^{
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [downloadInfoView dismiss];
            [weakSelf.tableView reloadData];
        });
    }];
}

- (void)previewVideoWithIndexPath:(NSIndexPath *)indexPath{
    
    NSMutableArray *urlArray = [[NSMutableArray alloc] init];
    NSMutableArray *nameArray = [[NSMutableArray alloc] init];
    for (APKDVRFile *file in self.dataSource) {
        
        [nameArray addObject:file.name];
        NSURL *url = [NSURL URLWithString:file.fileDownloadPath];
        [urlArray addObject:url];
    }
    
    APKVideoPlayer *videoPlayer = [self.storyboard instantiateViewControllerWithIdentifier:@"APKVideoPlayer"];
    [videoPlayer configurePlayerWithURLArray:urlArray nameArray:nameArray playItemIndex:indexPath.row];
    videoPlayer.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:videoPlayer animated:YES completion:nil];
}

- (void)previewPhotoWithIndexPath:(NSIndexPath *)indexPath{
    
    [self.photos removeAllObjects];
    for (APKDVRFile *file in self.dataSource) {
        
        UIImage *image = nil;
        if (file.previewPath) {
            image = [UIImage imageWithContentsOfFile:file.previewPath];
        }else if (file.thumbnailPath) {
            image = [UIImage imageWithContentsOfFile:file.thumbnailPath];
        }else{
            image = [UIImage imageNamed:@"cameraPhoto_placeholder"];
        }
        MWPhoto *photo = [MWPhoto photoWithImage:image];
        [self.photos addObject:photo];
    }
    
    MWPhotoBrowser *photoBrowser = [[MWPhotoBrowser alloc] initWithDelegate:self];
    photoBrowser.alwaysShowControls = YES;
    photoBrowser.displayActionButton = NO;
    [photoBrowser setCurrentPhotoIndex:indexPath.row];
    UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:photoBrowser];
    navi.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:navi animated:YES completion:nil];
    self.photoBrowser = photoBrowser;
}



- (void)refreshPage{
    
    if (self.requestState == kAPKRequestDVRFileStateNone && !self.tableView.isEditing) {
        
        self.requestState = kAPKRequestDVRFileStateRefreshPage;
        self.isNoMoreFiles = NO;
        [self.dataSource removeAllObjects];
        [self.tableView reloadData];
        [self requestFileList];
        
    }else{
        
        [self.refreshControl endRefreshing];
    }
}

- (void)setupToolBar{
    
    UIButton *downloadButton = [UIButton buttonWithType:UIButtonTypeCustom];
    downloadButton.frame = CGRectMake(0, 0, 30, 30);
    [downloadButton setBackgroundImage:[UIImage imageNamed:@"download_normal"] forState:UIControlStateNormal];
    [downloadButton setBackgroundImage:[UIImage imageNamed:@"download_highlight"] forState:UIControlStateHighlighted];
    [downloadButton addTarget:self action:@selector(clickDownloadButton:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *downloadItem = [[UIBarButtonItem alloc] initWithCustomView:downloadButton];
    
    UIButton *deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
    deleteButton.frame = CGRectMake(0, 0, 30, 30);
    [deleteButton setBackgroundImage:[UIImage imageNamed:@"delete_normal"] forState:UIControlStateNormal];
    [deleteButton setBackgroundImage:[UIImage imageNamed:@"delete_highlight"] forState:UIControlStateHighlighted];
    [deleteButton addTarget:self action:@selector(clickDeleteButton:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *deleteItem = [[UIBarButtonItem alloc] initWithCustomView:deleteButton];
    
    UIBarButtonItem *flexSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    self.toolbarItems = @[downloadItem,flexSpace,deleteItem];
}

#pragma mark - MWPhotoBrowserDelegate

- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser{
    
    return self.photos.count;
}

- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index{
    
    MWPhoto *photo = self.photos[index];
    return photo;
}

- (void)photoBrowser:(MWPhotoBrowser *)photoBrowser didDisplayPhotoAtIndex:(NSUInteger)index{
    
    APKDVRFile *file = self.dataSource[index];
    if (file.previewPath) {
        
        return;
    }
    
    if (self.downloadTask) {
        
        [self.downloadTask cancel];
    }
    
    __weak typeof(self)weakSelf = self;
    NSString *savePath = [NSTemporaryDirectory() stringByAppendingPathComponent:file.name];//保存路径
    self.downloadTask = [APKDVRFileDownloadTask taskWithPriority:kDownloadPriorityNormal sourcePath:file.fileDownloadPath targetPath:savePath progress:^(float progress, NSString *info) {
        
    } success:^{
        
        file.previewPath = savePath;
        UIImage *image = [UIImage imageWithContentsOfFile:savePath];
        MWPhoto *photo = [MWPhoto photoWithImage:image];
        [weakSelf.photos replaceObjectAtIndex:index withObject:photo];
        if (index == weakSelf.photoBrowser.currentIndex) {
            
            [weakSelf.photoBrowser reloadData];
        }
        
    } failure:^{
        
        if (index == weakSelf.photoBrowser.currentIndex) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                MWPhoto *photo = [MWPhoto photoWithImage:nil];
                [weakSelf.photos replaceObjectAtIndex:index withObject:photo];
                [weakSelf.photoBrowser reloadData];
            });
        }
    }];
}

- (MWCaptionView *)photoBrowser:(MWPhotoBrowser *)photoBrowser captionViewForPhotoAtIndex:(NSUInteger)index{
    
    MWPhoto *photo = self.photos[index];
    APKDVRPhotoCaptionView *captionView = [[APKDVRPhotoCaptionView alloc] initWithPhoto:photo];
    captionView.customDelegate = self;
    
    APKDVRFile *dvrFile = self.dataSource[index];
    [captionView configureViewWithDVRFile:dvrFile];
    
    return captionView;
}

#pragma mark APKDVRPhotoCaptionViewDelegate

- (void)APKDVRPhotoCaptionView:(APKDVRPhotoCaptionView *)captionView didClickDeleteButton:(UIButton *)sender{
    
    NSString *message = [NSString stringWithFormat:NSLocalizedString(@"删除%d个文件？", nil),1];
    [APKAlertTool showAlertInViewController:self.photoBrowser title:nil message:message cancelHandler:nil confirmHandler:^(UIAlertAction *action) {
        
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.photoBrowser.navigationController.view animated:YES];
        
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.photoBrowser.currentIndex inSection:0];
        APKDVRFile *file = self.dataSource[indexPath.row];
        NSString *fileName = [file.originalName stringByReplacingOccurrencesOfString:@"/" withString:@"$"];
        __weak typeof(self)weakSelf = self;
        [[APKDVRCommandFactory deleteCommandWithFileName:fileName] execute:^(id responseObject) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [weakSelf.dataSource removeObject:file];
                [weakSelf.tableView reloadData];
                [weakSelf updateTipsLabel];

                [weakSelf.photos removeObjectAtIndex:weakSelf.photoBrowser.currentIndex];
                if (weakSelf.photos.count == 0) {
                    
                    [weakSelf.photoBrowser dismissViewControllerAnimated:YES completion:nil];
                    
                }else{
                    
                    [weakSelf.photoBrowser reloadData];
                    [weakSelf photoBrowser:weakSelf.photoBrowser didDisplayPhotoAtIndex:weakSelf.photoBrowser.currentIndex];
                }
                
                [hud hideAnimated:YES];
            });
            
        } failure:^(int rval) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                NSString *message = [NSString stringWithFormat:NSLocalizedString(@"%d个文件删除失败！", nil),1];
                [APKAlertTool showAlertInViewController:weakSelf.photoBrowser title:nil message:message confirmHandler:^(UIAlertAction *action) {
                    
                    [hud hideAnimated:YES];
                }];
            });
        }];
    }];
}

- (void)APKDVRPhotoCaptionView:(APKDVRPhotoCaptionView *)captionView didClickDownloadButton:(UIButton *)sender{
    
    NSManagedObjectContext *context = [APKMOCManager sharedInstance].context;
    if (!context) {
        
        return;
    }
    
    MWPhoto *photo = self.photos[self.photoBrowser.currentIndex];
    if (!photo.underlyingImage) {
        
        return;
    }
    
    self.haveRefreshedLocalFiles = YES;
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.photoBrowser.navigationController.view animated:YES];
    __weak typeof(self) weakSelf = self;
    [APKPhotosTool saveImage:photo.underlyingImage successBlock:^(NSString *identifier) {
        
        APKDVRFile *file = weakSelf.dataSource[weakSelf.photoBrowser.currentIndex];
        [context performBlock:^{
            
            [LocalFileInfo createWithName:file.name type:file.type localIdentifier:identifier date:file.fullStyleDate context:context];
            [context save:nil];
            file.isDownloaded = YES;
            [weakSelf.tableView reloadData];
            
            [captionView configureViewWithDVRFile:file];
            [hud hideAnimated:YES];
        }];
        
    } failureBlock:^(NSError *error) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [APKAlertTool showAlertInViewController:weakSelf.photoBrowser title:nil message:NSLocalizedString(@"保存失败！", nil) confirmHandler:^(UIAlertAction *action) {
                
                [hud hideAnimated:YES];
            }];
        });
    }];
}

#pragma mark - APKDVRFileCellDelegate

- (void)APKDVRFileCell:(APKDVRFileCell *)cell didClickDeleteButton:(UIButton *)sender{
    
    NSString *message = [NSString stringWithFormat:NSLocalizedString(@"删除%d个文件？", nil),1];
    [APKAlertTool showAlertInViewController:self title:nil message:message cancelHandler:nil confirmHandler:^(UIAlertAction *action) {
        
        NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
        APKDVRFile *file = self.dataSource[indexPath.row];
        [self executeBatchDeleteWithFileArray:@[file]];
    }];
}

- (void)APKDVRFileCell:(APKDVRFileCell *)cell didClickDownloadButton:(UIButton *)sender{
    
    NSManagedObjectContext *context = [APKMOCManager sharedInstance].context;
    if (!context) {
        
        return;
    }
    
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    APKDVRFile *file = self.dataSource[indexPath.row];
    
    if (file.isDownloaded == YES) {
        
        [APKAlertTool showAlertInViewController:self title:nil message:NSLocalizedString(@"该视频已下载", nil) confirmHandler:nil];
        return;
    }
    
    [self executeBatchDownloadWithFileArray:@[file]];
}

- (void)APKDVRFileCell:(APKDVRFileCell *)cell didClickLockButton:(UIButton *)sender{
    
    
}

#pragma mark - UITableViewDelegate

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return tableView.isEditing ? UITableViewCellEditingStyleDelete | UITableViewCellEditingStyleInsert : UITableViewCellEditingStyleDelete;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (tableView.isEditing) {
        return;
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (self.fileType == APKFileTypeCapture) {
    
        [self previewPhotoWithIndexPath:indexPath];
        
    }else{
        
        [self previewVideoWithIndexPath:indexPath];
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    APKDVRFileCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    APKDVRFile *file = self.dataSource[indexPath.row];
    [cell configureCellWithDVRFile:file];
    cell.delegate = self;
    return cell;
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    if (self.requestState == kAPKRequestDVRFileStateNone && self.dataSource.count != 0 && !self.isNoMoreFiles && !self.tableView.isEditing) {
        
        CGFloat x = 0;//x是触发操作的阀值
        if (scrollView.contentOffset.y >= fmaxf(.0f, scrollView.contentSize.height - scrollView.frame.size.height) + x)
        {
            self.requestState = kAPKRequestDVRFileStateLoadMore;
            [self.flower startAnimating];
            [self requestFileList];
        }
    }
}


#pragma mark - getter

- (APKBatchDelete *)batchDelete{
    
    if (!_batchDelete) {
        
        _batchDelete = [[APKBatchDelete alloc] init];
    }
    
    return _batchDelete;
}

- (APKBatchDownload *)batchDownload{
    
    if (!_batchDownload) {
        
        _batchDownload = [[APKBatchDownload alloc] init];
    }
    
    return _batchDownload;
}

- (NSMutableArray *)photos{
    
    if (!_photos) {
        
        _photos = [[NSMutableArray alloc] init];
    }
    return _photos;
}

- (APKRetrieveDVRFileListing *)retrieveFileListing{
    
    if (!_retrieveFileListing) {
    
        _retrieveFileListing = [[APKRetrieveDVRFileListing alloc] initWithRetrieveFileType:self.fileType];
        _retrieveFileListing.isFrontCamera = YES;
    }

    return _retrieveFileListing;
}

- (NSMutableArray *)dataSource{
    
    if (!_dataSource) {
        
        _dataSource = [[NSMutableArray alloc] init];
    }
    return _dataSource;
}

#pragma mark - setter

- (void)setIsNoMoreFiles:(BOOL)isNoMoreFiles{
    
    _isNoMoreFiles = isNoMoreFiles;
    
    [self updateTipsLabel];
}

@end
