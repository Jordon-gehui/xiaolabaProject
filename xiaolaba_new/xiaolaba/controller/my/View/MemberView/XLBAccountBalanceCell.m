//
//  XLBAccountBalanceCell.m
//  xiaolaba
//
//  Created by 戴葛辉 on 2018/1/25.
//  Copyright © 2018年 jackzhang. All rights reserved.
//

#import "XLBAccountBalanceCell.h"

@interface XLBAccountBalanceCell ()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *subLabel;
@property (nonatomic, strong) UIButton *moneyBtn;
@property (nonatomic, strong) UIView *line;
@end

@implementation XLBAccountBalanceCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle= UITableViewCellSelectionStyleNone;
        [self setSubViews];
    }
    return self;
}
- (void)setRow:(NSInteger)row {
    if (row == 0) {
        self.subLabel.text = @"首次充值+2车币";
    }
    _row = row;
}
- (void)setSubViews {
    self.titleLabel = [UILabel new];
    self.titleLabel.text = @"10车币";
    self.titleLabel.font = [UIFont systemFontOfSize:15];
    self.titleLabel.textColor = [UIColor textBlackColor];
    [self.contentView addSubview:self.titleLabel];
    
    self.subLabel = [UILabel new];
    self.subLabel.textColor = [UIColor annotationTextColor];
    self.subLabel.font = [UIFont systemFontOfSize:12];
    [self.contentView addSubview:self.subLabel];
    
    self.moneyBtn = [UIButton new];
    self.moneyBtn.layer.masksToBounds = YES;
    self.moneyBtn.layer.cornerRadius = 15;
    self.moneyBtn.layer.borderWidth = 1;
    self.moneyBtn.layer.borderColor = [UIColor colorWithHexString:@"#e1e6f0"].CGColor;
    [self.moneyBtn setTitle:@"¥ 1000元" forState:0];
    [self.moneyBtn setTitleColor:[UIColor textBlackColor] forState:0];
    self.moneyBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [self.contentView addSubview:self.moneyBtn];
    
    self.line = [UIView new];
    self.line.backgroundColor = [UIColor lineColor];
    [self.contentView addSubview:self.line];
}

- (void)layoutSubviews {
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.centerY.mas_equalTo(self.contentView.mas_centerY).with.offset(0);
    }];
    
    [self.subLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.titleLabel.mas_bottom).with.offset(5);
        make.left.mas_equalTo(self.titleLabel.mas_left).with.offset(0);
    }];
    
    [self.moneyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15);
        make.centerY.mas_equalTo(self.mas_centerY).with.offset(0);
        make.width.mas_equalTo(80);
        make.height.mas_equalTo(30);
    }];
    
    [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.bottom.mas_equalTo(0);
        make.left.mas_equalTo(15);
        make.height.mas_equalTo(0.7);
    }];
}
+ (NSString *)accountBalanceCell {
    return @"accountBalanceCell";
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
