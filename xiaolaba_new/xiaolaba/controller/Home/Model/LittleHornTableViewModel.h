//
//  LittleHornTableViewModel.h
//  xiaolaba
//
//  Created by jackzhang on 2017/9/12.
//  Copyright © 2017年 jackzhang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserTagsModel.h"
@class Imgs;

@interface LittleHornTableViewModel : NSObject


@property (nonatomic, copy) NSString *brandImg;
@property (nonatomic, copy) NSString *createUser;//用户ID
@property (nonatomic, copy) NSString *avatar;//头像
@property (nonatomic, copy) NSString *ID;//
@property (nonatomic, copy) NSString *nickName;//用户昵称
@property (nonatomic, copy) NSString *follows;//关注
@property (nonatomic, copy) NSString *publishDate;//发布时间
@property (nonatomic, copy) NSString *moment;//内容
@property (nonatomic, copy) NSString *shares;//分享数
@property (nonatomic, copy) NSString *location;//位置
@property (nonatomic, copy) NSString *likes;//点赞
@property (nonatomic, copy) NSString *views;//查看数
@property (nonatomic, copy) NSString *liked;//
@property (nonatomic, copy) NSString *createDate;
@property (nonatomic, copy) NSString *discussCount;//评论数
@property (nonatomic, copy) NSString *height;
@property (nonatomic, copy) NSString *width;

@property (nonatomic, strong) NSMutableArray<NSString *> *imgs;//动态图片数组

@property (nonatomic, strong) NSMutableArray<UserTagsModel *> *tags;//标签数组

@property (nonatomic, assign) CGFloat cellHeight;
@end

@interface Imgs : NSObject

@end
