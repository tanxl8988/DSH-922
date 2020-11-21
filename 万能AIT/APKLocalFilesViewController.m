//
//  APKLocalFilesViewController.m
//  万能AIT
//
//  Created by Mac on 17/5/9.
//  Copyright © 2017年 APK. All rights reserved.
//

#import "APKLocalFilesViewController.h"
#import "APKLocalFileCell.h"
#import "APKPhotosPageFooterView.h"
#import "MBProgressHUD.h"
#import "MWPhotoBrowser.h"
#import "APKMWPhoto.h"
#import "APKLocalPhotoCaptionView.h"
#import "APKVideoPlayer.h"
#import "APKRetrieveLocalFileListing.h"
#import "APKLocalFile.h"
#import "APKCachingAssetThumbnail.h"
#import "APKMOCManager.h"
#import "APKShareTool.h"

static NSString *cellIdentifier = @"localFileCell";
static NSString *footerViewIdentifier = @"footerView";

@interface APKLocalFilesViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,MWPhotoBrowserDelegate,APKLocalPhotoCaptionViewDelegate,APKLocalFileCellDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UICollectionViewFlowLayout *layout;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *selectButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *checkAllButton;
@property (strong,nonatomic) NSMutableArray *dataSource;
@property (weak,nonatomic) APKPhotosPageFooterView *footerView;
@property (strong,nonatomic) NSMutableDictionary *assetInfo;
@property (strong,nonatomic) NSMutableArray *photos;
@property (weak,nonatomic) MWPhotoBrowser *photoBrowser;
@property (assign) BOOL haveRefreshedLocalFiles;
@property (strong,nonatomic) NSIndexPath *longPressIndexPath;
@property (nonatomic) CGSize itemSize;
@property (strong,nonatomic) APKRetrieveLocalFileListing *retrieveLocalFileListing;
@property (strong,nonatomic) APKCachingAssetThumbnail *cachingThumbnail;
@property (nonatomic) BOOL isLoadingData;
@property (nonatomic) BOOL isHaveNoMoreData;
@property (weak,nonatomic) UIBarButtonItem *deleteItem;
@property (weak,nonatomic) UIBarButtonItem *shareItem;

@end

@implementation APKLocalFilesViewController

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
    
    self.collectionView.alwaysBounceVertical = YES;
    
    CGFloat screenWidth = CGRectGetWidth([UIScreen mainScreen].bounds);
    self.layout.footerReferenceSize = CGSizeMake(screenWidth, 40);
    UINib *nib = [UINib nibWithNibName:@"APKPhotosPageFooterView" bundle:nil];
    [self.collectionView registerNib:nib forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:footerViewIdentifier];
    
    self.layout.itemSize = self.itemSize;
    
    [self setupToolBarItems];
    
    [self fetchData];
}

- (void)dealloc
{
    NSLog(@"%s",__func__);
    if (self.haveRefreshedLocalFiles) {
        
        self.updateLocalAlbumCoverBlock(self.fileType);
    }
}

#pragma mark - private method

- (void)updateToolBarItemsWithSelectedFileCount:(NSInteger)fileCount{
    
    if (fileCount > 0) {
        
        self.deleteItem.enabled = YES;
        if (self.fileType == APKFileTypeCapture) {
            self.shareItem.enabled = fileCount <= 9 ? YES : NO;
        }
        else{
            self.shareItem.enabled = fileCount == 1;
        }
    }
    else{
        
        self.deleteItem.enabled = NO;
        self.shareItem.enabled = NO;
    }
}

- (void)fetchData{
    
    self.isLoadingData = YES;
    static NSInteger fetchCount = 21;
    __weak typeof(self)weakSelf = self;
    [self.retrieveLocalFileListing executeWithFileType:self.fileType offset:self.dataSource.count count:fetchCount completionHandler:^(NSArray<APKLocalFile *> *fileArray, NSArray<PHAsset *> *assets) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if (fileArray.count > 0) {
                
                [weakSelf.cachingThumbnail executeWithAssets:assets];
                if (fileArray.count < fetchCount) {
                    
                    weakSelf.isHaveNoMoreData = YES;
                }
                weakSelf.isLoadingData = NO;
                
                if (weakSelf.dataSource.count == 0) {
                    
                    [weakSelf.dataSource addObjectsFromArray:fileArray];
                    NSIndexSet *indexSet = [NSIndexSet indexSetWithIndex:0];
                    [weakSelf.collectionView insertSections:indexSet];
                    
                }else{
                    
                    NSMutableArray *indexPathArray = [[NSMutableArray alloc] init];
                    for (NSInteger item = weakSelf.dataSource.count; item < fileArray.count + weakSelf.dataSource.count ; item++) {
                        
                        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:item inSection:0];
                        [indexPathArray addObject:indexPath];
                    }
                    [weakSelf.dataSource addObjectsFromArray:fileArray];
                    [weakSelf.collectionView insertItemsAtIndexPaths:indexPathArray];
                }
            }
        });
    }];
}

- (void)setupToolBarItems{
    
    UIButton *deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
    deleteButton.frame = CGRectMake(0, 0, 30, 30);
    [deleteButton setBackgroundImage:[UIImage imageNamed:@"delete_normal"] forState:UIControlStateNormal];
    [deleteButton setBackgroundImage:[UIImage imageNamed:@"delete_highlight"] forState:UIControlStateHighlighted];
    [deleteButton addTarget:self action:@selector(clickDeleteButton:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *deleteItem = [[UIBarButtonItem alloc] initWithCustomView:deleteButton];
    self.deleteItem = deleteItem;

    UIButton *shareButton = [UIButton buttonWithType:UIButtonTypeCustom];
    shareButton.frame = CGRectMake(0, 0, 30, 30);
    [shareButton setBackgroundImage:[UIImage imageNamed:@"shareFile_nor"] forState:UIControlStateNormal];
    [shareButton setBackgroundImage:[UIImage imageNamed:@"shareFile_highLight"] forState:UIControlStateHighlighted];
    [shareButton addTarget:self action:@selector(clickShareButton:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *shareItem = [[UIBarButtonItem alloc] initWithCustomView:shareButton];
    self.shareItem = shareItem;
    
    UIBarButtonItem *flexSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    self.toolbarItems = @[deleteItem,flexSpace,shareItem];
}

#pragma mark - MWPhotoBrowserDelegate

- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser{
    
    return self.photos.count;
}

- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index{
    
    MWPhoto *photo = self.photos[index];
    return photo;
}

//- (MWCaptionView *)photoBrowser:(MWPhotoBrowser *)photoBrowser captionViewForPhotoAtIndex:(NSUInteger)index{
//    
//    MWPhoto *photo = self.photos[index];
//    APKLocalPhotoCaptionView *captionView = [[APKLocalPhotoCaptionView alloc] initWithPhoto:photo];
//    captionView.customDelegate = self;
//    return captionView;
//}

#pragma mark - APKLocalPhotoCaptionViewDelegate

- (void)APKLocalPhotoCaptionView:(APKLocalPhotoCaptionView *)captionView didClickDeleteButton:(UIButton *)sender{
    
    APKLocalFile *file = self.dataSource[self.photoBrowser.currentIndex];
    
    [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
       
        [PHAssetChangeRequest deleteAssets:@[file.asset]];
        
    } completionHandler:^(BOOL success, NSError * _Nullable error) {
        
        if (success) {
            
            NSManagedObjectContext *context = [APKMOCManager sharedInstance].context;
            [context performBlock:^{
               
                self.haveRefreshedLocalFiles = YES;

                [context deleteObject:file.info];
                NSError *error = nil;
                [context save:&error];
                
                [self.dataSource removeObject:file];
                [self.collectionView reloadData];
                
                [self.photos removeObjectAtIndex:self.photoBrowser.currentIndex];
                if (self.photos.count == 0) {
                    [self.photoBrowser dismissViewControllerAnimated:YES completion:nil];
                }else{
                    [self.photoBrowser reloadData];
                }
            }];
        }
    }];
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if (collectionView.allowsMultipleSelection) {
        
        [self updateToolBarItemsWithSelectedFileCount:self.collectionView.indexPathsForSelectedItems.count];
        return;
    }
    
    [collectionView deselectItemAtIndexPath:indexPath animated:NO];
    
    if (self.fileType == APKFileTypeCapture){
        
        [self.photos removeAllObjects];
        for (APKLocalFile *file in self.dataSource) {
            
            PHAsset *asset = file.asset;
            APKMWPhoto *photo = [[APKMWPhoto alloc] initWithAsset:asset targetSize:CGSizeMake(asset.pixelWidth, asset.pixelHeight)];
            [self.photos addObject:photo];
        }
        
        MWPhotoBrowser *photoBrowser = [[MWPhotoBrowser alloc] initWithDelegate:self];
        photoBrowser.alwaysShowControls = YES;
        photoBrowser.displayActionButton = NO;
        self.photoBrowser = photoBrowser;
        [photoBrowser setCurrentPhotoIndex:indexPath.row];
        UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:photoBrowser];
        navi.modalPresentationStyle = UIModalPresentationFullScreen;
        [self presentViewController:navi animated:YES completion:nil];
        
    }else{
        
        NSMutableArray *assetArray = [[NSMutableArray alloc] init];
        NSMutableArray *nameArray = [[NSMutableArray alloc] init];
        for (APKLocalFile *file in self.dataSource) {
            
            PHAsset *asset = file.asset;
            [assetArray addObject:asset];
            [nameArray addObject:file.info.name];
        }
        
        APKVideoPlayer *videoPlayer = [self.storyboard instantiateViewControllerWithIdentifier:@"APKVideoPlayer"];
        [videoPlayer configurePlayerWithAssetArray:assetArray nameArray:nameArray playItemIndex:indexPath.row];
        videoPlayer.modalPresentationStyle = UIModalPresentationFullScreen;
        [self presentViewController:videoPlayer animated:YES completion:nil];
    }
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if (collectionView.allowsMultipleSelection) {
    
        [self updateToolBarItemsWithSelectedFileCount:self.collectionView.indexPathsForSelectedItems.count];
    }
}

#pragma mark - APKLocalFileCellDelegate

- (void)beganLongPressAPKLocalFileCell:(APKLocalFileCell *)cell{
    
    //此处需要把indexpath保存起来，因为变成多选模式并刷新列表后，用该Cell找到的IndexPath会变化！
    self.longPressIndexPath = [self.collectionView indexPathForCell:cell];
    [self clickSelectButton:self.selectButton];
}

- (void)endedLongPressAPKLocalFileCell:(APKLocalFileCell *)cell{
    
    [self.collectionView selectItemAtIndexPath:self.longPressIndexPath animated:YES scrollPosition:UICollectionViewScrollPositionNone];
    self.longPressIndexPath = nil;
    
    [self updateToolBarItemsWithSelectedFileCount:1];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    
    return self.dataSource.count == 0 ? 0 : 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return self.dataSource.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    APKLocalFileCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    cell.delegate = self;
    APKLocalFile *file = self.dataSource[indexPath.row];
    NSString *name = [file.info valueForKey:@"name"];
    cell.label.text = name;
    [self.cachingThumbnail requestThumbnailForAsset:file.asset completionHandler:^(UIImage *thumbnail) {
        
        cell.imagev.image = thumbnail;
    }];
    
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    
    if ([kind isEqualToString:UICollectionElementKindSectionFooter]) {
        
        APKPhotosPageFooterView *footerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:footerViewIdentifier forIndexPath:indexPath];
        self.footerView = footerView;
        [self updateFooterView];
        return footerView;
    }
    return nil;
}

- (void)updateFooterView{
    
    if (self.footerView) {
        
        if (self.isHaveNoMoreData) {
            
        }
        NSString *msg = self.isHaveNoMoreData ? [NSString stringWithFormat:NSLocalizedString(@"共有%d个文件", nil),(int)self.dataSource.count] : nil;
        self.footerView.label.text = msg;
    }
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    if (!self.isLoadingData && !self.isHaveNoMoreData) {
        
        CGFloat x = 0;//x是触发操作的阀值
        if (scrollView.contentOffset.y >= fmaxf(.0f, scrollView.contentSize.height - scrollView.frame.size.height) + x)
        {
            [self fetchData];
        }
    }
}

#pragma mark - actions

- (void)clickShareButton:(UIButton *)sender{
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    APKLoadShareItemsCompletionHandler completionHandler = ^(BOOL success, NSArray *items){
        
        [hud hideAnimated:YES];
        if (success) {
            UIActivityViewController *avc = [[UIActivityViewController alloc]initWithActivityItems:items applicationActivities:nil];
            avc.excludedActivityTypes = @[UIActivityTypeSaveToCameraRoll,UIActivityTypeCopyToPasteboard,UIActivityTypeAssignToContact,UIActivityTypeAddToReadingList,UIActivityTypePostToTencentWeibo,UIActivityTypePostToTwitter,UIActivityTypePostToFacebook];
            [self presentViewController:avc animated:YES completion:nil];
        }
    };
    
    NSArray *indexPaths = self.collectionView.indexPathsForSelectedItems;
    NSMutableArray *assets = [[NSMutableArray alloc] init];
    for (NSIndexPath *indexPath in indexPaths) {
        
        APKLocalFile *file = self.dataSource[indexPath.item];
        [assets addObject:file.asset];
    }
    if (self.fileType == APKFileTypeCapture) {
        [APKShareTool loadShareItemsWithLocalPhotoAssets:assets completionHandler:completionHandler];
    }
    else{
        [APKShareTool loadShareItemsWithLocalVideoAsset:assets.firstObject completionHandler:completionHandler];
    }
    
    [self clickSelectButton:self.selectButton];
}

- (void)clickDeleteButton:(UIButton *)sender{
    
    if (self.collectionView.indexPathsForSelectedItems.count == 0) {
        
        return;
    }
    
    NSMutableArray *assets = [[NSMutableArray alloc] init];
    NSMutableArray *fileArray = [[NSMutableArray alloc] init];
    for (NSIndexPath *indexPath in self.collectionView.indexPathsForSelectedItems) {
        
        APKLocalFile *file = self.dataSource[indexPath.item];
        [fileArray addObject:file];
        [assets addObject:file.asset];
    }
    
    [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
        
        [PHAssetChangeRequest deleteAssets:assets];

    } completionHandler:^(BOOL success, NSError * _Nullable error) {
        
        if (success) {
            
            NSManagedObjectContext *context = [APKMOCManager sharedInstance].context;
            [context performBlock:^{
               
                for (APKLocalFile *file in fileArray) {
                    
                    [context deleteObject:file.info];
                }
                NSError *error = nil;
                [context save:&error];
                
                self.haveRefreshedLocalFiles = YES;
                [self.dataSource removeObjectsInArray:fileArray];
                if (self.dataSource.count == 0) {
                    
                    [self.collectionView deleteSections:[NSIndexSet indexSetWithIndex:0]];
                    
                }else{
                    
                    [self.collectionView deleteItemsAtIndexPaths:self.collectionView.indexPathsForSelectedItems];
                }
                [self clickSelectButton:self.selectButton];
                [self updateFooterView];
            }];
        }
    }];
}

- (IBAction)clickCheckAllButton:(UIBarButtonItem *)sender {
    
    if (self.collectionView.indexPathsForSelectedItems.count != self.dataSource.count) {
        
        for (int i = 0; i < self.dataSource.count; i++) {
            
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
            [self.collectionView selectItemAtIndexPath:indexPath animated:NO scrollPosition:UICollectionViewScrollPositionNone];
        }
        
        [self updateToolBarItemsWithSelectedFileCount:self.dataSource.count];
        
    }else{
        
        [self.collectionView reloadData];
        
        [self updateToolBarItemsWithSelectedFileCount:0];
    }
}

- (IBAction)clickSelectButton:(UIBarButtonItem *)sender {
    
    if ([sender.title isEqualToString:NSLocalizedString(@"选择", nil)]) {
        
        sender.title = NSLocalizedString(@"取消", nil);
        self.checkAllButton.title = NSLocalizedString(@"全选", nil);
        self.checkAllButton.enabled = YES;
        [self.navigationController setToolbarHidden:NO];
        [self.navigationItem setHidesBackButton:YES];
        self.collectionView.allowsMultipleSelection = YES;
        
        [self updateToolBarItemsWithSelectedFileCount:0];
        
    }else{
        
        sender.title = NSLocalizedString(@"选择", nil);
        self.checkAllButton.enabled = NO;
        self.checkAllButton.title = @"";
        [self.navigationController setToolbarHidden:YES];
        [self.navigationItem setHidesBackButton:NO];
        self.collectionView.allowsMultipleSelection = NO;
        [self.collectionView reloadData];
    }
}

#pragma mark - getter

- (APKCachingAssetThumbnail *)cachingThumbnail{
    
    if (!_cachingThumbnail) {
        
        _cachingThumbnail = [[APKCachingAssetThumbnail alloc] initWithSize:self.itemSize contentMode:PHImageContentModeAspectFill options:nil];
    }
    
    return _cachingThumbnail;
}

- (APKRetrieveLocalFileListing *)retrieveLocalFileListing{
    
    if (!_retrieveLocalFileListing) {
        
        _retrieveLocalFileListing = [[APKRetrieveLocalFileListing alloc] init];
    }
    
    return _retrieveLocalFileListing;
}

- (CGSize)itemSize{
    
    CGFloat screenWidth = CGRectGetWidth([UIScreen mainScreen].bounds);
    CGFloat space = 20 * 2 + 8 * 2;
    CGFloat infoLabelHeight = 42;
    CGFloat cellWidth = (screenWidth - space) / 3;
    CGFloat imagevHeight = cellWidth / 16.f * 9.f;
    CGFloat cellHeight = imagevHeight + infoLabelHeight;
    
    CGSize size = CGSizeMake(cellWidth, cellHeight);
    return size;
}

- (NSMutableArray *)photos{
    
    if (!_photos) {
        _photos = [[NSMutableArray alloc] init];
    }
    return _photos;
}

- (NSMutableDictionary *)assetInfo{
    
    if (!_assetInfo) {
        _assetInfo = [[NSMutableDictionary alloc] init];
    }
    return _assetInfo;
}

- (NSMutableArray *)dataSource{
    
    if (!_dataSource) {
        
        _dataSource = [[NSMutableArray alloc] init];
    }
    return _dataSource;
}

@end
