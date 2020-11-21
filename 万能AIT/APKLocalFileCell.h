//
//  APKLocalFileCell.h
//  万能AIT
//
//  Created by Mac on 17/5/9.
//  Copyright © 2017年 APK. All rights reserved.
//

#import <UIKit/UIKit.h>


@class APKLocalFileCell;
@protocol APKLocalFileCellDelegate <NSObject>

- (void)beganLongPressAPKLocalFileCell:(APKLocalFileCell *)cell;
- (void)endedLongPressAPKLocalFileCell:(APKLocalFileCell *)cell;

@end

@interface APKLocalFileCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *imagev;
@property (weak, nonatomic) IBOutlet UIImageView *selectFlag;
@property (weak, nonatomic) IBOutlet UILabel *label;
@property (weak,nonatomic) id<APKLocalFileCellDelegate> delegate;

@end
