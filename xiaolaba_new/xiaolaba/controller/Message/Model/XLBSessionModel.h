//
//  XLBSessionModel.h
//  xiaolaba
//
//  Created by lin on 2017/8/16.
//  Copyright © 2017年 jxcode. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XLBSessionModel : NSObject

@property (nonatomic, strong) NSIndexPath *indexPath;
@property (nonatomic, copy) NSString *em_id; // id
@property (nonatomic, copy) NSString *em_nickname; // 昵称
@property (nonatomic, copy) NSString *em_lastMsg; // 最后一条消息
@property (nonatomic, copy) NSString *em_avatar; // 头像
@property (nonatomic, copy) NSString *em_unRead; // 未读消息数
@property (nonatomic, copy) NSString *em_time; // 最后一条消息时间
@property (nonatomic, copy) NSString *em_date; //最后一条消息时间戳
@property (nonatomic, copy) NSString *messageID;
@property (nonatomic, copy) NSString *type;
@end
