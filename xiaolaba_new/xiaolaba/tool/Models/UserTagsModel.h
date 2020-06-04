//
//  UserTagsModel.h
//  xiaolaba
//
//  Created by 斯陈 on 2017/11/22.
//  Copyright © 2017年 jackzhang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserTagsModel : NSObject

@property (nonatomic, copy) NSString *color;    // 背景色
@property (nonatomic, copy) NSString *label;    // 标签名
@property (nonatomic, copy) NSString *sort;     // 无用参数
@property (nonatomic, copy) NSString *type;     // 标签类型

@end


@interface UserAkiraModel : NSObject

@property (nonatomic, copy) NSString *img;
@property (nonatomic, strong) NSArray<NSString *>*imgs;
@property (nonatomic, copy) NSString *imgAkira;
@property (nonatomic, copy) NSString *imgStatus;
@property (nonatomic, copy) NSString *onlineType;
@property (nonatomic, copy) NSString *priceAkira;
@property (nonatomic, copy) NSString *status;
@property (nonatomic, copy) NSString *voiceAkira;
@property (nonatomic, copy) NSString *voiceStatus;
@property (nonatomic, copy) NSString *voiceTime;

@end

@interface UserAkiraCountModel : NSObject

@property (nonatomic, copy) NSString *connectNumber;
@property (nonatomic, copy) NSString *connectionRate;
@property (nonatomic, copy) NSString *conversationTime;
@property (nonatomic, copy) NSString *evaluateNumber;
@property (nonatomic, copy) NSString *praiseSum;
@property (nonatomic, copy) NSString *praiseRate;
@property (nonatomic, copy) NSString *totalNumber;

@end

@interface UserAkiraVisitorModel : NSObject

@property (nonatomic, copy) NSString *visitor;
@property (nonatomic, copy) NSString *img;
@property (nonatomic, copy) NSString *status;

@end

