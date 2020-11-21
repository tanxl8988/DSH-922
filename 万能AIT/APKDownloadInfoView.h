//
//  APKDownloadInfoView.h
//  Innowa
//
//  Created by Mac on 17/4/26.
//  Copyright © 2017年 APK. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface APKDownloadInfoView : UIView

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *downloadInfoLabel;
@property (weak, nonatomic) IBOutlet UILabel *progressLabel;
@property (weak, nonatomic) IBOutlet UILabel *progressLabel2;
@property (weak, nonatomic) IBOutlet UIProgressView *progressView;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;

- (void)showInView:(UIView *)view cancelHandler:(void (^)(void))cancelHandler;
- (void)dismiss;


@end
