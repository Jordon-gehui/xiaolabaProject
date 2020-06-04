//
//  FriendModel.h
//  xiaolaba
//
//  Created by 斯陈 on 2018/1/16.
//  Copyright © 2018年 jackzhang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FriendModel : NSObject
@property (nonatomic, copy) NSString *img; // 头像
@property (nonatomic, copy) NSString *userId; // 用户id
@property (nonatomic, copy) NSString *nickname; // 昵称

//通讯录
@property (nonatomic, copy) NSString *name; // 通讯录备用名
@property (nonatomic, copy) NSString *friends;
@property (nonatomic, copy) NSString *account; //电话
@property (nonatomic, copy) NSString *createDate;

//微博
@property (nonatomic, copy) NSString *weiboId; //微博id
@property (nonatomic, copy) NSString *follows;


@end
