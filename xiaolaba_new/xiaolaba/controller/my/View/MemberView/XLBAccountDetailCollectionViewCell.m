//
//  XLBAccountDetailCollectionViewCell.m
//  xiaolaba
//
//  Created by 戴葛辉 on 2018/4/21.
//  Copyright © 2018年 jackzhang. All rights reserved.
//

#import "XLBAccountDetailCollectionViewCell.h"

@interface XLBAccountDetailCollectionViewCell()


@end

@implementation XLBAccountDetailCollectionViewCell
- (instancetype)init {
    self = [super init];
    if (self) {
        [self setSubViews];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setSubViews];
    }
    return self;
}

- (void)setDict:(NSDictionary *)dict {
    self.priceLabel.text = [NSString stringWithFormat:@"%@元",dict[@"value"]];
    self.subPriceLabel.text = [NSString stringWithFormat:@"%@",dict[@"label"]];
    
    _dict = dict;
}
- (void)setSubViews {
    self.bgView = [UIView new];
    self.bgView.layer.masksToBounds = YES;
    self.bgView.layer.cornerRadius = 5;
    self.bgView.layer.borderColor = [UIColor lineColor].CGColor;
    self.bgView.layer.borderWidth = 1;
    [self.contentView addSubview:self.bgView];
    
    self.priceLabel = [UILabel new];
    self.priceLabel.text = @"6元";
    self.priceLabel.textColor = [UIColor textBlackColor];
    self.priceLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:16];
    self.priceLabel.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:self.priceLabel];
    
    self.subPriceLabel = [UILabel new];
    self.subPriceLabel.textAlignment = NSTextAlignmentLeft;
    self.subPriceLabel.textColor = [UIColor minorTextColor];
    self.subPriceLabel.text = @"10车币";
    self.subPriceLabel.font = [UIFont systemFontOfSize:13];
    [self.contentView addSubview:self.subPriceLabel];
    
    self.img = [UIImageView new];
    self.img.image = [UIImage imageNamed:@"pic_ch_czb"];
    [self.contentView addSubview:self.img];
    
    self.discountsLabel = [UILabel new];
    self.discountsLabel.textAlignment = NSTextAlignmentRight;
    self.discountsLabel.textColor = [UIColor textBlackColor];
    self.discountsLabel.font = [UIFont systemFontOfSize:11];
    self.discountsLabel.text = @"首充赠2车币";
    [self.contentView addSubview:self.discountsLabel];
    
    self.customPrice = [UILabel new];
    self.customPrice.text = @"自定义充值金额(≥1元)";
    self.customPrice.textColor = [UIColor minorTextColor];
    self.customPrice.font = [UIFont systemFontOfSize:13];
    [self.contentView addSubview:self.customPrice];
 
    
}

- (void)layoutSubviews {
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.mas_equalTo(self.contentView).with.offset(5);
        make.right.bottom.mas_equalTo(self.contentView).with.offset(-5);
    }];
    
    [self.priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.bgView.mas_left).with.offset(10);
        make.top.mas_equalTo(self.bgView.mas_top).with.offset(10);
    }];
    
    [self.subPriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.priceLabel.mas_left).with.offset(0);
        make.top.mas_equalTo(self.priceLabel.mas_bottom).with.offset(10);
    }];
    
//    [self.discountsLabel layoutIfNeeded];
//    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.discountsLabel.bounds byRoundingCorners:UIRectCornerBottomLeft cornerRadii:CGSizeMake(30, 40)];
//    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
//    maskLayer.frame = self.discountsLabel.bounds;
//    maskLayer.path = maskPath.CGPath;
//    self.discountsLabel.layer.mask = maskLayer;
    
    [self.customPrice mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
        make.centerX.mas_equalTo(self.contentView.mas_centerX);
    }];
    
    [self.img mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.bgView.mas_top).with.offset(0);
        make.right.mas_equalTo(self.bgView.mas_right).with.offset(0);
    }];
    
    [self.discountsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.img.mas_right).with.offset(-4);
        make.top.mas_equalTo(self.img.mas_top).with.offset(0);
        make.bottom.mas_equalTo(self.img.mas_bottom).with.offset(0);
        make.centerX.mas_equalTo(self.img.mas_centerX);
    }];
}
+ (NSString *)accountDetailCellId {
    return @"accountDetailCellId";
}
@end
