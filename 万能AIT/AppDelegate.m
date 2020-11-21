//
//  AppDelegate.m
//  万能AIT
//
//  Created by Mac on 17/3/21.
//  Copyright © 2017年 APK. All rights reserved.
//

#import "AppDelegate.h"
#import "APKDVR.h"
#import "APKMOCManager.h"
//#import "UMMobClick/MobClick.h"

@interface AppDelegate ()

@property (assign,nonatomic) UIBackgroundTaskIdentifier backgroundTaskIdentifier;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    //修复在实时预览的过程中直接按电源键锁屏导致的奔溃（signal SIGPIPE）
    signal(SIGPIPE, SIG_IGN);
    
    [APKDVR sharedInstance];
    [[APKMOCManager sharedInstance] setupCoreDataStack];
    
    //集成友盟统计
    //友盟后台账号：yangzc@apical.com.cn 密码：yzc123456=
//    UMConfigInstance.appKey = @"59e5cd41677baa710f00052b";
//    [MobClick startWithConfigure:UMConfigInstance];//配置以上参数后调用此方法初始化SDK！
//    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
//    [MobClick setAppVersion:version];
    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
    //在连接的状态下进入后台时，如果当前正在进行实时预览，很大几率会导致奔溃！因为实时预览需要建立两个UDP和一个TCP，进入后台后很可能切断的“不干净”，然后接收到SIGPIPE信号导致进程退出。
    //经调试后，发现只要争取后台运行时间，就可以让所有socket能切断得“干干净净”，从而解决了这个奔溃问题。
    if ([APKDVR sharedInstance].isConnected) {
        
        self.backgroundTaskIdentifier = [application beginBackgroundTaskWithExpirationHandler:^{
            
            [application endBackgroundTask:self.backgroundTaskIdentifier];
        }];
        
//        NSLog(@"开始后台任务");
        [self performSelector:@selector(endMyBackgroundTask:) withObject:application afterDelay:3];
    }
}

- (void)endMyBackgroundTask:(UIApplication *)application{
    
    if (application.applicationState == UIApplicationStateBackground) {
//        NSLog(@"结束后台任务");
        [application endBackgroundTask:self.backgroundTaskIdentifier];
    }
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
