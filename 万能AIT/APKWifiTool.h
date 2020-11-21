//
//  APKWifiTool.h
//  保时捷项目
//
//  Created by Mac on 16/5/16.
//
//

#import <Foundation/Foundation.h>

@interface APKWifiTool : NSObject

+ (NSString *)getWifiName;
+ (BOOL)isWifiReachable;
+ (NSString *)getWifiAddress;
+ (BOOL)isConnectedAITCameraWifi;

@end
