//
//  APKDVRPhotoCaptionView.h
//  万能AIT
//
//  Created by Mac on 17/3/24.
//  Copyright © 2017年 APK. All rights reserved.
//

#import <MWPhotoBrowser/MWPhotoBrowser.h>
#import "APKDVRFile.h"

@class APKDVRPhotoCaptionView;

@protocol APKDVRPhotoCaptionViewDelegate <NSObject>

- (void)APKDVRPhotoCaptionView:(APKDVRPhotoCaptionView *)captionView didClickDeleteButton:(UIButton *)sender;
- (void)APKDVRPhotoCaptionView:(APKDVRPhotoCaptionView *)captionView didClickDownloadButton:(UIButton *)sender;

@end

@interface APKDVRPhotoCaptionView : MWCaptionView

@property (strong,nonatomic) UIButton *deleteButton;
@property (strong,nonatomic) UIButton *downloadButton;
@property (weak,nonatomic) id<APKDVRPhotoCaptionViewDelegate> customDelegate;

- (void)configureViewWithDVRFile:(APKDVRFile *)file;

@end
