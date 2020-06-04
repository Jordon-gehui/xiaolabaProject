//
//  MsgSystemImgCell.h
//  xiaolaba
//
//  Created by 戴葛辉 on 2017/12/29.
//  Copyright © 2017年 jackzhang. All rights reserved.
//
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

#import "XLBSystemMsgModel.h"

@interface MsgSystemImgCell : UITableViewCell

@property (nonatomic, strong)XLBSystemMsgModel *model;
+ (NSString *)msgSystemImgCellID;
@end
