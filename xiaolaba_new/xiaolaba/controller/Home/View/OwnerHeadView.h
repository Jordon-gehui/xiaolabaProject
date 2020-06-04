//
//  OwnerHeadView.h
//  xiaolaba
//
//  Created by 戴葛辉 on 2017/9/13.
//  Copyright © 2017年 jackzhang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XLBDEvaluateView.h"
#import "XLBOwnerModel.h"

@protocol OwnerHeadViewDelegate <NSObject>

@optional
- (void)showImage;

@end

@interface OwnerHeadView : UIView

@property (nonatomic, weak) id delegate;

@property (nonatomic, strong) UIButton *friendBtn;
@property (nonatomic, strong) UIButton *imgBtn;
@property (nonatomic, strong) UIButton *followBtn;
@property (nonatomic, strong) UIButton *portraitBtn;
@property (nonatomic, strong) UIImageView *ownerImg;
@property (nonatomic, strong) UIButton *praiseBtn;
@property (nonatomic, strong) UILabel *praiseCountLabel;

@property (nonatomic, strong) XLBOwnerModel *model;
@end
