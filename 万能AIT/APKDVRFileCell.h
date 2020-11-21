//
//  APKDVRFileCell.h
//  万能AIT
//
//  Created by Mac on 17/3/23.
//  Copyright © 2017年 APK. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "APKDVRFile.h"


@class APKDVRFileCell;
@protocol APKDVRFileCellDelegate <NSObject>

- (void)APKDVRFileCell:(APKDVRFileCell *)cell didClickDownloadButton:(UIButton *)sender;
- (void)APKDVRFileCell:(APKDVRFileCell *)cell didClickDeleteButton:(UIButton *)sender;
- (void)APKDVRFileCell:(APKDVRFileCell *)cell didClickLockButton:(UIButton *)sender;

@end

@interface APKDVRFileCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *imagev;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIButton *downloadButton;
@property (weak, nonatomic) IBOutlet UIButton *deleteButton;
@property (weak, nonatomic) IBOutlet UIButton *lockButton;

@property (weak,nonatomic) id<APKDVRFileCellDelegate> delegate;

- (void)configureCellWithDVRFile:(APKDVRFile *)file;

@end
