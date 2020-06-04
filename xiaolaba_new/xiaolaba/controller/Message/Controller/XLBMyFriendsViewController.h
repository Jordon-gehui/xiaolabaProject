//
//  XLBMyFriendsViewController.h
//  xiaolaba
//
//  Created by lin on 2017/7/26.
//  Copyright © 2017年 jxcode. All rights reserved.
//

#import "SearchViewController.h"
#import <EaseUI/EaseUI.h>
@interface XLBMyFriendsViewController : SearchViewController

@property (nonatomic, assign)BOOL isMe;
@property (nonatomic, copy) NSString *type;
@property (nonatomic, strong) EMGroup *groupDetail;
@end
