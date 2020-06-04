//
//  XLBFaceWallTableViewCell.h
//  xiaolaba
//
//  Created by 戴葛辉 on 2017/12/26.
//  Copyright © 2017年 jackzhang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FaceListModel.h"
typedef NS_ENUM(NSInteger,RoundCornerType) {
    CellTypeTop,
    CellTypeBottom,
    CellTypeDefault,
    CellTypeAll
};
@interface XLBFaceWallTableViewCell : UITableViewCell

@property(nonatomic,readwrite,assign)RoundCornerType roundCornerType;

@property (nonatomic, strong) UIImageView *attentImg;

@property (nonatomic, strong)FaceWallListModel *model;
@property (nonatomic, assign)NSInteger index;
+ (NSString *)faceWallCellID;

+ (NSString *)faceWallCellIDVoice;
@end
