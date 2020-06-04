//
//  LittleDetailTwoViewController.h
//  xiaolaba
//
//  Created by jackzhang on 2017/9/14.
//  Copyright © 2017年 jackzhang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DetailModel.h"
#import "LittleDetailModel.h"

@interface LittleDetailTwoViewController : BaseViewController

@property (strong,nonatomic) LittleDetailModel *littleDetailModel;


@property (strong,nonatomic) DetailModel *detailLittleModel;


@property (copy,nonatomic) NSString *moreStr;
@property (copy,nonatomic) NSString *dissID;
@property (copy,nonatomic) NSString *momentID;
@property (nonatomic,assign)BOOL isNews;

@end
