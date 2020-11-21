//
//  APKDVRFileCell.m
//  万能AIT
//
//  Created by Mac on 17/3/23.
//  Copyright © 2017年 APK. All rights reserved.
//

#import "APKDVRFileCell.h"


@implementation APKDVRFileCell


- (void)configureCellWithDVRFile:(APKDVRFile *)file{
    
    self.titleLabel.text = file.name;
//    self.downloadButton.enabled = !file.isDownloaded;
    self.downloadButton.selected = file.isDownloaded;
    self.lockButton.hidden = !file.isLocked;
    self.deleteButton.enabled = !file.isLocked;
    
    if (file.thumbnailPath) {
        UIImage *image = [UIImage imageWithContentsOfFile:file.thumbnailPath];
        self.imagev.image = image;
    }
}

- (IBAction)didClickDeleteButton:(UIButton *)sender {
    
    if (self.delegate) {
        
        if ([self.delegate respondsToSelector:@selector(APKDVRFileCell:didClickDeleteButton:)]) {
            
            [self.delegate APKDVRFileCell:self didClickDeleteButton:sender];
        }
    }
}

- (IBAction)didClickDownloadButton:(UIButton *)sender {
    
    if (self.delegate) {
        
        if ([self.delegate respondsToSelector:@selector(APKDVRFileCell:didClickDownloadButton:)]) {
            
            [self.delegate APKDVRFileCell:self didClickDownloadButton:sender];
        }
    }
}

- (IBAction)didClickLockButton:(UIButton *)sender {
    
    if (self.delegate) {
        
        if ([self.delegate respondsToSelector:@selector(APKDVRFileCell:didClickLockButton:)]) {
            
            [self.delegate APKDVRFileCell:self didClickLockButton:sender];
        }
    }
}

@end
