//
//  APKDVRCommandFactory.h
//  Aigo
//
//  Created by Mac on 17/6/30.
//  Copyright © 2017年 APK. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "APKDVRCommand.h"

@interface APKDVRCommandFactory : NSObject

+ (APKDVRCommand *)rebotWifiCommand;
+ (APKDVRCommand *)modifyWifiCommandWithAccount:(NSString *)account password:(NSString *)password;
+ (APKDVRCommand *)getWifiInfoCommand;
+ (APKDVRCommand *)setCommandWithProperty:(NSString *)property value:(NSString *)value;
+ (APKDVRCommand *)getLiveUrlCommand;
+ (APKDVRCommand *)deleteCommandWithFileName:(NSString *)fileName;
+ (APKDVRCommand *)getFileListCommandWithFileType:(NSInteger)type count:(NSInteger)count offset:(NSInteger)offset isFrontCamera:(BOOL)isFrontCamera;
+ (APKDVRCommand *)getSettingInfoCommand;
+ (APKDVRCommand *)changeCameraCommand:(BOOL)isFront;
+ (APKDVRCommand *)captureCommand;
+ (APKDVRCommand *)getCameraStateCommand;
+ (APKDVRCommand *)getDBValueCommand;

+ (APKDVRCommand *)getRearInfoCommand;

+ (APKDVRCommand *)startHeartbeatCommand;
+ (APKDVRCommand *)getFormatSDCardInfo;


@end
