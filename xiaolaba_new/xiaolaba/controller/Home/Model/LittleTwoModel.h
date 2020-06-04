//
//  LittleTwoModel.h
//  xiaolaba
//
//  Created by jackzhang on 2017/9/18.
//  Copyright © 2017年 jackzhang. All rights reserved.
//

#import <Foundation/Foundation.h>

@class LittleTwoDetailModel;
@interface LittleTwoModel : NSObject


@property (nonatomic, copy) NSString *avatar;//头像
@property (nonatomic, copy) NSString *userId;//
@property (nonatomic, copy) NSString *disc;//评论
@property (nonatomic, copy) NSString *nickName;//n昵称
@property (nonatomic, copy) NSString *time;//发布时间

@property (nonatomic, copy) NSString *id;//头像
@property (nonatomic, copy) NSString *momentId;
@property (nonatomic, copy) NSString *discussion;//


@end



@interface LittleTwoDetailModel : NSObject


@property (nonatomic, copy) NSString *avatar;//头像
@property (nonatomic, copy) NSString *userId;//
@property (nonatomic, copy) NSString *disc;//评论
@property (nonatomic, copy) NSString *nickName;//n昵称
@property (nonatomic, copy) NSString *time;//发布时间

@end

