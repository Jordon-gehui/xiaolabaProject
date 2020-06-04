//
//  GroupMemberModel.h
//  xiaolaba
//
//  Created by 戴葛辉 on 2018/6/2.
//  Copyright © 2018年 jackzhang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GroupMemberModel : NSObject
@property (nonatomic, copy) NSString *img; // 头像
@property (nonatomic, copy) NSString *membersId; // 用户id
@property (nonatomic, copy) NSString *membersName; // 昵称
@property (nonatomic, copy) NSString *isAdmin;
@property (nonatomic, copy) NSString *type;
@property (nonatomic, copy) NSString *status;
@property (nonatomic, copy) NSString *disturb;
@end
