//
//  LocalFileInfo.m
//  万能AIT
//
//  Created by Mac on 17/7/27.
//  Copyright © 2017年 APK. All rights reserved.
//

#import "LocalFileInfo.h"

@implementation LocalFileInfo

@dynamic name,type,localIdentifier,date;

+ (LocalFileInfo *)createWithName:(NSString *)name type:(int16_t)type localIdentifier:(NSString *)localIdentifier date:(NSDate *)date context:(NSManagedObjectContext *)context{
    
    LocalFileInfo *info = [NSEntityDescription insertNewObjectForEntityForName:@"LocalFileInfo" inManagedObjectContext:context];
    info.name = name;
    info.type = type;
    info.localIdentifier = localIdentifier;
    info.date = date;
    return info;
}

+ (LocalFileInfo *)createWithName:(NSString *)name type:(int16_t)type isFroontCamera:(BOOL)isFrontCamera localIdentifier:(NSString *)localIdentifier date:(NSDate *)date context:(NSManagedObjectContext *)context
{
    LocalFileInfo *info = [NSEntityDescription insertNewObjectForEntityForName:@"LocalFileInfo" inManagedObjectContext:context];
    info.name = name;
    info.type = type;
    info.isFrontCamera = isFrontCamera;
    info.localIdentifier = localIdentifier;
    info.date = date;
    return info;
}

+ (long)getFileCountWithType:(int16_t)type context:(NSManagedObjectContext *)context{
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"type == %d",type];
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"LocalFileInfo"];
    request.predicate = predicate;
    request.resultType = NSCountResultType;
    
    NSError *error = nil;
    NSArray *arr = [context executeFetchRequest:request error:&error];
    if (error) {
        
        return 0;
    
    }else{
        
        NSNumber *number = arr.firstObject;
        return [number longValue];
    }
}

+ (LocalFileInfo *)getFirstLocalFileInfoWithType:(int16_t)type context:(NSManagedObjectContext *)context{
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"type == %d",type];
    NSSortDescriptor *dateSort = [NSSortDescriptor sortDescriptorWithKey:@"date" ascending:NO];
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"LocalFileInfo"];
    request.predicate = predicate;
    request.sortDescriptors = @[dateSort];
    request.fetchBatchSize = 1;
    NSError *error = nil;
    NSArray *arr = [context executeFetchRequest:request error:&error];
    if (error) {
        
        return nil;
        
    }else{
        
        return arr.firstObject;
    }
}

+ (LocalFileInfo *)retrieveLocalFileInfoWithName:(NSString *)name type:(int16_t)type context:(NSManagedObjectContext *)context{
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name == %@ AND type == %d",name,type];
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"LocalFileInfo"];
    request.predicate = predicate;
    request.fetchBatchSize = 1;
    NSError *error = nil;
    NSArray *arr = [context executeFetchRequest:request error:&error];
    if (error) {
        
        return nil;
        
    }else{
        
        return arr.firstObject;
    }
}

+ (NSArray *)retrieveLocalfileInfosWithType:(int16_t)type offset:(NSInteger)offset count:(NSInteger)count context:(NSManagedObjectContext *)context{
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"type == %d",type];
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"LocalFileInfo"];
    request.predicate = predicate;
    request.fetchOffset = offset;
    request.fetchLimit = count;
    NSError *error = nil;
    NSArray *arr = [context executeFetchRequest:request error:&error];
    if (error) {
        
        return nil;
        
    }else{
        
        return arr;
    }
}

+ (void)retrieveLocalfileInfosWithType:(int16_t)type offset:(NSInteger)offset count:(NSInteger)count context:(NSManagedObjectContext *)context completionHandler:(NSPersistentStoreAsynchronousFetchResultCompletionBlock)completionHandler{
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"type == %d",type];
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"LocalFileInfo"];
    request.predicate = predicate;
    request.fetchOffset = offset;
    request.fetchLimit = count;
    NSAsynchronousFetchRequest *asyncRequest = [[NSAsynchronousFetchRequest alloc] initWithFetchRequest:request completionBlock:completionHandler];
    NSError *error = nil;
    [context executeRequest:asyncRequest error:&error];
}

@end
