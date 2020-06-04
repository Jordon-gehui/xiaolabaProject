//
//  XLBMyInfoSubShowViewController.h
//  xiaolaba
//
//  Created by 戴葛辉 on 2017/9/7.
//  Copyright © 2017年 jxcode. All rights reserved.
//

#import "BaseViewController.h"

@protocol XLBMyInfoSubShowViewControllerDelegate <NSObject>

@optional
- (void)saveSuccessClick;

@end


@interface XLBMyInfoSubShowViewController : BaseViewController
@property (weak, nonatomic) IBOutlet UITableView *meTable;
@property (nonatomic, strong) XLBUser *editUser;
@property (nonatomic, weak) id <XLBMyInfoSubShowViewControllerDelegate>delegate;
@end
