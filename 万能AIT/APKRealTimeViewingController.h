//
//  APKRtspPlayerController.h
//  万能AIT
//
//  Created by Mac on 17/12/19.
//  Copyright © 2017年 APK. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface APKRealTimeViewingController : UIViewController

@property (strong,nonatomic) NSURL *url;
- (void)play;
- (void)stop;

-(void)createTimer;
-(void)ClearTimer;

@end
