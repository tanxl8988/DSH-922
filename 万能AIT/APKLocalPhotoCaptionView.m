//
//  APKLocalPhotoCaptionView.m
//  万能AIT
//
//  Created by Mac on 17/4/18.
//  Copyright © 2017年 APK. All rights reserved.
//

#import "APKLocalPhotoCaptionView.h"

@implementation APKLocalPhotoCaptionView

- (CGSize)sizeThatFits:(CGSize)size {
    
    return CGSizeMake(size.width, 44);
}

- (void)setupCaption {
    
    UIBarButtonItem *flexSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    
    // 初始化
    self.deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.deleteButton.frame = CGRectMake(0, 0, 30, 30);
    [self.deleteButton setBackgroundImage:[UIImage imageNamed:@"delete_normal"] forState:UIControlStateNormal];
    [self.deleteButton setBackgroundImage:[UIImage imageNamed:@"delete_highlight"] forState:UIControlStateHighlighted];
    [self.deleteButton setBackgroundImage:[UIImage imageNamed:@"delete_highlight"] forState:UIControlStateDisabled];
    [self.deleteButton addTarget:self action:@selector(clickActionButton:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *deleteItem = [[UIBarButtonItem alloc]initWithCustomView:self.deleteButton];
    
    [self setItems:@[flexSpace,deleteItem,flexSpace]];
    self.userInteractionEnabled = YES;
}

- (void)clickActionButton:(UIButton *)sender{
    
    if (!self.customDelegate) return;
    
    if (sender == self.deleteButton) {
        
        if ([self.customDelegate respondsToSelector:@selector(APKLocalPhotoCaptionView:didClickDeleteButton:)]) {
            
            [self.customDelegate APKLocalPhotoCaptionView:self didClickDeleteButton:sender];
        }
    }
}

@end
