//
//  NetMsgTablePage.h
//  xiaolaba
//
//  Created by 斯陈 on 2017/10/17.
//  Copyright © 2017年 jackzhang. All rights reserved.
//

#import "BaseTablePage.h"

@interface NetMsgTablePage : BaseTablePage

@property (nonatomic,copy)NSString *carId;
@property (nonatomic,copy)NSString *createUser;
@property (nonatomic, assign)BOOL isFinishMove;

@end
