//
//  APKDVRSettingInfoResponseObjectHandler.m
//  Aigo
//
//  Created by Mac on 17/7/5.
//  Copyright © 2017年 APK. All rights reserved.
//

#import "APKDVRSettingInfoResponseObjectHandler.h"
#import "APKDVRSettingInfo.h"
#import "APKDVR.h"

@implementation APKDVRSettingInfoResponseObjectHandler

- (void)handle:(id)responseObject successCommandHandler:(APKSuccessCommandHandler)successCommandHandler failureCommandHandler:(APKFailureCommandHandler)failureCommandHandler{
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSData *data = responseObject;
        NSString *msg = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"%@",msg);
        NSArray *lines = [msg componentsSeparatedByString:@"\n"];
        if (lines.count > 0) {
            int rval = [lines.firstObject intValue];
            if (rval != 0) {
                failureCommandHandler(rval);
                return;
            }
        }else{
            failureCommandHandler(-1);
            return;
        }
        
        
        NSMutableDictionary *infoDict = [[NSMutableDictionary alloc] init];
        for (NSString *line in lines) {
            
            NSArray *properties = [line componentsSeparatedByString:@"="];
            if (properties.count != 2) {
                
                continue;
            }
            
            NSString *str = properties.firstObject;
            NSArray *arr = [str componentsSeparatedByString:@".Menu."];
            if (arr.count != 2) {
                
                continue;
            }
            
            NSString *key = arr.lastObject;
            NSString *value = properties.lastObject;
            [infoDict setValue:value forKey:key];
        }
        
        APKDVRSettingInfo *info = [[APKDVRSettingInfo alloc] init];
        info.motionDetection = [info.motionDetectionMap indexOfObject:infoDict[@"MTD"]];
        info.VideoClipTime = [info.VideoClipTimeMap indexOfObject:infoDict[@"LoopingVideo"]];
        info.GSensor = [info.GSensorMap indexOfObject:infoDict[@"GSensor"]];
        info.exposure = [info.exposureMap indexOfObject:infoDict[@"EV"]];
        info.FWVersion = infoDict[@"FWversion"];
        info.edog = [info.edogMap indexOfObject:infoDict[@"Edog"]];
        info.speedLimit = [info.speedLimitMap indexOfObject:infoDict[@"SpeedLimitAlert"]];
        info.volume = [info.volumeMap indexOfObject:infoDict[@"Volume"]];

        if ([APKDVR sharedInstance].modal == kAPKDVRModalAosibi) {
//            info.recordSound = [info.recordSoundMap indexOfObject:infoDict[@"MuteStatus"]];
            info.recordSound = [info.recordSoundMap indexOfObject:infoDict[@"SoundRecord"]];
            info.watermark = [info.watermarkMap indexOfObject:infoDict[@"TimeStampStatus"]];
            info.dateFormat = [info.dateFormatMap indexOfObject:infoDict[@"TimeFormat"]];
            info.LCDPowerSave = [info.LCDPowerSaveMap indexOfObject:infoDict[@"LCDPower"]];
        }
        else{
            info.recordSound = ![info.recordSoundMap indexOfObject:infoDict[@"SoundRecord"]];
            info.watermark = [info.watermarkMap2 indexOfObject:infoDict[@"TimeStamp"]];
            info.dateFormat = [info.dateFormatMap2 indexOfObject:infoDict[@"TimeFormat"]];
            info.LCDPowerSave = [info.LCDPowerSaveMap indexOfObject:infoDict[@"LCDPowerSave"]];
        }
        
        //雄风
        info.upsidedown = [info.upsidedownMap indexOfObject:infoDict[@"UpsideDown"]];
        info.videoRes = [info.videoResMap indexOfObject:infoDict[@"VideoRes"]];
        
        successCommandHandler(info);
    });
}

@end
