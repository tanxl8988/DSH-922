//
//  APKLockRemainingTimeRecorder.m
//  万能AIT
//
//  Created by Mac on 18/2/1.
//  Copyright © 2018年 APK. All rights reserved.
//

#import "APKLockRemainingTimeRecorder.h"
#import "APKDVR.h"

@interface APKLockRemainingTimeRecorder ()

@property (copy,nonatomic) void (^updateRemainingTimeHandler)(int);
@property (strong,nonatomic) NSTimer *timer;

@end

@implementation APKLockRemainingTimeRecorder

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        APKDVR *dvr = [APKDVR sharedInstance];
        [dvr addObserver:self forKeyPath:@"isConnected" options:NSKeyValueObservingOptionNew context:nil];
    }
    return self;
}

- (void)dealloc{
    
    APKDVR *dvr = [APKDVR sharedInstance];
    [dvr removeObserver:self forKeyPath:@"isConnected"];
}


#pragma mark - public method

- (void)interrupt{
    
    if (self.timer) {
        
        [self.timer invalidate];
        self.timer = nil;
        
        self.remainingTime = -1;
        self.updateRemainingTimeHandler(self.remainingTime);
    }
}

- (void)launchWithUpdateRemainingTimeHandler:(void (^)(int))updateRemainingTimeHandler{
    
    self.updateRemainingTimeHandler = updateRemainingTimeHandler;
    self.remainingTime = 120;
    
    self.updateRemainingTimeHandler(self.remainingTime);
    
    self.timer = [NSTimer timerWithTimeInterval:1 target:self selector:@selector(updateRemainingTime) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}

#pragma mark - KVO

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    
    if ([keyPath isEqualToString:@"isConnected"]) {
        
        BOOL isConnected = [change[@"new"] boolValue];
        if (!isConnected) {
            
            [self interrupt];
        }
    }
}

#pragma mark - private method

- (void)updateRemainingTime{
    
    self.remainingTime--;
    self.updateRemainingTimeHandler(self.remainingTime);
    
    if (self.remainingTime < 0) {
        
        [self.timer invalidate];
        self.timer = nil;
    }
}
                
@end
