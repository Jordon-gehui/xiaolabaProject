//
//  XLBSystemMsgModel.h
//  xiaolaba
//
//  Created by lin on 2017/7/26.
//  Copyright © 2017年 jxcode. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XLBSystemMsgModel : NSObject
@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSString *createDate;
@property (nonatomic, copy) NSString *img;
@property (nonatomic, copy) NSString *nickname;
@property (nonatomic, copy) NSString *pushStatus;
@property (nonatomic, copy) NSString *readStatus;
@property (nonatomic, copy) NSString *remark;
@property (nonatomic, copy) NSString *summary;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *uid;
@property (nonatomic, copy) NSString *sysNewId;
@property (nonatomic, copy) NSString *initiatorId;
@property (nonatomic, copy) NSString *packageName;

@end
