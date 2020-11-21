//
//  APKDVRSettingInfo.m
//  万能AIT
//
//  Created by Mac on 17/6/16.
//  Copyright © 2017年 APK. All rights reserved.
//

#import "APKDVRSettingInfo.h"

@implementation APKDVRSettingInfo

#pragma mark - getter

- (NSArray *)recordSoundMap{
    
    if (!_recordSoundMap) {
        _recordSoundMap = @[@"OF",@"ON"];
    }
    return _recordSoundMap;
}

- (NSArray *)motionDetectionMap{
    
    if (!_motionDetectionMap) {
        _motionDetectionMap = @[@"OFF",@"HIGH"];
    }
    return _motionDetectionMap;
}

- (NSArray *)VideoClipTimeMap{
    
    if (!_VideoClipTimeMap) {
        _VideoClipTimeMap = @[@"1MIN",@"3MIN",@"5MIN"];
    }
    return _VideoClipTimeMap;
}

- (NSArray *)GSensorMap{
    
    if (!_GSensorMap) {
        _GSensorMap = @[@"OFF",@"LEVEL0",@"LEVEL2",@"LEVEL4"];
    }
    return _GSensorMap;
}

- (NSArray *)LCDPowerSaveMap{
    
    if (!_LCDPowerSaveMap) {
        _LCDPowerSaveMap = @[@"OFF",@"30SEC",@"1MIN",@"5MIN"];
    }
    return _LCDPowerSaveMap;
}

- (NSArray *)watermarkMap{
    
    if (!_watermarkMap) {
        _watermarkMap = @[@"DATE+TIME",@"DATE",@"OFF"];
    }
    return _watermarkMap;
}

- (NSArray *)dateFormatMap{
    
    if (!_dateFormatMap) {
        _dateFormatMap = @[@"OFF",@"YMD",@"MDY",@"DMY"];
    }
    return _dateFormatMap;
}

- (NSArray *)exposureMap{
    
    if (!_exposureMap) {
        _exposureMap = @[@"EVN200",@"EVN167",@"EVN133",@"EVN100",@"EVN067",@"EVN033",@"EV0",@"EVP033",@"EVP067",@"EVP100",@"EVP133",@"EVP167",@"EVP200"];
    }
    return _exposureMap;
}

#pragma mark 雄风

- (NSArray *)upsidedownMap{
    
    if (!_upsidedownMap) {
        _upsidedownMap = @[@"Normal",@"Upsidedown"];
    }
    return _upsidedownMap;
}

- (NSArray *)videoResMap{
    
    if (!_videoResMap) {
        _videoResMap = @[@"1440P30",@"1080P60",@"1080P30",@"720P60"];
    }
    return _videoResMap;
}

- (NSArray *)watermarkMap2{
    
    if (!_watermarkMap2) {
        _watermarkMap2 = @[@"Date+Logo",@"Date",@"Logo",@"OFF"];
    }
    return _watermarkMap2;
}

- (NSArray *)dateFormatMap2{
    
    if (!_dateFormatMap2) {
        _dateFormatMap2 = @[@"YMD",@"MDY",@"DMY"];
    }
    return _dateFormatMap2;
}

-(NSArray *)speedLimitMap
{
    if (!_speedLimitMap) {
        _speedLimitMap = @[@"OFF",@"30",@"50",@"70",@"90",@"100",@"120",@"140"];
    }
    return _speedLimitMap;
                           
}

-(NSArray *)edogMap
{
    if (!_edogMap) {
        _edogMap = @[@"OFF",@"ON"];
    }
    return _edogMap;
    
}

-(NSArray *)volumeMap
{
    if (!_volumeMap) {
        _volumeMap = @[@"OFF",@"LOW",@"MID",@"HIGHT"];
    }
    return _volumeMap;
    
}

@end
