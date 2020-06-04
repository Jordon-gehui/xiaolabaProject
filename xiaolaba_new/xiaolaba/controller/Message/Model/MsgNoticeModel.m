//
//  MsgNoticeModel.m
//  xiaolaba
//
//  Created by 斯陈 on 2017/8/31.
//  Copyright © 2017年 jxcode. All rights reserved.
//

#import "MsgNoticeModel.h"

@implementation MsgNoticeModel

+(NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{
             @"createDate":@"createDate",
             @"friendId":@"friendId",
             @"userId":@"id",
             @"img":@"img",
             @"message":@"message",
             @"nickName":@"nickname",
             @"status":@"status",
             @"uid":@"uid",
             };
}



@end


@implementation NoticeNewsModel



@end
