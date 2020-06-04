//
//  XLBCompleteViewController.h
//  xiaolaba
//
//  Created by lin on 2017/7/11.
//  Copyright © 2017年 jxcode. All rights reserved.
//

#import "BaseViewController.h"

@protocol XLBCompleteViewControllerDelegate <NSObject>

@optional

- (void)completeBtnClick:(XLBUser *)user;

@end

@interface XLBCompleteViewController : BaseViewController
@property (nonatomic, strong) UIButton *rightItem;
@property (nonatomic, copy) NSString *rightItemTag;

@property (nonatomic, weak) id <XLBCompleteViewControllerDelegate>delegate;

@end
