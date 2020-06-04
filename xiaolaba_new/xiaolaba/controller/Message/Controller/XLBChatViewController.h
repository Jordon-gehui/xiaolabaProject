//
//  XLBChatViewController.h
//  xiaolaba
//
//  Created by lin on 2017/7/26.
//  Copyright © 2017年 jxcode. All rights reserved.
//

#import <EaseUI/EaseUI.h>
#import "GiftView.h"

@interface XLBChatViewController : EaseMessageViewController

@property (nonatomic, copy) NSString *nickname;
@property (nonatomic, copy) NSString *avatar; // 对方头像
@property (nonatomic, copy) NSString *userId;
@property (nonatomic, assign)BOOL isMoveCar;
@property (nonatomic, assign)BOOL isFinishMove;
@end
