//
//  OwnerInfoTableViewCell.m
//  xiaolaba
//
//  Created by 戴葛辉 on 2017/9/14.
//  Copyright © 2017年 jackzhang. All rights reserved.
//

#import "OwnerInfoTableViewCell.h"

@interface OwnerInfoTableViewCell ()
@property (nonatomic, strong) UILabel *headLabel;
@property (nonatomic, strong) UILabel *ageLabel;
@property (nonatomic, strong) UILabel *tagLabel;
@property (nonatomic, strong) UILabel *carSerLabel;
@property (nonatomic, strong) UILabel *adressLabel;
@property (nonatomic, strong) UILabel *carLabel;
@property (nonatomic, strong) UILabel *tagSub;
@property (nonatomic, strong) UILabel *ageSub;
@property (nonatomic, strong) UILabel *carSerSub;
@property (nonatomic, strong) UILabel *adressSub;
@property (nonatomic, strong) UILabel *carSub;
@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UIView *bottomV;

@end

@implementation OwnerInfoTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setSubViews];
    }
    return self;
}

- (void)setOwner:(XLBOwnerModel *)owner {
    
    self.ageSub.text = owner.age;
    NSString *ser = [owner.status integerValue] == 30 ? @"已认证":@"未认证";
    self.carSerSub.text = ser;

    if (kNotNil(owner.domicile)) {
        if ([owner.domicile containsString:@","]) {
            NSArray *strArr = [owner.domicile componentsSeparatedByString:@","];
            self.adressSub.text = [NSString stringWithFormat:@"%@%@",strArr[1],strArr[2]];
        }else {
            self.adressSub.text = owner.domicile;
        }
    }
    self.carSub.text = owner.serieName;
    self.tagSub.text = owner.signature;
    if (!kNotNil(owner.age)) {
        self.ageSub.text = @"未填写";
    }
    if (!kNotNil(owner.city)) {
        self.adressSub.text = @"未填写";
    }
    if (!kNotNil(owner.serieName)) {
        self.carSub.text = @"未填写";
    }
    if (!kNotNil(owner.signature)) {
        self.tagSub.text = @"未填写";
    }
}

- (void)setSubViews {
    self.headLabel = [UILabel new];
    self.headLabel.text = @"个人资料";
    self.headLabel.textColor = RGB(51, 51, 51);
    self.headLabel.font = [UIFont systemFontOfSize:14];
    [self addSubview:self.headLabel];
    
    self.bgView = [UIView new];
    self.bgView.clipsToBounds = YES;
    self.bgView.layer.cornerRadius = 5;
    self.bgView.backgroundColor = RGB(247, 248, 250);
    [self addSubview:self.bgView];
    self.ageLabel = [UILabel new];
    self.ageLabel.text = @"年龄";
    self.ageLabel.textColor = RGB(138, 143, 153);
    self.ageLabel.font = [UIFont systemFontOfSize:14];
    
    [self.bgView addSubview:self.ageLabel];
    
    self.ageSub = [UILabel new];
    self.ageSub.textColor = RGB(51, 51, 51);
    self.ageSub.font = [UIFont systemFontOfSize:14];
    
    [self.bgView addSubview:self.ageSub];

    self.carSerLabel = [UILabel new];
    self.carSerLabel.text = @"车辆认证";
    self.carSerLabel.textColor = RGB(138, 143, 153);
    self.carSerLabel.font = [UIFont systemFontOfSize:14];
    
    [self.bgView addSubview:self.carSerLabel];

    self.carSerSub = [UILabel new];
    self.carSerSub.textColor = RGB(51, 51, 51);
    self.carSerSub.font = [UIFont systemFontOfSize:14];
    
    [self.bgView addSubview:self.carSerSub];

    self.adressLabel = [UILabel new];
    self.adressLabel.text = @"居住地";
    self.adressLabel.textColor = RGB(138, 143, 153);
    self.adressLabel.font = [UIFont systemFontOfSize:14];
    
    [self.bgView addSubview:self.adressLabel];

    self.adressSub = [UILabel new];
    self.adressSub.textColor = RGB(51, 51, 51);
    self.adressSub.font = [UIFont systemFontOfSize:14];
    
    [self.bgView addSubview:self.adressSub];

    self.carLabel = [UILabel new];
    self.carLabel.text = @"车型";
    self.carLabel.textColor = RGB(138, 143, 153);
    self.carLabel.font = [UIFont systemFontOfSize:14];
    
    [self.bgView addSubview:self.carLabel];

    self.carSub = [UILabel new];
    self.carSub.textColor = RGB(51, 51, 51);
    self.carSub.font = [UIFont systemFontOfSize:14];
    
    [self.bgView addSubview:self.carSub];

    self.tagLabel = [UILabel new];
    self.tagLabel.text = @"个签";
    self.tagLabel.textColor = RGB(138, 143, 153);
    self.tagLabel.font = [UIFont systemFontOfSize:14];
    
    [self.bgView addSubview:self.tagLabel];

    self.tagSub = [UILabel new];
    self.tagSub.textColor = RGB(51, 51, 51);
    self.tagSub.text = @"不知道什么鬼";
    self.tagSub.font = [UIFont systemFontOfSize:14];
    
    [self.bgView addSubview:self.tagSub];

}

- (void)layoutSubviews {
    
    kWeakSelf(self);
    [weakSelf.headLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.mas_equalTo(10);
        make.right.mas_equalTo(-15);
        make.height.mas_equalTo(30);
    }];
    
    [weakSelf.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.right.mas_equalTo(-10);
        make.top.mas_equalTo(weakSelf.headLabel.mas_bottom).mas_offset(5);
        make.height.mas_equalTo(165);
    }];
    
//    [weakSelf.bottomV mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.right.mas_equalTo(0);
//        make.top.mas_equalTo(weakSelf.bgView.mas_bottom).with.offset(20);
//        make.height.mas_equalTo(100);
//    }];
    
    [weakSelf.ageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.mas_equalTo(weakSelf.bgView).mas_offset(17);
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(18);
    }];
    
    [weakSelf.ageSub mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.ageLabel.mas_right).mas_offset(0);
        make.right.mas_equalTo(weakSelf.bgView).mas_equalTo(0);
        make.height.mas_equalTo(18);
        make.centerY.mas_equalTo(weakSelf.ageLabel);
    
    }];
    
    [weakSelf.carSerLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.ageLabel.mas_left).mas_offset(0);
        make.top.mas_equalTo(weakSelf.ageLabel.mas_bottom).mas_equalTo(10);
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(18);
    }];
    
    
    [weakSelf.carSerSub mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.carSerLabel.mas_right).mas_offset(0);
        make.right.mas_equalTo(weakSelf.bgView).mas_equalTo(0);
        make.height.mas_equalTo(18);
        make.centerY.mas_equalTo(weakSelf.carSerLabel);
    }];
    
    
    [weakSelf.adressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.carSerLabel.mas_left).mas_offset(0);
        make.top.mas_equalTo(weakSelf.carSerLabel.mas_bottom).mas_equalTo(10);
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(18);
    }];
    
    
    [weakSelf.adressSub mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.adressLabel.mas_right).mas_offset(0);
        make.right.mas_equalTo(weakSelf.bgView).mas_equalTo(0);
        make.height.mas_equalTo(18);
        make.centerY.mas_equalTo(weakSelf.adressLabel);
    }];
    
    
    [weakSelf.carLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.adressLabel.mas_left).mas_offset(0);
        make.top.mas_equalTo(weakSelf.adressLabel.mas_bottom).mas_equalTo(10);
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(18);
    }];
    
    
    [weakSelf.carSub mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.carLabel.mas_right).mas_offset(0);
        make.right.mas_equalTo(weakSelf.bgView).mas_equalTo(0);
        make.height.mas_equalTo(18);
        make.centerY.mas_equalTo(weakSelf.carLabel);
    }];
    
    
    [weakSelf.tagLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.carLabel.mas_left).mas_offset(0);
        make.top.mas_equalTo(weakSelf.carLabel.mas_bottom).mas_equalTo(10);
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(18);
    }];
    
    
    [weakSelf.tagSub mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.tagLabel.mas_right).mas_offset(0);
        make.right.mas_equalTo(weakSelf.bgView).mas_equalTo(0);
        make.height.mas_equalTo(18);
        make.centerY.mas_equalTo(weakSelf.tagLabel);
    }];
    
    
}

+ (NSString *)cellID {
    return @"cellID";
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
