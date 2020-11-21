//
//  APKLocalFileCell.m
//  万能AIT
//
//  Created by Mac on 17/5/9.
//  Copyright © 2017年 APK. All rights reserved.
//

#import "APKLocalFileCell.h"

@implementation APKLocalFileCell


- (void)awakeFromNib{
    
    [super awakeFromNib];
    
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressCell:)];
    self.userInteractionEnabled = YES;
    [self addGestureRecognizer:longPress];
}

- (void)longPressCell:(UILongPressGestureRecognizer *)sender {

    if (self.delegate) {
        
        if (sender.state == UIGestureRecognizerStateBegan) {
            
            if ([self.delegate respondsToSelector:@selector(beganLongPressAPKLocalFileCell:)]) {
                
                [self.delegate beganLongPressAPKLocalFileCell:self];
            }
            
        }else if (sender.state == UIGestureRecognizerStateEnded){
            
            if ([self.delegate respondsToSelector:@selector(endedLongPressAPKLocalFileCell:)]) {
                
                [self.delegate endedLongPressAPKLocalFileCell:self];
            }
        }
    }
}

- (void)setSelected:(BOOL)selected{
    
    [super setSelected:selected];
    
    self.selectFlag.hidden = !selected;
}

@end
