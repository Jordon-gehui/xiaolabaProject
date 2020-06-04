//
//  XLBCallingSubViews.h
//  xiaolaba
//
//  Created by 戴葛辉 on 2018/5/4.
//  Copyright © 2018年 jackzhang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XLBCallManager.h"

typedef NS_ENUM(NSUInteger, CallingBtnTag) {
    HangupBtnTag = 1000,
    MuteBtnTag,
    LoudspeakerBtnTag,
    PackupBtnTag,
    
};

@protocol XLBCallingSubViewsDelegate<NSObject>

- (void)didSeletedCallingBtn:(UIButton *)sender time:(int)timeStr;
- (void)didSeletedAlipay;
@end

@interface XLBCallingSubViews : UIView


- (instancetype)initWithIsCall:(BOOL)isCaller aSession:(EMCallSession *)session;
@property (weak, nonatomic) id<XLBCallingSubViewsDelegate>delegate;

/** 收起按钮 */
@property (nonatomic, strong) UIButton *packupBtn;

@property (strong, nonatomic, readonly) EMCallSession *callSession;

@property (nonatomic) int timeLength;

@property (nonatomic, assign) BOOL isCall;

@property (nonatomic, copy) NSString *nickNameStr;

@property (nonatomic, copy) NSString *callImg;

@property (nonatomic, copy) NSString *callID;

@property (nonatomic, copy) NSString *money;

- (void)_startTimeTimer;

- (void)_stopTimeTimer;

- (void)startHeartbeatTime;

- (void)stopHeadtbeatTime;

@end
