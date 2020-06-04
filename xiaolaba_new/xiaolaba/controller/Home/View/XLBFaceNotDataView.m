//
//  XLBFaceNotDataView.m
//  xiaolaba
//
//  Created by 戴葛辉 on 2017/12/29.
//  Copyright © 2017年 jackzhang. All rights reserved.
//

#import "XLBFaceNotDataView.h"
@interface XLBFaceNotDataView ()

@property (nonatomic, strong)UIImageView *img;
@property (nonatomic, strong)UILabel *remindLabel;
@end
@implementation XLBFaceNotDataView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.frame = frame;
        self.backgroundColor = [UIColor whiteColor];
        [self setSubViews];
    }
    return self;
}

- (void)setSubViews {
    self.img = [UIImageView new];
    self.img.image = [UIImage imageNamed:@"pic_kb_m"];
    [self addSubview:self.img];
    self.remindLabel = [UILabel new];
    self.remindLabel.textColor = [UIColor minorTextColor];
    self.remindLabel.text = @"快去集赞，获取排名～";
    [self addSubview:self.remindLabel];
}

- (void)layoutSubviews {
    
    [self.remindLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left).with.offset(50);
        make.centerY.mas_equalTo(self.mas_centerY);
    }];
    [self.img mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.remindLabel.mas_centerY);
        make.left.mas_equalTo(self.remindLabel.mas_right).with.offset(3);
        make.width.mas_equalTo(68);
        make.height.mas_equalTo(35);
    }];
}

@end
