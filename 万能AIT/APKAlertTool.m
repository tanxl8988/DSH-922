//
//  APKAlertTool.m
//  Innowa
//
//  Created by Mac on 17/5/2.
//  Copyright © 2017年 APK. All rights reserved.
//

#import "APKAlertTool.h"
#import "MBProgressHUD.h"

@implementation APKAlertTool

+ (UIAlertController *)showAlertInViewController:(UIViewController *)viewController title:(NSString *)title message:(NSString *)message cancelHandler:(void (^)(UIAlertAction *action))cancelHandler confirmHandler:(void (^)(UIAlertAction *action))confirmHandler{
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:NSLocalizedString(@"取消", nil) style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
        if (cancelHandler) {
            
            cancelHandler(action);
        }
    }];
    UIAlertAction *confirm = [UIAlertAction actionWithTitle:NSLocalizedString(@"确定", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        if (confirmHandler) {
            
            confirmHandler(action);
        }
    }];
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:cancel];
    [alert addAction:confirm];
    [viewController presentViewController:alert animated:YES completion:^{
        
    }];
    
    return alert;
}

+ (UIAlertController *)showAlertInViewController:(UIViewController *)viewController title:(NSString *)title message:(NSString *)message confirmHandler:(void (^)(UIAlertAction *action))confirmHandler{
    
    UIAlertAction *confirm = [UIAlertAction actionWithTitle:NSLocalizedString(@"确定", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        if (confirmHandler) {
            
            confirmHandler(action);
        }
    }];
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:confirm];
    [viewController presentViewController:alert animated:YES completion:^{
    }];
    
    return alert;
}

+ (void)showAlertInView:(UIView*)view andText:(NSString*)str
{
    MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithView:view];
    [view addSubview:HUD];
    HUD.label.text = str;
    HUD.mode = MBProgressHUDModeText;
    [HUD showAnimated:YES];
    HUD.yOffset = 100;
    
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [HUD hideAnimated:YES];
        //        HUD = nil;
    });
}

@end
