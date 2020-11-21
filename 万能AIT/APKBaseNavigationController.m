//
//  APKBaseNavigationController.m
//  保时捷项目
//
//  Created by Mac on 16/4/26.
//
//

#import "APKBaseNavigationController.h"

@interface APKBaseNavigationController ()

@end

@implementation APKBaseNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(BOOL)shouldAutorotate{
    
    return [self.topViewController shouldAutorotate];
}

-(UIInterfaceOrientationMask)supportedInterfaceOrientations{
    
    return [self.topViewController supportedInterfaceOrientations];
}

- (UIStatusBarStyle)preferredStatusBarStyle{
    
    return [self.topViewController preferredStatusBarStyle];
}

@end
