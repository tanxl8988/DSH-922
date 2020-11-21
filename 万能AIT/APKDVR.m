//
//  APKDVR.m
//  AITBrain
//
//  Created by Mac on 17/3/20.
//  Copyright © 2017年 APK. All rights reserved.
//

#import "APKDVR.h"
#import "APKWifiTool.h"
#import "APKDVRCommandFactory.h"
#import <UIKit/UIKit.h>

#define LASTDVRMODAL @"lastDVRModal"

@implementation APKDVR

#pragma mark - init

- (instancetype)init
{
    self = [super init];
    if (self) {
    
        APKDVRModal modal = [[NSUserDefaults standardUserDefaults] integerForKey:LASTDVRMODAL];
        _modal = modal;
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleApplicationState:) name:UIApplicationDidBecomeActiveNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleApplicationState:) name:UIApplicationDidEnterBackgroundNotification object:nil];
    }
    return self;
}

- (void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidBecomeActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidEnterBackgroundNotification object:nil];
}

+ (instancetype)sharedInstance{
    
    static APKDVR *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        instance = [[APKDVR alloc] init];
    });
    
    return instance;
}

#pragma mark - public method

- (void)tryToUpdateConnectState{
    
    NSString *aitWifiAddress = @"192.72.1.1";
    NSString *wifiAddress = [APKWifiTool getWifiAddress];
//    NSString *aitWifiAddress = @"192.168.2.1";
    BOOL isConnectedDVRWifi = [wifiAddress isEqualToString:aitWifiAddress];
    if (isConnectedDVRWifi && !self.isConnected) {
        
        [[APKDVRCommandFactory getSettingInfoCommand] execute:^(id responseObject) {
            
            self.settingInfo = responseObject;
            NSString *version = self.settingInfo.FWVersion;
            if ([version hasPrefix:@"RR530"]) {
                self.modal = kAPKDVRModalAosibi;
            }
            else if ([version hasPrefix:@"RR535"] || [version isEqualToString:@"1207"]){
                self.modal = kAPKDVRModalXiongFeng;
            }
            else{
                NSLog(@"⚠️连接的不是我们的DVR！");
//                return;
            }
            self.isConnected = YES;
            
            UIViewController *VC = [self topController];
            NSString *FWVersion = self.settingInfo.FWVersion;
            if (![FWVersion containsString:@"2.4"]) {
                
                static dispatch_once_t onceToken;
                dispatch_once(&onceToken, ^{
                    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:NSLocalizedString(@"硬件升级提示", nil) preferredStyle:UIAlertControllerStyleAlert];
                    
                    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"忽略", nil) style:UIAlertActionStyleCancel handler:nil];
                    UIAlertAction *okAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"确认", nil) style:UIAlertActionStyleDestructive handler:nil];
                    [alertController addAction:cancelAction];
                    [alertController addAction:okAction];
                    
//                    [VC presentViewController:alertController animated:YES completion:nil];
                });
            }
            
            [self startTimer];
            
        } failure:^(int rval) {
            
        }];
    }
    else if (!isConnectedDVRWifi && self.isConnected){
        
        self.settingInfo = nil;
        self.isConnected = NO;
    }
}

- (UIViewController *)topController {
    
    UIViewController *topC = [self topViewController:[[UIApplication sharedApplication].keyWindow rootViewController]];
    while (topC.presentedViewController) {
        topC = [self topViewController:topC.presentedViewController];
    }
    return topC;
}

- (UIViewController *)topViewController:(UIViewController *)controller {
    
    if ([controller isKindOfClass:[UINavigationController class]]) {
        return [self topViewController:[(UINavigationController *)controller topViewController]];
    } else if ([controller isKindOfClass:[UITabBarController class]]) {
        return [self topViewController:[(UITabBarController *)controller selectedViewController]];
    } else {
        return controller;
    }
}

-(void)startTimer
{
    self.timer = [NSTimer timerWithTimeInterval:5.0 target:self selector:@selector(heartbeat) userInfo:nil repeats:YES];
//    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSDefaultRunLoopMode];
}

-(void)heartbeat
{
    [[APKDVRCommandFactory startHeartbeatCommand] execute:^(id responseObject) {
        
        NSLog(@"This is heartbeat!");
    } failure:^(int rval) {
        
    }];
}

#pragma mark - private method

- (void)handleApplicationState:(NSNotification *)notification{
    
    if ([notification.name isEqualToString:UIApplicationDidBecomeActiveNotification]) {
    
        [self tryToUpdateConnectState];
        
    }else if([notification.name isEqualToString:UIApplicationDidEnterBackgroundNotification]){

        if (self.isConnected) {
            
            self.settingInfo = nil;
            self.isConnected = NO;
        }
    }
}

#pragma mark - setter

- (void)setModal:(APKDVRModal)modal{
    
    _modal = modal;
    
    [[NSUserDefaults standardUserDefaults] setInteger:modal forKey:LASTDVRMODAL];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end
