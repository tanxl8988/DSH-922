//
//  APKRtspPlayerController.m
//  万能AIT
//
//  Created by Mac on 17/12/19.
//  Copyright © 2017年 APK. All rights reserved.
//

#import "APKRealTimeViewingController.h"
#import "MobileVLCKit/VLCMediaPlayer.h"

@interface APKRealTimeViewingController ()<VLCMediaPlayerDelegate>

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *flower;
@property (weak, nonatomic) IBOutlet UIButton *playButton;
@property (strong,nonatomic) UIView *displayView;
@property (strong,nonatomic) VLCMediaPlayer *player;
@property (strong,nonatomic) NSTimer *redTipTimer;
@property (weak, nonatomic) IBOutlet UIView *redTipView;
@property (assign,nonatomic) NSInteger timerCountNum;

@end

@implementation APKRealTimeViewingController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIViewController *vc = [[UIViewController alloc] init];
    [self addChildViewController:vc];
    vc.view.frame = self.view.bounds;
    vc.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:vc.view];
    [self.view sendSubviewToBack:vc.view];
    self.displayView = vc.view;
    
    
}

-(void)createTimer
{
    /*
    _redTipTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 repeats:YES block:^(NSTimer * _Nonnull timer) {
        
        self.redTipView.hidden = !self.redTipView.hidden;
    }];*/
    if (self.timerCountNum > 1) {
         self.redTipView.hidden = !self.redTipView.hidden;
         self.timerCountNum = 0;
     }
     
     self.timerCountNum++;
}

-(void)ClearTimer
{
    /*
    self.redTipView.hidden = YES;
    [_redTipTimer invalidate];
    _redTipTimer = nil;*/
    
    __weak typeof(self) weakSelf = self;
     dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0/*延迟执行时间*/ * NSEC_PER_SEC));

     dispatch_after(delayTime, dispatch_get_main_queue(), ^{
         weakSelf.redTipView.hidden = YES;
     });
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
    [self stop];
}

#pragma mark - public method

- (void)play{
    
    if (!self.url)
        return;
    
    switch (self.player.state) {
        case VLCMediaPlayerStateOpening:
        case VLCMediaPlayerStateBuffering:
        case VLCMediaPlayerStatePlaying:
            return;
            break;
        case VLCMediaPlayerStatePaused:
            [self.player play];
            return;
        default:
            break;
    }
    
    self.playButton.hidden = YES;
    [self.flower startAnimating];
    
    VLCMedia *media = [VLCMedia mediaWithURL:self.url];
    [self.player setMedia:media];
    [self.player play];
}

- (void)stop{
    
//    NSLog(@"stop live in state:%d",(int)self.player.state);
    switch (self.player.state) {
        case VLCMediaPlayerStateOpening:
        case VLCMediaPlayerStateBuffering:
        case VLCMediaPlayerStatePlaying:
        case VLCMediaPlayerStatePaused:
            [self.player stop];
            break;
        default:
            break;
    }
}

#pragma mark - VLCMediaPlayerDelegate

- (void)mediaPlayerStateChanged:(NSNotification *)aNotification{
    
//    NSLog(@"------>%d",self.player.state);
    switch (self.player.state) {
        case VLCMediaPlayerStateEnded:
        case VLCMediaPlayerStateStopped:
        case VLCMediaPlayerStateError:
        case VLCMediaPlayerStatePaused:
            if (self.playButton.hidden)
                self.playButton.hidden = NO;
            if (self.flower.isAnimating)
                [self.flower stopAnimating];
            break;
        case VLCMediaPlayerStatePlaying:
            if (!self.playButton.hidden)
                self.playButton.hidden = YES;
            if (self.flower.isAnimating)
                [self.flower stopAnimating];
            
            break;
        case VLCMediaPlayerStateOpening:
        case VLCMediaPlayerStateBuffering:
            if (!self.playButton.hidden)
                self.playButton.hidden = YES;
            if (!self.flower.isAnimating)
                [self.flower startAnimating];
            break;
    }
}

- (void)mediaPlayerTimeChanged:(NSNotification *)aNotification{
    
//    NSLog(@"number of video tracks:%d",self.player.numberOfAudioTracks);

    if (self.flower.isAnimating)
        [self.flower stopAnimating];
}

#pragma mark - event response

- (IBAction)clickPlayButton:(UIButton *)sender {
    
    [self play];
}

#pragma mark - getter

- (VLCMediaPlayer *)player{
    
    if (!_player) {
        
        NSString *caching = [NSString stringWithFormat:@"--network-caching=%d",1200];
        NSString *jitter = [NSString stringWithFormat:@"--clock-jitter=%d",1200];
        NSArray *options = @[caching,jitter,@"--extraintf=",@"--gain=0"];
//        NSArray *options = @[@"--network-caching=400",@"--extraintf="];
        _player = [[VLCMediaPlayer alloc] initWithOptions:options];
        _player.delegate = self;
        _player.drawable = self.displayView;
    }
    return _player;
}

@end
