//
//  APKManagedObjectContextManager.m
//  Aigo
//
//  Created by Mac on 17/7/19.
//  Copyright © 2017年 APK. All rights reserved.
//

#import "APKMOCManager.h"

@implementation APKMOCManager

static APKMOCManager *instance = nil;
+ (instancetype)sharedInstance{
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        instance = [[APKMOCManager alloc] init];
    });
    
    return instance;
}

- (void)setupCoreDataStack{
    
    NSURL *momUrl = [[NSBundle mainBundle] URLForResource:@"DataModal" withExtension:@"momd"];
    NSManagedObjectModel *mom = [[NSManagedObjectModel alloc] initWithContentsOfURL:momUrl];
    NSAssert(mom, @"create mom failure");
    
    NSPersistentStoreCoordinator *psc = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:mom];
    NSManagedObjectContext *context = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    context.persistentStoreCoordinator = psc;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSURL *documentsDirectory = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
        NSURL *psUrl = [documentsDirectory URLByAppendingPathComponent:@"database.sqlite"];
        
        NSError *error;
        [psc addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:psUrl options:nil error:&error];
        NSAssert(!error, error.description);
        
        self.context = context;
    });
}

@end
