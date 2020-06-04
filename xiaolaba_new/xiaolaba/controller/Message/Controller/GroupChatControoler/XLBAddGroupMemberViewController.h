//
//  XLBAddGroupMemberViewController.h
//  xiaolaba
//
//  Created by 戴葛辉 on 2018/5/23.
//  Copyright © 2018年 jackzhang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SearchViewController.h"
#import <EaseUI/EaseUI.h>
#import "XLBGroupModel.h"
@interface XLBAddGroupMemberViewController : SearchViewController
@property (nonatomic, copy) NSString *titleStr;
@property (nonatomic, copy) NSString *type;
@property (nonatomic, strong) NSArray *menberList;
@property (nonatomic, strong) EMGroup *groupDetail;
@property (nonatomic, strong) XLBGroupModel *groupModel;
@end
