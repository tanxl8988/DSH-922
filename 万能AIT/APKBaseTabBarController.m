//
//  APKBaseTabBarController.m
//  保时捷项目
//
//  Created by Mac on 16/5/9.
//
//

#import "APKBaseTabBarController.h"

@interface APKBaseTabBarController ()

@end

@implementation APKBaseTabBarController

#pragma mark - system

-(BOOL)shouldAutorotate{
    
    return [self.selectedViewController shouldAutorotate];
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations{
    
    return [self.selectedViewController supportedInterfaceOrientations];
}

- (UIStatusBarStyle)preferredStatusBarStyle{
    
    return [self.selectedViewController preferredStatusBarStyle];
}

@end
