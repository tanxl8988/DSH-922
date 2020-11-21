//
//  APKLocalPhotoCaptionView.h
//  万能AIT
//
//  Created by Mac on 17/4/18.
//  Copyright © 2017年 APK. All rights reserved.
//

#import <MWPhotoBrowser/MWPhotoBrowser.h>

@class APKLocalPhotoCaptionView;

@protocol APKLocalPhotoCaptionViewDelegate <NSObject>

- (void)APKLocalPhotoCaptionView:(APKLocalPhotoCaptionView *)captionView didClickDeleteButton:(UIButton *)sender;

@end

@interface APKLocalPhotoCaptionView : MWCaptionView

@property (strong,nonatomic) UIButton *deleteButton;
@property (weak,nonatomic) id<APKLocalPhotoCaptionViewDelegate> customDelegate;

@end
