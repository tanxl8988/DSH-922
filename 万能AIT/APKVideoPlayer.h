//
//  APKLocalVideoPlayerVC.h
//  第三版云智汇
//
//  Created by Mac on 16/8/10.
//  Copyright © 2016年 APK. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Photos/Photos.h>

@interface APKAVPlayerView : UIView

@property (strong,nonatomic) AVPlayer *player;

@end

@interface APKVideoPlayer : UIViewController

- (void)configurePlayerWithURLArray:(NSArray <NSURL *>*)urlArray nameArray:(NSArray *)nameArray playItemIndex:(NSInteger)playItemIndex;
- (void)configurePlayerWithAssetArray:(NSArray <PHAsset *>*)assetArray nameArray:(NSArray *)nameArray playItemIndex:(NSInteger)playItemIndex;

@end
