//
//  EMCallViewController.h
//  xiaolaba
//
//  Created by 戴葛辉 on 2018/3/16.
//  Copyright © 2018年 jackzhang. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "XLBCallManager.h"
@interface EMCallViewController : UIViewController

@property (strong, nonatomic, readonly) EMCallSession *callSession;

@property (copy, nonatomic) NSString *money;
@property (copy, nonatomic) NSString *nickName;

@property (copy, nonatomic) NSString *avatar;

@property (copy, nonatomic) NSString *called;
@property (copy, nonatomic) NSString *calledID;
@property (copy, nonatomic) NSString *calledImg;

@property (copy, nonatomic) NSString *userId;

@property (nonatomic) int timeLength;


@property (nonatomic) BOOL isDismissing;

- (instancetype)initWithCallSession:(EMCallSession *)aCallSession;

- (void)stateToConnected;

- (void)stateToAnswered;

- (void)setNetwork:(EMCallNetworkStatus)aStatus;

- (void)setStreamType:(EMCallStreamingStatus)aType;

- (void)clearData;
@end
