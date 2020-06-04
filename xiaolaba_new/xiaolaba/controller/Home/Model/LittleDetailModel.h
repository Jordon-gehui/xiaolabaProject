//
//  LittleDetailModel.h
//  xiaolaba
//
//  Created by jackzhang on 2017/9/14.
//  Copyright © 2017年 jackzhang. All rights reserved.
//

#import <Foundation/Foundation.h>
@class DiscussDiscussList;

@interface LittleDetailModel : NSObject

@property (nonatomic, copy) NSString *avatar;//头像
@property (nonatomic, copy) NSString *ID;//
@property (nonatomic, copy) NSString *nickName;//用户昵称
@property (nonatomic, copy) NSString *discussion;//评论
@property (nonatomic, copy) NSString *momentId;//查看数
@property (nonatomic, copy) NSString *likes;//查看数
@property (nonatomic, copy) NSString *liked;//
@property (nonatomic, copy) NSString *createUser;//





@property (nonatomic, strong) NSMutableArray<NSMutableArray *> *discussDiscussList;//动态图片数组

@end


@interface DiscussDiscussList : NSObject

@property (nonatomic, copy) NSString *avatar;//头像
@property (nonatomic, copy) NSString *userId;//
@property (nonatomic, copy) NSString *disc;//评论
@property (nonatomic, copy) NSString *nickName;//n昵称
@property (nonatomic, copy) NSString *time;//发布时间
@property (nonatomic, copy) NSString *momentId;//
@property (nonatomic, copy) NSString *discussId;//discussion
@property (nonatomic, copy) NSString *discussion;//





@end
