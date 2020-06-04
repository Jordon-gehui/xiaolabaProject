//
//  XLBOwnerView.m
//  xiaolaba
//
//  Created by 戴葛辉 on 2017/11/21.
//  Copyright © 2017年 jackzhang. All rights reserved.
//

#import "XLBOwnerView.h"
#import "XLBDEvaluateView.h"

@interface XLBOwnerView ()

@property (nonatomic, strong) UIImageView *ownerImg;
@property (nonatomic, strong) XLBDEvaluateView *devaluatV;
@property (nonatomic, strong) UILabel *nickName;
@property (nonatomic, strong) UILabel *content;

@end

@implementation XLBOwnerView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setSubViews];
        self.backgroundColor = [UIColor whiteColor];
        self.layer.masksToBounds = YES;
        self.layer.cornerRadius = 10;
    }
    return self;
}

- (void)setSubViews {
    
    self.ownerImg = [UIImageView new];
    [self.ownerImg sd_setImageWithURL:[NSURL URLWithString:[JXutils judgeImageheader:[XLBUser user].userModel.img Withtype:IMGNormal]] placeholderImage:[UIImage imageNamed:@"pic_m"]];
    [self addSubview:self.ownerImg];
    
    [self.ownerImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.mas_equalTo(0);
        make.height.mas_equalTo(80);
        
    }];
    
    self.nickName = [UILabel new];
    self.nickName.textColor = [UIColor textBlackColor];
    self.nickName.text = [XLBUser user].userModel.nickname;
    [self addSubview:self.nickName];
    
    [self.nickName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(self.ownerImg.mas_bottom).with.offset(0);
    }];
    
    XLBDEvaluateView *evaluate_view = [XLBDEvaluateView new];
    [evaluate_view insertSign:[XLBUser user].userModel.tags];
    [evaluate_view setFont:9];
    [evaluate_view setlHeight:18];
    [evaluate_view setLwidth:15];
    [evaluate_view setRadius:3];
    [self addSubview:evaluate_view];
    
    [evaluate_view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(self.nickName.mas_bottom).with.offset(0);
        make.height.mas_equalTo(15);
    }];
    self.devaluatV = evaluate_view;
//    dispatch_semaphore_t sign =
    self.content = [UILabel new];
    self.content.textColor = [UIColor textBlackColor];
    self.content.text = @"想和你一起去旅行";
    [self addSubview:self.content];
    
    [self.content mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(self.devaluatV.mas_bottom).with.offset(0);
        make.height.mas_equalTo(30);
        make.bottom.mas_equalTo(self.mas_bottom).with.offset(0);
        
    }];
    
}


-(UIImage*)convertViewToImage:(UIView*)view{
    CGSize size = view.bounds.size;
    UIGraphicsBeginImageContextWithOptions(size, NO, [UIScreen mainScreen].scale);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage*image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}


@end
