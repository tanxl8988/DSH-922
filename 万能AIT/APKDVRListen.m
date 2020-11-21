//
//  APKDVRListen.m
//  微米
//
//  Created by Mac on 17/9/11.
//  Copyright © 2017年 APK. All rights reserved.
//

#import "APKDVRListen.h"
#import <GCDAsyncUdpSocket.h>
#include <netinet/in.h>
#import <arpa/inet.h>

@interface APKDVRListen ()<GCDAsyncUdpSocketDelegate>

@property (weak,nonatomic) id<APKDVRListenDelegate>delegate;
@property (strong,nonatomic) GCDAsyncUdpSocket *socket;
@property (nonatomic) BOOL isBindToAddress;
@property (strong,nonatomic) NSData *address;
@property (nonatomic) BOOL isListening;

@end

@implementation APKDVRListen

#pragma mark - life circle

- (instancetype)initWithDelegate:(id<APKDVRListenDelegate>)delegate{
    
    if (self = [super init]) {
        
        self.delegate = delegate;
    }
    return self;
}

- (void)dealloc{
    
    NSLog(@"%s",__func__);
}

#pragma mark - public method

- (BOOL)startListen{
    
//    NSError *error = nil;
//    if (![self.socket bindToAddress:self.address error:&error]) {
//
//        return NO;
//    }
//
//    if (![self.socket beginReceiving:&error]) {
//
//        NSLog(@"%@",error);
//        [self.socket close];
//        return NO;
//    }
    
    NSError * error = nil;
    [self.socket bindToPort:49142 error:&error];
    if (error) {//监听错误打印错误信息
        NSLog(@"error:%@",error);
    }else {//监听成功则开始接收信息
        [self.socket beginReceiving:&error];
    }

    __weak typeof(self)weakSelf = self;
    [self.socket setReceiveFilter:^BOOL(NSData * _Nonnull data, NSData * _Nonnull address, id  _Nullable __autoreleasing * _Nonnull context) {

        NSString *msg = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        if ([msg containsString:@"SD0=ERROR"]) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"FormatSDCardFailed" object:nil];
        }
        
        if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(APKDVRListenDidReceiveMessage:)]) {

            [weakSelf.delegate APKDVRListenDidReceiveMessage:msg];
        }
        return NO;

    } withQueue:dispatch_get_main_queue()];

    self.isListening = YES;
    
    return YES;
}

- (void)stopListen{
    
    if (self.isListening) {
        
        self.isListening = NO;
        [self.socket close];
    }
}

#pragma mark - getter

- (NSData *)address{
    
    int port = 49142;
    struct sockaddr_in ip;
    ip.sin_family = AF_UNSPEC;
//    ip.sin_addr.s_addr = inet_addr("0.0.0.0");
    ip.sin_port = htons(port);
    ip.sin_len = sizeof(struct sockaddr_in);
    NSData * discoveryHost = [NSData dataWithBytes:&ip length:ip.sin_len];
    return discoveryHost;
}

- (GCDAsyncUdpSocket *)socket{
    
    
    if (!_socket) {
        
        _socket = [[GCDAsyncUdpSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
    }
    return _socket;
}

@end
