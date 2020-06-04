//
//  XLBCallManager.m
//  xiaolaba
//
//  Created by 戴葛辉 on 2018/3/16.
//  Copyright © 2018年 jackzhang. All rights reserved.
//
#import "XLBCallManager.h"
#import "VoiceCallEndView.h"
#import "VoiceCallView.h"
#import "VoiceEndCallView.h"
#import "OwnerRequestManager.h"
#import "XLBCallingView.h"
static XLBCallManager *callManager = nil;

@interface XLBCallManager ()<EMChatManagerDelegate, EMCallManagerDelegate, EMCallBuilderDelegate>
{
    NSString * isCaller;
    NSString *voiceID;
}
@property (nonatomic, copy) NSString *messageID;

@property (nonatomic, copy) NSString *nickName;

@property (nonatomic, copy) NSString *avatar;

@property (nonatomic, copy) NSString *remarks;
//@property (nonatomic, copy) NSString *called;
//@property (nonatomic, copy) NSString *calledImg;

@property (nonatomic, copy) NSString *money;

@property (nonatomic, copy) NSString *userId;

@property (strong, nonatomic) NSObject *callLock;

@property (strong, nonatomic) NSTimer *timer;

@property (strong, nonatomic) EMCallSession *currentSession;

@property (strong, nonatomic) XLBCallingView *callingView;

@end
@implementation XLBCallManager

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self _initManager];
    }
    
    return self;
}

+ (instancetype)sharedManager
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        callManager = [[XLBCallManager alloc] init];
    });
    
    return callManager;
}

- (void)dealloc
{
    [[EMClient sharedClient].chatManager removeDelegate:self];
    [[EMClient sharedClient].callManager removeDelegate:self];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:KNOTIFICATION_CALL object:nil];
}


- (void)_initManager {
    _callLock = [[NSObject alloc] init];
    _currentSession = nil;
    [[EMClient sharedClient].chatManager addDelegate:self delegateQueue:nil];
    [[EMClient sharedClient].callManager addDelegate:self delegateQueue:nil];
    [[EMClient sharedClient].callManager setBuilderDelegate:self];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(makeCall:) name:KNOTIFICATION_CALL object:nil];

    NSString *file = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject stringByAppendingPathComponent:@"calloptions.data"];
    EMCallOptions *options = nil;
    if ([[NSFileManager defaultManager] fileExistsAtPath:file]) {
        options = [NSKeyedUnarchiver unarchiveObjectWithFile:file];
    } else {
        options = [[EMClient sharedClient].callManager getCallOptions];
        options.isSendPushIfOffline = YES;
        options.offlineMessageText = @"xiaolaba通话无人接听";
    }
    [[EMClient sharedClient].callManager setCallOptions:options];
}

#pragma mark - NSNotification

- (void)saveCallOptions
{
    NSString *file = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject stringByAppendingPathComponent:@"calloptions.data"];
    EMCallOptions *options = [[EMClient sharedClient].callManager getCallOptions];
    [NSKeyedArchiver archiveRootObject:options toFile:file];
}

- (void)makeCall:(NSNotification*)notify
{
    if (notify.object) {
        EMCallType type = (EMCallType)[[notify.object objectForKey:@"type"] integerValue];
        self.messageID = [notify.object valueForKey:@"chatter"];
        self.nickName = [notify.object valueForKey:@"nickName"];
        self.avatar = [notify.object valueForKey:@"userImg"];
        self.money = [notify.object valueForKey:@"money"];
        [self makeCallWithUsername:[notify.object valueForKey:@"chatter"] type:type];
    }
}

- (void)makeCallWithUsername:(NSString *)aUsername
                        type:(EMCallType)aType
{
    if ([aUsername length] == 0) {
        return;
    }
    
    __weak typeof(self) weakSelf = self;
    void (^completionBlock)(EMCallSession *, EMError *) = ^(EMCallSession *aCallSession, EMError *aError){
        XLBCallManager *strongSelf = weakSelf;
        if (strongSelf) {
            if (aError || aCallSession == nil) {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"不在线" message:aError.errorDescription delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil, nil];
                [alertView show];
                return;
            }
            
            @synchronized (self.callLock) {
                strongSelf.currentSession = aCallSession;
                strongSelf.callingView = [[XLBCallingView alloc] initWithIsCall:YES session:aCallSession];
                strongSelf.callingView.nickNameStr = strongSelf.nickName;
                strongSelf.callingView.callImg = strongSelf.avatar;
                strongSelf.callingView.callID = strongSelf.messageID;
                strongSelf.callingView.money = strongSelf.money;
                [strongSelf.callingView show];
                isCaller = @"2";
                voiceID = aCallSession.callId;
            }
            
            [self _startCallTimer];
        }
        else {
            [[EMClient sharedClient].callManager endCall:aCallSession.callId reason:EMCallEndReasonNoResponse];
        }
    };
    NSString *ext = [NSString stringWithFormat:@"%@,%@,%@,%@,",[XLBUser user].userModel.nickname,[XLBUser user].userModel.img,[XLBUser user].userModel.ID,self.money];
    [[EMClient sharedClient].callManager startCall:aType remoteName:aUsername ext:ext completion:^(EMCallSession *aCallSession, EMError *aError) {
        
        completionBlock(aCallSession, aError);
    }];
}

- (void)answerCall:(NSString *)aCallId
{
    if (!self.currentSession || ![self.currentSession.callId isEqualToString:aCallId]) {
        return ;
    }
    
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        EMError *error = [[EMClient sharedClient].callManager answerIncomingCall:weakSelf.currentSession.callId];
        
        if (error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (error.code == EMErrorNetworkUnavailable) {
                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"网络连接失败" delegate:nil cancelButtonTitle:NSLocalizedString(@"ok", @"OK") otherButtonTitles:nil, nil];
                    [alertView show];
                }
                else{
                    [weakSelf hangupCallWithReason:EMCallEndReasonFailed callTime:0];
                }
            });
        }
        
    });
}


- (void)_startCallTimer
{
    self.timer = [NSTimer scheduledTimerWithTimeInterval:50 target:self selector:@selector(_timeoutBeforeCallAnswered) userInfo:nil repeats:NO];
}

- (void)_stopCallTimer
{
    if (self.timer == nil) {
        return;
    }
    
    [self.timer invalidate];
    self.timer = nil;
}

- (void)_timeoutBeforeCallAnswered {
    [self hangupCallWithReason:EMCallEndReasonNoResponse callTime:0];
}

- (void)callEndRequestWithType:(NSString *)type callId:(NSString *)callId time:(NSString *)time remarks:(void (^)(id))remarks{

    [OwnerRequestManager requestCallEndWithParameter:@{@"type":type,@"huanxinNo":callId,@"calledId":self.messageID ? self.messageID:[XLBUser user].userModel.ID,@"huanxinTime":time,} success:^(id respones) {
            self.remarks = [NSString stringWithFormat:@"%@",respones[@"remarks"]];
            remarks(self.remarks);
        } error:^(id error) {
            self.remarks = @"0";
            remarks(self.remarks);
        }];
}
-(void)showCallendView:(NSString*)time {
    self.currentSession = nil;
    UIWindow *winde = [UIApplication sharedApplication].keyWindow;
    [UIView animateWithDuration:0.3 animations:^{
        [self.callingView dismiss];
    } completion:^(BOOL finished) {
        if ([[[XLBUser user].userModel.ID stringValue] isEqualToString:@"42327218134736896"] || [[[XLBUser user].userModel.ID stringValue] isEqualToString:@"22099512457715712"]) {
            if (kNotNil(time) && ![time isEqualToString:@"0"]) {
                if ([isCaller isEqualToString:@"2"]) {
                    //主叫方
                    VoiceCallEndView *end = [VoiceCallEndView new];
                    end.nickname = self.nickName;
                    end.img = self.avatar;
                    end.userId = self.messageID;
                    end.voiceCallId = voiceID;
                    [winde addSubview:end];
                }
                voiceID = @"";
            }
        }else {
            if (kNotNil(time) && ![time isEqualToString:@"0"]) {
                NSUserDefaults *userDe = [NSUserDefaults standardUserDefaults];
                [userDe removeObjectForKey:@"inTheCall"];
                [userDe synchronize];
                if ([isCaller isEqualToString:@"2"]) {
                    //主叫方
                    VoiceCallEndView *end = [VoiceCallEndView new];
                    end.nickname = self.nickName;
                    end.img = self.avatar;
                    end.userId = self.messageID;
                    end.voiceCallId = voiceID;
                    [winde addSubview:end];
                } else {
                    //被叫方
                    VoiceEndCallView *endCall = [VoiceEndCallView new];
                    endCall.money = self.remarks;
                    endCall.time = time;
                    [winde addSubview:endCall];
                }
                voiceID = @"";
            }
        }
        
    }];
    NSUserDefaults *userd = [NSUserDefaults standardUserDefaults];
    if (kNotNil([userd objectForKey:@"callID"])) {
        [userd removeObjectForKey:@"callID"];
    }
    [userd synchronize];
}
#pragma mark - EMChatManagerDelegate

- (void)cmdMessagesDidReceive:(NSArray *)aCmdMessages {
    for (EMMessage *message in aCmdMessages) {
        EMCmdMessageBody *cmdBody = (EMCmdMessageBody *)message.body;
        NSString *action = cmdBody.action;
        if ([action isEqualToString:@"inviteToJoinConference"]) {
            //            NSString *callId = [message.ext objectForKey:@"callId"];
        } else if ([action isEqualToString:@"__Call_ReqP2P_ConferencePattern"]) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"已转为会议模式" delegate:self cancelButtonTitle:NSLocalizedString(@"ok", @"OK") otherButtonTitles:nil, nil];
            [alertView show];
        }
    }
}

#pragma mark - EMCallManagerDelegate

- (void)callDidReceive:(EMCallSession *)aSession {
    NSLog(@"用户A拨打用户B，用户B会收到这个回调");
    if (!aSession || [aSession.callId length] == 0) {
        return ;
    }
    
    if ([EaseSDKHelper shareHelper].isShowingimagePicker) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"hideImagePicker" object:nil];
    }
    
    if(self.currentSession && self.currentSession.status != EMCallSessionStatusDisconnected){
        [[EMClient sharedClient].callManager endCall:aSession.callId reason:EMCallEndReasonBusy];
        return;
    }
    
    @synchronized (_callLock) {
        [self _startCallTimer];
        self.currentSession = aSession;
        isCaller = @"1";
        NSArray *arr = [aSession.ext componentsSeparatedByString:@","];
        self.callingView = [[XLBCallingView alloc] initWithIsCall:NO session:self.currentSession];
        self.callingView.nickNameStr = arr[0];
        self.callingView.callImg = arr[1];
        self.callingView.callID = arr[2];
        self.callingView.money = arr[3];
        [self.callingView show];
    }
}

- (void)callDidConnect:(EMCallSession *)aSession {
    NSLog(@"通话通道建立完成，用户A和用户B都会收到这个回调");
    if ([aSession.callId isEqualToString:self.currentSession.callId]) {
        [self.callingView stateToConnected];
    }
}

- (void)callDidAccept:(EMCallSession *)aSession {
    NSLog(@"用户B同意用户A拨打的通话后，用户A会收到这个回调");
    if ([aSession.callId isEqualToString:self.currentSession.callId]) {
        [self _stopCallTimer];
        [self.callingView stateToAnswered];
    }
}

- (void)callDidEnd:(EMCallSession *)aSession
            reason:(EMCallEndReason)aReason
             error:(EMError *)aError
{
    if ([aSession.callId isEqualToString:self.currentSession.callId]) {
        NSLog(@"%u",aSession.status);

        [self _stopCallTimer];
        @synchronized (_callLock) {
            NSString *time = [NSString stringWithFormat:@"%d",self.callingView.callingSubViews.timeLength];
            [self _clearCurrentCallViewAndDataWithTimeStr:time];
        }
        
        if (aReason != EMCallEndReasonHangup) {
            NSString *reasonStr = @"end";
            switch (aReason) {
                case EMCallEndReasonNoResponse:
                {
                    reasonStr = @"对方没有响应";
                }
                    break;
                case EMCallEndReasonDecline:
                {
                    reasonStr = @"拒接通话";
                }
                    break;
                case EMCallEndReasonBusy:
                {
                    reasonStr = @"正在通话中...";
                }
                    break;
                case EMCallEndReasonFailed:
                {
                    reasonStr = @"建立连接失败";
                }
                    break;
                case EMCallEndReasonUnsupported:
                {
                    reasonStr = @"功能不支持";
                }
                    break;
                case EMCallEndReasonRemoteOffline:
                {
                    reasonStr = @"对方不在线";
                }
                    break;
                default:
                    break;
            }
            
            if (aError) {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:aError.errorDescription delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alertView show];
            }else{
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:reasonStr delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alertView show];
            }
        }
    }
}

- (void)callStateDidChange:(EMCallSession *)aSession
                      type:(EMCallStreamingStatus)aType
{
    NSLog(@"用户A和用户B正在通话中，用户A中断或者继续数据流传输时，用户B会收到该回调");
    if ([aSession.callId isEqualToString:self.currentSession.callId]) {
        [self.callingView setStreamType:aType];
    }
}

- (void)callNetworkDidChange:(EMCallSession *)aSession
                      status:(EMCallNetworkStatus)aStatus
{
    NSLog(@"用户A和用户B正在通话中，用户A的网络状态出现不稳定，用户A会收到该回调");
    if ([aSession.callId isEqualToString:self.currentSession.callId]) {
        [self.callingView setNetwork:aStatus];
    }
}

#pragma mark - EMCallBuilderDelegate

- (void)callRemoteOffline:(NSString *)aRemoteName
{
    NSString *text = [[EMClient sharedClient].callManager getCallOptions].offlineMessageText;
    EMTextMessageBody *body = [[EMTextMessageBody alloc] initWithText:text];
    NSString *fromStr = [EMClient sharedClient].currentUsername;
    EMMessage *message = [[EMMessage alloc] initWithConversationID:aRemoteName from:fromStr to:aRemoteName body:body ext:@{@"em_apns_ext":@{@"em_push_title":text}}];
    message.chatType = EMChatTypeChat;
    
    [[EMClient sharedClient].chatManager sendMessage:message progress:nil completion:nil];
}

- (void)hangupCallWithReason:(EMCallEndReason)aReason callTime:(int)time {
    [self _stopCallTimer];
    if (self.currentSession) {
        [[EMClient sharedClient].callManager endCall:self.currentSession.callId reason:aReason];
    }
//    NSString *timeString = [NSString stringWithFormat:@"%d",time];
//    [self _clearCurrentCallViewAndDataWithTimeStr:timeString];
}

- (void)_clearCurrentCallViewAndDataWithTimeStr:(NSString *)timeStr {
    @synchronized (_callLock) {
        if (kNotNil(timeStr) && ![timeStr isEqualToString:@"0"]) {
            if (self.currentSession.isCaller) {
                isCaller = @"2";
                [self callEndRequestWithType:@"0" callId:self.currentSession.callId time:timeStr remarks:^(id remark) {
                    [self showCallendView:timeStr];
                    
                }];
            } else {
                isCaller = @"1";
                NSArray *callIdArr = [self.currentSession.callId componentsSeparatedByString:@"/"];
                NSLog(@"%@",callIdArr);
                if (kNotNil(callIdArr)) {
                    [self callEndRequestWithType:@"1" callId:callIdArr[3] time:timeStr remarks:^(id remark) {
                        [self showCallendView:timeStr];
                    }];
                }
            }
        }else {
            [self showCallendView:@"0"];
        }
    }
}

@end
