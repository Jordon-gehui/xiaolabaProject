//
//  XLBFriendModel.h
//  xiaolaba
//
//  Created by lin on 2017/8/10.
//  Copyright © 2017年 jxcode. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XLBFriendModel : NSObject

@property (nonatomic, strong) NSNumber *friendId; // 好友id
@property (nonatomic, strong) NSNumber *ID; // id
@property (nonatomic, copy) NSString *img; // 头像
@property (nonatomic, copy) NSString *nickname; // 昵称
@property (nonatomic, strong) NSNumber *status; // 状态0好友 1拉黑

@property (nonatomic, copy) NSString *temp;

@end
