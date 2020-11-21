//
//  APKDVRCommand.h
//  Aigo
//
//  Created by Mac on 17/6/30.
//  Copyright © 2017年 APK. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "APKDVRCommandResponseObjectHandler.h"

typedef void(^APKCommandSuccessHandler)(id responseObject);
typedef void(^APKCommandFailureHandler)(int rval);

@interface APKDVRCommand : NSObject

@property (strong,nonatomic) APKDVRCommandResponseObjectHandler *responseObjectHandler;
@property (strong,nonatomic) NSString *url;

+ (APKDVRCommand *)commandWithUrl:(NSString *)url responseObjectHandler:(APKDVRCommandResponseObjectHandler *)responseObjectHandler;
- (void)execute:(APKCommandSuccessHandler)success failure:(APKCommandFailureHandler)failure;

@end
