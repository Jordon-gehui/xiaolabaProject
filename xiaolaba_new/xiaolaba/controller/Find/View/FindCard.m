//
//  FindCard.m
//  xiaolaba
//
//  Created by 斯陈 on 2017/9/12.
//  Copyright © 2017年 jackzhang. All rights reserved.
//

#import "FindCard.h"

@implementation FindCard
#define scale self.width/(kSCREEN_WIDTH*0.9)
- (instancetype)init {
    
    if(self = [super init]) {
        
        [self setupSubViews];
    }
    return self;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self setupSubViews];
    }
    return self;
}
- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setupSubViews];
    }
    return self;
}

- (void)setModel:(XLBFindUserModel *)model {
    self.nickname.text = model.nickname;
    CGSize size = [model.nickname sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:self.nickname.font,NSFontAttributeName,nil]];
    NSString *picks = model.picks;
    if ([model.sex isEqualToString:@"1"]) {
        [self.sexView setImage:[UIImage imageNamed:@"icon_man"]];
    }else{
        [self.sexView setImage:[UIImage imageNamed:@"icon_woman"]];
    }
    NSArray <NSString *>*pickArray = [picks componentsSeparatedByString:@","];
    self.backV.hidden = pickArray.count > 1 ? NO:YES;

    [self.avatar sd_setImageWithURL:[NSURL URLWithString:[JXutils judgeImageheader:[pickArray firstObject] Withtype:IMGPick]] placeholderImage:[UIImage imageNamed:@"weitouxiang"]];
    [self.tagV insertSign:model.tags];
    NSRange range = [model.distance rangeOfString:@"--"];
    NSString*locationStr = @"";
    if ([[XLBUser user].userModel.city isEqualToString:model.city]) {
        if (kNotNil(model.district)) {
            locationStr = [NSString stringWithFormat:@"%@",model.district];

        }
    }else{
        if (kNotNil(model.city)) {
            locationStr = [NSString stringWithFormat:@"%@",model.city];
        }
    }
    if (locationStr.length>6) {
        locationStr =[NSString stringWithFormat:@"%@...",[locationStr substringToIndex:6]];
    }
    if (range.location == NSNotFound){
        if (!kNotNil(locationStr)) {
            locationStr = [NSString stringWithFormat:@"%@ • %@",model.distance,[ZZCHelper dateStringFromNow:model.updateDate]];
        }else{
            locationStr = [NSString stringWithFormat:@"%@  %@ • %@",locationStr,model.distance,[ZZCHelper dateStringFromNow:model.updateDate]];
        }
        
    }else{
        if (!kNotNil(locationStr)) {
            locationStr = [NSString stringWithFormat:@"%@",[ZZCHelper dateStringFromNow:model.updateDate]];
        }else{
            locationStr = [NSString stringWithFormat:@"%@ • %@",locationStr,[ZZCHelper dateStringFromNow:model.updateDate]];
        }
    }
    
    self.location.text =locationStr;

    [self.carImgV sd_setImageWithURL:[NSURL URLWithString:model.serieImg] placeholderImage:nil];
    [self.brandImg sd_setImageWithURL:[NSURL URLWithString:[JXutils judgeImageheader:model.brandImg Withtype:IMGNormal]]];
    if (pickArray.count > 1 ) {
        _pickerCountL.text = [NSString stringWithFormat:@"%lu",(unsigned long)pickArray.count];
    }else {
        _pickerCountL.text = @"";

    }
    self.avatar.frame = CGRectMake(0, 0, self.width, self.width);
//    self.whiteBackV.frame = CGRectMake(0, self.avatar.bottom, self.width, self.height-self.width);
    CGFloat line;
    if (iPhone5s) {
        line = 0;
    }else {
        line = 5;
    }
    self.nickname.frame = CGRectMake(15, self.avatar.bottom+line, size.width, 20);
    self.sexView.frame = CGRectMake(self.nickname.right+5, self.avatar.bottom+line, 20, 20);
    self.tagV.frame = CGRectMake(15, self.nickname.bottom+line, self.width-(self.height-self.width)*4/3-30, 20);
    self.location.frame = CGRectMake(15, self.tagV.bottom+line, self.width, 20);
    self.backV.frame = CGRectMake(10, 10, 45, 26);
    self.pickerCountV.frame =CGRectMake(0, 0, 25, 25);
    _pickerCountL.frame = CGRectMake(25, 1, 20, 25);
    self.carImgV.frame = CGRectMake(self.width-(self.height-self.width)*4/3-7, self.width, (self.height-self.width)*4/3, self.height-self.width-2);
    self.brandImg.frame = CGRectMake(self.carImgV.left, self.carImgV.top+line, 25, 20);

    _model = model;
}

- (void)setupSubViews {
    self.backgroundColor = UIColorFromRGB(0xe5e5e5);
    UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(modelClick)];
    [self addGestureRecognizer:tap2];
    CALayer * temp = [CALayer layer];
    [temp setBackgroundColor:[UIColor whiteColor].CGColor];
    temp.frame = CGRectMake(1, 1, self.bounds.size.width - 2, self.bounds.size.height - 2);

    UIBezierPath * path = [UIBezierPath bezierPathWithRoundedRect:temp.bounds byRoundingCorners:UIRectCornerBottomLeft|UIRectCornerBottomRight cornerRadii:CGSizeMake(3.5, 3.5)];
    CAShapeLayer * mask  = [[CAShapeLayer alloc] initWithLayer:temp];
    mask.path = path.CGPath;
    temp.mask = mask;
    [self.layer addSublayer:temp];
    
    self.layer.cornerRadius = 5;
    self.layer.masksToBounds = YES;
    // 头像
    self.avatar = [UIImageView new];
    self.avatar.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(avatarClick)];
    [self.avatar addGestureRecognizer:tap];
    [self addSubview:self.avatar];
    
    // 昵称
    self.nickname = [UILabel new];
    self.nickname.textColor = RGB(10, 10, 10);
    self.nickname.font = [UIFont systemFontOfSize:16];
    [self addSubview:self.nickname];
    
    self.sexView = [UIImageView new];
    [self.sexView setImage:[UIImage imageNamed:@"icon_man"]];
    [self.sexView setHidden:YES];
    [self addSubview:self.sexView];
    
    self.tagV = [XLBDEvaluateView new];
    self.tagV.backgroundColor = [UIColor whiteColor];
    [self.tagV setFont:7];
    [self.tagV setlHeight:12];
    [self.tagV setLwidth:15];
    [self.tagV setRadius:2];
    [self addSubview:self.tagV];
    
    self.location = [UILabel new];
    self.location.textColor = [UIColor minorTextColor];
    self.location.font = [UIFont systemFontOfSize:12];
    [self addSubview:self.location];
    
    self.backV = [UIView new];
    self.backV.layer.masksToBounds = YES;
    self.backV.layer.cornerRadius = 5;
    self.backV.backgroundColor = RGBA(0, 0, 0, 0.3);
    [self addSubview:self.backV];
    
    // 有几张照片
    self.pickerCountV = [UIImageView new];
//    self.pickerCountV.backgroundColor = RGBA(0, 0, 0, 0.3);
    _pickerCountV.image =[UIImage imageNamed:@"zhaopian"];
    [self.backV addSubview:self.pickerCountV];
    
    _pickerCountL = [UILabel new];
    _pickerCountL.textColor = [UIColor whiteColor];
    _pickerCountL.font = [UIFont systemFontOfSize:14];
    [self.backV addSubview:self.pickerCountL];
    
    // 车图
    self.carImgV = [UIImageView new];
    [self addSubview:self.carImgV];
    
    self.brandImg = [UIImageView new];
    [self addSubview:self.brandImg];
    
}
-(void)modelClick {
    if([self.delegate respondsToSelector:@selector(cardView:card:)]) {
        [self.delegate cardView:self card:self.model];
    }
}
-(void)avatarClick {
    if([self.delegate respondsToSelector:@selector(cardView:didTouchCardImages:)]) {        
        NSArray <NSString *>*images = [self.model.picks componentsSeparatedByString:@","];
        [self.delegate cardView:self didTouchCardImages:images];
    }
}
-(void)layoutSubviewssss {
    kWeakSelf(self);
    [_avatar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.mas_equalTo(0);
        make.width.height.mas_equalTo(weakSelf.width);
    }];
    [_whiteBackV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_avatar.mas_bottom).with.offset(-10);
        make.left.mas_equalTo(0);
        make.width.mas_equalTo(weakSelf.width);
        make.bottom.mas_equalTo(weakSelf.mas_bottom);
    }];
    [_nickname mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(weakSelf.avatar.mas_bottom).with.offset(10*scale);
        make.left.mas_equalTo(12*scale);
    }];
    [_sexView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(_nickname);
        make.left.mas_equalTo(weakSelf.nickname.mas_right).with.offset(10);
    }];
    [_tagV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.right.mas_equalTo(0);
        make.top.mas_equalTo(weakSelf.nickname.mas_bottom).with.offset(9);
        make.height.mas_equalTo(18*scale);
    }];
//    [_locationV mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(weakSelf.tagV.mas_bottom).with.offset(5);
//        make.left.mas_equalTo(12);
//        make.height.width.mas_equalTo(12);
//    }];
    [_location mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(weakSelf.tagV.mas_bottom).with.offset(11);
        make.left.mas_equalTo(18);
//        make.height.width.mas_equalTo(12);
//        make.centerY.mas_equalTo(_locationV);
//        make.left.mas_equalTo(weakSelf.locationV.mas_right).with.offset(5);
    }];
    [_carImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_avatar.mas_bottom).with.offset(10*scale);
        make.right.mas_equalTo(weakSelf);
        make.bottom.mas_equalTo(weakSelf).with.offset(-10*scale);
        make.width.mas_equalTo(100*kiphone6_ScreenWidth*scale);
        make.height.mas_equalTo(100*3/4*scale);
    }];
    
    [_brandImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_nickname.mas_top);
        make.right.mas_equalTo(_carImgV.mas_left).with.offset(20*scale);
        make.width.mas_equalTo(25*scale);
        make.height.mas_equalTo(20*scale);
    }];
    [_pickerCountV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.mas_equalTo(13*scale);
        make.width.height.mas_equalTo(20*scale);
    }];
    
    
    [_pickerCountL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(_pickerCountV.mas_centerY);
        make.left.mas_equalTo(_pickerCountV.mas_right).with.offset(2*scale);
    }];
    
    [_backV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.mas_equalTo(10*scale);
        make.height.mas_equalTo(26*scale);
        make.width.mas_equalTo(45*scale);
    }];
}


@end
