//
//  XLBMeCarGainCell.m
//  xiaolaba
//
//  Created by 戴葛辉 on 2018/7/31.
//  Copyright © 2018年 jackzhang. All rights reserved.
//

#import "XLBMeCarGainCell.h"

@interface XLBMeCarGainCell ()
    
@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UILabel *topLabel;
@property (nonatomic, strong) UILabel *bottomLabel;
@property (nonatomic, strong) UIImageView *btnImg;
@end

@implementation XLBMeCarGainCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor = [UIColor whiteColor];
        [self setSubViews];
    }
    return self;
}
- (void)setCellIndex:(NSInteger)cellIndex {
    _cellIndex = cellIndex;
    if (cellIndex == 0) {
        self.topLabel.text = @"免费领取";
        self.topLabel.textColor = [UIColor shadeStartColor];
        self.bottomLabel.text = @"邀请3位好友成功注册即可";
        self.btnImg.image = [UIImage imageNamed:@"icon_mflq"];
    }else {
        self.topLabel.text = @"点击申购";
        self.topLabel.textColor = [UIColor textBlackColor];
        self.bottomLabel.text = @"填写联系人，地址即可";
        self.btnImg.image = [UIImage imageNamed:@"icon_hc"];
        [self.btnImg mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(64);
            make.height.mas_equalTo(37);
            make.centerY.mas_equalTo(0);
            make.right.mas_equalTo(-27);
        }];
        
    }
}
- (void)setSubViews {
    self.bgView = [UIView new];
    self.bgView.backgroundColor = [UIColor whiteColor];
    self.bgView.layer.shadowOpacity = 0.5;// 阴影透明度
    self.bgView.layer.shadowColor = [UIColor grayColor].CGColor;// 阴影的颜色
    self.bgView.layer.shadowOffset = CGSizeMake(0, 1);
    self.bgView.layer.cornerRadius = 10;
    [self.contentView addSubview:self.bgView];
    
    self.topLabel = [UILabel new];
    self.topLabel.textColor = [UIColor shadeStartColor];
    self.topLabel.text = @"免费领取";
    self.topLabel.font = [UIFont systemFontOfSize:18];
    [self.bgView addSubview:self.topLabel];

    self.bottomLabel = [UILabel new];
    self.bottomLabel.textColor = [UIColor minorTextColor];
    self.bottomLabel.font = [UIFont systemFontOfSize:14];
    self.bottomLabel.text = @"邀请3位好友成功注册即可";
    [self.bgView addSubview:self.bottomLabel];
    
    self.btnImg = [UIImageView new];
    self.btnImg.image = [UIImage imageNamed:@"icon_mflq"];
    [self.bgView addSubview:self.btnImg];
    
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.top.mas_equalTo(5);
//        make.right.bottom.mas_equalTo(-5);
        make.height.mas_equalTo(90);
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-15);
        make.center.mas_equalTo(0);
    }];
    
    [self.topLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(24);
        make.left.mas_equalTo(25);
    }];
    
    [self.bottomLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(25);
        make.bottom.mas_equalTo(-24);
    }];
    
    [self.btnImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(45);
        make.height.mas_equalTo(51);
        make.centerY.mas_equalTo(0);
        make.right.mas_equalTo(-32);
    }];

}

+ (NSString *)carGainCellID {
    return @"carGainCellID";
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
