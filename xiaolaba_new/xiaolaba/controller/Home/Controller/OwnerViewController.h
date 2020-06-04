//
//  OwnerPageViewController.h
//  xiaolaba
//
//  Created by 戴葛辉 on 2017/9/13.
//  Copyright © 2017年 jackzhang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseTablePage.h"
#import "XLBFllowFansModel.h"
@interface OwnerViewController : BaseTablePage


@property (nonatomic, copy)NSString *userID;

@property (nonatomic, assign) NSInteger delFlag; //扫描为1   非扫描为0

@property (nonatomic, copy) NSString  *owerTitle;

@end

