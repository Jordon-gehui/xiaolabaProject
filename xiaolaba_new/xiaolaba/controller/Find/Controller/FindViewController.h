//
//  FindViewController.h
//  xiaolaba
//
//  Created by 斯陈 on 2017/9/12.
//  Copyright © 2017年 jackzhang. All rights reserved.
//

#import "BaseTablePage.h"
#import "MessageNetWorking.h"
#import "ZLSwipeableView.h"

typedef NS_ENUM(NSInteger, HandleDirectionType) {
    HandleDirectionOn          = 0,
    HandleDirectionDown        = 1,
    HandleDirectionLeft        = 2,
    HandleDirectionRight       = 3,
};

@interface FindViewController : BaseTablePage

@property (nonatomic, strong) ZLSwipeableView *swipeableView;
- (UIView *)nextViewForSwipeableView:(ZLSwipeableView *)swipeableView;
@end
