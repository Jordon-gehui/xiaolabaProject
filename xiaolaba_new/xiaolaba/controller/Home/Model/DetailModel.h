//
//  DetailModel.h
//  xiaolaba
//
//  Created by jackzhang on 2017/9/13.
//  Copyright © 2017年 jackzhang. All rights reserved.
//

#import <Foundation/Foundation.h>

@class DetailTwoModel;
@interface DetailModel : NSObject


@property (nonatomic, copy) NSString *avatar;//头像
@property (nonatomic, copy) NSString *userId;//
@property (nonatomic, copy) NSString *disc;//评论
@property (nonatomic, copy) NSString *nickName;//n昵称
@property (nonatomic, copy) NSString *time;//发布时间
@property (nonatomic, copy) NSString *likes;//点赞数



@end

@interface DetailTwoModel : NSObject

@property (nonatomic, copy) NSString *avatar;//头像
@property (nonatomic, copy) NSString *userId;//
@property (nonatomic, copy) NSString *disc;//评论
@property (nonatomic, copy) NSString *nickName;//n昵称
@property (nonatomic, copy) NSString *time;//发布时间

@end





