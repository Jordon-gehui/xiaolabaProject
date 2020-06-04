//
//  XLBFllowFansViewController.h
//  xiaolaba
//
//  Created by lin on 2017/7/25.
//  Copyright © 2017年 jxcode. All rights reserved.
//

#import "BaseTablePage.h"
typedef NS_ENUM(NSUInteger, FllowFansType) {
    FllowFansTypeFllow = 0, // 关注
    FllowFansTypeFans // 粉丝
};

@interface XLBFllowFansViewController : BaseTablePage

- (instancetype)initWith:(FllowFansType )type;

@end
