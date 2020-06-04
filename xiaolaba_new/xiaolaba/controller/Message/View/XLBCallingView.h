//
//  XLBCallingView.h
//  xiaolaba
//
//  Created by 戴葛辉 on 2018/5/3.
//  Copyright © 2018年 jackzhang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XLBCallManager.h"
#import "XLBCallingSubViews.h"


/* 挂断的通知，object 中附带参数
 @{
 @"isVideo":@(self.isVideo),     // 是否是视频通话
 @"isCaller":@(!self.callee),    // 是否是发起方挂断
 @"answered":@(self.answered)    // 通话是否已经接通
 }
 */
UIKIT_EXTERN NSString *const kHangUpNotification;

/* 接听按钮事件处理的通知，参数在object中，示例如下：
 @{
 @"isVideo":@(YES),      // 是否为视频通话
 @"audioAccept":@(YES)   // 是否为语音接听，音频通话和视频通话里的语音接听都是YES
 }
 */
UIKIT_EXTERN NSString *const kAcceptNotification;


/*  静音按钮事件通知, 静音之后，对方听不到自己这边的任何声音
 object 中的参数：
 @{@"isMute":@(self.muteBtn.selected)}
 */
UIKIT_EXTERN NSString *const kMuteNotification;


@interface XLBCallingView : UIView


/** 音频通话缩小后的按钮 */
@property (strong, nonatomic) UIButton *microBtn;

@property (nonatomic, strong) XLBCallingSubViews *callingSubViews;

@property (strong, nonatomic, readonly) EMCallSession *callSession;

@property (nonatomic, assign) BOOL isCall;

@property (nonatomic, assign) BOOL isAnswered;
/** 连接信息，如等待对方接听...、对方已拒绝、语音通话、视频通话 */
@property (copy, nonatomic) NSString *connectText;
/** 是否是被挂断 */
@property (assign, nonatomic) BOOL isHanged;

@property (nonatomic, copy) NSString *nickNameStr;

@property (nonatomic, copy) NSString *callImg;

@property (nonatomic, copy) NSString *callID;

@property (nonatomic, copy) NSString *money;

- (instancetype)initWithIsCall:(BOOL)isCaller session:(EMCallSession *)session;

- (void)show;

- (void)dismiss;

- (void)stateToConnected;

- (void)stateToAnswered;

- (void)setNetwork:(EMCallNetworkStatus)aStatus;

- (void)setStreamType:(EMCallStreamingStatus)aType;
@end
