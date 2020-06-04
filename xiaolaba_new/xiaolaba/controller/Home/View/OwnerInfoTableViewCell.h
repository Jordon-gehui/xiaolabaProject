//
//  OwnerInfoTableViewCell.h
//  xiaolaba
//
//  Created by 戴葛辉 on 2017/9/14.
//  Copyright © 2017年 jackzhang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XLBOwnerModel.h"

@interface OwnerInfoTableViewCell : UITableViewCell


@property (nonatomic, strong) XLBOwnerModel *owner;

+ (NSString *)cellID;
@end
