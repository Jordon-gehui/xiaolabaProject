//
//  ReportChatCollectionViewCell.h
//  xiaolaba
//
//  Created by jackzhang on 2017/9/17.
//  Copyright © 2017年 jackzhang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ReportChatModel.h"

@interface ReportChatCollectionViewCell : UICollectionViewCell

@property (nonatomic,strong) UILabel *reportLable;
@property (nonatomic,strong) ReportChatModel *reportModel;

@property(nonatomic,assign)BOOL *isselected;


@end
