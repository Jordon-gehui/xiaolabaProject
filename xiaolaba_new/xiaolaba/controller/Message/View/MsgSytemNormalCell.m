//
//  MsgSytemNormalCell.m
//  xiaolaba
//
//  Created by 戴葛辉 on 2017/12/29.
//  Copyright © 2017年 jackzhang. All rights reserved.
//

#import "MsgSytemNormalCell.h"

@interface MsgSytemNormalCell ()

@property (nonatomic, strong) UIView *bgV;
@property (nonatomic, strong) UILabel *topLabel;
@property (nonatomic, strong) UILabel *dateLabel;
@property (nonatomic, strong) UILabel *contentLabel;

@end

@implementation MsgSytemNormalCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor = [UIColor viewBackColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setSubViews];
    }
    return self;
}

- (void)setModel:(XLBSystemMsgModel *)model {
    CGFloat height = [model.summary sizeWithMaxWidth:(kSCREEN_WIDTH-60) font:[UIFont systemFontOfSize:13]].height;
    
    self.contentLabel.text = model.summary;
    self.dateLabel.text = model.createDate;
    self.topLabel.text = model.title;
    
    [self.bgV mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView).with.offset(15);
        make.left.mas_equalTo(self.contentView).with.offset(15);
        make.right.mas_equalTo(self.contentView).with.offset(-15);
        make.height.mas_equalTo(50 + height);
        make.bottom.mas_equalTo(5);
    }];
    
    [self.contentLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.dateLabel.mas_bottom).with.offset(8);
        make.left.mas_equalTo(self.bgV.mas_left).with.offset(15);
        make.right.mas_equalTo(self.bgV.mas_right).with.offset(-15);
    }];
    
    [self layoutIfNeeded];
}

- (void)setSubViews {
    self.bgV = [UIView new];
    self.bgV.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:self.bgV];
    
    self.topLabel = [UILabel new];
    self.topLabel.font = [UIFont systemFontOfSize:15];
    self.topLabel.textColor = [UIColor blackColor];
    self.topLabel.textAlignment = NSTextAlignmentLeft;
    [self.bgV addSubview:self.topLabel];
    
    self.dateLabel = [UILabel new];
    self.dateLabel.textColor = [UIColor annotationTextColor];
    self.dateLabel.font = [UIFont systemFontOfSize:12];
    self.dateLabel.textAlignment = NSTextAlignmentRight;
    [self.bgV addSubview:self.dateLabel];
    
    self.contentLabel = [UILabel new];
    self.contentLabel.font = [UIFont systemFontOfSize:13];
    self.contentLabel.textColor = [UIColor minorTextColor];
    self.contentLabel.textAlignment = NSTextAlignmentLeft;
    self.contentLabel.numberOfLines = 0;
    [self.bgV addSubview:self.contentLabel];
    
}

- (void)layoutSubviews {
    
    [self.topLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.bgV.mas_top).with.offset(15);
        make.left.mas_equalTo(self.bgV.mas_left).with.offset(15);
    }];
    
    [self.dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.bgV.mas_top).with.offset(15);
        make.right.mas_equalTo(self.bgV.mas_right).with.offset(-15);
    }];
    
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (NSString *)msgSystemNormalCellID {
    return @"msgSystemNormalCellID";
}
@end
