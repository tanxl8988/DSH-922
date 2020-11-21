//
//  APKDVRSettingInfo.h
//  万能AIT
//
//  Created by Mac on 17/6/16.
//  Copyright © 2017年 APK. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface APKDVRSettingInfo : NSObject

@property (assign,nonatomic) BOOL recordSound;
@property (assign,nonatomic) BOOL motionDetection;
@property (assign,nonatomic) NSInteger VideoClipTime;
@property (assign,nonatomic) NSInteger GSensor;
@property (assign,nonatomic) NSInteger LCDPowerSave;
@property (assign,nonatomic) NSInteger watermark;
@property (assign,nonatomic) NSInteger dateFormat;
@property (assign,nonatomic) NSInteger exposure;
@property (strong,nonatomic) NSString *FWVersion;
@property (assign,nonatomic) NSInteger speedLimit;
@property (assign,nonatomic) NSInteger edog;
@property (assign,nonatomic) NSInteger volume;


//雄风
//@property (assign,nonatomic) BOOL recordSound2;
@property (assign,nonatomic) BOOL upsidedown;
@property (assign,nonatomic) NSInteger videoRes;
//@property (assign,nonatomic) NSInteger watermark2;
//@property (assign,nonatomic) NSInteger dateFormat2;

@property (strong,nonatomic) NSArray *recordSoundMap;
@property (strong,nonatomic) NSArray *motionDetectionMap;
@property (strong,nonatomic) NSArray *VideoClipTimeMap;
@property (strong,nonatomic) NSArray *GSensorMap;
@property (strong,nonatomic) NSArray *LCDPowerSaveMap;
@property (strong,nonatomic) NSArray *watermarkMap;
@property (strong,nonatomic) NSArray *dateFormatMap;
@property (strong,nonatomic) NSArray *exposureMap;

@property (strong,nonatomic) NSArray *speedLimitMap;
@property (strong,nonatomic) NSArray *edogMap;
@property (strong,nonatomic) NSArray *volumeMap;




//雄风
@property (strong,nonatomic) NSArray *upsidedownMap;
@property (strong,nonatomic) NSArray *videoResMap;
@property (strong,nonatomic) NSArray *watermarkMap2;
@property (strong,nonatomic) NSArray *dateFormatMap2;


@end
