//
//  APKManagedObjectContextManager.h
//  Aigo
//
//  Created by Mac on 17/7/19.
//  Copyright © 2017年 APK. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface APKMOCManager : NSObject

@property (strong,nonatomic) NSManagedObjectContext *context;

+ (instancetype)sharedInstance;
- (void)setupCoreDataStack;

@end
