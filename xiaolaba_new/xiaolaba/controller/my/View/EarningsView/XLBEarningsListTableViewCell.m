//
//  XLBEarningsListTableViewCell.m
//  xiaolaba
//
//  Created by 戴葛辉 on 2018/1/25.
//  Copyright © 2018年 jackzhang. All rights reserved.
//

#import "XLBEarningsListTableViewCell.h"

@interface XLBEarningsListTableViewCell ()

@property (nonatomic, strong) UILabel *money;
@property (nonatomic, strong) UILabel *dateLabel;
@property (nonatomic, strong) UILabel *statusLabel;
@property (nonatomic, strong) UIView *line;
@end

@implementation XLBEarningsListTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor = [UIColor whiteColor];
        self.selectionStyle= UITableViewCellSelectionStyleNone;
        [self setSubViews];
    }
    return self;
}

- (void)setModel:(EarningsListModel *)model {
    _model = model;
    if (self.isPay) {
        self.statusLabel.text = @"充值成功";
    }else {
        if ([model.type isEqualToString:@"1"]) {
            self.statusLabel.text = @"提现成功";
        }
        if ([model.type isEqualToString:@"-1"]) {
            self.statusLabel.text = @"等待到账";
        }
        if ([model.type isEqualToString:@"-2"]) {
            self.statusLabel.text = @"余额不足";
        }
    }
    self.money.text = [NSString stringWithFormat:@"%@元",model.remarks];
    self.dateLabel.text = [NSString stringWithFormat:@"%@",[ZZCHelper dateStringFromNumberTimer:model.createDate type:1]];
}
- (void)setIsPay:(BOOL)isPay {
    _isPay = isPay;
}
- (void)setSubViews {
    self.money = [UILabel new];
    self.money.textColor = [UIColor shadeStartColor];
    self.money.font = [UIFont fontWithName:@"Helvetica-Bold" size:16];
    [self.contentView addSubview:self.money];
    
    self.dateLabel = [UILabel new];
    self.dateLabel.textColor = [UIColor minorTextColor];
    self.dateLabel.font = [UIFont systemFontOfSize:12];
    [self.contentView addSubview:self.dateLabel];
    
    self.statusLabel = [UILabel new];
    self.statusLabel.textColor = [UIColor commonTextColor];
    self.statusLabel.font = [UIFont systemFontOfSize:15];
    [self.contentView addSubview:self.statusLabel];
    
    self.line = [UIView new];
    self.line.backgroundColor = [UIColor lineColor];
    [self.contentView addSubview:self.line];
}

- (void)layoutSubviews {
    [self.money mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15);
        make.top.bottom.mas_equalTo(0);
    }];
    
    [self.dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.top.mas_equalTo(self.contentView.mas_centerY).with.offset(3);
    }];
    
    [self.statusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.bottom.mas_equalTo(self.contentView.mas_centerY).with.offset(-3);
    }];
    
    [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
        make.height.mas_equalTo(0.7);
    }];
}

+ (NSString *)earningsCellID {
    return @"earningsCellID";
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
