//
//  APKCustomTabBarController.m
//  万能AIT
//
//  Created by Mac on 17/4/11.
//  Copyright © 2017年 APK. All rights reserved.
//

#import "APKCustomTabBarController.h"

@interface APKCustomTabBarController ()

@end

@implementation APKCustomTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UITabBarItem *previewItem = self.tabBar.items[0];
    UITabBarItem *albumItem = self.tabBar.items[1];
    UITabBarItem *settingsItem = self.tabBar.items[2];
    previewItem.title = NSLocalizedString(@"摄像机", nil);
    albumItem.title = NSLocalizedString(@"相册", nil);
    settingsItem.title = NSLocalizedString(@"设置", nil);
    [self.tabBar setTintColor:[UIColor colorWithRed:249.f/255.f green:77.f/255.f blue:9.f/255.f alpha:1]];
}


@end
