//
//  APKFoldersViewController.m
//  万能AIT
//
//  Created by Mac on 17/3/22.
//  Copyright © 2017年 APK. All rights reserved.
//

#import "APKFoldersViewController.h"
#import "APKFloderCell.h"
#import "APKDVRFilesViewController.h"
#import "APKLocalFilesViewController.h"
#import "MBProgressHUD.h"
#import "APKDVR.h"
#import "APKAlertTool.h"
#import <Photos/Photos.h>
#import "APKAlbumCoverInfo.h"
#import "APKGetLocalAlbumCoverInfo.h"


static NSString *localFloderCellIdentifier = @"localFloderCell";
static NSString *dvrFloderCellIdentifier = @"dvrFloderCell";

@interface APKFoldersViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *scrollViewContentWidth;
@property (weak, nonatomic) IBOutlet UICollectionView *localFloderCollectionView;
@property (weak, nonatomic) IBOutlet UICollectionView *dvrFloderCollectionView;
@property (weak, nonatomic) IBOutlet UICollectionViewFlowLayout *localFloderLayout;
@property (weak, nonatomic) IBOutlet UICollectionViewFlowLayout *dvrFloderLayout;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentControl;
@property (strong,nonatomic) NSMutableArray *localAlbumInfos;
@property (strong,nonatomic) NSMutableArray *dvrAlbumInfos;
@property (strong,nonatomic) APKGetLocalAlbumCoverInfo *getLocalAlbumCoverInfo;
@property (strong,nonatomic) NSArray *albumSort;//决定文件夹的排序
@property (copy,nonatomic) void (^updateLocalAlbumCoverInfoBlock)(APKFileType fileType);

@end

@implementation APKFoldersViewController


#pragma mark - life circle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title = NSLocalizedString(@"相册", nil);

    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    self.scrollViewContentWidth.constant = screenWidth * 2;
    
    CGFloat space = (self.localFloderLayout.sectionInset.left + self.localFloderLayout.sectionInset.right) * 2;
    CGFloat infoViewHeight = 29;
    CGFloat cellWidth = (screenWidth - space) / 2;
    CGFloat cellHeight = cellWidth * 0.77 + infoViewHeight;
    CGSize cellSize = CGSizeMake(cellWidth, cellHeight);
    self.localFloderLayout.itemSize = cellSize;
    self.dvrFloderLayout.itemSize = cellSize;
    
    [self.segmentControl removeAllSegments];
    [self.segmentControl insertSegmentWithTitle:NSLocalizedString(@"本地", nil) atIndex:0 animated:NO];
    [self.segmentControl insertSegmentWithTitle:NSLocalizedString(@"DVR", nil) atIndex:1 animated:NO];
    self.segmentControl.selectedSegmentIndex = 0;
    
    //Photos authorization
    [self checkPHAuthorizationStatus];
    
    //setup block
    [self setupUpdateLocalAlbumCoverInfoBlock];
}

#pragma mark - private method

- (void)setupUpdateLocalAlbumCoverInfoBlock{
    
    __weak typeof(self)weakSelf = self;
    self.updateLocalAlbumCoverInfoBlock = ^(APKFileType fileType){
        
        if (self.localAlbumInfos.count == 0) return;
        
        [weakSelf.getLocalAlbumCoverInfo getLocalAlbumCoverInfoWithType:fileType completionHandler:^(APKAlbumCoverInfo *info) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                NSInteger item = [weakSelf.albumSort indexOfObject:@(fileType)];
                [weakSelf.localAlbumInfos replaceObjectAtIndex:item withObject:info];
                NSIndexPath *indexPath = [NSIndexPath indexPathForItem:item inSection:0];
                [weakSelf.localFloderCollectionView reloadItemsAtIndexPaths:@[indexPath]];
            });
        }];
    };
}

- (void)loadLocalAlbumCoverInfo{
    
    [self.getLocalAlbumCoverInfo getLocalAlbumCoverInfo:self.albumSort completionHandler:^(NSArray<APKAlbumCoverInfo *> *infos) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self.localAlbumInfos setArray:infos];
            NSIndexSet *indexset = [NSIndexSet indexSetWithIndex:0];
            [self.localFloderCollectionView insertSections:indexset];
        });
    }];
}

- (void)checkPHAuthorizationStatus{
    
    PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
    if (status == PHAuthorizationStatusAuthorized) {
        
        [self loadLocalAlbumCoverInfo];
        
    }else{
        
        if (status == PHAuthorizationStatusDenied) {
            
            [self showGetPHAuthorizationAlert];
            
        }else{
            
            [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
                
                if (status == PHAuthorizationStatusAuthorized) {
                    
                    [self loadLocalAlbumCoverInfo];
                }
            }];
        }
    }
}

- (void)showGetPHAuthorizationAlert{
    
    [APKAlertTool showAlertInViewController:self title:nil message:NSLocalizedString(@"请允许访问iPhone的\"照片\"，否则无法使用下载功能！", nil) confirmHandler:^(UIAlertAction *action) {
        
        NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
        UIApplication *app = [UIApplication sharedApplication];
        if ([app canOpenURL:url]) {
            
            NSString *iosVersion = [[UIDevice currentDevice] systemVersion];
            NSInteger iosVersionNumber = [[[iosVersion componentsSeparatedByString:@"."] firstObject] integerValue];
            if (iosVersionNumber >= 10) {
                
                [app openURL:url options:@{} completionHandler:^(BOOL success) { /*do nothing*/ }];
                
            }else{
                
                [app openURL:url];
            }
        }
    }];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    
    if (collectionView == self.dvrFloderCollectionView) {
        
        return self.dvrAlbumInfos.count == 0 ? 0 : 1;
        
    }else{
        
        return self.localAlbumInfos.count == 0 ? 0 : 1;
    }
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return collectionView == self.localFloderCollectionView ? self.localAlbumInfos.count : self.dvrAlbumInfos.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    APKFloderCell *cell = nil;
    if (collectionView == self.localFloderCollectionView) {
        
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:localFloderCellIdentifier forIndexPath:indexPath];
        APKAlbumCoverInfo *albumInfo = self.localAlbumInfos[indexPath.row];
        cell.label.text = albumInfo.info;
        cell.imagev.image = albumInfo.image;
        if (albumInfo.asset) {
            [[PHImageManager defaultManager] requestImageForAsset:albumInfo.asset targetSize:cell.coverImagev.frame.size contentMode:PHImageContentModeAspectFill options:nil resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
                cell.coverImagev.image = result;
            }];
        }else{
            cell.coverImagev.image = nil;
        }
        
    }else if (collectionView == self.dvrFloderCollectionView){
        
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:dvrFloderCellIdentifier forIndexPath:indexPath];
        APKAlbumCoverInfo *albumInfo = self.dvrAlbumInfos[indexPath.row];
        cell.label.text = albumInfo.info;
        cell.imagev.image = albumInfo.image;
        cell.coverImagev.image = nil;
    }
    
    return cell;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if (collectionView == self.localFloderCollectionView) {
        
        APKAlbumCoverInfo *albumInfo = self.localAlbumInfos[indexPath.row];
        [self performSegueWithIdentifier:@"browseLocalFiles" sender:albumInfo];
        
    }else if (collectionView == self.dvrFloderCollectionView){
        
        if (![APKDVR sharedInstance].isConnected) {
            
            [APKAlertTool showAlertInViewController:self title:nil message:NSLocalizedString(@"未连接DVR", nil) confirmHandler:^(UIAlertAction *action) {
            }];
            return;
        }
        
        APKAlbumCoverInfo *albumInfo = self.dvrAlbumInfos[indexPath.row];
        [self performSegueWithIdentifier:@"browseDVRFiles" sender:albumInfo];
    }
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    CGFloat offsetX = scrollView.contentOffset.x;
    if (offsetX == 0) {
        
        self.segmentControl.selectedSegmentIndex = 0;
        
    }else{
        
        self.segmentControl.selectedSegmentIndex = 1;
    }
}

#pragma mark - actions

- (IBAction)updateSegmentControl:(UISegmentedControl *)sender {
    
    CGFloat offsetX = 0;
    if (sender.selectedSegmentIndex == 1) {
        CGFloat scrollViewWidth = CGRectGetWidth(self.scrollView.frame);
        offsetX = scrollViewWidth;
    }
    CGPoint offset = self.scrollView.contentOffset;
    offset.x = offsetX;
    
    [UIView animateWithDuration:0.3 animations:^{
        
        self.scrollView.contentOffset = offset;
    }];
}

#pragma mark - segue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    if ([segue.identifier isEqualToString:@"browseLocalFiles"]) {
        
        APKAlbumCoverInfo *albumInfo = sender;
        APKLocalFilesViewController *vc = segue.destinationViewController;
        vc.fileType = albumInfo.fileType;
        vc.updateLocalAlbumCoverBlock = self.updateLocalAlbumCoverInfoBlock;

    }else if ([segue.identifier isEqualToString:@"browseDVRFiles"]){
        
        APKAlbumCoverInfo *albumInfo = sender;
        APKDVRFilesViewController *vc = segue.destinationViewController;
        vc.fileType = albumInfo.fileType;
        vc.updateLocalAlbumCoverBlock = self.updateLocalAlbumCoverInfoBlock;
    }
}

#pragma mark - getter

- (NSArray *)albumSort{
    
    if (!_albumSort) {
        
        _albumSort = @[@(APKFileTypeCapture),@(APKFileTypeVideo),@(APKFileTypeEvent)];
    }
    
    return _albumSort;
}

- (APKGetLocalAlbumCoverInfo *)getLocalAlbumCoverInfo{
    
    if (!_getLocalAlbumCoverInfo) {
        
        _getLocalAlbumCoverInfo = [[APKGetLocalAlbumCoverInfo alloc] init];
    }
    
    return _getLocalAlbumCoverInfo;
}

- (NSMutableArray *)localAlbumInfos{
    
    if (!_localAlbumInfos) {
        
        _localAlbumInfos = [[NSMutableArray alloc] init];
    }
    
    return _localAlbumInfos;
}

- (NSMutableArray *)dvrAlbumInfos{
    
    if (!_dvrAlbumInfos) {
        
        _dvrAlbumInfos = [[NSMutableArray alloc] init];
        for (NSNumber *number in self.albumSort) {
            
            APKFileType type = [number integerValue];
            APKAlbumCoverInfo *info = [APKAlbumCoverInfo dvrAlbumWithType:type];
            [_dvrAlbumInfos addObject:info];
        }
    }
    return _dvrAlbumInfos;
}

@end



