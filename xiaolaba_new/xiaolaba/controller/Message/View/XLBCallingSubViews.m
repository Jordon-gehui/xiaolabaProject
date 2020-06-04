//
//  XLBCallingSubViews.m
//  xiaolaba
//
//  Created by 戴葛辉 on 2018/5/4.
//  Copyright © 2018年 jackzhang. All rights reserved.
//

#import "XLBCallingSubViews.h"
#import "XLBDEvaluateView.h"
#import "OwnerRequestManager.h"
#import <AVFoundation/AVFoundation.h>
#import "CallBackMusicView.h"
#import "MusicPlayerView.h"
#import <FSAudioStream.h>
#import "PlayingView.h"
@interface XLBCallingSubViews ()<UIAlertViewDelegate,CallBackMusicViewDelegate,MusicPlayerViewDelegate>
@property (strong,nonatomic)NSString *ispatern;
@property (strong,nonatomic)NSString *chooseIndex;

@property (strong, nonatomic) NSTimer *timeTimer;
@property (strong, nonatomic) NSTimer *heartbeatTimer;

/** 背景 */
@property (nonatomic, strong) UIImageView *bgImg;
/** 背景遮罩 */
@property (nonatomic, strong) UIImageView *lineImg;
/** 时间 */
@property (nonatomic, strong) UILabel *timeStatus;
/** 通话时长 */
@property (nonatomic, strong) UILabel *time;
/** 主叫背景 */
@property (nonatomic, strong) UIView *callBgV;
/** 主叫头像 */
@property (nonatomic, strong) UIImageView *callUserImg;
/** 主叫昵称 */
@property (nonatomic, strong) UILabel *callNickName;
/** 主叫标签 */
@property (nonatomic, strong) XLBDEvaluateView *callSig;
/** 被叫背景 */
@property (nonatomic, strong) UIView *calledBgV;
/** 被叫昵称 */
@property (nonatomic, strong) UILabel *calledNickName;
/** 被叫头像 */
@property (nonatomic, strong) UIImageView *calledImg;
/** 被叫标签 */
@property (nonatomic, strong) XLBDEvaluateView *calledSig;

@property (nonatomic ,strong) UIView *musicv;
@property(nonatomic,strong)UIImageView *musicImg;
@property(nonatomic,strong)PlayingView *playingV;
@property (nonatomic, strong) UILabel *musicNameL;
//添加音乐按钮
@property (nonatomic, strong) UIButton *addMusicBtn;

/** 静音按钮 */
@property (nonatomic, strong) UIButton *muteBtn;
/** 挂断按钮 */
@property (nonatomic, strong) UIButton *hangupBtn;
/** 扬声器按钮 */
@property (nonatomic, strong) UIButton *loudspeakerBtn;


@property (nonatomic, strong) CallBackMusicView *musicView;
@property (nonatomic, strong) MusicPlayerView *playerView;

@property (nonatomic, strong) NSArray *musicList;
@property (nonatomic, strong) FSAudioStream *audioStream;
@property (nonatomic, strong) NSMutableArray *songList;

@property (nonatomic, assign) BOOL playerViewisshow;
@property (assign, nonatomic) int count;
@end
#define TIMECOUNT 10

@implementation XLBCallingSubViews

- (instancetype)initWithIsCall:(BOOL)isCaller aSession:(EMCallSession *)session {
    self = [super initWithFrame:[UIScreen mainScreen].bounds];
    if (self) {
        _callSession = session;
        self.isCall = isCaller;
        [self setSubViews];
        [self loadMusicList];
    }
    return self;
}

-(void)loadMusicList {
    [[NetWorking network]POST:kCallMusic params:nil cache:nil success:^(id result) {
        self.musicList = result;
    } failure:^(NSString *description) {
        
    }];
}
- (void)_startTimeTimer {
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
        [self callPulseRequestWithType:@"0" huanxinNo:self.callSession.callId calledID:self.callID];
    } else {
        NSArray *callIdArr = [self.callSession.callId componentsSeparatedByString:@"/"];
        if (kNotNil(callIdArr)) {
            [self callPulseRequestWithType:@"1" huanxinNo:callIdArr[3] calledID:[[XLBUser user].userModel.ID stringValue]];
        }
    }
}

- (void)callPulseRequestWithType:(NSString *)type huanxinNo:(NSString *)huanxinNo calledID:(NSString *)calledID{
    NSDictionary *dict = @{@"type":type,@"huanxinNo":huanxinNo,@"calledId":calledID,};
    [OwnerRequestManager requestCallPulseWithParameter:dict success:^(id respones) {
        if ([[[XLBUser user].userModel.ID stringValue] isEqualToString:@"42327218134736896"] || [[[XLBUser user].userModel.ID stringValue] isEqualToString:@"22099512457715712"]) return ;
        NSString *status = respones[@"status"];
        NSString *surplusMoney = respones[@"money"];
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
        if (kNotNil(respones[@"songList"])) {
            NSArray *array = respones[@"songList"];
            if (array.count>0&&[[[array firstObject] objectForKey:@"status"] isEqualToString:@"1"]) {
                self.songList = respones[@"songList"];
                [self HttpLoadMusic];
            }
            
        }
    } error:^(id error) {
        
    }];
}
-(void)HttpLoadMusic{
    NSDictionary*dic = [self.songList objectAtIndex:0];
    self.audioStream.volume = [[dic objectForKey:@"songVolume"] floatValue];
    NSString *playing = [NSString stringWithFormat:@"%@",[dic objectForKey:@"playing"] ];
    if ([playing isEqualToString:@"-1"]) {
        [self.audioStream stop];
        [self.musicv setHidden:YES];
    }else{
        self.chooseIndex = playing;
        [self.musicv setHidden:NO];
        [self.audioStream playFromURL:[self getNetworkUrl:self.songList choose:[playing integerValue]]];
        [self.audioStream play];
    }

    if (self.callSession.isCaller) {
        [[NetWorking network]POST:kSongGet params:@{@"huanxinId":self.callSession.callId} cache:nil success:^(id result) {
            
        } failure:^(NSString *description) {
            
        }];
    }
    
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        if ([self.delegate respondsToSelector:@selector(didSeletedAlipay)]) {
            [self.delegate didSeletedAlipay];
        }
    }
}

- (void)stopCall {
    [self _stopTimeTimer];
    [self stopHeadtbeatTime];
    [[XLBCallManager sharedManager] hangupCallWithReason:EMCallEndReasonHangup callTime:self.timeLength];
}
- (void)timeTimerAction:(id)sender {
    self.timeLength += 1;
    int hour = self.timeLength / 3600;
    int m = (self.timeLength - hour * 3600) / 60;
    int s = self.timeLength - hour * 3600 - m * 60;
    if (hour > 0) {
        self.time.text = [NSString stringWithFormat:@"%02d:%02d:%02d", hour, m, s];
    }
    else if(m > 0){
        self.time.text = [NSString stringWithFormat:@"%02d:%02d", m, s];
    }
    else{
        self.time.text = [NSString stringWithFormat:@"00:%02d", s];
    }
}

- (void)callingBtnClick:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(didSeletedCallingBtn:time:)]) {
        [self.delegate didSeletedCallingBtn:sender time:self.timeLength];
    }
}

- (void)setSubViews {
    NSUserDefaults *userDe = [NSUserDefaults standardUserDefaults];
    [userDe setObject:@"inTheCall" forKey:@"inTheCall"];
    [userDe synchronize];
    self.ispatern = @"1";
    self.chooseIndex = @"0";
    self.bgImg = [UIImageView new];
    self.bgImg.layer.masksToBounds = YES;
    self.bgImg.contentMode = UIViewContentModeScaleAspectFill;
    self.bgImg.image = [UIImage imageNamed:@"weitouxiang"];
    [self addSubview:self.bgImg];
    
    self.lineImg = [UIImageView new];
    self.lineImg.backgroundColor = [UIColor blackColor];
    self.lineImg.alpha = 0.5;
    [self addSubview:self.lineImg];
    
//    self.timeStatus = [UILabel new];
//    self.timeStatus.text = @"通话时间";
//    self.timeStatus.textColor = [UIColor whiteColor];
//    self.timeStatus.textAlignment = NSTextAlignmentCenter;
//    self.timeStatus.font = [UIFont systemFontOfSize:18];
//    [self addSubview:self.timeStatus];
    
    self.time = [UILabel new];
    self.time.textAlignment = NSTextAlignmentCenter;
    self.time.textColor = [UIColor whiteColor];
    self.time.text = @"00:00";
    self.time.font = [UIFont systemFontOfSize:16];
    [self addSubview:self.time];
    
    self.callBgV = [UIView new];
    self.callBgV.backgroundColor = [UIColor textBlackColor];
    self.callBgV.alpha = 0.8;
    [self addSubview:self.callBgV];
    
    self.callSig = [XLBDEvaluateView new];
    [self.callSig setFont:7];
    [self.callSig setlHeight:12];
    [self.callSig setLwidth:15];
    [self.callSig setRadius:2];
    [self.callBgV addSubview:self.callSig];
    
    self.callNickName = [UILabel new];
    self.callNickName.textColor = [UIColor whiteColor];
    self.callNickName.font = [UIFont systemFontOfSize:14];
    self.callNickName.textAlignment = NSTextAlignmentRight;
    [self.callBgV addSubview:self.callNickName];
    
    self.callUserImg = [UIImageView new];
    self.callUserImg.layer.masksToBounds = YES;
    self.callUserImg.layer.cornerRadius = 32;
    self.callUserImg.image = [UIImage imageNamed:@"weitouxiang"];
    [self.callBgV addSubview:self.callUserImg];
    
    self.calledBgV = [UIView new];
    self.calledBgV.backgroundColor = [UIColor textBlackColor];
    self.calledBgV.alpha = 0.8;
    [self addSubview:self.calledBgV];
    
    self.calledNickName = [UILabel new];
    self.calledNickName.textColor = [UIColor whiteColor];
    self.calledNickName.font = [UIFont systemFontOfSize:14];
    self.calledNickName.textAlignment = NSTextAlignmentLeft;
    [self.calledBgV addSubview:self.calledNickName];
    
    self.calledSig = [XLBDEvaluateView new];
    [self.calledSig setFont:7];
    [self.calledSig setlHeight:12];
    [self.calledSig setLwidth:15];
    [self.calledSig setRadius:2];
    [self.calledBgV addSubview:self.calledSig];
    
    self.calledImg = [UIImageView new];
    self.calledImg.layer.masksToBounds = YES;
    self.calledImg.layer.cornerRadius = 32;
    [self.calledBgV addSubview:self.calledImg];
    
    self.hangupBtn = [UIButton new];
    [self.hangupBtn setImage:[UIImage imageNamed:@"icon_th_gd"] forState:UIControlStateNormal];
    self.hangupBtn.tag = HangupBtnTag;
    [self.hangupBtn addTarget:self action:@selector(callingBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.hangupBtn];
    
    self.packupBtn = [UIButton new];
    [self.packupBtn setImage:[UIImage imageNamed:@"icon_th_sx"] forState:UIControlStateNormal];
    self.packupBtn.tag = PackupBtnTag;
    [self.packupBtn addTarget:self action:@selector(callingBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.packupBtn setEnlargeEdge:10];
    [self addSubview:self.packupBtn];
    
    self.musicv = [UIView new];
    [self.musicv setHidden:YES];
    [self addSubview:self.musicv];
    if (!self.callSession.isCaller) {
        UITapGestureRecognizer *tap =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(addMusicBtnClick)];
        [self.musicv addGestureRecognizer:tap];
    }
    
    
    self.musicImg = [UIImageView new];
    self.musicImg.image =[UIImage imageNamed:@"icon_syth_byy"];
    [self.musicv addSubview:self.musicImg];

    self.musicNameL = [UILabel new];
    self.musicNameL.textColor = [UIColor whiteColor];
    self.musicNameL.font = [UIFont systemFontOfSize:14];
    self.musicNameL.textAlignment = NSTextAlignmentLeft;
    [self.musicv addSubview:self.musicNameL];
    self.playingV = [[PlayingView alloc]initWithSize:CGSizeMake(20, 15) lineWidth:3 lineColor:[UIColor whiteColor]];
    [self.musicv addSubview:self.playingV];
    
    self.addMusicBtn =[UIButton new];
    [self.addMusicBtn setTitle:@"点击添加背景音乐" forState:UIControlStateNormal];
    self.addMusicBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    self.addMusicBtn.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4];
    [self.addMusicBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.addMusicBtn.layer.borderWidth = 1;
    self.addMusicBtn.layer.borderColor = [[UIColor whiteColor] colorWithAlphaComponent:0.3].CGColor;
    self.addMusicBtn.layer.cornerRadius = 22;
    self.addMusicBtn.layer.masksToBounds =YES;
    [self.addMusicBtn addTarget:self action:@selector(addMusicBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.addMusicBtn];
    if (!self.callSession.isCaller) {
        [self.addMusicBtn setHidden:NO];
    }else{
        [self.addMusicBtn setHidden:YES];
    }
    
    self.loudspeakerBtn = [UIButton new];
    [self.loudspeakerBtn setImage:[UIImage imageNamed:@"icon_th_mt"] forState:UIControlStateNormal];
    self.loudspeakerBtn.tag = LoudspeakerBtnTag;
    [self.loudspeakerBtn addTarget:self action:@selector(callingBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.loudspeakerBtn];
    
    self.muteBtn = [UIButton new];
    [self.muteBtn setImage:[UIImage imageNamed:@"icon_th_jy_n"] forState:UIControlStateNormal];
    self.muteBtn.tag = MuteBtnTag;
    [self.muteBtn addTarget:self action:@selector(callingBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.muteBtn];
    
}
-(void)addMusicBtnClick {
    if (self.musicView.choseDataList.count ==0) {
        [self showMusicView];
    }else{
        [self.playerView setList:self.musicView.choseDataList];
        self.playerView.volume = self.audioStream.volume;
        self.playerView.isplay = self.audioStream.isPlaying;
        self.playerView.index = [self.chooseIndex integerValue];
        [self.playerView setSelect];
        [self.playerView showView];
        self.playerViewisshow = YES;
        [self performSelectorInBackground:@selector(timerThread) withObject:nil];
    }
}
- (void)timerThread {
    for (int i = TIMECOUNT; i >= 0 ; i--) {
        //切换到主线程中更新UI
        if (i ==0) {
            [self performSelectorOnMainThread:@selector(updateFirstBtn) withObject:nil waitUntilDone:YES];
        }
        sleep(1);
    }
}
- (void)updateFirstBtn {
    if (self.playerViewisshow ==YES) {
        NSString *songIds=@"";
        for (int i=0; i<self.musicView.choseDataList.count; i++) {
            NSDictionary *tempdic =[self.musicView.choseDataList objectAtIndex:i];
            if (i==self.musicView.choseDataList.count-1) {
                songIds = [NSString stringWithFormat:@"%@%@",songIds,[tempdic objectForKey:@"url"]];
                
            }else{
                songIds = [NSString stringWithFormat:@"%@%@,",songIds,[tempdic objectForKey:@"url"]];
            }
        }
        NSArray *callIdArr = [self.callSession.callId componentsSeparatedByString:@"/"];
        NSString *playing = self.chooseIndex;
        if (![self.audioStream isPlaying]) {
            playing = @"-1";
        }
        NSDictionary *params = @{@"huanxinId": callIdArr[3],
                                 @"playing":playing,
                                 @"songVolume":[NSString stringWithFormat:@"%.2lf",self.audioStream.volume],
                                 @"songIds":songIds,
                                 @"playMode":self.ispatern
                                 };
        NSLog(@"++++++++%@",params);
        [[NetWorking network]POST:kSongAdd params:params cache:nil success:^(id result) {
            
        } failure:^(NSString *description) {
            
        }];
        [self performSelectorInBackground:@selector(timerThread) withObject:nil];
    }
}

-(void)lastMusic:(MusicPlayerView*)musicView index:(NSInteger)index {
    self.chooseIndex = [NSString stringWithFormat:@"%li",index];
    NSLog(@"%@",self.chooseIndex);
    [self.audioStream playFromURL:[self getNetworkUrl:self.musicView.choseDataList choose:index]];
}
-(void)nextMusic:(MusicPlayerView*)musicView index:(NSInteger)index {
    self.chooseIndex = [NSString stringWithFormat:@"%li",index];
    NSLog(@"%@",self.chooseIndex);
    [self.audioStream playFromURL:[self getNetworkUrl:self.musicView.choseDataList choose:index]];
}
//音量
- (void)setMusicVolume:(MusicPlayerView*)musicView volume:(CGFloat)volume {
    self.audioStream.volume = volume;
}
//播放模式 yes 表示列表播放
- (void)patternMusic:(MusicPlayerView*)musicView pattern:(BOOL)isPattern {
    if (isPattern) {
        self.ispatern = @"1";
    }else{
        self.ispatern = @"0";
    }
}
- (void)isPlayMusic:(MusicPlayerView *)musicView isPlay:(BOOL)isPlay {
    if (!isPlay){
        [self.audioStream stop];
        [self.musicv setHidden:YES];
        [self.addMusicBtn setHidden:NO];
        [musicView.playBtn setImage:[UIImage imageNamed:@"icon_syth_bf"] forState:0];
    }else{
        [self.audioStream play];
        [self.musicv setHidden:NO];
        [self.addMusicBtn setHidden:YES];
        [musicView.playBtn setImage:[UIImage imageNamed:@"icon_syth_zt"] forState:0];
    }
}
//音乐播放器中点击添加音乐
-(void)addMusic:(MusicPlayerView *)musicView {
    [musicView closeView];
    [self performSelector:@selector(showMusicView) withObject:nil afterDelay:0.3];
}

-(void)showMusicView{
    self.musicView.musicList = self.musicList;
    [self.musicView showView];
}
-(void)closeMusic:(MusicPlayerView *)musicView {
    self.playerViewisshow = NO;
    NSString *songIds=@"";
    for (int i=0; i<self.musicView.choseDataList.count; i++) {
        NSDictionary *tempdic =[self.musicView.choseDataList objectAtIndex:i];
        if (i==self.musicView.choseDataList.count-1) {
            songIds = [NSString stringWithFormat:@"%@%@",songIds,[tempdic objectForKey:@"url"]];
            
        }else{
            songIds = [NSString stringWithFormat:@"%@%@,",songIds,[tempdic objectForKey:@"url"]];
        }
    }
    NSArray *callIdArr = [self.callSession.callId componentsSeparatedByString:@"/"];
    NSString *playing = self.chooseIndex;
    if (![self.audioStream isPlaying]) {
        playing = @"-1";
    }
    NSDictionary *params = @{@"huanxinId": callIdArr[3],
                             @"playing":playing,
                             @"songVolume":[NSString stringWithFormat:@"%.2lf",self.audioStream.volume],
                             @"songIds":songIds,
                             @"playMode":self.ispatern
                             };
    NSLog(@"++++++++%@",params);
    [[NetWorking network]POST:kSongAdd params:params cache:nil success:^(id result) {
        
    } failure:^(NSString *description) {
        
    }];
}
//添加音乐
-(void)addCallBackMusic:(CallBackMusicView *)musicView {
    self.audioStream.volume = 0.5;
    if (musicView.choseDataList.count>0) {
        [self.audioStream pause];
        [self.audioStream playFromURL:[self getNetworkUrl:musicView.choseDataList choose:0]];
        if (!self.audioStream.isPlaying) {
            [self.audioStream play];
        }
        [self.addMusicBtn setHidden:YES];
        [self.musicv setHidden:NO];
    }else{
        [self.addMusicBtn setHidden:NO];
        [self.musicv setHidden:YES];
        [self.audioStream pause];
    }
    NSString *songIds=@"";
    for (int i=0; i<self.musicView.choseDataList.count; i++) {
        NSDictionary *tempdic =[self.musicView.choseDataList objectAtIndex:i];
        if (i==self.musicView.choseDataList.count-1) {
            songIds = [NSString stringWithFormat:@"%@%@",songIds,[tempdic objectForKey:@"url"]];
            
        }else{
            songIds = [NSString stringWithFormat:@"%@%@,",songIds,[tempdic objectForKey:@"url"]];
        }
    }
    NSArray *callIdArr = [self.callSession.callId componentsSeparatedByString:@"/"];
    NSString *playing = self.chooseIndex;
    NSDictionary *params = @{@"huanxinId": callIdArr[3],
                             @"playing":playing,
                             @"songVolume":[NSString stringWithFormat:@"%.2lf",self.audioStream.volume],
                             @"songIds":songIds,
                             @"playMode":self.ispatern
                             };
    NSLog(@"==========%@",params);
    [[NetWorking network]POST:kSongAdd params:params cache:nil success:^(id result) {
        
    } failure:^(NSString *description) {
        
    }];
}
- (void)layoutSubviews {
    [self.bgImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.mas_equalTo(0);
    }];
    
    [self.lineImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.mas_equalTo(0);
    }];
    
    
//    [self.timeStatus mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(self.mas_top).with.offset(100);
//        make.centerX.mas_equalTo(self.mas_centerX).with.offset(0);
//        make.height.mas_equalTo(20);
//        make.left.right.mas_equalTo(0);
//    }];
    
    [self.time mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.hangupBtn.mas_bottom).with.offset(10);
        make.left.right.mas_equalTo(0);
    }];
    
    [self.callBgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_top).with.offset(160);
        make.left.mas_equalTo(self.mas_left).with.offset(0);
        make.width.mas_equalTo(155);
        make.height.mas_equalTo(76);
    }];
    
    [self.callUserImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.callBgV.mas_centerY).with.offset(0);
        make.width.height.mas_equalTo(64);
        make.right.mas_equalTo(self.callBgV.mas_right).with.offset(-6);
    }];
    
    [self.callNickName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.callBgV.mas_centerY).with.offset(-10);
        make.left.mas_equalTo(self.callBgV.mas_left).with.offset(5);
        make.right.mas_equalTo(self.callUserImg.mas_left).with.offset(-5);
    }];
    
    [self.callSig mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.callNickName.mas_bottom).with.offset(5);
        make.left.mas_equalTo(self.callNickName.mas_left).with.offset(0);
        make.height.mas_equalTo(15);
    }];
    
    [self.calledBgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.callBgV.mas_centerY).with.offset(0);
        make.right.mas_equalTo(self.mas_right).with.offset(0);
        make.width.mas_equalTo(self.callBgV.mas_width);
        make.height.mas_equalTo(self.callBgV.mas_height);
    }];
    
    [self.calledImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.calledBgV.mas_centerY).with.offset(0);
        make.width.height.mas_equalTo(64);
        make.left.mas_equalTo(self.calledBgV.mas_left).with.offset(6);
    }];
    
    [self.calledNickName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.calledBgV.mas_centerY).with.offset(-10);
        make.right.mas_equalTo(self.calledBgV.mas_right).with.offset(-5);
        make.left.mas_equalTo(self.calledImg.mas_right).with.offset(5);
    }];
    
    [self.calledSig mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.calledNickName.mas_bottom).with.offset(5);
        make.left.mas_equalTo(self.calledImg.mas_right).with.offset(5);
        make.height.mas_equalTo(12);
    }];
    [self.musicv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.addMusicBtn);
        make.left.right.mas_equalTo(self);
        make.height.mas_equalTo(44);
    }];
    [self.musicImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.musicNameL.mas_left).with.offset(-5);
        make.centerY.mas_equalTo(self.musicNameL);
        make.width.height.mas_equalTo(20);
    }];
    [self.musicNameL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(self.musicv);
        make.width.mas_lessThanOrEqualTo(kSCREEN_WIDTH-100);
    }];
    [self.playingV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.musicv);
        make.left.mas_equalTo(self.musicNameL.mas_right).with.offset(5);
        make.width.mas_equalTo(20);
        make.height.mas_equalTo(15);
    }];
    [self.addMusicBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.calledBgV.mas_bottom).with.offset(20);
        make.centerX.mas_equalTo(self.bgImg);
        make.height.mas_equalTo(44);
        make.width.mas_equalTo(190);
    }];
    [self.callBgV layoutIfNeeded];
    [self.calledBgV layoutIfNeeded];
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.callBgV.bounds byRoundingCorners:UIRectCornerTopRight | UIRectCornerBottomRight cornerRadii:CGSizeMake(38, 38)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.callBgV.bounds;
    maskLayer.path = maskPath.CGPath;
    self.callBgV.layer.mask = maskLayer;

    UIBezierPath *maskPathed = [UIBezierPath bezierPathWithRoundedRect:self.calledBgV.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerBottomLeft cornerRadii:CGSizeMake(38, 38)];
    CAShapeLayer *maskLayered = [[CAShapeLayer alloc] init];
    maskLayered.frame = self.calledBgV.bounds;
    maskLayered.path = maskPathed.CGPath;
    self.calledBgV.layer.mask = maskLayered;
    
    [self.hangupBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.mas_centerX).with.offset(0);
        make.width.height.mas_equalTo(70);
        make.bottom.mas_equalTo(self.mas_bottom).with.offset(-74);
    }];
    
    [self.loudspeakerBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.hangupBtn.mas_left).with.offset(-54);
        make.centerY.mas_equalTo(self.hangupBtn.mas_centerY).with.offset(0);
        make.width.height.mas_equalTo(55);
    }];
    
    
    [self.packupBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        if (iPhoneX) {
            make.top.mas_equalTo(self.mas_top).with.offset(50);
            make.right.mas_equalTo(self.mas_right).with.offset(-25);
        }else {
            make.top.mas_equalTo(self.mas_top).with.offset(40);
            make.right.mas_equalTo(self.mas_right).with.offset(-20);
        }
        make.width.height.mas_equalTo(20);
    }];
    
    [self.muteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.hangupBtn.mas_right).with.offset(54);
        make.centerY.mas_equalTo(self.hangupBtn.mas_centerY).with.offset(0);
        make.width.height.mas_equalTo(55);
    }];
    
}

- (void)setNickNameStr:(NSString *)nickNameStr {
    _nickNameStr = nickNameStr;
    self.callNickName.text = nickNameStr;
    self.calledNickName.text = [XLBUser user].userModel.nickname;
    NSLog(@"%@",self.callSession.remoteName);
}

- (void)setCallImg:(NSString *)callImg {
    _callImg = callImg;
    
    [self.callUserImg sd_setImageWithURL:[NSURL URLWithString:[JXutils judgeImageheader:callImg Withtype:IMGAvatar]] placeholderImage:[UIImage imageNamed:@"weitouxiang"]];
    [self.calledImg sd_setImageWithURL:[NSURL URLWithString:[JXutils judgeImageheader:[XLBUser user].userModel.img Withtype:IMGAvatar]] placeholderImage:[UIImage imageNamed:@"weitouxiang"]];
    [self.bgImg sd_setImageWithURL:[NSURL URLWithString:[JXutils judgeImageheader:callImg Withtype:IMGAvatar]] placeholderImage:[UIImage imageNamed:@"weitouxiang"]];
    
}
-(CallBackMusicView*)musicView {
    if (_musicView ==nil) {
        _musicView = [[CallBackMusicView alloc]init];
        [_musicView setDelegate:self];
        [self addSubview:_musicView];
    }
    return _musicView;
}
-(MusicPlayerView*)playerView {
    if (_playerView ==nil) {
        _playerView = [[MusicPlayerView alloc]init];
        [_playerView setDelegate:self];
        [self addSubview:_playerView];
    }
    return _playerView;
}
-(NSURL *)getNetworkUrl:(NSArray*)list choose:(NSInteger)index {
    NSDictionary *dic = [list objectAtIndex:index];
    if (self.callSession.isCaller) {
        self.musicNameL.text = [dic objectForKey:@"songName"];
        NSString *string = [NSString stringWithFormat:@"%@%@",kImagePrefix,[dic objectForKey:@"songUrl"]];
        NSURL *url = [NSURL URLWithString:string];
        return url;
    }else{
        self.musicNameL.text = [dic objectForKey:@"label"];
        NSString *string = [NSString stringWithFormat:@"%@%@",kImagePrefix,[dic objectForKey:@"url"]];
        NSURL *url = [NSURL URLWithString:string];
        return url;
    }
    
    
}
/**
 *  创建FSAudioStream对象
 *
 *  @return FSAudioStream对象
 */
-(FSAudioStream *)audioStream{
    if (!_audioStream) {
        //创建FSAudioStream对象
        _audioStream=[[FSAudioStream alloc]init];
        kWeakSelf(self)
        _audioStream.onFailure=^(FSAudioStreamError error,NSString *description){
            NSLog(@"播放过程中发生错误，错误信息：%@",description);
        };
        [_audioStream setVolume:0.5];//设置声音
        _audioStream.onCompletion=^(){
            //
            if (weakSelf.callSession.isCaller) {
                if (weakSelf.songList.count>0) {
                    if ([weakSelf.ispatern isEqualToString:@"1"]) {
                        NSInteger index = [weakSelf.chooseIndex integerValue];
                        if (index <weakSelf.songList.count-1) {
                            index ++;
                        }else{
                            index = 0;
                        }
                        weakSelf.chooseIndex = [NSString stringWithFormat:@"%li",index];
                        [weakSelf.audioStream playFromURL:[weakSelf getNetworkUrl:weakSelf.songList choose:index]];
                    }else{
                        [weakSelf.audioStream playFromURL:[weakSelf getNetworkUrl:weakSelf.songList choose:[weakSelf.chooseIndex integerValue]]];
                    }
                }
                
            }else{
                if ([weakSelf.ispatern isEqualToString:@"1"]) {
                    NSInteger index = [weakSelf.chooseIndex integerValue];
                    if (index <weakSelf.musicView.choseDataList.count-1) {
                        index ++;
                    }else{
                        index = 0;
                    }
                    weakSelf.chooseIndex = [NSString stringWithFormat:@"%li",index];
                    [weakSelf.audioStream playFromURL:[weakSelf getNetworkUrl:weakSelf.musicView.choseDataList choose:index]];
                }else{
                    [weakSelf.audioStream playFromURL:[weakSelf getNetworkUrl:weakSelf.musicView.choseDataList choose:[weakSelf.chooseIndex integerValue]]];
                }
            }
            
            NSLog(@"播放完成!");
        };
    }
    return _audioStream;
}
- (void)setCallID:(NSString *)callID {
    _callID = callID;
    NSDictionary *dict = @{@"createUser":callID};
    [OwnerRequestManager requestOwnerWithParameter:dict success:^(XLBOwnerModel *respones) {
        [self.callSig insertSign:respones.tags];
    } error:^(id error) {
        
    }];
    NSDictionary *par = @{@"createUser":[XLBUser user].userModel.ID,};
    [OwnerRequestManager requestOwnerWithParameter:par success:^(XLBOwnerModel *respones) {
        [self.calledSig insertSign:respones.tags];
    } error:^(id error) {
        
    }];
}
-(NSMutableArray*)songList {
    if (_songList==nil) {
        _songList = [NSMutableArray array];
    }
    return _songList;
}
- (void)setMoney:(NSString *)money {
    _money = money;
}

@end
