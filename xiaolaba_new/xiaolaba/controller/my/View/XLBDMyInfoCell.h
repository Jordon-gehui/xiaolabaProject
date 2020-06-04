//
//  XLBDMyInfoCell.h
//  xiaolaba
//
//  Created by 戴葛辉 on 2017/9/6.
//  Copyright © 2017年 jxcode. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XLBUser.h"
@interface XLBDMyInfoCell : UITableViewCell
@property (nonatomic, strong) NSDictionary *keyValue;
@property (weak, nonatomic) IBOutlet UILabel *XLBTitle;

@property (weak, nonatomic) IBOutlet UILabel *XLBSubTitle;
@property (weak, nonatomic) IBOutlet UILabel *XLBAllTitle;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *XLBSubTitleHeight;

@property (nonatomic, strong) XLBUser *user;
@property (nonatomic, assign) NSInteger row;
@property (nonatomic, assign) NSInteger section;
@end
