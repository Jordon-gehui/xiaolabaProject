//
//  XLBPraseListCollectionViewCell.h
//  xiaolaba
//
//  Created by 戴葛辉 on 2017/12/16.
//  Copyright © 2017年 jackzhang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PraiseListModel.h"
@protocol XLBPraseListCollectionViewCellDelegate <NSObject>
- (void)checkUserImgWithImg:(UIImage *)img;

@end

@interface XLBPraseListCollectionViewCell : UICollectionViewCell

@property (nonatomic, weak)id <XLBPraseListCollectionViewCellDelegate>delegate;

@property (nonatomic, strong)PraiseListModel *model;
+ (NSString *)praiseCellID;
@end
