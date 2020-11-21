//
//  APKWifiTool.m
//  保时捷项目
//
//  Created by Mac on 16/5/16.
//
//

#import "APKWifiTool.h"
#import <SystemConfiguration/CaptiveNetwork.h>
#import <TargetConditionals.h>
//#import "Reachability.h"

#include <ifaddrs.h>
#include <arpa/inet.h>

#include <netinet/in.h>
#include <sys/sysctl.h>

#if TARGET_IPHONE_SIMULATOR
#include <net/route.h>
#else
#include "route.h"
#endif

#include <net/if.h>
#include <string.h>

#define ROUNDUP(a) ((a) > 0 ? (1 + (((a) - 1) | (sizeof(long) - 1))) : sizeof(long))

@implementation APKWifiTool

#pragma mark - public method

+ (NSString *)getWifiName{
    
    NSArray *ifs = (__bridge_transfer id)CNCopySupportedInterfaces();
    NSDictionary *ssidInfo = nil;
    for (NSString *ifnam in ifs) {
        ssidInfo = (__bridge_transfer id)CNCopyCurrentNetworkInfo((__bridge CFStringRef)ifnam);
        if (ssidInfo && [ssidInfo count]) { break; }
    }
    
    NSString *wifiName = ssidInfo[@"SSID"];
    return wifiName;
}

+ (BOOL)isWifiReachable{
    
    NSString *wifiName = [APKWifiTool getWifiName];
    if ([wifiName hasPrefix:@"amba"] || [wifiName hasPrefix:@"F37"] || [wifiName hasPrefix:@"Apical"]) return YES;
    return NO;
}

+ (BOOL)isConnectedAITCameraWifi{
    
    BOOL res = NO;
    NSString *wifiAddress = [APKWifiTool getWifiAddress];
    if ([wifiAddress isEqualToString:@"192.72.1.1"]) {
        res = YES;
    }
    
    return res;
}

+ (NSString *)getWifiAddress{
    
    NSString *address = @"error";
    in_addr_t addr ;
    if ([APKWifiTool getdefaultgateway:&addr] >= 0) {
        address = [NSString stringWithUTF8String:inet_ntoa(*((struct in_addr*)&addr))];
    }
    return address;
}

#pragma mark - private method

+ (int) getdefaultgateway: (in_addr_t *) addr//获取wifi ip地址
{
    
#if TARGET_IPHONE_SIMULATOR
#define IF_NAME "en1"
#else
#define IF_NAME "en0"
#endif
    
    int mib[] = {CTL_NET, PF_ROUTE, 0, AF_INET,
        NET_RT_FLAGS, RTF_GATEWAY};
    size_t l;
    char * buf, * p;
    struct rt_msghdr * rt;
    struct sockaddr * sa;
    struct sockaddr * sa_tab[RTAX_MAX];
    int i;
    int ret = -1;
    
    if(sysctl(mib, sizeof(mib)/sizeof(int), 0, &l, 0, 0) < 0) {
        return -1;
    }
    if(l>0) {
        buf = malloc(l);
        if(sysctl(mib, sizeof(mib)/sizeof(int), buf, &l, 0, 0) < 0) {
            return -1;
        }
        for(p=buf; p<buf+l; p+=rt->rtm_msglen) {
            rt = (struct rt_msghdr *)p;
            sa = (struct sockaddr *)(rt + 1);
            for(i=0; i<RTAX_MAX; i++) {
                if(rt->rtm_addrs & (1 << i)) {
                    sa_tab[i] = sa;
                    sa = (struct sockaddr *)((char *)sa + ROUNDUP(sa->sa_len));
                } else {
                    sa_tab[i] = NULL;
                }
            }
            
            if( ((rt->rtm_addrs & (RTA_DST|RTA_GATEWAY)) == (RTA_DST|RTA_GATEWAY))
               && sa_tab[RTAX_DST]->sa_family == AF_INET
               && sa_tab[RTAX_GATEWAY]->sa_family == AF_INET) {
                
                
                if(((struct sockaddr_in *)sa_tab[RTAX_DST])->sin_addr.s_addr == 0) {
                    char ifName[128];
                    if_indextoname(rt->rtm_index,ifName);
                    
                    if(strcmp(IF_NAME,ifName)==0){
                        
                        *addr = ((struct sockaddr_in *)(sa_tab[RTAX_GATEWAY]))->sin_addr.s_addr;
                        ret = 0;
                        
                    }
                }
            }
        }
        free(buf);
    }
    return ret;
}

@end
