//
//  XLBMessageCell.h
//  xiaolaba
//
//  Created by lin on 2017/7/20.
//  Copyright © 2017年 jxcode. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XLBSessionModel.h"

@interface XLBMessageCell : UITableViewCell

@property (nonatomic, strong) NSDictionary *data;
@property (nonatomic, strong) XLBSessionModel *model;


-(void)setShowType:(NSString*)type;
@end
