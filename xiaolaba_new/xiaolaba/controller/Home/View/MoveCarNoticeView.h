//
//  MoveCarNoticeView.h
//  xiaolaba
//
//  Created by 戴葛辉 on 2017/9/17.
//  Copyright © 2017年 jackzhang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XLBMoveRecordsModel.h"
@interface MoveCarNoticeView : UIView
@property (nonatomic, strong)NSArray *imageArray;
@property (nonatomic, strong)UIButton *chatBtn;
@property (nonatomic, strong)UIButton *ownerBtn;

-(void) setDateDic:(NSDictionary *)dic;

//挪车记录

@property (nonatomic, assign) BOOL isMoveCar;

@property (nonatomic, strong) XLBMoveRecordsModel *model;

@end
