//
//  XLBFllowFansCell.h
//  xiaolaba
//
//  Created by lin on 2017/7/25.
//  Copyright © 2017年 jxcode. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XLBFllowFansModel.h"

@interface XLBFllowFansCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *handle_button;

@property (nonatomic, strong) XLBFllowFansModel *model;
@property (nonatomic, assign) BOOL isFllow; // YES是关注cell NO是粉丝cell
@property (nonatomic, assign) NSInteger row;
@end
