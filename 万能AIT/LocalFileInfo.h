//
//  LocalFileInfo.h
//  万能AIT
//
//  Created by Mac on 17/7/27.
//  Copyright © 2017年 APK. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface LocalFileInfo : NSManagedObject

@property (strong,nonatomic) NSString *name;
@property (nonatomic) int16_t type;
@property (strong,nonatomic)NSString *localIdentifier;
@property (strong,nonatomic) NSDate *date;
@property (nonatomic,assign) BOOL isFrontCamera;

+ (long)getFileCountWithType:(int16_t)type context:(NSManagedObjectContext *)context;
+ (LocalFileInfo *)getFirstLocalFileInfoWithType:(int16_t)type context:(NSManagedObjectContext *)context;
+ (LocalFileInfo *)createWithName:(NSString *)name type:(int16_t)type localIdentifier:(NSString *)localIdentifier date:(NSDate *)date context:(NSManagedObjectContext *)context;

+ (LocalFileInfo *)createWithName:(NSString *)name type:(int16_t)type isFroontCamera:(BOOL)isFrontCamera localIdentifier:(NSString *)localIdentifier date:(NSDate *)date context:(NSManagedObjectContext *)context;

+ (LocalFileInfo *)retrieveLocalFileInfoWithName:(NSString *)name type:(int16_t)type context:(NSManagedObjectContext *)context;
+ (NSArray *)retrieveLocalfileInfosWithType:(int16_t)type offset:(NSInteger)offset count:(NSInteger)count context:(NSManagedObjectContext *)context;

+ (void)retrieveLocalfileInfosWithType:(int16_t)type offset:(NSInteger)offset count:(NSInteger)count context:(NSManagedObjectContext *)context completionHandler:(NSPersistentStoreAsynchronousFetchResultCompletionBlock)completionHandler;

@end
