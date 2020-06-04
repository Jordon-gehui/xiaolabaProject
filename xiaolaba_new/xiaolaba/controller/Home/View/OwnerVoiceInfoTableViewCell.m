//
//  OwnerVoiceInfoTableViewCell.m
//  xiaolaba
//
//  Created by 戴葛辉 on 2018/4/8.
//  Copyright © 2018年 jackzhang. All rights reserved.
//

#import "OwnerVoiceInfoTableViewCell.h"

@interface OwnerVoiceInfoTableViewCell()

@property (nonatomic, strong) UILabel *headLabel;
//@property (nonatomic, strong) UILabel *ageLabel;
@property (nonatomic, strong) UILabel *tagLabel;//
@property (nonatomic, strong) UILabel *carSerLabel;//
@property (nonatomic, strong) UILabel *adressLabel;//
//@property (nonatomic, strong) UILabel *carLabel;
@property (nonatomic, strong) UILabel *tagSub;//
//@property (nonatomic, strong) UILabel *ageSub;
@property (nonatomic, strong) UILabel *carSerSub;//
@property (nonatomic, strong) UILabel *adressSub;//
//@property (nonatomic, strong) UILabel *carSub;
//@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UIView *bottomV;
@end

@implementation OwnerVoiceInfoTableViewCell

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

- (void)setOwner:(XLBVoiceActorModel *)owner {
    
//    self.ageSub.text = owner.user.age;
//    NSString *ser = [owner.user.status integerValue] == 30 ? @"已认证":@"未认证";
//    self.carSerSub.text = ser;
    
    if (kNotNil(owner.user.domicile)) {
        if ([owner.user.domicile containsString:@","]) {
            NSArray *strArr = [owner.user.domicile componentsSeparatedByString:@","];
            self.adressSub.text = [NSString stringWithFormat:@"%@%@",strArr[1],strArr[2]];
        }else {
            self.adressSub.text = owner.user.domicile;
        }
    }
    self.carSerSub.text = owner.user.serieName;
//    self.carSub.text = owner.user.serieName;
    self.tagSub.text = owner.user.signature;
//    if (!kNotNil(owner.user.age)) {
//        self.ageSub.text = @"未填写";
//    }
    if (!kNotNil(owner.user.city)) {
        self.adressSub.text = @"未填写";
    }
    if (!kNotNil(owner.user.serieName)) {
//        self.carSub.text = @"未填写";
        self.carSerSub.text = @"未填写";
    }
    if (!kNotNil(owner.user.signature)) {
        self.tagSub.text = @"未填写";
    }
}

- (void)setSubViews {
    self.headLabel = [UILabel new];
    self.headLabel.text = @"个人资料";
    self.headLabel.textColor = [UIColor commonTextColor];
    self.headLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:14];
    [self addSubview:self.headLabel];
    
    
    self.tagLabel = [UILabel new];
    self.tagLabel.text = @"个签";
    self.tagLabel.textColor = RGB(138, 143, 153);
    self.tagLabel.textAlignment = NSTextAlignmentLeft;
    self.tagLabel.font = [UIFont systemFontOfSize:14];
    
    [self addSubview:self.tagLabel];
    
    self.tagSub = [UILabel new];
    self.tagSub.textColor = RGB(51, 51, 51);
    self.tagSub.text = @"不知道什么鬼";
    self.tagSub.font = [UIFont systemFontOfSize:14];
    self.tagSub.textAlignment = NSTextAlignmentRight;
    [self addSubview:self.tagSub];
    
    self.carSerLabel = [UILabel new];
    self.carSerLabel.text = @"车辆认证";
    self.carSerLabel.textColor = RGB(138, 143, 153);
    self.carSerLabel.textAlignment = NSTextAlignmentLeft;
    self.carSerLabel.font = [UIFont systemFontOfSize:14];
    
    [self addSubview:self.carSerLabel];
    
    self.carSerSub = [UILabel new];
    self.carSerSub.textColor = RGB(51, 51, 51);
    self.carSerSub.textAlignment = NSTextAlignmentRight;

    self.carSerSub.font = [UIFont systemFontOfSize:14];
    
    [self addSubview:self.carSerSub];
    
    self.adressLabel = [UILabel new];
    self.adressLabel.text = @"居住地";
    self.adressLabel.textColor = RGB(138, 143, 153);
    self.adressLabel.textAlignment = NSTextAlignmentLeft;
    self.adressLabel.font = [UIFont systemFontOfSize:14];
    
    [self addSubview:self.adressLabel];
    
    self.adressSub = [UILabel new];
    self.adressSub.textColor = RGB(51, 51, 51);
    self.adressSub.textAlignment = NSTextAlignmentRight;
    self.adressSub.font = [UIFont systemFontOfSize:14];
    
    [self addSubview:self.adressSub];

    
}

- (void)layoutSubviews {
    
    kWeakSelf(self);
    [weakSelf.headLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(10);
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-15);
        make.height.mas_equalTo(30);
    }];

    
    
    [weakSelf.tagLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.mas_left).mas_offset(30);
        make.top.mas_equalTo(weakSelf.headLabel.mas_bottom).mas_equalTo(10);
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(18);
    }];
    
    
    [weakSelf.tagSub mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.tagLabel.mas_right).mas_offset(0);
        make.right.mas_equalTo(weakSelf.mas_right).mas_equalTo(-26);
        make.height.mas_equalTo(18);
        make.centerY.mas_equalTo(weakSelf.tagLabel);
    }];
    
    [weakSelf.carSerLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.tagLabel.mas_left).mas_offset(0);
        make.top.mas_equalTo(weakSelf.tagLabel.mas_bottom).mas_equalTo(10);
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(18);
    }];
    
    
    [weakSelf.carSerSub mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.carSerLabel.mas_right).mas_offset(0);
        make.right.mas_equalTo(weakSelf.mas_right).mas_equalTo(-26);
        make.height.mas_equalTo(18);
        make.centerY.mas_equalTo(weakSelf.carSerLabel);
    }];
    
    
    [weakSelf.adressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.tagLabel.mas_left).mas_offset(0);
        make.top.mas_equalTo(weakSelf.carSerLabel.mas_bottom).mas_equalTo(10);
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(18);
    }];
    
    
    [weakSelf.adressSub mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.adressLabel.mas_right).mas_offset(0);
        make.right.mas_equalTo(weakSelf.mas_right).mas_equalTo(-26);
        make.height.mas_equalTo(18);
        make.centerY.mas_equalTo(weakSelf.adressLabel);
    }];
    
    
//    [weakSelf.carLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(weakSelf.adressLabel.mas_left).mas_offset(0);
//        make.top.mas_equalTo(weakSelf.adressLabel.mas_bottom).mas_equalTo(10);
//        make.width.mas_equalTo(100);
//        make.height.mas_equalTo(18);
//    }];
//
//
//    [weakSelf.carSub mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(weakSelf.carLabel.mas_right).mas_offset(0);
//        make.right.mas_equalTo(weakSelf.bgView).mas_equalTo(0);
//        make.height.mas_equalTo(18);
//        make.centerY.mas_equalTo(weakSelf.carLabel);
//    }];
    

    
    
}

+ (NSString *)cellID {
    return @"cellID";
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
