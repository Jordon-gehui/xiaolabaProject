//
//  XLBCallManager.h
//  xiaolaba
//
//  Created by 戴葛辉 on 2018/3/16.
//  Copyright © 2018年 jackzhang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Hyphenate/Hyphenate.h>
#import "EaseSDKHelper.h"

@class RootTabbarController;
@interface XLBCallManager : NSObject

@property (strong, nonatomic) RootTabbarController *mainController;


+ (instancetype)sharedManager;

- (void)saveCallOptions;

- (void)makeCallWithUsername:(NSString *)aUsername
                        type:(EMCallType)aType;

- (void)answerCall:(NSString *)aCallId;

//- (void)hangupCallWithReason:(EMCallEndReason)aReason withCallTime:(int)time;

- (void)hangupCallWithReason:(EMCallEndReason)aReason callTime:(int)time;

@end
