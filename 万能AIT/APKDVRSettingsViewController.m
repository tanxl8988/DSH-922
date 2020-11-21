//
//  APKDVRSettingsViewController.m
//  万能AIT
//
//  Created by Mac on 17/3/23.
//  Copyright © 2017年 APK. All rights reserved.
//

#import "APKDVRSettingsViewController.h"
#import "APKDVR.h"
#import "MBProgressHUD.h"
#import "APKNetworkConfigureViewController.h"
#import "APKAlertTool.h"
#import "APKDVRSettingInfo.h"
#import "APKDVRCommandFactory.h"
#import "APKAboatViewController.h"

@interface APKDVRSettingsViewController ()

//cells
@property (weak, nonatomic) IBOutlet UITableViewCell *recordSoundCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *motionDetectionCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *clipDurationCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *gSensorCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *LCDLightCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *watermarkCell1;
@property (weak, nonatomic) IBOutlet UITableViewCell *dateFormatCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *exposureCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *correctCameraClockCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *formatCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *networkConfigureCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *factoryResetCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *helpCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *aboatCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *EdogCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *speedLimitCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *volumeCell;
//雄风
@property (weak, nonatomic) IBOutlet UITableViewCell *upsidedownCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *videoModeCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *watermarkCell2;
@property (weak, nonatomic) IBOutlet UITableViewCell *dateFormatCell2;
@property (weak, nonatomic) IBOutlet UITableViewCell *DBValueCell;
@property (weak, nonatomic) IBOutlet UILabel *volumeL;
@property (weak, nonatomic) IBOutlet UISegmentedControl *volumeSeg;


@property (weak, nonatomic) IBOutlet UILabel *networkConfigureLabel;
@property (weak, nonatomic) IBOutlet UILabel *correctCameraClockLabel;
@property (weak, nonatomic) IBOutlet UILabel *formatLabel;
@property (weak, nonatomic) IBOutlet UILabel *micLabel;
@property (weak, nonatomic) IBOutlet UILabel *clipDurationLabel;
@property (weak, nonatomic) IBOutlet UILabel *gSensorLabel;
@property (weak, nonatomic) IBOutlet UILabel *factoryResetLabel;
@property (weak, nonatomic) IBOutlet UILabel *speedLimitL;
@property (weak, nonatomic) IBOutlet UISegmentedControl *speedLimitSeg;

@property (weak, nonatomic) IBOutlet UISwitch *micSwitch;
@property (weak, nonatomic) IBOutlet UISegmentedControl *clipDurationSegment;
@property (weak, nonatomic) IBOutlet UILabel *EdogTitleL;
@property (weak, nonatomic) IBOutlet UISegmentedControl *gSensorSegment;
@property (weak, nonatomic) IBOutlet UISwitch *EdogSwitch;
@property (weak, nonatomic) IBOutlet UILabel *helpLabel;
@property (weak, nonatomic) IBOutlet UILabel *aboatLabel;
@property (weak, nonatomic) IBOutlet UILabel *motionDetectionLabel;
@property (weak, nonatomic) IBOutlet UISwitch *motionDetectionSwitch;
@property (weak, nonatomic) IBOutlet UILabel *LCDLightLabel;
@property (weak, nonatomic) IBOutlet UISegmentedControl *LCDLightSegment;
@property (weak, nonatomic) IBOutlet UILabel *watermarkLabel;
@property (weak, nonatomic) IBOutlet UISegmentedControl *watermarkSegment;
@property (weak, nonatomic) IBOutlet UILabel *dateFormatLabel;
@property (weak, nonatomic) IBOutlet UISegmentedControl *dateFormatSegment;
@property (weak, nonatomic) IBOutlet UILabel *EVLabel;
@property (weak, nonatomic) IBOutlet UILabel *EVValueLabel;
@property (weak, nonatomic) IBOutlet UISlider *EVSlider;
//雄风
@property (weak, nonatomic) IBOutlet UILabel *upsidedownLabel;
@property (weak, nonatomic) IBOutlet UILabel *videoModeLabel;
@property (weak, nonatomic) IBOutlet UILabel *watermarkLabel2;
@property (weak, nonatomic) IBOutlet UILabel *dateFormatLabel2;
@property (weak, nonatomic) IBOutlet UISegmentedControl *dateFormatSegment2;

@property (weak, nonatomic) IBOutlet UISwitch *upsidedownSwitch;
@property (weak, nonatomic) IBOutlet UISegmentedControl *videoModeSegment;
@property (weak, nonatomic) IBOutlet UISegmentedControl *watermarkSegment2;


@property (weak,nonatomic) UIAlertController *correctCameraClockAlert;
@property (nonatomic) BOOL isSettable;
@property (strong,nonatomic) NSString *currentTime;
@property (strong,nonatomic) NSArray *cells;
@property (strong,nonatomic) NSArray *rowHeights;
@property (assign,nonatomic) APKDVRModal dvrModal;
@property (nonatomic,assign) BOOL clickFormatSDCard;

@end

@implementation APKDVRSettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title = NSLocalizedString(@"设置", nil);
    
    self.networkConfigureLabel.text = NSLocalizedString(@"wifi设置", nil);
    self.correctCameraClockLabel.text = NSLocalizedString(@"校准时间", nil);
    self.formatLabel.text = NSLocalizedString(@"格式化SD卡", nil);
    self.micLabel.text = NSLocalizedString(@"录音设置", nil);
    self.clipDurationLabel.text = NSLocalizedString(@"录制时长", nil);
    self.gSensorLabel.text = NSLocalizedString(@"碰撞灵敏度", nil);
    self.factoryResetLabel.text = NSLocalizedString(@"恢复出厂设置", nil);
    self.helpLabel.text = NSLocalizedString(@"帮助", nil);
    self.aboatLabel.text = NSLocalizedString(@"关于", nil);
    self.EVLabel.text = [NSString stringWithFormat:@"%@:",NSLocalizedString(@"曝光调整", nil)];
    self.EVValueLabel.text = @"0";
    self.LCDLightLabel.text = NSLocalizedString(@"自动关屏", nil);
    self.watermarkLabel.text = NSLocalizedString(@"戳记", nil);
    self.dateFormatLabel.text = NSLocalizedString(@"日期格式", nil);
    self.motionDetectionLabel.text = NSLocalizedString(@"移动侦测", nil);
    //雄风
    self.upsidedownLabel.text = NSLocalizedString(@"翻转", nil);
    self.videoModeLabel.text = NSLocalizedString(@"视频模式", nil);
    self.watermarkLabel2.text = NSLocalizedString(@"戳记", nil);
    self.dateFormatLabel2.text = NSLocalizedString(@"日期格式", nil);
    self.EdogTitleL.text = NSLocalizedString(@"电子狗", nil);
    self.speedLimitL.text = NSLocalizedString(@"超速提醒", nil);
    self.volumeL.text = NSLocalizedString(@"音量", nil);

    [self.clipDurationSegment setTitle:NSLocalizedString(@"1分钟", nil) forSegmentAtIndex:0];
    [self.clipDurationSegment setTitle:NSLocalizedString(@"3分钟", nil) forSegmentAtIndex:1];
//    [self.clipDurationSegment setTitle:NSLocalizedString(@"5分钟", nil) forSegmentAtIndex:2];
    [self.gSensorSegment setTitle:NSLocalizedString(@"关闭", nil) forSegmentAtIndex:0];
    [self.gSensorSegment setTitle:NSLocalizedString(@"高", nil) forSegmentAtIndex:1];
    [self.gSensorSegment setTitle:NSLocalizedString(@"中", nil) forSegmentAtIndex:2];
    [self.gSensorSegment setTitle:NSLocalizedString(@"低", nil) forSegmentAtIndex:3];
    [self.LCDLightSegment setTitle:NSLocalizedString(@"关闭", nil) forSegmentAtIndex:0];
    [self.LCDLightSegment setTitle:NSLocalizedString(@"30秒", nil) forSegmentAtIndex:1];
    [self.LCDLightSegment setTitle:NSLocalizedString(@"1分钟", nil) forSegmentAtIndex:2];
    [self.LCDLightSegment setTitle:NSLocalizedString(@"5分钟", nil) forSegmentAtIndex:3];
    [self.watermarkSegment setTitle:NSLocalizedString(@"日期+型号", nil) forSegmentAtIndex:0];
    [self.watermarkSegment setTitle:NSLocalizedString(@"日期", nil) forSegmentAtIndex:1];
    [self.watermarkSegment setTitle:NSLocalizedString(@"关闭", nil) forSegmentAtIndex:2];
    [self.dateFormatSegment setTitle:NSLocalizedString(@"无", nil) forSegmentAtIndex:0];
    [self.dateFormatSegment setTitle:NSLocalizedString(@"年月日", nil) forSegmentAtIndex:1];
    [self.dateFormatSegment setTitle:NSLocalizedString(@"月日年", nil) forSegmentAtIndex:2];
    [self.dateFormatSegment setTitle:NSLocalizedString(@"日月年", nil) forSegmentAtIndex:3];
    [self.volumeSeg setTitle:NSLocalizedString(@"关闭", nil) forSegmentAtIndex:0];
    [self.volumeSeg setTitle:NSLocalizedString(@"低", nil) forSegmentAtIndex:1];
    [self.volumeSeg setTitle:NSLocalizedString(@"中", nil) forSegmentAtIndex:2];
    [self.volumeSeg setTitle:NSLocalizedString(@"高", nil) forSegmentAtIndex:3];
    
    
    //雄风
    UIFont *font = [UIFont boldSystemFontOfSize:7.0f];
    NSDictionary *attributes = [NSDictionary dictionaryWithObject:font forKey:NSFontAttributeName];
    [self.videoModeSegment setTitleTextAttributes:attributes forState:UIControlStateNormal];
    [self.videoModeSegment setTitle:@"2560*1440 30fps" forSegmentAtIndex:0];
    [self.videoModeSegment setTitle:@"1920*1080 60fps" forSegmentAtIndex:1];
    [self.videoModeSegment setTitle:@"1920*1080 30fps" forSegmentAtIndex:2];
    [self.videoModeSegment setTitle:@"1280*720 60fps" forSegmentAtIndex:3];
    [self.watermarkSegment2 setTitle:NSLocalizedString(@"日期+型号", nil) forSegmentAtIndex:0];
    [self.watermarkSegment2 setTitle:NSLocalizedString(@"日期", nil) forSegmentAtIndex:1];
    [self.watermarkSegment2 setTitle:NSLocalizedString(@"型号", nil) forSegmentAtIndex:2];
    [self.watermarkSegment2 setTitle:NSLocalizedString(@"关闭", nil) forSegmentAtIndex:3];
    [self.dateFormatSegment2 setTitle:NSLocalizedString(@"年月日", nil) forSegmentAtIndex:0];
    [self.dateFormatSegment2 setTitle:NSLocalizedString(@"月日年", nil) forSegmentAtIndex:1];
    [self.dateFormatSegment2 setTitle:NSLocalizedString(@"日月年", nil) forSegmentAtIndex:2];
    
    __weak typeof (self) weakSelf = self;
    [[NSNotificationCenter defaultCenter] addObserverForName:@"FormatSDCardFailed" object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
        
        if (weakSelf.clickFormatSDCard == YES) {
            [APKAlertTool showAlertInViewController:self title:nil message:NSLocalizedString(@"格式化SD卡失败！", nil) confirmHandler:^(UIAlertAction *action) {
                
                nil;
            }];
        }
        weakSelf.clickFormatSDCard = NO;;
    }];
}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];

    APKDVR *dvr = [APKDVR sharedInstance];
    [dvr addObserver:self forKeyPath:@"isConnected" options:NSKeyValueObservingOptionNew context:nil];

    [self updateUIWithDVRModal];
    [self updateUIWithSettingInfo];
}

- (void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    
    APKDVR *dvr = [APKDVR sharedInstance];
    [dvr removeObserver:self forKeyPath:@"isConnected"];
}

#pragma mark - KVO

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    
    if ([keyPath isEqualToString:@"isConnected"]) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self updateUIWithDVRModal];
            [self updateUIWithSettingInfo];
        });
    }
}

#pragma mark - private method

- (void)updateUIWithDVRModal{
    
    APKDVR *dvr = [APKDVR sharedInstance];
    if (self.dvrModal == dvr.modal) {
        return;
    }
    self.dvrModal = dvr.modal;
    
    if (self.dvrModal == kAPKDVRModalAosibi) {
        self.cells = @[self.recordSoundCell,self.motionDetectionCell,self.clipDurationCell,self.gSensorCell,self.LCDLightCell,self.watermarkCell1,self.dateFormatCell,self.exposureCell,self.correctCameraClockCell,self.formatCell,self.networkConfigureCell,self.factoryResetCell,self.helpCell,self.aboatCell];
        self.rowHeights = @[@(62),@(62),@(98),@(98),@(98),@(98),@(98),@(100),@(62),@(62),@(62),@(62),@(62),@(62)];
    }
    else if (self.dvrModal == kAPKDVRModalXiongFeng){
        self.cells = @[self.recordSoundCell,self.upsidedownCell,self.motionDetectionCell,self.videoModeCell,self.clipDurationCell,self.gSensorCell,self.LCDLightCell,self.watermarkCell2,self.dateFormatCell2,self.exposureCell,self.correctCameraClockCell,self.formatCell,self.networkConfigureCell,self.factoryResetCell,self.helpCell,self.aboatCell];
        self.rowHeights = @[@(62),@(62),@(62),@(98),@(98),@(98),@(98),@(98),@(98),@(100),@(62),@(62),@(62),@(62),@(62),@(62)];
    }
    
    [self.tableView reloadData];
}

- (void)updateUIWithSettingInfo{
    
    APKDVR *dvr = [APKDVR sharedInstance];
    APKDVRSettingInfo *settingInfo = dvr.settingInfo;
    if (settingInfo) {
        
        self.micSwitch.on = settingInfo.recordSound;
        self.clipDurationSegment.selectedSegmentIndex = settingInfo.VideoClipTime;
        self.gSensorSegment.selectedSegmentIndex = settingInfo.GSensor;
        self.EVValueLabel.text = [self exposureValueWithSettingInfoValue:settingInfo.exposure];
        self.EVSlider.value = [self exposureSliderValueWithSettingInfoValue:settingInfo.exposure];
        self.motionDetectionSwitch.on = settingInfo.motionDetection;
        self.LCDLightSegment.selectedSegmentIndex = settingInfo.LCDPowerSave;
        self.dateFormatSegment.selectedSegmentIndex = settingInfo.dateFormat;
        self.watermarkSegment.selectedSegmentIndex = settingInfo.watermark;
        self.EdogSwitch.on = settingInfo.edog;
        self.speedLimitSeg.selectedSegmentIndex = settingInfo.speedLimit;
        self.volumeSeg.selectedSegmentIndex = settingInfo.volume;
        if (self.dvrModal == kAPKDVRModalAosibi) {
            self.watermarkSegment.selectedSegmentIndex = settingInfo.watermark;
            self.dateFormatSegment.selectedSegmentIndex = settingInfo.dateFormat;
        }
        else{
            self.watermarkSegment2.selectedSegmentIndex = settingInfo.watermark;
            self.dateFormatSegment2.selectedSegmentIndex = settingInfo.dateFormat;
        }
        //雄风
        self.upsidedownSwitch.on = settingInfo.upsidedown;
        self.videoModeSegment.selectedSegmentIndex = settingInfo.videoRes;
    }
    else{
        
        self.micSwitch.on = NO;
        self.clipDurationSegment.selectedSegmentIndex = UISegmentedControlNoSegment;
        self.gSensorSegment.selectedSegmentIndex = UISegmentedControlNoSegment;
        self.EVValueLabel.text = [self exposureValueWithSettingInfoValue:0];
        self.EVSlider.value = [self exposureSliderValueWithSettingInfoValue:0];
        self.motionDetectionSwitch.on = NO;
        self.LCDLightSegment.selectedSegmentIndex = UISegmentedControlNoSegment;
        self.dateFormatSegment.selectedSegmentIndex = UISegmentedControlNoSegment;
        self.watermarkSegment.selectedSegmentIndex = UISegmentedControlNoSegment;
        self.volumeSeg.selectedSegmentIndex = UISegmentedControlNoSegment;

        //雄风
        self.upsidedownSwitch.on = NO;
        self.videoModeSegment.selectedSegmentIndex = UISegmentedControlNoSegment;
        self.watermarkSegment2.selectedSegmentIndex = UISegmentedControlNoSegment;
        self.dateFormatSegment2.selectedSegmentIndex = UISegmentedControlNoSegment;
    }
}

- (void)updateUIWithTimer:(NSTimer *)timer{
    
    if (self.correctCameraClockAlert) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            self.correctCameraClockAlert.message = self.currentTime;
        });
        
    }else{
        
        [timer invalidate];
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.cells.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = self.cells[indexPath.row];
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    CGFloat rowHeight = [[self.rowHeights objectAtIndex:indexPath.row] floatValue];
    return rowHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (cell == self.helpCell || cell == self.aboatCell) {
        
        return;
    }
    
    if (![APKDVR sharedInstance].isConnected) {
        
        [APKAlertTool showAlertInViewController:self title:nil message:NSLocalizedString(@"未连接DVR", nil) confirmHandler:^(UIAlertAction *action) {}];
        return;
    }
    
    if (cell == self.networkConfigureCell) {
        
        [self performSegueWithIdentifier:@"networkConfigure" sender:nil];
    
    }else if(cell == self.correctCameraClockCell){
        
        NSString *title = [NSString stringWithFormat:@"%@?",NSLocalizedString(@"校准时间", nil)];//NSLocalizedString(@"摄像机时间将会校准为：", nil)
        self.correctCameraClockAlert = [APKAlertTool showAlertInViewController:self title:title message:self.currentTime cancelHandler:nil confirmHandler:^(UIAlertAction *action) {
            
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.tabBarController.view animated:YES];
            __weak typeof(self) weakSelf = self;
            NSDate *today = [NSDate date];
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"yyyy$MM$dd$HH$mm$ss"];
            NSString *currentTime = [dateFormatter stringFromDate:today];
            [[APKDVRCommandFactory setCommandWithProperty:@"TimeSettings" value:currentTime] execute:^(id responseObject) {
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    [APKAlertTool showAlertInViewController:weakSelf title:nil message:NSLocalizedString(@"校准时间成功！", nil) confirmHandler:nil];
                    [hud hideAnimated:YES];
                });
                
            } failure:^(int rval) {
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    [APKAlertTool showAlertInViewController:weakSelf title:nil message:NSLocalizedString(@"校准时间失败！", nil) confirmHandler:nil];
                    [hud hideAnimated:YES];
                    
                });
            }];
        }];

        [NSTimer scheduledTimerWithTimeInterval:1.f target:self selector:@selector(updateUIWithTimer:) userInfo:nil repeats:YES];
        
    }else if (cell == self.formatCell){
        
//        [[APKDVRCommandFactory getFormatSDCardInfo] execute:^(id responseObject) {
//
//            NSString *info = responseObject;
//            if (![info containsString:@"INSERT"]){
//                [APKAlertTool showAlertInViewController:self title:nil message:NSLocalizedString(@"检测TF卡失败", nil) confirmHandler:nil];
//                return;
//            }
//
//            [self formatSdCard];
//        } failure:^(int rval) {
//        }];
        self.clickFormatSDCard = YES;
        [self formatSdCard];

    }else if (cell == self.factoryResetCell){
        
        NSString *message = [NSString stringWithFormat:@"%@?",NSLocalizedString(@"恢复出厂设置", nil)];
        [APKAlertTool showAlertInViewController:self title:nil message:message cancelHandler:nil confirmHandler:^(UIAlertAction *action) {
            
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.tabBarController.view animated:YES];
            
            NSString *property = @"FactoryReset",*value = @"Camera";
            if ([APKDVR sharedInstance].modal == kAPKDVRModalXiongFeng)
                property = @"ResetSetup",value = @"YES";
            __weak typeof(self) weakSelf = self;
            [[APKDVRCommandFactory setCommandWithProperty:property value:value] execute:^(id responseObject) {
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    [APKAlertTool showAlertInViewController:weakSelf title:nil message:NSLocalizedString(@"恢复出厂设置成功！", nil) confirmHandler:nil];
                    [hud hideAnimated:YES];
                });
                
            } failure:^(int rval) {
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    [APKAlertTool showAlertInViewController:weakSelf title:nil message:NSLocalizedString(@"恢复出厂设置失败！", nil) confirmHandler:nil];
                    [hud hideAnimated:YES];
                });
            }];
        }];
    }else if (cell == self.DBValueCell){
        
        [self performSegueWithIdentifier:@"DBValueVC" sender:nil];
        

    }
}

-(void)formatSdCard
{
    NSString *message = [NSString stringWithFormat:@"%@?",NSLocalizedString(@"格式化SD卡", nil)];
    [APKAlertTool showAlertInViewController:self title:nil message:message cancelHandler:nil confirmHandler:^(UIAlertAction *action) {
        
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.tabBarController.view animated:YES];
        __weak typeof(self) weakSelf = self;
        [[APKDVRCommandFactory setCommandWithProperty:@"SD0" value:@"format"] execute:^(id responseObject) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [APKAlertTool showAlertInViewController:weakSelf title:nil message:NSLocalizedString(@"格式化SD卡成功！", nil) confirmHandler:nil];
                [hud hideAnimated:YES];
            });
            
        } failure:^(int rval) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [APKAlertTool showAlertInViewController:weakSelf title:nil message:NSLocalizedString(@"格式化SD卡失败！", nil) confirmHandler:nil];
                [hud hideAnimated:YES];
            });
        }];
    }];
}

#pragma mark - event response

- (IBAction)finishUpdateEVSlider:(UISlider *)sender {
    
    if (!self.isSettable) return;
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];

    NSDictionary *info = [self exposureInfoWithSliderValue:sender.value];
    NSString *value = info.allValues.firstObject;
    NSString *property = @"EV";
    __weak typeof(self)weakSelf = self;
    [[APKDVRCommandFactory setCommandWithProperty:property value:value] execute:^(id responseObject) {
        
        [APKDVR sharedInstance].settingInfo.exposure = [[APKDVR sharedInstance].settingInfo.exposureMap indexOfObject:value];
        
        [hud hideAnimated:YES];
        
        [APKAlertTool showAlertInView:self.view andText:NSLocalizedString(@"设置成功", nil)];
        
    } failure:^(int rval) {
        
        [hud hideAnimated:YES];
        [APKAlertTool showAlertInViewController:weakSelf title:nil message:NSLocalizedString(@"设置失败！", nil) confirmHandler:^(UIAlertAction *action) {
            
            weakSelf.EVSlider.value = [weakSelf exposureSliderValueWithSettingInfoValue:[APKDVR sharedInstance].settingInfo.exposure];
            weakSelf.EVValueLabel.text = [weakSelf exposureValueWithSettingInfoValue:[APKDVR sharedInstance].settingInfo.exposure];
        }];
    }];
}

- (IBAction)updateEVSlider:(UISlider *)sender {
    
    NSDictionary *info = [self exposureInfoWithSliderValue:sender.value];
    self.EVValueLabel.text = info.allKeys.firstObject;
}

- (IBAction)updateDateFormatSegment:(UISegmentedControl *)sender {
    
    if (!self.isSettable) return;
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];

    NSString *value = [APKDVR sharedInstance].settingInfo.dateFormatMap[sender.selectedSegmentIndex];
    NSString *property = @"TimeFormat";
    __weak typeof(self)weakSelf = self;
    [[APKDVRCommandFactory setCommandWithProperty:property value:value] execute:^(id responseObject) {
        
        [APKDVR sharedInstance].settingInfo.dateFormat = sender.selectedSegmentIndex;
        
        [hud hideAnimated:YES];
        
        [APKAlertTool showAlertInView:self.view andText:NSLocalizedString(@"设置成功", nil)];
        
    } failure:^(int rval) {
        
        [hud hideAnimated:YES];
        [APKAlertTool showAlertInViewController:weakSelf title:nil message:NSLocalizedString(@"设置失败！", nil) confirmHandler:^(UIAlertAction *action) {
            
            sender.selectedSegmentIndex = [APKDVR sharedInstance].settingInfo.dateFormat;
        }];
    }];
}

- (IBAction)updateWatermarkSegment:(UISegmentedControl *)sender {
    
    if (!self.isSettable) return;
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];

    NSString *value = [APKDVR sharedInstance].settingInfo.watermarkMap[sender.selectedSegmentIndex];
    NSString *property = @"TimeStamp";
    __weak typeof(self)weakSelf = self;
    [[APKDVRCommandFactory setCommandWithProperty:property value:value] execute:^(id responseObject) {
        
        [APKDVR sharedInstance].settingInfo.watermark = sender.selectedSegmentIndex;
        
        [hud hideAnimated:YES];
        
        [APKAlertTool showAlertInView:self.view andText:NSLocalizedString(@"设置成功", nil)];
        
    } failure:^(int rval) {
        
        [hud hideAnimated:YES];
        [APKAlertTool showAlertInViewController:weakSelf title:nil message:NSLocalizedString(@"设置失败！", nil) confirmHandler:^(UIAlertAction *action) {
            
            sender.selectedSegmentIndex = [APKDVR sharedInstance].settingInfo.watermark;
        }];
    }];
}

- (IBAction)updateLCDLightSegment:(UISegmentedControl *)sender {
    
    if (!self.isSettable) return;
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];

    NSString *value = [APKDVR sharedInstance].settingInfo.LCDPowerSaveMap[sender.selectedSegmentIndex];
    NSString *property = @"LCDPowerSave";
    __weak typeof(self)weakSelf = self;
    [[APKDVRCommandFactory setCommandWithProperty:property value:value] execute:^(id responseObject) {
        
        [APKDVR sharedInstance].settingInfo.LCDPowerSave = sender.selectedSegmentIndex;
        [hud hideAnimated:YES];
        
        [APKAlertTool showAlertInView:self.view andText:NSLocalizedString(@"设置成功", nil)];
        
    } failure:^(int rval) {
        
        [hud hideAnimated:YES];
        [APKAlertTool showAlertInViewController:weakSelf title:nil message:NSLocalizedString(@"设置失败！", nil) confirmHandler:^(UIAlertAction *action) {
            
            sender.selectedSegmentIndex = [APKDVR sharedInstance].settingInfo.LCDPowerSave;
        }];
    }];
}
- (IBAction)toggleEdogSwitch:(UISwitch *)sender {
    
    if (!self.isSettable) return;
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    
    NSString *value = [APKDVR sharedInstance].settingInfo.edogMap[sender.isOn];
    NSString *property = @"Camera.Menu.Edog";
    __weak typeof(self)weakSelf = self;
    [[APKDVRCommandFactory setCommandWithProperty:property value:value] execute:^(id responseObject) {
        
        [APKDVR sharedInstance].settingInfo.edog = sender.isOn;
        [hud hideAnimated:YES];
        [APKAlertTool showAlertInView:self.view andText:NSLocalizedString(@"设置成功", nil)];
        
    } failure:^(int rval) {
        
        [hud hideAnimated:YES];
        [APKAlertTool showAlertInViewController:weakSelf title:nil message:NSLocalizedString(@"设置失败！", nil) confirmHandler:^(UIAlertAction *action) {
            
            sender.on = !sender.isOn;
        }];
    }];
}

- (IBAction)toggleMotionDetectionSwitch:(UISwitch *)sender {
    
    if (!self.isSettable) return;
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];

    NSString *value = [APKDVR sharedInstance].settingInfo.motionDetectionMap[sender.isOn];
    NSString *property = @"MTD";
    __weak typeof(self)weakSelf = self;
    [[APKDVRCommandFactory setCommandWithProperty:property value:value] execute:^(id responseObject) {
        
        [APKDVR sharedInstance].settingInfo.motionDetection = sender.isOn;
        [hud hideAnimated:YES];
        [APKAlertTool showAlertInView:self.view andText:NSLocalizedString(@"设置成功", nil)];
        
    } failure:^(int rval) {
        
        [hud hideAnimated:YES];
        [APKAlertTool showAlertInViewController:weakSelf title:nil message:NSLocalizedString(@"设置失败！", nil) confirmHandler:^(UIAlertAction *action) {
            
            sender.on = !sender.isOn;
        }];
    }];
}

- (IBAction)updateGSensorSegment:(UISegmentedControl *)sender {
    
    if (!self.isSettable) return;
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];

    NSString *value = [APKDVR sharedInstance].settingInfo.GSensorMap[sender.selectedSegmentIndex];
    NSString *property = @"GSensor";
    __weak typeof(self)weakSelf = self;
    [[APKDVRCommandFactory setCommandWithProperty:property value:value] execute:^(id responseObject) {
        
        [APKDVR sharedInstance].settingInfo.GSensor = sender.selectedSegmentIndex;
        [hud hideAnimated:YES];
        [APKAlertTool showAlertInView:self.view andText:NSLocalizedString(@"设置成功", nil)];
        
    } failure:^(int rval) {
        
        [hud hideAnimated:YES];
        [APKAlertTool showAlertInViewController:weakSelf title:nil message:NSLocalizedString(@"设置失败！", nil) confirmHandler:^(UIAlertAction *action) {
            
            sender.selectedSegmentIndex = [APKDVR sharedInstance].settingInfo.GSensor;
        }];
    }];
}

- (IBAction)updateClipDurationSegment:(UISegmentedControl *)sender {
    
    if (!self.isSettable) return;
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    
    NSString *value = [APKDVR sharedInstance].settingInfo.VideoClipTimeMap[sender.selectedSegmentIndex];
    NSString *property = @"VideoClipTime";
    __weak typeof(self)weakSelf = self;
    [[APKDVRCommandFactory setCommandWithProperty:property value:value] execute:^(id responseObject) {
        
        [APKDVR sharedInstance].settingInfo.VideoClipTime = sender.selectedSegmentIndex;
        [hud hideAnimated:YES];
        [APKAlertTool showAlertInView:self.view andText:NSLocalizedString(@"设置成功", nil)];
        
    } failure:^(int rval) {
        
        [hud hideAnimated:YES];
        [APKAlertTool showAlertInViewController:weakSelf title:nil message:NSLocalizedString(@"设置失败！", nil) confirmHandler:^(UIAlertAction *action) {
            
            sender.selectedSegmentIndex = [APKDVR sharedInstance].settingInfo.VideoClipTime;
        }];
    }];
}

- (IBAction)toggleMicSwitch:(UISwitch *)sender {
    
    if (!self.isSettable) return;
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    
    APKDVRModal dvrModal = [APKDVR sharedInstance].modal;
    NSString *property;
    NSString *value;
    if (dvrModal == kAPKDVRModalAosibi) {
        property = @"Video";
        value = sender.isOn ? @"unmute" : @"mute";
    }
    else{
        property = @"SoundRecord";
        value = sender.isOn ? @"OFF" : @"ON";
    }
    
    __weak typeof(self)weakSelf = self;
    [[APKDVRCommandFactory setCommandWithProperty:property value:value] execute:^(id responseObject) {
        
        [APKDVR sharedInstance].settingInfo.recordSound = sender.isOn;
        [hud hideAnimated:YES];
        [APKAlertTool showAlertInView:self.view andText:NSLocalizedString(@"设置成功", nil)];
        
    } failure:^(int rval) {
        
        [hud hideAnimated:YES];
        [APKAlertTool showAlertInViewController:weakSelf title:nil message:NSLocalizedString(@"设置失败！", nil) confirmHandler:^(UIAlertAction *action) {
            sender.on = !sender.on;
        }];
    }];
}

#pragma mark 雄风

- (IBAction)toggleUpsidedownSwitch:(UISwitch *)sender {
    
    if (!self.isSettable) return;
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];

    NSString *property = @"UpsideDown";
    NSString *value = sender.isOn ? @"Upsidedown" : @"Normal";
    __weak typeof(self)weakSelf = self;
    [[APKDVRCommandFactory setCommandWithProperty:property value:value] execute:^(id responseObject) {
        
        [APKDVR sharedInstance].settingInfo.upsidedown = sender.isOn;
        [hud hideAnimated:YES];
        [APKAlertTool showAlertInView:self.view andText:NSLocalizedString(@"设置成功", nil)];
        
    } failure:^(int rval) {
        
        [hud hideAnimated:YES];
        [APKAlertTool showAlertInViewController:weakSelf title:nil message:NSLocalizedString(@"设置失败！", nil) confirmHandler:^(UIAlertAction *action) {
            sender.on = !sender.on;
        }];
    }];
}

- (IBAction)updateVideoModeSegment:(UISegmentedControl *)sender {
    
    if (!self.isSettable) return;
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    
    NSString *value = [APKDVR sharedInstance].settingInfo.videoResMap[sender.selectedSegmentIndex];
    NSString *property = @"Videores";
    __weak typeof(self)weakSelf = self;
    [[APKDVRCommandFactory setCommandWithProperty:property value:value] execute:^(id responseObject) {
        
        [APKDVR sharedInstance].settingInfo.videoRes = sender.selectedSegmentIndex;
        [hud hideAnimated:YES];
        [APKAlertTool showAlertInView:self.view andText:NSLocalizedString(@"设置成功", nil)];
        
    } failure:^(int rval) {
        
        [hud hideAnimated:YES];
        [APKAlertTool showAlertInViewController:weakSelf title:nil message:NSLocalizedString(@"设置失败！", nil) confirmHandler:^(UIAlertAction *action) {
            
            sender.selectedSegmentIndex = [APKDVR sharedInstance].settingInfo.videoRes;
        }];
    }];
}

- (IBAction)updateWatermarkSegment2:(UISegmentedControl *)sender {
    
    if (!self.isSettable) return;
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];

    NSString *value = [APKDVR sharedInstance].settingInfo.watermarkMap2[sender.selectedSegmentIndex];
    NSString *property = @"TimeStamp";
    __weak typeof(self)weakSelf = self;
    [[APKDVRCommandFactory setCommandWithProperty:property value:value] execute:^(id responseObject) {
        
        [APKDVR sharedInstance].settingInfo.watermark = sender.selectedSegmentIndex;
        [hud hideAnimated:YES];
        [APKAlertTool showAlertInView:self.view andText:NSLocalizedString(@"设置成功", nil)];
        
    } failure:^(int rval) {
        
        [hud hideAnimated:YES];
        [APKAlertTool showAlertInViewController:weakSelf title:nil message:NSLocalizedString(@"设置失败！", nil) confirmHandler:^(UIAlertAction *action) {
            
            sender.selectedSegmentIndex = [APKDVR sharedInstance].settingInfo.watermark;
        }];
    }];
}
- (IBAction)updateDateFormatSegment2:(UISegmentedControl *)sender {
    
    if (!self.isSettable) return;
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];

    NSString *value = [APKDVR sharedInstance].settingInfo.dateFormatMap2[sender.selectedSegmentIndex];
    NSString *property = @"TimeFormat";
    __weak typeof(self)weakSelf = self;
    [[APKDVRCommandFactory setCommandWithProperty:property value:value] execute:^(id responseObject) {
        
        [APKDVR sharedInstance].settingInfo.dateFormat = sender.selectedSegmentIndex;
        [hud hideAnimated:YES];
        [APKAlertTool showAlertInView:self.view andText:NSLocalizedString(@"设置成功", nil)];
        
    } failure:^(int rval) {
        
        [hud hideAnimated:YES];
        [APKAlertTool showAlertInViewController:weakSelf title:nil message:NSLocalizedString(@"设置失败！", nil) confirmHandler:^(UIAlertAction *action) {
            
            sender.selectedSegmentIndex = [APKDVR sharedInstance].settingInfo.dateFormat;
        }];
    }];
}
- (IBAction)updateSpeedLimitSeg:(UISegmentedControl *)sender {
    
    if (!self.isSettable) return;
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    
    NSString *value = [APKDVR sharedInstance].settingInfo.speedLimitMap[sender.selectedSegmentIndex];
    NSString *property = @"Camera.Menu.SpeedLimitAlert";
    __weak typeof(self)weakSelf = self;
    [[APKDVRCommandFactory setCommandWithProperty:property value:value] execute:^(id responseObject) {
        
        [APKDVR sharedInstance].settingInfo.speedLimit = sender.selectedSegmentIndex;
        [hud hideAnimated:YES];
        [APKAlertTool showAlertInView:self.view andText:NSLocalizedString(@"设置成功", nil)];
        
    } failure:^(int rval) {
        
        [hud hideAnimated:YES];
        [APKAlertTool showAlertInViewController:weakSelf title:nil message:NSLocalizedString(@"设置失败！", nil) confirmHandler:^(UIAlertAction *action) {
            
            sender.selectedSegmentIndex = [APKDVR sharedInstance].settingInfo.speedLimit;
        }];
    }];
}
- (IBAction)updateVolumeSeg:(UISegmentedControl *)sender {
    
    if (!self.isSettable) return;
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    
    NSString *value = [APKDVR sharedInstance].settingInfo.volumeMap[sender.selectedSegmentIndex];
    NSString *property = @"Camera.Menu.Volume";
    __weak typeof(self)weakSelf = self;
    [[APKDVRCommandFactory setCommandWithProperty:property value:value] execute:^(id responseObject) {
        
        [APKDVR sharedInstance].settingInfo.volume = sender.selectedSegmentIndex;
        [hud hideAnimated:YES];
        [APKAlertTool showAlertInView:self.view andText:NSLocalizedString(@"设置成功", nil)];
        
    } failure:^(int rval) {
        
        [hud hideAnimated:YES];
        [APKAlertTool showAlertInViewController:weakSelf title:nil message:NSLocalizedString(@"设置失败！", nil) confirmHandler:^(UIAlertAction *action) {
            
            sender.selectedSegmentIndex = [APKDVR sharedInstance].settingInfo.volume;
        }];
    }];
}

#pragma mark - Utilities

- (CGFloat)exposureSliderValueWithSettingInfoValue:(NSInteger)value{
    
    if (value == -1) {
        
        return 0;
    }
    
    CGFloat map[] = {-2,-1.7,-1.3,-1,-0.7,-0.3,0,0.3,0.7,1,1.3,1.7,2};
    CGFloat f = map[value];
    return f;
}

- (NSString *)exposureValueWithSettingInfoValue:(NSInteger)value{
    
    if (value == -1) {
        
        return @"0";
    }
    
    NSArray *map = @[@"-2",@"-1.7",@"-1.3",@"-1",@"-0.7",@"-0.3",@"0",@"0.3",@"0.7",@"1",@"1.3",@"1.7",@"2"];
    NSString *str = map[value];
    return str;
}

- (NSDictionary *)exposureInfoWithSliderValue:(CGFloat)value{
    
    NSString *setValue = nil;
    NSString *displayValue = nil;
    if (value > -0.15 && value < 0.15) {
        
        displayValue = @"0";
        setValue = @"EV0";
        
    }else{
        
        BOOL isPositive = value > 0 ? YES : NO;
        if (!isPositive) value = -value;
        
        if (value >= 0.15 && value < 0.5) {
            
            displayValue = isPositive ? @"0.3" : @"-0.3";
            setValue = isPositive ? @"EVP033" : @"EVN033";
        }
        else if (value >= 0.5 && value < 0.85){
            
            displayValue = isPositive ? @"0.7" : @"-0.7";
            setValue = isPositive ? @"EVP067" : @"EVN067";

        }
        else if (value >= 0.85 && value < 1.15){
            
            displayValue = isPositive ? @"1" : @"-1";
            setValue = isPositive ? @"EVP100" : @"EVN100";

        }
        else if (value >= 1.15 && value < 1.5){
            
            displayValue = isPositive ? @"1.3" : @"-1.3";
            setValue = isPositive ? @"EVP133" : @"EVN133";

        }
        else if (value >= 1.5 && value < 1.85){
            
            displayValue = isPositive ? @"1.7" : @"-1.7";
            setValue = isPositive ? @"EVP167" : @"EVN167";
        }
        else{
        
            displayValue = isPositive ? @"2" : @"-2";
            setValue = isPositive ? @"EVP200" : @"EVN200";
        }
    }
    
    return @{displayValue:setValue};
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    if ([segue.identifier isEqualToString:@"checkAboat"]) {
        
        APKAboatViewController *vc = segue.destinationViewController;
        vc.firmwareVersion = [APKDVR sharedInstance].settingInfo.FWVersion;
    }
}

#pragma mark - getter

- (NSArray *)rowHeights{
    
    if (!_rowHeights) {
        _rowHeights = @[@(62),@(62),@(98),@(98),@(98),@(62),@(62),@(62),@(62),@(62),@(62),@(62),@(62),@(62),@(62)];
    }
    return _rowHeights;
}

- (NSArray *)cells{
    
    if (!_cells) {
        
//        _cells = @[self.recordSoundCell,self.motionDetectionCell,self.clipDurationCell,self.gSensorCell,self.LCDLightCell,self.watermarkCell1,self.dateFormatCell,self.exposureCell,self.correctCameraClockCell,self.formatCell,self.networkConfigureCell,self.factoryResetCell,self.helpCell,self.aboatCell,self.DBValueCell];
        _cells = @[self.recordSoundCell,self.EdogCell,self.clipDurationCell,self.gSensorCell,self.volumeCell,self.correctCameraClockCell,self.formatCell,self.networkConfigureCell,self.factoryResetCell,self.helpCell,self.aboatCell];
    }
    return _cells;
}

- (NSString *)currentTime{
    
    //获取手机当前时间
    NSDate *date = [[NSDate alloc] init];
    //实例化一个NSDateFormatter对象
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //设定时间格式,这里可以设置成自己需要的格式
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *currentTime = [dateFormatter stringFromDate:date];
    return currentTime;
}

- (BOOL)isSettable{
    
    BOOL isSettable = YES;
    
    if (![APKDVR sharedInstance].isConnected) {
        
        [APKAlertTool showAlertInViewController:self title:nil message:NSLocalizedString(@"未连接DVR", nil) confirmHandler:^(UIAlertAction *action) {}];
        
        isSettable = NO;
    }
    
    return isSettable;
}

@end
