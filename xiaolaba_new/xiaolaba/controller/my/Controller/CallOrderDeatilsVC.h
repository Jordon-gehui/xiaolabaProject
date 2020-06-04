//
//  CallOrderDeatilsVC.h
//  xiaolaba
//
//  Created by 斯陈 on 2018/3/30.
//  Copyright © 2018年 jackzhang. All rights reserved.
//

#import "BaseTablePage.h"
#import "CallOrderModel.h"

@interface CallOrderDeatilsVC : BaseTablePage
@property(nonatomic,assign) NSInteger isPlace;
@property(nonatomic,strong)CallOrderModel *orderModel;
@end
