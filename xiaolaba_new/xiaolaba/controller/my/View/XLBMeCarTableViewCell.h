//
//  XLBMeCarTableViewCell.h
//  xiaolaba
//
//  Created by 戴葛辉 on 2017/10/27.
//  Copyright © 2017年 jackzhang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XLBMeCarTableViewCell : UITableViewCell


@property (nonatomic, strong) NSDictionary *meCarList;
@property (nonatomic, assign) NSIndexPath *indexPath;
+ (NSString *)cellMeCarID;
@end
