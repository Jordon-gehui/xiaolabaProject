//
//  ScroHeadView.h
//  xiaolaba
//
//  Created by jackzhang on 2017/9/26.
//  Copyright © 2017年 jackzhang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ScroHeadModel.h"

@interface ScroHeadView : UIView

@property (nonatomic,strong) UIView *scroHeadView;
@property (nonatomic,strong) UIImageView *scroImageView;
@property (nonatomic,strong) UILabel *scroImageLabel;
@property (nonatomic,strong) UIImageView *leftImageView;
@property (nonatomic,strong) UILabel *leftImageLabel;
@property (nonatomic,strong) UIImageView *rightImageView;
@property (nonatomic,strong) UILabel *rightImageLabel;
@property (nonatomic,strong) ScroHeadModel *scroModel;
@property (nonatomic,strong) UIImageView *carImageView;

@property (nonatomic,strong) NSMutableArray *scroModelArr;

@property (nonatomic,strong) NSMutableArray *scroContentArr;
@property (nonatomic,strong) NSMutableArray *scroImgArr;
@property (nonatomic,strong) NSMutableArray *scroBrandImgArr;
@property (nonatomic) NSInteger index;

@end
