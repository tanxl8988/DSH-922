//
//  APKNetworkConfigureViewController.m
//  万能AIT
//
//  Created by Mac on 17/4/18.
//  Copyright © 2017年 APK. All rights reserved.
//

#import "APKNetworkConfigureViewController.h"
#import "MBProgressHUD.h"
#import "APKDVR.h"
#import "APKAlertTool.h"
#import "APKDVRCommandFactory.h"

@interface APKNetworkConfigureViewController ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIBarButtonItem *updateItem;
@property (weak, nonatomic) IBOutlet UILabel *ssidLabel;
@property (weak, nonatomic) IBOutlet UILabel *passwordLabel;
@property (weak, nonatomic) IBOutlet UITextField *ssidTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (strong,nonatomic) NSString *wifiName;
@property (strong,nonatomic) NSString *wifiPassword;
@property (weak,nonatomic) MBProgressHUD *loadWifiInfoHUD;
@property (weak,nonatomic) MBProgressHUD *modifyWifiHUD;

@end

@implementation APKNetworkConfigureViewController

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateUIWithNotification:) name:UITextFieldTextDidChangeNotification object:nil];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title = NSLocalizedString(@"wifi设置", nil);
    self.ssidLabel.text = NSLocalizedString(@"Wi-Fi名称必须为1-27个非空字符。", nil);
    self.passwordLabel.text = NSLocalizedString(@"Wi-Fi密码必须为8-32个非空字符。", nil);
    self.updateItem.title = NSLocalizedString(@"更新", nil);
    self.updateItem.enabled = NO;
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    __weak typeof(self) weakSelf = self;
    [[APKDVRCommandFactory getWifiInfoCommand] execute:^(id responseObject) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            NSDictionary *info = responseObject;
            weakSelf.wifiName = info.allKeys.firstObject;
            weakSelf.wifiPassword = info.allValues.firstObject;
            weakSelf.ssidTextField.text = weakSelf.wifiName;
            weakSelf.passwordTextField.text = weakSelf.wifiPassword;
            [hud hideAnimated:YES];
        });
        
    } failure:^(int rval) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [hud hideAnimated:YES];
        });
    }];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:nil];
}

#pragma mark - getter

- (void)updateUIWithNotification:(NSNotification *)notification{
    
    if ([notification.name isEqualToString:UITextFieldTextDidChangeNotification]) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if ([self.ssidTextField.text isEqualToString:self.wifiName] && [self.passwordTextField.text isEqualToString:self.wifiPassword]) {
                
                self.updateItem.enabled = NO;
                
            }else if(self.ssidTextField.text.length == 0 || self.ssidTextField.text.length > 27){
                
                self.updateItem.enabled = NO;
                
            }else if (self.passwordTextField.text.length < 8 || self.passwordTextField.text.length > 32){
                
                self.updateItem.enabled = NO;
                
            }else{
                
                self.updateItem.enabled = YES;
            }
        });
    }
}

#pragma mark - actions

- (IBAction)clickUpdateItem:(UIBarButtonItem *)sender {
    
    [self.view endEditing:YES];
    
    NSString *wifiName = [self.ssidTextField.text stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    __weak typeof(self) weakSelf = self;
    [[APKDVRCommandFactory modifyWifiCommandWithAccount:wifiName password:self.passwordTextField.text] execute:^(id responseObject) {
        
        [[APKDVRCommandFactory rebotWifiCommand] execute:^(id responseObject) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [hud hideAnimated:YES];
                [APKAlertTool showAlertInViewController:weakSelf title:NSLocalizedString(@"修改成功！", nil) message:NSLocalizedString(@"DVR将会重启Wi-Fi", nil) confirmHandler:^(UIAlertAction *action) {
                    [APKDVR sharedInstance].isConnected = NO;
                    [weakSelf.navigationController popViewControllerAnimated:YES];
                }];
            });
            
        } failure:^(int rval) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [hud hideAnimated:YES];
                [APKAlertTool showAlertInViewController:weakSelf title:NSLocalizedString(@"修改成功！", nil) message:NSLocalizedString(@"DVR将会重启Wi-Fi", nil) confirmHandler:^(UIAlertAction *action) {
                    [APKDVR sharedInstance].isConnected = NO;
                    [weakSelf.navigationController popViewControllerAnimated:YES];
                }];
            });
        }];
        
    } failure:^(int rval) {
       
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [APKAlertTool showAlertInViewController:weakSelf title:nil message:NSLocalizedString(@"修改失败！", nil) confirmHandler:nil];
            [hud hideAnimated:YES];
        });
    }];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    BOOL isShouldChangeCharacters = YES;
    
    if (![string isEqualToString:@""]) {
        
        char ch = [string characterAtIndex:0];
        if (!(ch >= '0' && ch <= '9') && !(ch >= 'a' && ch <= 'z') && !(ch >= 'A' && ch <= 'Z')) {
            
            isShouldChangeCharacters = NO;
        }
    }
    
    return isShouldChangeCharacters;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    if (textField == self.ssidTextField) {
        
        [self.passwordTextField becomeFirstResponder];
    }
    
    return YES;
}

@end
