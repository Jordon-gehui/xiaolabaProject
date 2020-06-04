//
//  XLBMoveRecordsModel.h
//  xiaolaba
//
//  Created by lin on 2017/7/21.
//  Copyright © 2017年 jxcode. All rights reserved.
//


/**
 挪车记录模型
 */
@interface XLBMoveRecordsModel : NSObject

@property (nonatomic, copy) NSString *createDate; // 创建时间
@property (nonatomic, copy) NSString *createID; // id
@property (nonatomic, copy) NSString *img; // 头像
@property (nonatomic, copy) NSString *location; // 地址
@property (nonatomic, copy) NSString *message; // 消息
@property (nonatomic, copy) NSString *nickname; // 昵称
@property (nonatomic, strong) NSNumber *owner; // 所属人id
@property (nonatomic, copy) NSString *status; // 状态0等待帮助 1已完成
@property (nonatomic, copy) NSString *uid; //
@property (nonatomic, copy) NSString *updateDate; //
@property (nonatomic, copy) NSString *licensePlate; //
@property (nonatomic, copy) NSString *imgs;//
@property (nonatomic, copy) NSString *notice;
@property (nonatomic, copy) NSString *countdown;//
@property (nonatomic, copy) NSString *createUser;//
@property (nonatomic, copy) NSString *noticeDate;//
@property (nonatomic, copy) NSString *page;//
@property (nonatomic, copy) NSString *parentId;//
@property (nonatomic, copy) NSString *replys;//
@property (nonatomic, copy) NSString *updateUser;//
@property (nonatomic, copy) NSString *userId;//
@property (nonatomic, copy) NSString *app;//


@end
