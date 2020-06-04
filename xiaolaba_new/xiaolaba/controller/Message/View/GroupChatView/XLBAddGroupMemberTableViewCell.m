//
//  XLBAddGroupMemberTableViewCell.m
//  xiaolaba
//
//  Created by 戴葛辉 on 2018/5/24.
//  Copyright © 2018年 jackzhang. All rights reserved.
//

#import "XLBAddGroupMemberTableViewCell.h"
@interface XLBAddGroupMemberTableViewCell()

@property (nonatomic, strong)UILabel *line;

@end
@implementation XLBAddGroupMemberTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setSubViews];
    }
    return self;
}

- (void)setSubViews {
    self.backgroundColor = [UIColor whiteColor];
    
    self.seleImage = [UIImageView new];
    [self.contentView addSubview:self.seleImage];
    
    self.line = [UILabel new];
    self.line.backgroundColor = [UIColor viewBackColor];
    [self.contentView addSubview:self.line];
    
    self.img = [UIImageView new];
    self.img.layer.masksToBounds = YES;
    self.img.layer.cornerRadius = 25;
    [self.contentView addSubview:self.img];
    
    self.nickName = [UILabel new];
    self.nickName.font = [UIFont systemFontOfSize:15];
    self.nickName.textColor = [UIColor colorWithR:66 g:66 b:66];
    [self.contentView addSubview:self.nickName];
    
}

- (void)layoutSubviews {
    kWeakSelf(self);
    [weakSelf.line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(0);
        make.bottom.mas_equalTo(weakSelf.contentView.mas_bottom).with.offset(0);
        make.height.mas_equalTo(0.7);
    }];
    
    [weakSelf.seleImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.contentView.mas_left).with.offset(15);
        make.centerY.mas_equalTo(weakSelf.contentView.mas_centerY);
        make.width.height.mas_equalTo(23);
    }];
    
    [weakSelf.img mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(weakSelf.seleImage.mas_right).with.offset(10);
        make.centerY.mas_equalTo(weakSelf.contentView.mas_centerY);
        make.width.height.mas_equalTo(50);
    }];
    
    [weakSelf.nickName mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(weakSelf.img.mas_right).with.offset(15);
        make.centerY.mas_equalTo(weakSelf.img.mas_centerY);
    }];
    

    
    
}

+ (NSString *)addGroupMemberCellID {
    return @"addGroupMemberCellID";
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
