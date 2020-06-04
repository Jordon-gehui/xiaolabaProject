//
//  LittleHeadView.h
//  xiaolaba
//
//  Created by jackzhang on 2017/9/12.
//  Copyright © 2017年 jackzhang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LittleHeadModel.h"
#import "SLCycleScrollView.h"
#import "ScroHeadView.h"

@interface LittleHeadView : UIView

@property (nonatomic,strong) SLCycleScrollView *csView;
@property (nonatomic,strong) UIImageView *imageView;
@property (nonatomic,strong) UIButton *leftButton;
@property (nonatomic,strong) UIButton *rightButton;
@property (nonatomic,strong) LittleHeadModel *headModel;


@property (nonatomic,strong) UIScrollView *scre;

@property (nonatomic,strong) UIView *scroHeadView;
@property (nonatomic,strong) UIImageView *scroImageView;
@property (nonatomic,strong) UILabel *scroImageLabel;
@property (nonatomic,strong) UIImageView *leftImageView;
@property (nonatomic,strong) UILabel *leftImageLabel;
@property (nonatomic,strong) UIImageView *rightImageView;
@property (nonatomic,strong) UILabel *rightImageLabel;



@end
