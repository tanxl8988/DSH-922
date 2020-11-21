//
//  APKDVRCommand.m
//  Aigo
//
//  Created by Mac on 17/6/30.
//  Copyright © 2017年 APK. All rights reserved.
//

#import "APKDVRCommand.h"
#import "AFNetworking.h"
#import "APKDVR.h"
#import "APKAITCGI.h"

@implementation APKDVRCommand

+ (APKDVRCommand *)commandWithUrl:(NSString *)url responseObjectHandler:(APKDVRCommandResponseObjectHandler *)responseObjectHandler{
    
    APKDVRCommand *command = [[APKDVRCommand alloc] init];
    command.url = url;
    command.responseObjectHandler = responseObjectHandler;
    return command;
}

- (void)dealloc
{
//    NSLog(@"%s",__func__);
}

#pragma mark - public method

- (void)execute:(APKCommandSuccessHandler)success failure:(APKCommandFailureHandler)failure{
    
    NSLog(@"执行：%@",self.url);
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/plain",@"text/xml",nil];
    manager.requestSerializer.timeoutInterval = 10;//10s超时
    [manager GET:self.url parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        // new add
        NSData *data = responseObject;
        NSString *msg = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        if ([self.url isEqualToString:@"http://192.72.1.1/cgi-bin/Config.cgi?action=get&property=Camera.Preview.Source.1.Camid"]) {
            
            if ([msg containsString:@"Camera.Preview.Source.1.Camid=rear"]){
                
                success(@"rear");
                return;
            }
            if ([msg containsString:@"Camera.Preview.Source.1.Camid=front"]){
                
                success(@"front");
                return;
            }
        }else if ([self.url isEqualToString:@"http://192.72.1.1/cgi-bin/Config.cgi?action=get&property=Camera.Menu.satellite.status"]){
            
            success(msg);
            return;
        }else if ([self.url isEqualToString:@"http://192.72.1.1/cgi-bin/Config.cgi?action=get&property=Camera.Menu.status.rearCam"]){
            
            success(msg);
            return;
        }else if ([self.url isEqualToString:@"http://192.72.1.1/cgi-bin/Config.cgi?action=get&property=Camera.Menu.SdStatus"]){
            
            success(msg);
            return;
        }
            
        
        [self.responseObjectHandler handle:responseObject successCommandHandler:^(id result) {
        
            dispatch_async(dispatch_get_main_queue(), ^{
                
                success(result);
            });
            
        } failureCommandHandler:^(int rval) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                failure(rval);
            });
        }];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            //看是否连接中断
            if (![self.url isEqualToString:[APKAITCGI getSettingInfoCGI]]) {
                [[APKDVR sharedInstance] tryToUpdateConnectState];
            }
            
            failure(-1);
        });
    }];
}


@end
