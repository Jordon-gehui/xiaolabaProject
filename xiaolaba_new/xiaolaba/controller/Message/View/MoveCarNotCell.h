//
//  MoveCarNotCell.h
//  xiaolaba
//
//  Created by 斯陈 on 2017/9/28.
//  Copyright © 2017年 jackzhang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XLBMoveRecordsModel.h"

@interface MoveCarNotCell : UITableViewCell

-(void)setViewData:(XLBMoveRecordsModel*)model;

+(NSString *)cellReuseIdentifier;
@end
