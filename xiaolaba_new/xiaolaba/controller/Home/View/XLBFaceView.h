//
//  XLBFaceView.h
//  xiaolaba
//
//  Created by 戴葛辉 on 2017/12/23.
//  Copyright © 2017年 jackzhang. All rights reserved.
//
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "FaceListModel.h"

@protocol XLBFaceViewDelegate <NSObject>

- (void)seletedItemWithFaceModel:(FaceListModel *)faceModel;
- (void)showBtnClick;
- (void)notLogin;
@end

@interface XLBFaceView : UIView
@property (nonatomic, weak) id<XLBFaceViewDelegate>delegate;
@property (nonatomic, strong) UICollectionView *faceCollection;
@property (nonatomic, strong) UIButton *showFaceBtn;
@property (nonatomic, strong) UIButton *manBtn;
@property (nonatomic, strong) UIButton *womanBtn;
@property (nonatomic, strong) UIButton *changeBtn;
@property (nonatomic, strong) NSMutableArray *data;


@end
