//
//  APKAITCGI.h
//  万能AIT
//
//  Created by Mac on 17/6/16.
//  Copyright © 2017年 APK. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface APKAITCGI : NSObject

+ (NSString *)deleteCGIWithFileName:(NSString *)fileName;
+ (NSString *)getDVRFileListCGIWithFileFormat:(NSString *)format property:(NSString *)property offset:(NSInteger)offset count:(NSInteger)count isFrontCamera:(BOOL)isFrontCamera;
+ (NSString *)setCGIWithProperty:(NSString *)property value:(NSString *)value;
+ (NSString *)getSettingInfoCGI;

@end
