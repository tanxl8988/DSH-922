//
//  APKAlertTool.h
//  Innowa
//
//  Created by Mac on 17/5/2.
//  Copyright © 2017年 APK. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface APKAlertTool : NSObject

+ (UIAlertController *)showAlertInViewController:(UIViewController *)viewController title:(NSString *)title message:(NSString *)message cancelHandler:(void (^)(UIAlertAction *action))cancelHandler confirmHandler:(void (^)(UIAlertAction *action))confirmHandler;
+ (UIAlertController *)showAlertInViewController:(UIViewController *)viewController title:(NSString *)title message:(NSString *)message confirmHandler:(void (^)(UIAlertAction *action))confirmHandler;
+ (void)showAlertInView:(UIView*)view andText:(NSString*)str;

@end
