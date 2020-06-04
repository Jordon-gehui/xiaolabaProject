//
//  XLBFaceWallView.h
//  xiaolaba
//
//  Created by 戴葛辉 on 2017/12/25.
//  Copyright © 2017年 jackzhang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FaceListModel.h"
@protocol XLBFaceWallViewDelegate <NSObject>

- (void)loginBtnClick;
- (void)seletedRowWithFaceWallModel:(FaceWallListModel *)model rank:(NSInteger)rank;
@end

@interface XLBFaceWallView : UIView
@property (nonatomic, weak)id <XLBFaceWallViewDelegate>delegate;
@property (nonatomic, strong)UITableView *tableV;
@property (nonatomic, strong)UIButton *attentionBtn;
- (void)setFaceTableViewWithsource:(NSInteger)is_sy; //1 声优
- (void)loginOut;
- (instancetype)initWithFrame:(CGRect)frame withType:(NSInteger)type;
@end
