//
//  XLBMsgNotifitionModel.h
//  xiaolaba
//
//  Created by lin on 2017/7/26.
//  Copyright © 2017年 jxcode. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XLBMsgNotifitionModel : NSObject

@property (nonatomic, copy) NSString *image;
@property (nonatomic, copy) NSString *messageid;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *nickname;
@property (nonatomic, copy) NSString *subtitle;

/**
 状态
 0：添加好友
 1：等待验证
 2：已添加
 */
@property (nonatomic, assign) NSUInteger status;

@end
