//
//  MsgNoticeModel.h
//  xiaolaba
//
//  Created by 斯陈 on 2017/8/31.
//  Copyright © 2017年 jxcode. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MsgNoticeModel : NSObject

@property (nonatomic, copy) NSString *createDate;
@property (nonatomic, copy) NSString *friendId;
@property (nonatomic, copy) NSString *userId;
@property (nonatomic, copy) NSString *img;
@property (nonatomic, copy) NSString *message;
@property (nonatomic, copy) NSString *nickName;
@property (nonatomic, copy) NSString *parentId;
@property (nonatomic, copy) NSString *status;
@property (nonatomic, copy) NSString *uid;

@end


@interface NoticeNewsModel : NSObject

@property (nonatomic, copy) NSString *createDate;
@property (nonatomic, copy) NSString *summary;
@property (nonatomic, copy) NSString *type;


@end
