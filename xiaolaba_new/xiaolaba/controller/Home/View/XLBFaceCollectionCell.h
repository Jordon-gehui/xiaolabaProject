//
//  XLBFaceCollectionCell.h
//  xiaolaba
//
//  Created by 戴葛辉 on 2017/12/23.
//  Copyright © 2017年 jackzhang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XLBDEvaluateView.h"
#import "FaceListModel.h"

@protocol XLBFaceCollectionCellDelegate <NSObject>


- (void)seletedItemWithFaceModel:(FaceListModel *)faceModel index:(NSInteger)index;

@end


@interface XLBFaceCollectionCell : UICollectionViewCell

@property (nonatomic, weak)id<XLBFaceCollectionCellDelegate>delegate;
@property (nonatomic, strong)XLBDEvaluateView *evaluateV;
@property (nonatomic, strong)FaceListModel *model;
@property (nonatomic, assign)NSInteger index;
+ (NSString *)faceCollectionCellID;
@end
