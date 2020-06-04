//
//  XLBCallingView.m
//  xiaolaba
//
//  Created by 戴葛辉 on 2018/5/3.
//  Copyright © 2018年 jackzhang. All rights reserved.
//

#import "XLBCallingView.h"
#import "XLBDEvaluateView.h"
#import <AVFoundation/AVFoundation.h>
#import "OwnerRequestManager.h"

NSString *const kHangUpNotification = @"kHangUpNotification";

NSString *const kAcceptNotification = @"kAcceptNotification";

NSString *const kSwitchCameraNotification = @"kSwitchCameraNotification";

NSString *const kMuteNotification = @"kMuteNotification";

NSString *const kVideoCaptureNotification = @"kVideoCaptureNotification";

#define kContainerH (144 * kiphone6_ScreenWidth)

#define kBtnWH (70 * kiphone6_ScreenWidth)



@interface XLBCallingView ()<XLBCallingSubViewsDelegate>

/** 背景头像 */
@property (nonatomic, strong) UIImageView *userBgImg;
/** 遮罩层 */
@property (nonatomic, strong) UIImageView *lineBgImg;
/** 通用头像 */
@property (nonatomic, strong) UIImageView *userImg;
/** 通用昵称 */
@property (nonatomic, strong) UILabel *nickName;
/** 连接状态，如等待对方接听...、对方已拒绝、语音电话、视频电话 */
@property (nonatomic, strong) UILabel *status;
/** 主叫背景 */
@property (nonatomic, strong) UIView *callBgV;
/** 主叫头像 */
@property (nonatomic, strong) UIImageView *callImgV;
/** 主叫昵称 */
@property (nonatomic, strong) UILabel *callNickName;
/** 主叫标签 */
@property (nonatomic, strong) XLBDEvaluateView *callSig;
/** 被叫背景 */
@property (nonatomic, strong) UIView *calledBgV;
/** 被叫头像 */
@property (nonatomic, strong) UIImageView *calledImgV;
/** 被叫昵称 */
@property (nonatomic, strong) UILabel *calledNickName;
/** 标签 */
@property (nonatomic, strong) XLBDEvaluateView *calledSig;
/** 时间文字 */
@property (nonatomic, strong) UILabel *timeStatusLabel;
/** 通话时长 */
@property (nonatomic, strong) UILabel *timeLabel;
/** 底部按钮容器视图 */
@property (nonatomic, strong) UIView *btnContainerView;
/** 挂断按钮 */
@property (nonatomic, strong) UIButton *hangupBtn;
/** 接听按钮 */
@property (nonatomic, strong) UIButton *answerBtn;



@property (strong, nonatomic) AVAudioPlayer *ringPlayer;
@property (strong, nonatomic) NSTimer *timeTimer;
@property (strong, nonatomic) NSTimer *heartbeatTimer;

/** 遮罩视图 */
@property (strong, nonatomic) UIView *coverView;
/** 动画用的layer */
@property (strong, nonatomic) CAShapeLayer *shapeLayer;

@end

@implementation XLBCallingView

- (instancetype)initWithIsCall:(BOOL)isCaller session:(EMCallSession *)session{
    self = [super initWithFrame:[UIScreen mainScreen].bounds];
    if (self) {
        self.isCall = isCaller;
        _callSession = session;
        self.clipsToBounds = YES;
        self.backgroundColor = [UIColor whiteColor];
        NSUserDefaults *userDefa = [NSUserDefaults standardUserDefaults];
        [userDefa setObject:session.callId forKey:@"callID"];
        [userDefa synchronize];
        [self setSubViews];
    }
    return self;
}

- (void)setSubViews {
    //是否是主叫方
    self.userBgImg.frame = self.frame;
    [self addSubview:_userBgImg];
    
    self.lineBgImg.frame = self.frame;
    self.lineBgImg.backgroundColor = [UIColor blackColor];
    [self addSubview:_lineBgImg];
    
    if (self.isCall) {
        [self initUIForAudioCaller];
        _isAnswered = YES;
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
    }else {
        [self initUIForAudioCallee];
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
    }
}
- (void)callPayRequestWithType:(NSString *)type huanXinNo:(NSString *)huanXinNo calledID:(NSString *)calledID{
    NSDictionary *dict = @{@"type":type,@"huanxinNo":huanXinNo,@"calledId":calledID,@"money":self.money,};
    [OwnerRequestManager requestCallPayWithParameter:dict success:^(id respones) {
        
    } error:^(id error) {
        
    }];
}

/**
 *  语音通话，主叫方UI初始化
 */
- (void)initUIForAudioCaller
{
    // 上面 通用部分
    [self initUIForTopCommonViews];
    // 下面底部 6按钮视图
//    [self initUIForBottomBtns];
    CGFloat centerX = self.center.x;
    self.hangupBtn.frame = CGRectMake(centerX - (kBtnWH / 2), 5, kBtnWH, kBtnWH);
    [self.btnContainerView addSubview:_hangupBtn];
    self.coverView.frame = self.frame;
    self.coverView.hidden = YES;
    [self addSubview:_coverView];
}


/**
 *  语音通话时，被呼叫方的UI初始化
 */
- (void)initUIForAudioCallee
{
    // 上面 通用部分
    [self initUIForTopCommonViews];
    CGFloat paddingX = (kSCREEN_WIDTH - kBtnWH * 2) / 3;
    self.hangupBtn.frame = CGRectMake(paddingX, 5, kBtnWH, kBtnWH);
    [self.btnContainerView addSubview:_hangupBtn];
    
    self.answerBtn.frame = CGRectMake(paddingX * 2 + kBtnWH, 5, kBtnWH, kBtnWH);
    [self.btnContainerView addSubview:_answerBtn];

    self.coverView.frame = self.frame;
    self.coverView.hidden = YES;
    [self addSubview:_coverView];
}

/**
 *  上半部分通用视图
 *  语音通话呼叫方、语音通话接收方、视频通话接收方上半部分视图布局都一样
 */
- (void)initUIForTopCommonViews
{
    CGFloat centerX = self.center.x;
    CGFloat centerY = self.center.y;
    
    CGFloat userImgWH = 100 * kiphone6_ScreenWidth;
    self.userImg.frame = CGRectMake(0, 0, userImgWH, userImgWH);
    self.userImg.center = CGPointMake(centerX, 140);
    self.userImg.layer.cornerRadius = userImgWH * 0.5;
    self.userImg.layer.masksToBounds = YES;
    [self addSubview:_userImg];
    
    self.nickName.frame = CGRectMake(0, 0, kSCREEN_WIDTH, 30);
    self.nickName.center = CGPointMake(centerX, CGRectGetMaxY(self.userImg.frame) + 15);
    self.nickName.text = self.nickNameStr ? :@"未知用户";
    [self addSubview:_nickName];
    
    self.status.frame = CGRectMake(0, 0, kSCREEN_WIDTH, 30);
    self.status.center = CGPointMake(centerX, centerY);
    self.status.text = @"正在等待对方接听";
    [self addSubview:_status];

    self.btnContainerView.frame = CGRectMake(0, kSCREEN_HEIGHT - kContainerH, kSCREEN_WIDTH, kContainerH);
    [self addSubview:_btnContainerView];
}

- (void)initUIForBottomBtns
{
    CGFloat paddingX = (self.frame.size.width - kBtnWH*3) / 4;
    
    self.hangupBtn.frame = CGRectMake(paddingX * 2 + kBtnWH, 5, kBtnWH, kBtnWH);
    [self.btnContainerView addSubview:_hangupBtn];
}

- (void)show {
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    if (self.isCall) {
        self.status.text = @"正在等待对方接受邀请...";
        [self callPayRequestWithType:@"0" huanXinNo:self.callSession.callId calledID:self.callID];
    } else{
        self.status.text = @"正在邀请你语音通话...";
        NSArray *callIdArr = [self.callSession.callId componentsSeparatedByString:@"/"];
        NSLog(@"%@",callIdArr);
        if (kNotNil(callIdArr)) {
            [self callPayRequestWithType:@"1" huanXinNo:callIdArr[3] calledID:[[XLBUser user].userModel.ID stringValue]];
        }
    }
    self.alpha = 0;
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 1;
    } completion:^(BOOL finished) {
        
    }];
}

- (void)dismiss {
    if (self.callSession.isCaller) {
        [self _stopRing];
    }
    [self.callingSubViews _stopTimeTimer];
    [self.callingSubViews stopHeadtbeatTime];
    [UIView animateWithDuration:0.5 animations:^{
        [self clearAllSubViews];
        self.callingSubViews = nil;
        if (self.microBtn) {
            [self.microBtn removeFromSuperview];
            self.microBtn = nil;
        }
        [self removeFromSuperview];
    }];
    
}
- (void)didSeletedAlipay {
    [self packupClick];
}
- (void)didSeletedCallingBtn:(UIButton *)sender time:(int)timeStr {
    switch (sender.tag) {
        case HangupBtnTag:{
            [self hangupClickWithTime:timeStr aReason:EMCallEndReasonHangup];
        }
            break;
        case MuteBtnTag:{
            sender.selected = !sender.selected;
            if (sender.selected) {
                [self.callSession pauseVoice];
                [sender setImage:[UIImage imageNamed:@"icon_th_jy_s"] forState:0];
            } else {
                [self.callSession resumeVoice];
                [sender setImage:[UIImage imageNamed:@"icon_th_jy_n"] forState:0];
            }
        }
            break;
        case LoudspeakerBtnTag:{
            AVAudioSession *audioSession = [AVAudioSession sharedInstance];
            if (sender.selected) {
                [audioSession overrideOutputAudioPort:AVAudioSessionPortOverrideNone error:nil];
                [sender setImage:[UIImage imageNamed:@"icon_th_mt"] forState:0];
            }else {
                [audioSession overrideOutputAudioPort:AVAudioSessionPortOverrideSpeaker error:nil];
                [sender setImage:[UIImage imageNamed:@"icon_th_mtg"] forState:0];
            }
            [audioSession setActive:YES error:nil];
            sender.selected = !sender.selected;
        }
            break;
        case PackupBtnTag:{
            sender.enabled = NO;
            self.microBtn.enabled = YES;
            [self packupClick];
        }
            break;
            
        default:
            break;
    }
}
- (void)hangupClick {
    if (self.isCall) {
        [self hangupClickWithTime:0 aReason:EMCallEndReasonHangup];
        [self emSendMessage];
//        [self dismiss];
        
    }else {
        [self hangupClickWithTime:0 aReason:EMCallEndReasonDecline];
//        [self dismiss];
    }
}

- (void)emSendMessage {
    NSString *text = @"xiaolaba已取消";
    EMTextMessageBody *body = [[EMTextMessageBody alloc] initWithText:text];
    NSString *fromStr = [EMClient sharedClient].currentUsername;
    EMMessage *message = [[EMMessage alloc] initWithConversationID:self.callID from:fromStr to:self.callID body:body ext:nil];
    message.chatType = EMChatTypeChat;
    [[EMClient sharedClient].chatManager sendMessage:message progress:nil completion:nil];
}

- (void)hangupClickWithTime:(int)time aReason:(EMCallEndReason)aReason {
    
    if (self.callSession) {
        [[XLBCallManager sharedManager] hangupCallWithReason:aReason callTime:time];
//        [self dismiss];
    }
}

- (void)answerClick {
//    [self _stopRing];
    [[XLBCallManager sharedManager] answerCall:self.callSession.callId];
}


- (void)connected {
    [self clearAllSubViews];
    [self addSubview:self.callingSubViews];
}

- (void)stateToConnected {
    if (self.callSession.isCaller) {
        [self _beginRing];
    }
}

- (void)stateToAnswered {
    if (self.callSession.isCaller) {
        [self _stopRing];
    }
    [self clearAllSubViews];
    [self addSubview:self.callingSubViews];
    [self.callingSubViews _startTimeTimer];
    [self.callingSubViews startHeartbeatTime];
}

- (void)setNetwork:(EMCallNetworkStatus)aStatus
{
    if (aStatus == EMCallNetworkStatusUnstable) {
        NSLog(@"网络不稳定");
    } else if (aStatus == EMCallNetworkStatusNoData) {
        NSLog(@"无数据");
        [[XLBCallManager sharedManager] hangupCallWithReason:EMCallEndReasonHangup callTime:self.callingSubViews.timeLength];
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


- (void)clearAllSubViews {
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    _userBgImg = nil;
    _nickName = nil;
    _status = nil;
    [self clearBottomViews];
    
    _coverView = nil;
}

- (void)clearBottomViews {
    _btnContainerView = nil;
    _hangupBtn = nil;
    _answerBtn = nil;
}

- (void)dealloc
{
    NSLog(@"%s",__func__);
    [self clearAllSubViews];
}
- (void)panAction:(UIPanGestureRecognizer *)recognizer {
    self.alpha = 0;
    CGPoint translationPoint = [recognizer translationInView:self.superview];
    CGPoint center = recognizer.view.center;
    recognizer.view.center = CGPointMake(center.x + translationPoint.x, center.y + translationPoint.y);
    [recognizer setTranslation:CGPointZero inView:self.superview];
    
}

- (void)packupClick
{
    // 1.获取动画缩放结束时的圆形
    UIBezierPath *endPath = [UIBezierPath bezierPathWithOvalInRect:self.userImg.frame];
    // 2.获取动画缩放开始时的圆形
    CGSize startSize = CGSizeMake(self.frame.size.width * 0.5, self.frame.size.height - self.userImg.center.y);
    CGFloat radius = sqrt(startSize.width * startSize.width + startSize.height * startSize.height);
    CGRect startRect = CGRectInset(self.userImg.frame, -radius, -radius);
    UIBezierPath *startPath = [UIBezierPath bezierPathWithOvalInRect:startRect];
    
    // 3.创建shapeLayer作为视图的遮罩
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.path = endPath.CGPath;
    self.layer.mask = shapeLayer;
    self.shapeLayer = shapeLayer;
    
    // 添加动画
    CABasicAnimation *pathAnimation = [CABasicAnimation animationWithKeyPath:@"path"];
    pathAnimation.fromValue = (id)startPath.CGPath;
    pathAnimation.toValue = (id)endPath.CGPath;
    pathAnimation.duration = 0.5;
    pathAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    pathAnimation.delegate = self;
    pathAnimation.removedOnCompletion = NO;
    pathAnimation.fillMode = kCAFillModeForwards;
    [shapeLayer addAnimation:pathAnimation forKey:@"packupAnimation"];
}

- (void)microClick
{
    self.microBtn.enabled = NO;
    self.callingSubViews.packupBtn.enabled = YES;
    self.alpha = 1.0;
    [self.microBtn removeFromSuperview];
    self.microBtn = nil;
    [UIView animateWithDuration:1.0 animations:^{
        self.center = self.userImg.center;
        self.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        self.bounds = [UIScreen mainScreen].bounds;
        self.frame = self.bounds;
        
        CAShapeLayer *shapeLayer = self.shapeLayer;
        
        // 1.获取动画缩放开始时的圆形
        UIBezierPath *startPath = [UIBezierPath bezierPathWithOvalInRect:self.userImg.frame];
        
        // 2.获取动画缩放结束时的圆形
        CGSize endSize = CGSizeMake(self.frame.size.width * 0.5, self.frame.size.height - self.userImg.center.y);
        CGFloat radius = sqrt(endSize.width * endSize.width + endSize.height * endSize.height);
        CGRect endRect = CGRectInset(self.userImg.frame, -radius, -radius);
        UIBezierPath *endPath = [UIBezierPath bezierPathWithOvalInRect:endRect];
        
        // 3.创建shapeLayer作为视图的遮罩
        shapeLayer.path = endPath.CGPath;
        
        // 添加动画
        CABasicAnimation *pathAnimation = [CABasicAnimation animationWithKeyPath:@"path"];
        pathAnimation.fromValue = (id)startPath.CGPath;
        pathAnimation.toValue = (id)endPath.CGPath;
        pathAnimation.duration = 0.5;
        pathAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        pathAnimation.delegate = self;
        pathAnimation.removedOnCompletion = NO;
        pathAnimation.fillMode = kCAFillModeForwards;
        [shapeLayer addAnimation:pathAnimation forKey:@"showAnimation"];
    }];
}

#pragma mark - CAAnimationDelegate
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    if ([anim isEqual:[self.shapeLayer animationForKey:@"packupAnimation"]]) {
        CGRect rect = self.frame;
        rect.origin = self.userImg.frame.origin;
        self.bounds = rect;
        rect.size = self.userImg.frame.size;
        self.frame = rect;
        
        [UIView animateWithDuration:1.0 animations:^{
            if (iPhoneX) {
                self.center = CGPointMake(kSCREEN_WIDTH - 50, kSCREEN_HEIGHT - 130);
            }else {
                self.center = CGPointMake(kSCREEN_WIDTH - 50, kSCREEN_HEIGHT - 100);
            }
            self.transform = CGAffineTransformMakeScale(0.5, 0.5);
            
        } completion:^(BOOL finished) {
            self.microBtn.frame = self.frame;
            self.microBtn.layer.cornerRadius = self.microBtn.bounds.size.width * 0.5;
            self.microBtn.layer.masksToBounds = YES;
            [self.superview addSubview:_microBtn];
        }];
    } else if ([anim isEqual:[self.shapeLayer animationForKey:@"showAnimation"]]) {
        self.layer.mask = nil;
        self.shapeLayer = nil;
    }
}


- (XLBCallingSubViews *)callingSubViews {
    if (!_callingSubViews) {
        _callingSubViews = [[XLBCallingSubViews alloc] initWithIsCall:self.isCall aSession:self.callSession];
        _callingSubViews.delegate = self;
    }
    return _callingSubViews;
}

- (UIImageView *)userBgImg {
    if (!_userBgImg) {
        _userBgImg = [UIImageView new];
        _userBgImg.layer.masksToBounds = YES;
        _userBgImg.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _userBgImg;
}

- (UIImageView *)lineBgImg {
    if (!_lineBgImg) {
        _lineBgImg = [UIImageView new];
        _lineBgImg.alpha = 0.5f;
    }
    return _lineBgImg;
}

- (UIImageView *)userImg {
    if (!_userImg) {
        _userImg = [UIImageView new];
    }
    return _userImg;
}

- (UILabel*)nickName
{
    if (!_nickName) {
        _nickName = [[UILabel alloc] init];
        _nickName.text = @"飞翔的昵称";
        _nickName.font = [UIFont systemFontOfSize:20.0f];
        _nickName.textColor = [UIColor whiteColor];
        _nickName.textAlignment = NSTextAlignmentCenter;
    }
    return _nickName;
}

- (UILabel*)status
{
    if (!_status) {
        _status = [[UILabel alloc] init];
        _status.text = @"等待对方接听...";
        _status.font = [UIFont systemFontOfSize:15.0f];
        _status.textColor = [UIColor whiteColor];
        _status.textAlignment = NSTextAlignmentCenter;
    }
    
    return _status;
}

- (UIView *)btnContainerView
{
    if (!_btnContainerView) {
        _btnContainerView = [[UIView alloc] init];
    }
    return _btnContainerView;
}

- (UIButton *)hangupBtn
{
    if (!_hangupBtn) {
        _hangupBtn = [[UIButton alloc] init];
        [_hangupBtn setBackgroundImage:[UIImage imageNamed:@"icon_th_gd"] forState:UIControlStateNormal];
        [_hangupBtn addTarget:self action:@selector(hangupClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _hangupBtn;
}

- (UIButton *)answerBtn
{
    if (!_answerBtn) {
        _answerBtn = [[UIButton alloc] init];
        [_answerBtn setBackgroundImage:[UIImage imageNamed:@"icon_th_jt"] forState:UIControlStateNormal];
        [_answerBtn addTarget:self action:@selector(answerClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _answerBtn;
}


- (UIButton *)microBtn
{
    if (!_microBtn) {
        
        UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panAction:)];
        _microBtn = [UIButton new];
        [_microBtn setTitleColor:[UIColor shadeStartColor] forState:UIControlStateNormal];
        [_microBtn setTitle:@"通话中" forState:UIControlStateNormal];
        _microBtn.titleLabel.font = [UIFont systemFontOfSize:12.0f];
        _microBtn.backgroundColor = [UIColor textBlackColor];
        [_microBtn addTarget:self action:@selector(microClick) forControlEvents:UIControlEventTouchUpInside];
        [_microBtn addGestureRecognizer:panGesture];
    }
    
    return _microBtn;
}


- (UIView *)coverView
{
    if (!_coverView) {
        _coverView = [[UIView alloc] init];
        _coverView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
    }
    
    return _coverView;
}

#pragma mark - property setter
- (void)setNickNameStr:(NSString *)nickNameStr {
    _nickNameStr = nickNameStr;
    self.nickName.text = nickNameStr;
    self.callingSubViews.nickNameStr = self.nickNameStr;
}
- (void)setCallImg:(NSString *)callImg {
    _callImg = callImg;
    self.callingSubViews.callImg = callImg;
    [self.userBgImg sd_setImageWithURL:[NSURL URLWithString:[JXutils judgeImageheader:callImg Withtype:IMGNormal]] placeholderImage:[UIImage imageNamed:@"weitouxiang"]];
    [self.userImg sd_setImageWithURL:[NSURL URLWithString:[JXutils judgeImageheader:callImg Withtype:IMGAvatar]] placeholderImage:[UIImage imageNamed:@"weitouxiang"]];
}
- (void)setCallID:(NSString *)callID {
    _callID = callID;
    self.callingSubViews.callID = callID;
}
- (void)setConnectText:(NSString *)connectText
{
    _connectText = connectText;
    self.status.text = connectText;
    [self.microBtn setTitle:connectText forState:UIControlStateNormal];
}

- (void)setIsAnswered:(BOOL)isAnswered
{
    _isAnswered = isAnswered;
    if (!self.isCall) {
        [self connected];
    }
}

- (void)setMoney:(NSString *)money {
    _money = money;
    
    self.callingSubViews.money = money;
}

@end
