//
//  XLBGroupDetailTableViewCell.h
//  xiaolaba
//
//  Created by 戴葛辉 on 2018/6/1.
//  Copyright © 2018年 jackzhang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <EaseUI/EaseUI.h>
#import "XLBGroupModel.h"
@interface XLBGroupDetailTableViewCell : UITableViewCell
@property (nonatomic, strong) UIImageView *rightImg;
@property (nonatomic, strong) UIImageView *img;
@property (nonatomic, strong) UILabel *announcement;
@property (nonatomic, strong) UILabel *subTitleLabel;
@property (nonatomic, strong) UISwitch *switchCell;

@property (nonatomic, strong) NSDictionary *dict;
@property (nonatomic, copy) NSString *announcementStr;
+ (NSString *)groupDetailCellID;

@end
