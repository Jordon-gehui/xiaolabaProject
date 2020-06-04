//
//  DetailImageView.h
//  xiaolaba
//
//  Created by jackzhang on 2017/9/18.
//  Copyright © 2017年 jackzhang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DetailImageModel.h"


@class DetailImageView;
@protocol DetailImageViewDelegate <NSObject>

@optional

- (void)likeBu:(DetailImageView*)likeBu;//头像

- (void)ownerImgBtnClickWithId:(NSString *)userId;

@end

@interface DetailImageView : UIView

@property (nonatomic,strong) UILabel *topLabel;//
@property (nonatomic,strong) UILabel *bottomLable;//

@property (nonatomic,strong) UIImageView *imageView;//

@property (nonatomic,strong) UIButton *ownerImgBtn;

@property (nonatomic,strong) DetailImageModel *imageModel;//

@property (nonatomic,strong) NSMutableArray *imageModelArr;//

@property (nonatomic,strong) NSMutableArray *twoArr;//

@property (nonatomic,strong) NSMutableArray *ownerArr;

@property (nonatomic,strong) UILabel *likeLable;//

@property (nonatomic,strong) UIButton *likeBu;//

@property (nonatomic, strong)UIButton *praiseBtn;

@property (nonatomic,weak)  id<DetailImageViewDelegate> delegate;


@property (nonatomic,strong) UILabel *countLable;//总数

@property (nonatomic,strong) UIImageView *countImageView;//

@property (strong,nonatomic) UILabel *nilTagsLabel;


@end
