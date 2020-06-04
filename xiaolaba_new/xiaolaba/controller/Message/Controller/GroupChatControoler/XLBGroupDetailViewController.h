//
//  XLBGroupDetailViewController.h
//  xiaolaba
//
//  Created by 戴葛辉 on 2018/6/1.
//  Copyright © 2018年 jackzhang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <EaseUI/EaseUI.h>
#import "XLBGroupModel.h"

@interface XLBGroupDetailViewController : BaseTablePage
@property (nonatomic, strong) EMGroup *groupDetail;
@property (nonatomic, strong) XLBGroupModel *model;
@property (nonatomic, copy) NSString *groupID;
@end
