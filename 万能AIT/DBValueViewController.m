//
//  DBValueViewController.m
//  万能AIT
//
//  Created by apical on 2019/3/27.
//  Copyright © 2019年 APK. All rights reserved.
//

#import "DBValueViewController.h"
#import "APKDVRCommandFactory.h"

@interface DBValueViewController ()

@end

@implementation DBValueViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[APKDVRCommandFactory getDBValueCommand] execute:^(id responseObject) {
        
        [self handleMsg:responseObject];
    } failure:^(int rval) {
        
    }];
    
    // Do any additional setup after loading the view.
}

-(void)handleMsg:(id)msg
{
    NSString *msgStr = msg;
    
    NSString *version = [msg substringWithRange:NSMakeRange(msgStr.length - 15, 14)];
    NSString *state = [msg substringWithRange:NSMakeRange(msgStr.length-17, 1)];
    
    NSString *DBvalue = [msg componentsSeparatedByString:@"="][1];
    
    NSString *str = [DBvalue substringFromIndex:DBvalue.length-21];
    
    DBvalue = [DBvalue stringByReplacingOccurrencesOfString:str withString:@""];
    
    
    NSArray *arr = [DBvalue componentsSeparatedByString:@"."];
    for (int i = 0;  i < arr.count + 4; i ++) {
        
        UILabel *l = [[UILabel alloc] initWithFrame:CGRectMake(0,60+i*30, self.view.bounds.size.width, 40)];
        NSString *str = @"";
        if (i == 0)
            str = [NSString stringWithFormat:@"                           %@",NSLocalizedString(@"编号-数值", nil)];
        else if ( i == arr.count + 1)
            str = [NSString stringWithFormat:@"%@:%ld                     ",NSLocalizedString(@"个数", nil),arr.count];
        else if (i == arr.count + 2){
            NSString *stateStr = [state isEqualToString:@"0"] ? NSLocalizedString(@"失败", nil) : NSLocalizedString(@"成功", nil);
            str = [NSString stringWithFormat:@"%@:%@                     ",NSLocalizedString(@"定位", nil),stateStr];
        }
        else if (i == arr.count + 3)
            str = [NSString stringWithFormat:@"%@:%@                     ",NSLocalizedString(@"版本", nil),version];
        else{
            
            NSString *value = arr[i - 1];
            NSArray *array = [value componentsSeparatedByString:@"-"];
            str = [NSString stringWithFormat:@"DB %d:                     %@-%@",i,array[0],array[1]];
            
        }
        l.text = str;
        NSLog(@"%@",str);
        [self.view addSubview:l];
        
        
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
