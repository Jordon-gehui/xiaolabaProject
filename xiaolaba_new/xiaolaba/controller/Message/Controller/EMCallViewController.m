//
//  EMCallViewController.m
//  xiaolaba
//
//  Created by 戴葛辉 on 2018/3/16.
//  Copyright © 2018年 jackzhang. All rights reserved.
//

#import "EMCallViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "XLBDEvaluateView.h"
#import "OwnerRequestManager.h"
@interface EMCallViewController ()

@property (strong, nonatomic) UILabel *remoteNameLabel;//用户姓名

@property (nonatomic, strong) UIView *callV;
@property (nonatomic, strong) UILabel *callNickeName;
@property (nonatomic, strong) UIImageView *callImgV;
@property (nonatomic, strong) XLBDEvaluateView *callEvaV;

@property (nonatomic, strong) UIView *calledV;
@property (nonatomic, strong) UILabel *calledNickeName;
@property (nonatomic, strong) UIImageView *calledImgV;
@property (nonatomic, strong) XLBDEvaluateView *calledEvaV;


@property (strong, nonatomic) UIImageView *userImg;//拨打时头像
@property (strong, nonatomic) UIImageView *userBgImg;//背景图片
@property (strong, nonatomic) UIImageView *lineBgImg;//遮盖层

@property (strong, nonatomic) UILabel *timeStatus;
@property (strong, nonatomic) UILabel *timeLabel;//通话时长
@property (strong, nonatomic) UILabel *statusLabel;//通话状态
@property (strong, nonatomic) UIButton *silenceBtn;//静音
@property (strong, nonatomic) UIButton *handsFreeBtn;//免提
@property (strong, nonatomic) UIButton *minimumBtn;//最小化
@property (strong, nonatomic) UIButton *answerBtn;//接听
@property (strong, nonatomic) UIButton *rejectBtn;//拒绝
@property (strong, nonatomic) UIButton *HangupBtn;//挂机
@property (strong, nonatomic) AVAudioPlayer *ringPlayer;
@property (strong, nonatomic) NSTimer *timeTimer;
@property (strong, nonatomic) NSTimer *heartbeatTimer;

//@property (strong, nonatomic) UILabel *callNickName;//通话中昵称
//@property (strong, nonatomic) XLBDEvaluateView *tagV;//标签
//@property (strong, nonatomic) UIImageView *callUserImg;//通话中头像


@end

@implementation EMCallViewController
- (instancetype)initWithCallSession:(EMCallSession *)aCallSession
{
    self = [super init];
    if (self) {
        _callSession = aCallSession;
        _isDismissing = NO;
        NSUserDefaults *userDefa = [NSUserDefaults standardUserDefaults];
        [userDefa setObject:aCallSession.callId forKey:@"callID"];
        [userDefa synchronize];
    }
    
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    if (self.isDismissing) {
        return;
    }
    
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    if (self.isDismissing) {
        return;
    }
    [super viewDidAppear:animated];
}
- (void)viewDidLoad {
    if (self.isDismissing) {
        return;
    }
    [super viewDidLoad];
    
    [self setSubViews];
    [self _layoutSubviews];
    if (self.callSession.isCaller) {
        self.statusLabel.text = @"正在等待对方接受邀请...";
        [self callPayRequestWithType:@"0" huanXinNo:self.callSession.callId calledID:self.calledID];
    } else {
        self.statusLabel.text = @"正在邀请你语音通话...";
        NSArray *callIdArr = [self.callSession.callId componentsSeparatedByString:@"/"];
        NSLog(@"%@",callIdArr);
        if (kNotNil(callIdArr)) {
            [self callPayRequestWithType:@"1" huanXinNo:callIdArr[3] calledID:[[XLBUser user].userModel.ID stringValue]];
        }
    }
}
- (void)callPayRequestWithType:(NSString *)type huanXinNo:(NSString *)huanXinNo calledID:(NSString *)calledID{
    NSDictionary *dict = @{@"type":type,@"huanxinNo":huanXinNo,@"calledId":calledID,@"money":self.money,};
    [OwnerRequestManager requestCallPayWithParameter:dict success:^(id respones) {
        
    } error:^(id error) {
        
    }];
}
- (void)callPulseRequestWithType:(NSString *)type huanxinNo:(NSString *)huanxinNo calledID:(NSString *)calledID{
    NSDictionary *dict = @{@"type":type,@"huanxinNo":huanxinNo,@"calledId":calledID,};
    [OwnerRequestManager requestCallPulseWithParameter:dict success:^(id respones) {
        NSString *status = dict[@"status"];
        NSString *surplusMoney = dict[@"money"];
        if (self.callSession.isCaller) {
            if (![status isEqualToString:@"0"]) {
                 [self stopCall];
            }else {
                if ([surplusMoney intValue] > [self.money intValue]*2) {
                    
                }else {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"您的车币不足，请及时充值!" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
                    [alert show];
                }
                if ([surplusMoney intValue] < [self.money intValue]) {
                    [self stopCall];
                }
            }
        }
        
    } error:^(id error) {
        
    }];
}


- (void)silenceBtnClick:(UIButton *)sender {
    //静音
    self.silenceBtn.selected = !self.silenceBtn.selected;
    if (self.silenceBtn.selected) {
        [self.callSession pauseVoice];
        [self.silenceBtn setImage:[UIImage imageNamed:@"icon_th_jy"] forState:0];
    } else {
        [self.callSession resumeVoice];
        [self.silenceBtn setImage:[UIImage imageNamed:@"icon_th_ly"] forState:0];
    }
}

- (void)handsFreeBtnClick:(UIButton *)sender {
    //免提
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    if (self.handsFreeBtn.selected) {
        [audioSession overrideOutputAudioPort:AVAudioSessionPortOverrideNone error:nil];
        [self.handsFreeBtn setImage:[UIImage imageNamed:@"icon_th_mt"] forState:0];
    }else {
        [audioSession overrideOutputAudioPort:AVAudioSessionPortOverrideSpeaker error:nil];
        [self.handsFreeBtn setImage:[UIImage imageNamed:@"icon_th_mtg"] forState:0];
    }
    [audioSession setActive:YES error:nil];
    self.handsFreeBtn.selected = !self.handsFreeBtn.selected;
}

- (void)minimumBtnClick:(UIButton *)sender {

}


- (void)answerBtnClick:(UIButton *)sender {
    [self _stopRing];
    [[XLBCallManager sharedManager] answerCall:self.callSession.callId];
}

- (void)rejectBtnClick:(UIButton *)sender {
    [self _stopTimeTimer];
    [self stopHeadtbeatTime];

    [self _stopRing];
    
    [[XLBCallManager sharedManager] hangupCallWithReason:EMCallEndReasonDecline callTime:self.timeLength];
}
- (void)hangupBtnClick:(UIButton *)sender {
    [self stopCall];
}

- (void)stopCall {
    [self _stopTimeTimer];
    [self stopHeadtbeatTime];
    [self _stopRing];
    [[XLBCallManager sharedManager] hangupCallWithReason:EMCallEndReasonHangup callTime:self.timeLength];
}

- (void)_layoutSubviews {
    NSLog(@"语音ID%@  %@",self.callSession.remoteName,self.userId);
    NSDictionary *dict = @{@"createUser":self.callSession.remoteName};
    [OwnerRequestManager requestOwnerWithParameter:dict success:^(XLBOwnerModel *respones) {
        [self.calledEvaV insertSign:respones.tags];
    } error:^(id error) {
        
    }];
    
    [OwnerRequestManager requestOwnerWithParameter:@{@"createUser":self.userId} success:^(XLBOwnerModel *respones) {
        [self.callEvaV insertSign:respones.tags];

    } error:^(id error) {
        
    }];
    [OwnerRequestManager requestVoiceActorOwnerWithParameter:dict success:^(XLBVoiceActorModel *respones) {
        [self.callEvaV insertSign:respones.user.tags];
//        self.remoteNameLabel.text = respones.nickname;
//        [self.userBgImg sd_setImageWithURL:[NSURL URLWithString:[JXutils judgeImageheader:respones.img Withtype:IMGNormal]] placeholderImage:[UIImage imageNamed:@"weitouxiang"]];
//        [self.userImg sd_setImageWithURL:[NSURL URLWithString:[JXutils judgeImageheader:respones.img Withtype:IMGAvatar]] placeholderImage:[UIImage imageNamed:@"weitouxiang"]];
//        [self.callUserImg sd_setImageWithURL:[NSURL URLWithString:[JXutils judgeImageheader:respones.img Withtype:IMGAvatar]] placeholderImage:[UIImage imageNamed:@"weitouxiang"]];
//        self.callNickName.text = respones.nickname;

    } error:^(id error) {
        
    }];
    
    
    self.timeLabel.hidden = YES;
    self.handsFreeBtn.hidden = YES;
    self.silenceBtn.hidden = YES;
    self.minimumBtn.hidden = YES;
    [self _beginRing];
    self.callNickeName.text = self.nickName;
    self.calledNickeName.text = self.called;
    NSLog(@"%@  %@",self.called,self.nickName);
    [self.callImgV sd_setImageWithURL:[NSURL URLWithString:[JXutils judgeImageheader:self.avatar Withtype:IMGAvatar]] placeholderImage:[UIImage imageNamed:@"weitouxiang"]];
    [self.calledImgV sd_setImageWithURL:[NSURL URLWithString:[JXutils judgeImageheader:self.calledImg Withtype:IMGAvatar]] placeholderImage:[UIImage imageNamed:@"weitouxiang"]];
    
    BOOL isCaller = self.callSession.isCaller;
    switch (self.callSession.type) {
        case EMCallTypeVoice://音频
        {
            if (isCaller) {//主叫方
                self.remoteNameLabel.text = self.nickName;
                [self.userBgImg sd_setImageWithURL:[NSURL URLWithString:[JXutils judgeImageheader:self.avatar Withtype:IMGNormal]] placeholderImage:[UIImage imageNamed:@"weitouxiang"]];
                [self.userImg sd_setImageWithURL:[NSURL URLWithString:[JXutils judgeImageheader:self.avatar Withtype:IMGAvatar]] placeholderImage:[UIImage imageNamed:@"weitouxiang"]];
                self.rejectBtn.hidden = YES;
                self.answerBtn.hidden = YES;
            } else {
                self.HangupBtn.hidden = YES;
                self.remoteNameLabel.text = self.called;
                [self.userBgImg sd_setImageWithURL:[NSURL URLWithString:[JXutils judgeImageheader:self.calledImg Withtype:IMGNormal]] placeholderImage:[UIImage imageNamed:@"weitouxiang"]];
                [self.userImg sd_setImageWithURL:[NSURL URLWithString:[JXutils judgeImageheader:self.calledImg Withtype:IMGAvatar]] placeholderImage:[UIImage imageNamed:@"weitouxiang"]];
            }
        }
            break;
            
        default:
            break;
    }
}

- (void)setNetwork:(EMCallNetworkStatus)aStatus
{
    if (aStatus == EMCallNetworkStatusUnstable) {
        NSLog(@"网络不稳定");
    } else if (aStatus == EMCallNetworkStatusNoData) {
        NSLog(@"无数据");
        [[XLBCallManager sharedManager] hangupCallWithReason:EMCallEndReasonHangup callTime:self.timeLength];
    } else {
        NSLog(@"正常");
    }
}

- (void)setStreamType:(EMCallStreamingStatus)aType
{
    NSString *str = @"Unkonw";
    switch (aType) {
        case EMCallStreamStatusVoicePause:
            str = @"Audio Mute";
            break;
        case EMCallStreamStatusVoiceResume:
            str = @"Audio Unmute";
            break;
        case EMCallStreamStatusVideoPause:
            str = @"Video Pause";
            break;
        case EMCallStreamStatusVideoResume:
            str = @"Video Resume";
            break;
            
        default:
            break;
    }
    
}


- (void)_startTimeTimer
{
    self.timeLength = 0;
    self.timeTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timeTimerAction:) userInfo:nil repeats:YES];
}

- (void)_stopTimeTimer
{
    if (self.timeTimer) {
        [self.timeTimer invalidate];
        self.timeTimer = nil;
    }
}

- (void)startHeartbeatTime {
    self.heartbeatTimer = [NSTimer scheduledTimerWithTimeInterval:30.0 target:self selector:@selector(heartbeatTimerAction:) userInfo:nil repeats:YES];
}
- (void)stopHeadtbeatTime {
    if (self.heartbeatTimer) {
        [self.heartbeatTimer invalidate];
        self.heartbeatTimer = nil;
    }
}
- (void)heartbeatTimerAction:(id)sender {
    NSLog(@"心跳时间");
    if (self.callSession.isCaller) {
        [self callPulseRequestWithType:@"0" huanxinNo:self.callSession.callId calledID:self.calledID];
    } else {
        NSArray *callIdArr = [self.callSession.callId componentsSeparatedByString:@"/"];
        NSLog(@"%@",callIdArr);
        if (kNotNil(callIdArr)) {
            [self callPulseRequestWithType:@"1" huanxinNo:callIdArr[3] calledID:[[XLBUser user].userModel.ID stringValue]];
        }
    }
}

- (void)timeTimerAction:(id)sender
{
    self.timeLength += 1;
    int hour = self.timeLength / 3600;
    int m = (self.timeLength - hour * 3600) / 60;
    int s = self.timeLength - hour * 3600 - m * 60;
    
    if (hour > 0) {
        self.timeLabel.text = [NSString stringWithFormat:@"%02d:%02d:%02d", hour, m, s];
    }
    else if(m > 0){
        self.timeLabel.text = [NSString stringWithFormat:@"%02d:%02d", m, s];
    }
    else{
        self.timeLabel.text = [NSString stringWithFormat:@"00:%02d", s];
    }
}
#pragma mark - private ring

- (void)_beginRing
{
    [self.ringPlayer stop];
    
    NSString *musicPath = [[NSBundle mainBundle] pathForResource:@"xlb" ofType:@"wav"];
    NSURL *url = [[NSURL alloc] initFileURLWithPath:musicPath];
    
    self.ringPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
    [self.ringPlayer setVolume:1];
    self.ringPlayer.numberOfLoops = -1; //设置音乐播放次数  -1为一直循环
    if([self.ringPlayer prepareToPlay])
    {
        [self.ringPlayer play]; //播放
    }
}

- (void)_stopRing
{
    [self.ringPlayer stop];
}

//开始呼叫
- (void)stateToConnected {
}

//接通中
- (void)stateToAnswered {
    [self _stopRing];
    [self _startTimeTimer];
    [self startHeartbeatTime];
    self.timeLabel.hidden = NO;
    self.HangupBtn.hidden = NO;
    self.statusLabel.hidden = YES;
    self.rejectBtn.hidden = YES;
    self.answerBtn.hidden = YES;
    self.userImg.hidden = YES;
    self.remoteNameLabel.hidden = YES;
    self.callV.hidden = NO;
    self.calledV.hidden = NO;
    self.timeStatus.hidden = NO;
    self.handsFreeBtn.hidden = NO;
    self.silenceBtn.hidden = NO;
    self.minimumBtn.hidden = NO;
    
    if (self.callSession.isCaller) {
        [self callPayRequestWithType:@"0" huanXinNo:self.callSession.callId calledID:self.calledID];
    } else {
        NSArray *callIdArr = [self.callSession.callId componentsSeparatedByString:@"/"];
        if (kNotNil(callIdArr)) {
            [self callPayRequestWithType:@"1" huanXinNo:callIdArr[3] calledID:[[XLBUser user].userModel.ID stringValue]];
        }
    }
    
}
- (void)clearData {
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    [audioSession overrideOutputAudioPort:AVAudioSessionPortOverrideNone error:nil];
    [audioSession setActive:YES error:nil];
    
    self.callSession.remoteVideoView.hidden = YES;
    self.callSession.remoteVideoView = nil;
    _callSession = nil;
    
    [self _stopTimeTimer];
    [self stopHeadtbeatTime];
    [self _stopRing];
}


- (void)setSubViews {
    
    self.userBgImg = [UIImageView new];
    self.userBgImg.layer.masksToBounds = YES;
    self.userBgImg.contentMode = UIViewContentModeScaleAspectFill;
    [self.view addSubview:self.userBgImg];
    
    self.lineBgImg = [UIImageView new];
    self.lineBgImg.backgroundColor = [UIColor blackColor];
    self.lineBgImg.alpha = 0.5;
    [self.view addSubview:self.lineBgImg];
    
    
    self.userImg = [UIImageView new];
    self.userImg.layer.masksToBounds = YES;
    self.userImg.layer.cornerRadius = 50;
    [self.view addSubview:self.userImg];
    
    self.timeStatus = [UILabel new];
    self.timeStatus.text = @"通话时间";
    self.timeStatus.textColor = [UIColor whiteColor];
    self.timeStatus.font = [UIFont systemFontOfSize:18];
    self.timeStatus.hidden = YES;
    [self.view addSubview:self.timeStatus];
    
    
    self.timeLabel = [UILabel new];
    self.timeLabel.textAlignment = NSTextAlignmentCenter;
    self.timeLabel.textColor = [UIColor whiteColor];
    self.timeLabel.font = [UIFont systemFontOfSize:40];
    [self.view addSubview:self.timeLabel];
    
    self.callV = [UIView new];
    self.callV.backgroundColor = [UIColor textBlackColor];
    self.callV.alpha = 0.8;
    self.callV.hidden = YES;
    [self.view addSubview:self.callV];
    
    self.callEvaV = [XLBDEvaluateView new];
    [self.callEvaV setFont:7];
    [self.callEvaV setlHeight:12];
    [self.callEvaV setLwidth:15];
    [self.callEvaV setRadius:2];
    [self.callV addSubview:self.callEvaV];
    
    self.callNickeName = [UILabel new];
    self.callNickeName.textColor = [UIColor whiteColor];
    self.callNickeName.font = [UIFont systemFontOfSize:14];
    [self.callV addSubview:self.callNickeName];
    
    self.callImgV = [UIImageView new];
    self.callImgV.layer.masksToBounds = YES;
    self.callImgV.layer.cornerRadius = 30;
    [self.callV addSubview:self.callImgV];
    
    self.calledV = [UIView new];
    self.calledV.backgroundColor = [UIColor textBlackColor];
    self.calledV.alpha = 0.8;
    self.calledV.hidden = YES;
    [self.view addSubview:self.calledV];
    
    self.calledNickeName = [UILabel new];
    self.calledNickeName.textColor = [UIColor whiteColor];
    self.calledNickeName.font = [UIFont systemFontOfSize:14];
    [self.calledV addSubview:self.calledNickeName];
    
    self.calledEvaV = [XLBDEvaluateView new];
    [self.calledEvaV setFont:7];
    [self.calledEvaV setlHeight:12];
    [self.calledEvaV setLwidth:15];
    [self.calledEvaV setRadius:2];
    [self.calledV addSubview:self.calledEvaV];
    
    self.calledImgV = [UIImageView new];
    self.calledImgV.layer.masksToBounds = YES;
    self.calledImgV.layer.cornerRadius = 30;
    [self.calledV addSubview:self.calledImgV];
    
    
    self.remoteNameLabel = [UILabel new];
    self.remoteNameLabel.textAlignment = NSTextAlignmentCenter;
    self.remoteNameLabel.textColor = [UIColor whiteColor];
    self.remoteNameLabel.font = [UIFont systemFontOfSize:20];
    [self.view addSubview:self.remoteNameLabel];
    
    self.statusLabel = [UILabel new];
    self.statusLabel.textColor = [UIColor whiteColor];
    self.statusLabel.textAlignment = NSTextAlignmentCenter;
    self.statusLabel.font = [UIFont systemFontOfSize:15];
    [self.view addSubview:self.statusLabel];
    
    self.answerBtn = [UIButton new];
    [self.answerBtn setImage:[UIImage imageNamed:@"icon_th_jt"] forState:UIControlStateNormal];
    [self.answerBtn addTarget:self action:@selector(answerBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.answerBtn];
    
    
    self.rejectBtn = [UIButton new];
    [self.rejectBtn setImage:[UIImage imageNamed:@"icon_th_gd"] forState:UIControlStateNormal];
    [self.rejectBtn addTarget:self action:@selector(rejectBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.rejectBtn];
    
    self.HangupBtn = [UIButton new];
    [self.HangupBtn setImage:[UIImage imageNamed:@"icon_th_gd"] forState:UIControlStateNormal];
    [self.HangupBtn addTarget:self action:@selector(hangupBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.HangupBtn];
    
    self.minimumBtn = [UIButton new];
    [self.minimumBtn setImage:[UIImage imageNamed:@"icon_th_sx"] forState:UIControlStateNormal];
    [self.minimumBtn addTarget:self action:@selector(minimumBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:self.minimumBtn];
    
    self.handsFreeBtn = [UIButton new];
    [self.handsFreeBtn setImage:[UIImage imageNamed:@"icon_th_mt"] forState:UIControlStateNormal];
    [self.handsFreeBtn addTarget:self action:@selector(handsFreeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.handsFreeBtn];
    
    self.silenceBtn = [UIButton new];
    [self.silenceBtn setImage:[UIImage imageNamed:@"icon_th_ly"] forState:UIControlStateNormal];
    [self.silenceBtn addTarget:self action:@selector(silenceBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.silenceBtn];
    
    
    
    [self.userImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(100);
        make.width.height.mas_equalTo(100);
        make.centerX.mas_equalTo(self.view.mas_centerX).with.offset(0);
    }];
    
    
    [self.userBgImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.mas_equalTo(0);
    }];
    
    [self.lineBgImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.mas_equalTo(0);
    }];
    
    [self.timeStatus mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view.mas_top).with.offset(100);
        make.centerX.mas_equalTo(self.view.mas_centerX).with.offset(0);
    }];
    
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.timeStatus.mas_bottom).with.offset(10);
        make.left.right.mas_equalTo(0);
    }];
    
    [self.remoteNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.userImg.mas_bottom).with.offset(15);
        make.left.right.mas_equalTo(0);
        make.centerX.mas_equalTo(self.view.mas_centerX).with.offset(0);
    }];
    
    [self.callV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view.mas_top).with.offset(200);
        make.left.mas_equalTo(self.view.mas_left).with.offset(0);
        make.width.mas_equalTo(155);
        make.height.mas_equalTo(76);
    }];

    [self.callImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.callV.mas_centerY).with.offset(0);
        make.width.height.mas_equalTo(60);
        make.right.mas_equalTo(self.callV.mas_right).with.offset(-3);
    }];
    
    [self.callNickeName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.callV.mas_centerY).with.offset(-10);
        make.left.mas_equalTo(self.callV.mas_left).with.offset(5);
        make.right.mas_lessThanOrEqualTo(self.callImgV.mas_left).with.offset(-5);
    }];
    
    [self.callEvaV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.callNickeName.mas_bottom).with.offset(5);
        make.left.mas_equalTo(self.callNickeName.mas_left).with.offset(0);
        make.height.mas_equalTo(15);
    }];
    
    
    [self.calledV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.callV.mas_centerY).with.offset(0);
        make.right.mas_equalTo(self.view.mas_right).with.offset(0);
        make.width.mas_equalTo(self.callV.mas_width);
        make.height.mas_equalTo(self.callV.mas_height);
    }];
    
    [self.calledImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.calledV.mas_centerY).with.offset(0);
        make.width.height.mas_equalTo(60);
        make.left.mas_equalTo(self.calledV.mas_left).with.offset(3);
    }];
    
    [self.calledNickeName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.calledV.mas_centerY).with.offset(-10);
        make.right.mas_equalTo(self.calledV.mas_right).with.offset(-5);
//        make.left.mas_lessThanOrEqualTo(self.callImgV.mas_right).with.offset(5);
    }];
    
    [self.calledEvaV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.callNickeName.mas_bottom).with.offset(5);
        make.left.mas_equalTo(self.calledImgV.mas_right).with.offset(5);
        make.height.mas_equalTo(12);
    }];
    [self.callV layoutIfNeeded];
    [self.calledV layoutIfNeeded];
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.callV.bounds byRoundingCorners:UIRectCornerTopRight | UIRectCornerBottomRight cornerRadii:CGSizeMake(38, 38)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.callV.bounds;
    maskLayer.path = maskPath.CGPath;
    self.callV.layer.mask = maskLayer;
    
    UIBezierPath *maskPathed = [UIBezierPath bezierPathWithRoundedRect:self.calledV.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerBottomLeft cornerRadii:CGSizeMake(38, 38)];
    CAShapeLayer *maskLayered = [[CAShapeLayer alloc] init];
    maskLayered.frame = self.calledV.bounds;
    maskLayered.path = maskPathed.CGPath;
    self.calledV.layer.mask = maskLayered;
    
    [self.statusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.centerY.mas_equalTo(self.view.mas_centerY).with.offset(0);
        make.centerX.mas_equalTo(self.view.mas_centerX).with.offset(0);
    }];
    
    [self.HangupBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view.mas_centerX).with.offset(0);
        make.width.height.mas_equalTo(70);
        make.bottom.mas_equalTo(self.view.mas_bottom).with.offset(-74);
    }];
    
    [self.rejectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_left).with.offset(70);
        make.width.height.mas_equalTo(70);
        make.bottom.mas_equalTo(self.view.mas_bottom).with.offset(-74);
    }];
    
    [self.answerBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.view.mas_right).with.offset(-70);
        make.width.height.mas_equalTo(70);
        make.bottom.mas_equalTo(self.view.mas_bottom).with.offset(-74);
    }];
    
    [self.handsFreeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.HangupBtn.mas_left).with.offset(-54);
        make.centerY.mas_equalTo(self.HangupBtn.mas_centerY).with.offset(0);
        make.width.height.mas_equalTo(55);
    }];
    
    [self.silenceBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.HangupBtn.mas_right).with.offset(54);
        make.centerY.mas_equalTo(self.HangupBtn.mas_centerY).with.offset(0);
        make.width.height.mas_equalTo(55);
    }];
    
    [self.minimumBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view.mas_top).with.offset(30);
        make.right.mas_equalTo(self.view.mas_right).with.offset(-15);
        make.width.height.mas_equalTo(20);
    }];
    

    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
