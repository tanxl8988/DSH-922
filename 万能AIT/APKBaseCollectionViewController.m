//
//  APKBaseCollectionViewController.m
//  保时捷项目
//
//  Created by Mac on 16/4/21.
//
//

#import "APKBaseCollectionViewController.h"

@interface APKBaseCollectionViewController ()

@end

@implementation APKBaseCollectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (BOOL)shouldAutorotate{
    
    return NO;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations{
    
    return UIInterfaceOrientationMaskPortrait;
}

- (UIStatusBarStyle)preferredStatusBarStyle{
    
    return UIStatusBarStyleLightContent;
}


@end
