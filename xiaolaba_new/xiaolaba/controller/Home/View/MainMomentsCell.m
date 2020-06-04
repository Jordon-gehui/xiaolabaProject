//
//  MainMomentsCell.m
//  xiaolaba
//
//  Created by 斯陈 on 2019/3/22.
//  Copyright © 2019年 jackzhang. All rights reserved.
//

#import "MainMomentsCell.h"

@interface MainMomentsCell ()
{
    NSString *likeStr;
}

@property (nonatomic, strong) UIButton *userImg;
@property (nonatomic, strong) UILabel *nickNameLabel;
@property (nonatomic, strong) UILabel *dateLabel;
@property (nonatomic, strong) UIImageView *brandImg;
@property (nonatomic, strong) UIButton *rightBtn;
@property (nonatomic, strong) UILabel *contentLabel;

@property (nonatomic, strong) UIImageView *firstImg;
@property (nonatomic, strong) UIImageView *secondImg;
@property (nonatomic, strong) UIImageView *threeImg;

@property (nonatomic, strong) UIImageView *fourImg;
@property (nonatomic, strong) UIImageView *fiveImg;
@property (nonatomic, strong) UIImageView *sixImg;

@property (nonatomic, strong) UIImageView *sevenImg;
@property (nonatomic, strong) UIImageView *eightImg;
@property (nonatomic, strong) UIImageView *nineImg;

@property (nonatomic, strong) UIView *locationV;
@property (nonatomic, strong) UIImageView *locationImg;
@property (nonatomic, strong) UILabel *locationLabel;

@property (nonatomic, strong) UIView *lineV;

@property (nonatomic,assign)BOOL isFollows;

@property (nonatomic, copy) NSMutableArray *imageArr;


@end

@implementation MainMomentsCell


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setSubViewsWithType:reuseIdentifier];
    }
    return self;
}

- (void)setModel:(LittleHornTableViewModel *)model {
    _model = model;
    
    NSString *creatUser = [NSString stringWithFormat:@"%@",[XLBUser user].userModel.ID];
    if ([creatUser isEqualToString:model.createUser]) {
        if (self.isSelf) {
            [self.rightBtn setImage:[UIImage imageNamed:@"icon_fx_gd"] forState:0];
        }else {
            self.rightBtn.hidden = YES;
        }
    }else{
        self.rightBtn.hidden = NO;
        [self.rightBtn setImage:[UIImage imageNamed:@"icon_fx_gd"] forState:UIControlStateNormal];
        self.isFollows = [model.follows isEqualToString:@"1"];
    }
    
    likeStr = model.liked;
    if (![model.liked isEqualToString:@"0"]) {
        [self.likeBtn setImage:[UIImage imageNamed:@"icon_fx_dz_s"] forState:UIControlStateNormal];
    }else{
        [self.likeBtn setImage:[UIImage imageNamed:@"icon_fx_dz_n"] forState:UIControlStateNormal];
    }
    
    [self.likeBtn setTitle:[NSString stringWithFormat:@" %@",kNotNil(model.likes)?model.likes:@"0"] forState:0];
    //评论
    [self.commentBtn setTitle:[NSString stringWithFormat:@" %@",kNotNil(model.discussCount)?model.discussCount:@"0"]  forState:0];
    //查看
    [self.lookBtn setTitle:[NSString stringWithFormat:@" %@",kNotNil(model.views)?model.views:@"0"]  forState:0];
    
    
    [self.userImg sd_setImageWithURL:[NSURL URLWithString:[JXutils judgeImageheader:model.avatar Withtype:IMGAvatar]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"weitouxiang"]];
    self.nickNameLabel.text = model.nickName;
    self.dateLabel.text = model.publishDate;
    
    NSString *momentStr;
    if ([model.moment hasSuffix:@"\n"]) {
        momentStr = [model.moment stringByReplacingOccurrencesOfString:@"\n" withString:@" "];
    }else{
        momentStr = [NSString stringWithFormat:@"%@",model.moment];
    }
    NSMutableAttributedString *momentAttStr = [[NSMutableAttributedString alloc] initWithString:momentStr];
    
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    UIFont *font = [UIFont systemFontOfSize:15];
    if ([momentAttStr.string isMoreThanOneLineWithSize:CGSizeMake(kSCREEN_WIDTH - 30, MAXFLOAT) font:font lineSpaceing:5]) {
        style.lineSpacing = 5;
    }
    [momentAttStr addAttribute:NSParagraphStyleAttributeName value:style range:NSMakeRange(0, momentStr.length)];
    [momentAttStr addAttribute:NSForegroundColorAttributeName value:[UIColor commonTextColor] range:NSMakeRange(0, momentStr.length)];
    self.contentLabel.attributedText = momentAttStr;
    
    if ([self.reuseIdentifier integerValue] == MainMomentsDefault) {
        
    }else if ([self.reuseIdentifier integerValue] == MainMomentsOneImageWidthCell || [self.reuseIdentifier integerValue] == MainMomentsOneImageHeightCell) {
        if ([self.reuseIdentifier integerValue] == MainMomentsOneImageWidthCell) {
            [self.firstImg sd_setImageWithURL:[NSURL URLWithString:[JXutils judgeImageheader:model.imgs[0] Withtype:IMGMoment_single_w]] placeholderImage:[UIImage imageNamed:@"pic_home_jz"]];
        }else {
            [self.firstImg sd_setImageWithURL:[NSURL URLWithString:[JXutils judgeImageheader:model.imgs[0] Withtype:IMGMoment_single_h]] placeholderImage:[UIImage imageNamed:@"pic_home_jz"]];
        }
        
    }else if ([self.reuseIdentifier integerValue] == MainMomentsTwoImageCell) {
        [self.firstImg sd_setImageWithURL:[NSURL URLWithString:[JXutils judgeImageheader:model.imgs[0] Withtype:IMGMoment_square]] placeholderImage:[UIImage imageNamed:@"pic_home_jz"]];
        [self.secondImg sd_setImageWithURL:[NSURL URLWithString:[JXutils judgeImageheader:model.imgs[1] Withtype:IMGMoment_square]] placeholderImage:[UIImage imageNamed:@"pic_home_jz"]];
        
    }else if ([self.reuseIdentifier integerValue] == MainMomentsThreeImageCell) {
        [self.firstImg sd_setImageWithURL:[NSURL URLWithString:[JXutils judgeImageheader:model.imgs[0] Withtype:IMGMoment_square]] placeholderImage:[UIImage imageNamed:@"pic_home_jz"]];
        [self.secondImg sd_setImageWithURL:[NSURL URLWithString:[JXutils judgeImageheader:model.imgs[1] Withtype:IMGMoment_square]] placeholderImage:[UIImage imageNamed:@"pic_home_jz"]];
        [self.threeImg sd_setImageWithURL:[NSURL URLWithString:[JXutils judgeImageheader:model.imgs[2] Withtype:IMGMoment_square]] placeholderImage:[UIImage imageNamed:@"pic_home_jz"]];
        
    }else if ([self.reuseIdentifier integerValue] == MainMomentsFourImageCell) {
        [self.firstImg sd_setImageWithURL:[NSURL URLWithString:[JXutils judgeImageheader:model.imgs[0] Withtype:IMGMoment_rectangle]] placeholderImage:[UIImage imageNamed:@"pic_home_jz"]];
        [self.secondImg sd_setImageWithURL:[NSURL URLWithString:[JXutils judgeImageheader:model.imgs[1] Withtype:IMGMoment_rectangle]] placeholderImage:[UIImage imageNamed:@"pic_home_jz"]];
        [self.threeImg sd_setImageWithURL:[NSURL URLWithString:[JXutils judgeImageheader:model.imgs[2] Withtype:IMGMoment_rectangle]] placeholderImage:[UIImage imageNamed:@"pic_home_jz"]];
        [self.fourImg sd_setImageWithURL:[NSURL URLWithString:[JXutils judgeImageheader:model.imgs[3] Withtype:IMGMoment_rectangle]] placeholderImage:[UIImage imageNamed:@"pic_home_jz"]];
        
    }else if ([self.reuseIdentifier integerValue] == MainMomentsFiveImageCell) {
        [self.firstImg sd_setImageWithURL:[NSURL URLWithString:[JXutils judgeImageheader:model.imgs[0] Withtype:IMGMoment_rectangle]] placeholderImage:[UIImage imageNamed:@"pic_home_jz"]];
        [self.secondImg sd_setImageWithURL:[NSURL URLWithString:[JXutils judgeImageheader:model.imgs[1] Withtype:IMGMoment_rectangle]] placeholderImage:[UIImage imageNamed:@"pic_home_jz"]];
        [self.threeImg sd_setImageWithURL:[NSURL URLWithString:[JXutils judgeImageheader:model.imgs[2] Withtype:IMGMoment_square]] placeholderImage:[UIImage imageNamed:@"pic_home_jz"]];
        [self.fourImg sd_setImageWithURL:[NSURL URLWithString:[JXutils judgeImageheader:model.imgs[3] Withtype:IMGMoment_square]] placeholderImage:[UIImage imageNamed:@"pic_home_jz"]];
        [self.fiveImg sd_setImageWithURL:[NSURL URLWithString:[JXutils judgeImageheader:model.imgs[4] Withtype:IMGMoment_square]] placeholderImage:[UIImage imageNamed:@"pic_home_jz"]];
    }else if ([self.reuseIdentifier integerValue] == MainMomentsSixImageCell) {
        [self.firstImg sd_setImageWithURL:[NSURL URLWithString:[JXutils judgeImageheader:model.imgs[0] Withtype:IMGMoment_square]] placeholderImage:[UIImage imageNamed:@"pic_home_jz"]];
        [self.secondImg sd_setImageWithURL:[NSURL URLWithString:[JXutils judgeImageheader:model.imgs[1] Withtype:IMGMoment_square]] placeholderImage:[UIImage imageNamed:@"pic_home_jz"]];
        [self.threeImg sd_setImageWithURL:[NSURL URLWithString:[JXutils judgeImageheader:model.imgs[2] Withtype:IMGMoment_square]] placeholderImage:[UIImage imageNamed:@"pic_home_jz"]];
        [self.fourImg sd_setImageWithURL:[NSURL URLWithString:[JXutils judgeImageheader:model.imgs[3] Withtype:IMGMoment_square]] placeholderImage:[UIImage imageNamed:@"pic_home_jz"]];
        [self.fiveImg sd_setImageWithURL:[NSURL URLWithString:[JXutils judgeImageheader:model.imgs[4] Withtype:IMGMoment_square]] placeholderImage:[UIImage imageNamed:@"pic_home_jz"]];
        [self.sixImg sd_setImageWithURL:[NSURL URLWithString:[JXutils judgeImageheader:model.imgs[5] Withtype:IMGMoment_square]] placeholderImage:[UIImage imageNamed:@"pic_home_jz"]];
    }else if ([self.reuseIdentifier integerValue] == MainMomentsSevenImageCell) {
        [self.firstImg sd_setImageWithURL:[NSURL URLWithString:[JXutils judgeImageheader:model.imgs[0] Withtype:IMGMoment_rectangle]] placeholderImage:[UIImage imageNamed:@"pic_home_jz"]];
        [self.secondImg sd_setImageWithURL:[NSURL URLWithString:[JXutils judgeImageheader:model.imgs[1] Withtype:IMGMoment_rectangle]] placeholderImage:[UIImage imageNamed:@"pic_home_jz"]];
        [self.threeImg sd_setImageWithURL:[NSURL URLWithString:[JXutils judgeImageheader:model.imgs[2] Withtype:IMGMoment_square]] placeholderImage:[UIImage imageNamed:@"pic_home_jz"]];
        [self.fourImg sd_setImageWithURL:[NSURL URLWithString:[JXutils judgeImageheader:model.imgs[3] Withtype:IMGMoment_square]] placeholderImage:[UIImage imageNamed:@"pic_home_jz"]];
        [self.fiveImg sd_setImageWithURL:[NSURL URLWithString:[JXutils judgeImageheader:model.imgs[4] Withtype:IMGMoment_square]] placeholderImage:[UIImage imageNamed:@"pic_home_jz"]];
        [self.sixImg sd_setImageWithURL:[NSURL URLWithString:[JXutils judgeImageheader:model.imgs[5] Withtype:IMGMoment_rectangle]] placeholderImage:[UIImage imageNamed:@"pic_home_jz"]];
        [self.sevenImg sd_setImageWithURL:[NSURL URLWithString:[JXutils judgeImageheader:model.imgs[6] Withtype:IMGMoment_rectangle]] placeholderImage:[UIImage imageNamed:@"pic_home_jz"]];
    }else if ([self.reuseIdentifier integerValue] == MainMomentsEightImageCell) {
        [self.firstImg sd_setImageWithURL:[NSURL URLWithString:[JXutils judgeImageheader:model.imgs[0] Withtype:IMGMoment_rectangle]] placeholderImage:[UIImage imageNamed:@"pic_home_jz"]];
        [self.secondImg sd_setImageWithURL:[NSURL URLWithString:[JXutils judgeImageheader:model.imgs[1] Withtype:IMGMoment_rectangle]] placeholderImage:[UIImage imageNamed:@"pic_home_jz"]];
        [self.threeImg sd_setImageWithURL:[NSURL URLWithString:[JXutils judgeImageheader:model.imgs[2] Withtype:IMGMoment_square]] placeholderImage:[UIImage imageNamed:@"pic_home_jz"]];
        [self.fourImg sd_setImageWithURL:[NSURL URLWithString:[JXutils judgeImageheader:model.imgs[3] Withtype:IMGMoment_square]] placeholderImage:[UIImage imageNamed:@"pic_home_jz"]];
        [self.fiveImg sd_setImageWithURL:[NSURL URLWithString:[JXutils judgeImageheader:model.imgs[4] Withtype:IMGMoment_square]] placeholderImage:[UIImage imageNamed:@"pic_home_jz"]];
        [self.sixImg sd_setImageWithURL:[NSURL URLWithString:[JXutils judgeImageheader:model.imgs[5] Withtype:IMGMoment_square]] placeholderImage:[UIImage imageNamed:@"pic_home_jz"]];
        [self.sevenImg sd_setImageWithURL:[NSURL URLWithString:[JXutils judgeImageheader:model.imgs[6] Withtype:IMGMoment_square]] placeholderImage:[UIImage imageNamed:@"pic_home_jz"]];
        [self.eightImg sd_setImageWithURL:[NSURL URLWithString:[JXutils judgeImageheader:model.imgs[7] Withtype:IMGMoment_square]] placeholderImage:[UIImage imageNamed:@"pic_home_jz"]];
    }else if ([self.reuseIdentifier integerValue] == MainMomentsNineImageCell) {
        [self.firstImg sd_setImageWithURL:[NSURL URLWithString:[JXutils judgeImageheader:model.imgs[0] Withtype:IMGMoment_square]] placeholderImage:[UIImage imageNamed:@"pic_home_jz"]];
        [self.secondImg sd_setImageWithURL:[NSURL URLWithString:[JXutils judgeImageheader:model.imgs[1] Withtype:IMGMoment_square]] placeholderImage:[UIImage imageNamed:@"pic_home_jz"]];
        [self.threeImg sd_setImageWithURL:[NSURL URLWithString:[JXutils judgeImageheader:model.imgs[2] Withtype:IMGMoment_square]] placeholderImage:[UIImage imageNamed:@"pic_home_jz"]];
        [self.fourImg sd_setImageWithURL:[NSURL URLWithString:[JXutils judgeImageheader:model.imgs[3] Withtype:IMGMoment_square]] placeholderImage:[UIImage imageNamed:@"pic_home_jz"]];
        [self.fiveImg sd_setImageWithURL:[NSURL URLWithString:[JXutils judgeImageheader:model.imgs[4] Withtype:IMGMoment_square]] placeholderImage:[UIImage imageNamed:@"pic_home_jz"]];
        [self.sixImg sd_setImageWithURL:[NSURL URLWithString:[JXutils judgeImageheader:model.imgs[5] Withtype:IMGMoment_square]] placeholderImage:[UIImage imageNamed:@"pic_home_jz"]];
        [self.sevenImg sd_setImageWithURL:[NSURL URLWithString:[JXutils judgeImageheader:model.imgs[6] Withtype:IMGMoment_square]] placeholderImage:[UIImage imageNamed:@"pic_home_jz"]];
        [self.eightImg sd_setImageWithURL:[NSURL URLWithString:[JXutils judgeImageheader:model.imgs[7] Withtype:IMGMoment_square]] placeholderImage:[UIImage imageNamed:@"pic_home_jz"]];
        [self.nineImg sd_setImageWithURL:[NSURL URLWithString:[JXutils judgeImageheader:model.imgs[8] Withtype:IMGMoment_square]] placeholderImage:[UIImage imageNamed:@"pic_home_jz"]];
    }
    
    if (!kNotNil(model.moment)) {
        [self.firstImg mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.contentLabel.mas_bottom).with.offset(0);
        }];
    }else {
        [self.firstImg mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.contentLabel.mas_bottom).with.offset(14);
        }];
    }
    if (kNotNil(model.location)) {
        self.locationLabel.text = model.location;
        self.locationV.hidden = NO;
        [self.likeBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.locationV.mas_bottom).with.offset(10);
            make.left.mas_offset(15);
            make.width.mas_lessThanOrEqualTo(@60);
            make.height.mas_equalTo(30);
        }];
    }else {
        self.locationV.hidden = YES;
        [self.likeBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.locationV.mas_top).with.offset(0);
            make.left.mas_offset(15);
            make.width.mas_lessThanOrEqualTo(@60);
            make.height.mas_equalTo(30);
        }];
    }
}

-(void)setIsFollows:(BOOL)isFollows {
    _isFollows = isFollows;
    //关注
    //    if (_isFollows) {
    //        self.rightBtn.selected = YES;
    //        [self.rightBtn setBackgroundImage:[UIImage imageNamed:@"btn_ygz-1"] forState:UIControlStateNormal];
    //    }else{
    //        self.rightBtn.selected = NO;
    //        [self.rightBtn setBackgroundImage:[UIImage imageNamed:@"btn_gz-1"] forState:UIControlStateNormal];
    //    }
}

- (void)setSubViewsWithType:(NSString *)type {
    
    self.userImg = [UIButton new];
    self.userImg.layer.masksToBounds = YES;
    self.userImg.layer.cornerRadius = 18;
    [self.userImg addTarget:self action:@selector(userImgClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.userImg setImage:[UIImage imageNamed:@"weitouxiang"] forState:UIControlStateNormal];
    [self.contentView addSubview:self.userImg];
    
    self.nickNameLabel = [UILabel new];
    self.nickNameLabel.text = @"Maselskis";
    self.nickNameLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:15];
    self.nickNameLabel.textColor = [UIColor commonTextColor];
    [self.contentView addSubview:self.nickNameLabel];
    
    self.dateLabel = [UILabel new];
    self.dateLabel.text = @"2019.03.15  10:48";
    self.dateLabel.font = [UIFont fontWithName:@"PingFangSC-Light" size:12];
    self.dateLabel.textColor = [UIColor annotationTextColor];
    [self.contentView addSubview:self.dateLabel];
    
    self.brandImg = [UIImageView new];
    [self.contentView addSubview:self.brandImg];
    
    self.rightBtn = [UIButton new];
    [self.rightBtn setEnlargeEdge:15];
    [self.rightBtn setImage:[UIImage imageNamed:@"icon_fx_gd"] forState:UIControlStateNormal];
    [self.rightBtn addTarget:self action:@selector(rightBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.rightBtn];
    
    self.contentLabel = [UILabel new];
//    self.contentLabel.backgroundColor = [UIColor redColor];
    self.contentLabel.font = [UIFont systemFontOfSize:15];
    self.contentLabel.textColor = [UIColor commonTextColor];
    self.contentLabel.numberOfLines = 0;
    [self.contentView addSubview:self.contentLabel];
    
    
    self.firstImg = [UIImageView new];
    self.firstImg.backgroundColor = [UIColor imageBackgroundColor];
    self.firstImg.layer.masksToBounds = YES;
    self.firstImg.layer.borderWidth = 0.5;
    self.firstImg.tag = MainFirstImageTag;
    self.firstImg.userInteractionEnabled = YES;
    self.firstImg.layer.borderColor = [UIColor imageLineColor].CGColor;
    self.firstImg.contentMode = UIViewContentModeScaleAspectFill;
    [self.contentView addSubview:self.firstImg];
    
    self.secondImg = [UIImageView new];
    self.secondImg.backgroundColor = [UIColor imageBackgroundColor];
    self.secondImg.layer.masksToBounds = YES;
    self.secondImg.layer.borderWidth = 0.5;
    self.secondImg.layer.borderColor = [UIColor imageLineColor].CGColor;
    self.secondImg.contentMode = UIViewContentModeScaleAspectFill;
    self.secondImg.tag = MainSecondImageTag;
    self.secondImg.userInteractionEnabled = YES;
    [self.contentView addSubview:self.secondImg];
    
    
    self.threeImg = [UIImageView new];
    self.threeImg.backgroundColor = [UIColor imageBackgroundColor];
    self.threeImg.layer.masksToBounds = YES;
    self.threeImg.layer.borderWidth = 0.5;
    self.threeImg.layer.borderColor = [UIColor imageLineColor].CGColor;
    self.threeImg.contentMode = UIViewContentModeScaleAspectFill;
    self.threeImg.tag = MainThreeImageTag;
    self.threeImg.userInteractionEnabled = YES;
    [self.contentView addSubview:self.threeImg];
    
    self.fourImg = [UIImageView new];
    self.fourImg.backgroundColor = [UIColor imageBackgroundColor];
    self.fourImg.layer.masksToBounds = YES;
    self.fourImg.contentMode = UIViewContentModeScaleAspectFill;
    self.fourImg.layer.borderWidth = 0.5;
    self.fourImg.layer.borderColor = [UIColor imageLineColor].CGColor;
    self.fourImg.tag = MainFourImageTag;
    self.fourImg.userInteractionEnabled = YES;
    [self.contentView addSubview:self.fourImg];
    
    self.fiveImg = [UIImageView new];
    self.fiveImg.backgroundColor = [UIColor imageBackgroundColor];
    self.fiveImg.layer.masksToBounds = YES;
    self.fiveImg.contentMode = UIViewContentModeScaleAspectFill;
    self.fiveImg.layer.borderWidth = 0.5;
    self.fiveImg.layer.borderColor = [UIColor imageLineColor].CGColor;
    self.fiveImg.tag = MainFiveImageTag;
    self.fiveImg.userInteractionEnabled = YES;
    [self.contentView addSubview:self.fiveImg];
    
    self.sixImg = [UIImageView new];
    self.sixImg.backgroundColor = [UIColor imageBackgroundColor];
    self.sixImg.layer.masksToBounds = YES;
    self.sixImg.contentMode = UIViewContentModeScaleAspectFill;
    self.sixImg.layer.borderWidth = 0.5;
    self.sixImg.layer.borderColor = [UIColor imageLineColor].CGColor;
    self.sixImg.tag = MainSixImageTag;
    self.sixImg.userInteractionEnabled = YES;
    [self.contentView addSubview:self.sixImg];
    
    self.sevenImg = [UIImageView new];
    self.sevenImg.backgroundColor = [UIColor imageBackgroundColor];
    self.sevenImg.layer.masksToBounds = YES;
    self.sevenImg.contentMode = UIViewContentModeScaleAspectFill;
    self.sevenImg.layer.borderWidth = 0.5;
    self.sevenImg.layer.borderColor = [UIColor imageLineColor].CGColor;
    self.sevenImg.tag = MainSevenImageTag;
    self.sevenImg.userInteractionEnabled = YES;
    [self.contentView addSubview:self.sevenImg];
    
    self.eightImg = [UIImageView new];
    self.eightImg.backgroundColor = [UIColor imageBackgroundColor];
    self.eightImg.layer.masksToBounds = YES;
    self.eightImg.contentMode = UIViewContentModeScaleAspectFill;
    self.eightImg.layer.borderWidth = 0.5;
    self.eightImg.layer.borderColor = [UIColor imageLineColor].CGColor;
    self.eightImg.tag = MainEightImageTag;
    self.eightImg.userInteractionEnabled = YES;
    [self.contentView addSubview:self.eightImg];
    
    self.nineImg = [UIImageView new];
    self.nineImg.backgroundColor = [UIColor imageBackgroundColor];
    self.nineImg.layer.masksToBounds = YES;
    self.nineImg.contentMode = UIViewContentModeScaleAspectFill;
    self.nineImg.layer.borderWidth = 0.5;
    self.nineImg.layer.borderColor = [UIColor imageLineColor].CGColor;
    self.nineImg.userInteractionEnabled = YES;
    self.nineImg.tag = MainNineImageTag;
    [self.contentView addSubview:self.nineImg];
    
    
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageClickWithIndex:)];
    [self.firstImg addGestureRecognizer:tap];
    
    
    UITapGestureRecognizer *secondTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageClickWithIndex:)];
    [self.secondImg addGestureRecognizer:secondTap];
    
    
    UITapGestureRecognizer *threeTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageClickWithIndex:)];
    [self.threeImg addGestureRecognizer:threeTap];
    
    
    UITapGestureRecognizer *fourTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageClickWithIndex:)];
    [self.fourImg addGestureRecognizer:fourTap];
    
    
    UITapGestureRecognizer *fiveTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageClickWithIndex:)];
    [self.fiveImg addGestureRecognizer:fiveTap];
    
    
    UITapGestureRecognizer *sixTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageClickWithIndex:)];
    [self.sixImg addGestureRecognizer:sixTap];
    
    
    UITapGestureRecognizer *sevenTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageClickWithIndex:)];
    [self.sevenImg addGestureRecognizer:sevenTap];
    
    
    UITapGestureRecognizer *eightTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageClickWithIndex:)];
    [self.eightImg addGestureRecognizer:eightTap];
    
    
    UITapGestureRecognizer *nineTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageClickWithIndex:)];
    [self.nineImg addGestureRecognizer:nineTap];
    
    self.locationV = [UIView new];
    self.locationV.backgroundColor = [UIColor colorWithR:241 g:241 b:241];
    self.locationV.layer.masksToBounds = YES;
    self.locationV.layer.cornerRadius = 4;
    [self.contentView addSubview:self.locationV];
    
    self.locationImg = [UIImageView new];
    self.locationImg.image = [UIImage imageNamed:@"icon_fx_dw"];
    [self.locationV addSubview:self.locationImg];
    
    self.locationLabel = [UILabel new];
    self.locationLabel.font = [UIFont systemFontOfSize:12];
    self.locationLabel.textColor = [UIColor annotationTextColor];
    self.locationLabel.text = @"上海市·外滩中心";
    [self.locationV addSubview:self.locationLabel];
    
    self.likeBtn = [UIButton new];
    [self.likeBtn setImage:[UIImage imageNamed:@"icon_fx_dz_n"] forState:UIControlStateNormal];
    [self.likeBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, -5)];
    self.likeBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    self.likeBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [self.likeBtn setTitleColor:[UIColor buttonTitleColor] forState:UIControlStateNormal];
    [self.likeBtn addTarget:self action:@selector(likeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.likeBtn];
    
    self.commentBtn = [UIButton new];
    self.commentBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [self.commentBtn setImage:[UIImage imageNamed:@"icon_fx_pl"] forState:UIControlStateNormal];
    [self.commentBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, -5)];
    self.commentBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [self.commentBtn setTitleColor:[UIColor buttonTitleColor] forState:UIControlStateNormal];
    [self.commentBtn addTarget:self action:@selector(commentbtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.commentBtn];
    
    self.lookBtn = [UIButton new];
    [self.lookBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, -5)];
    self.lookBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [self.lookBtn setImage:[UIImage imageNamed:@"icon_fx_yj"] forState:UIControlStateNormal];
    self.lookBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [self.lookBtn setTitleColor:[UIColor buttonTitleColor] forState:UIControlStateNormal];
    [self.lookBtn addTarget:self action:@selector(lookBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.lookBtn];
    
    self.lineV = [UIView new];
    self.lineV.backgroundColor = [UIColor viewBackColor];
    [self.contentView addSubview:self.lineV];
    
    
    [self.userImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView.mas_left).with.offset(15);
        make.height.width.mas_equalTo(36);
        make.top.mas_equalTo(25);
    }];
    
    [self.nickNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.userImg.mas_top).with.offset(0);
        make.left.mas_equalTo(self.userImg.mas_right).with.offset(9);
    }];
    
    [self.brandImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.nickNameLabel.mas_right).with.offset(5);
        make.centerY.mas_equalTo(self.nickNameLabel.mas_centerY);
        make.width.mas_equalTo(25);
        make.height.mas_equalTo(20);
    }];
    
    [self.dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.nickNameLabel.mas_left).with.offset(0);
        make.bottom.mas_equalTo(self.userImg.mas_bottom).with.offset(3);
    }];
    
    [self.rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.contentView.mas_right).with.offset(-15);
        make.centerY.mas_equalTo(self.nickNameLabel.mas_centerY).with.offset(0);
        make.width.mas_equalTo(30);
        make.height.mas_equalTo(20);
    }];
    
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.userImg.mas_bottom).with.offset(14);
        make.left.mas_equalTo(self.contentView.mas_left).with.offset(15);
        make.right.mas_equalTo(self.contentView.mas_right).with.offset(-15);
    }];
    
    if ([type integerValue] == MainMomentsDefault) {
        
        [self.locationV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.contentLabel.mas_bottom).with.offset(10);
            make.left.mas_equalTo(self.contentView.mas_left).with.offset(15);
            make.height.mas_equalTo(20);
            make.right.mas_lessThanOrEqualTo(self.contentView.mas_right).with.offset(-15);
        }];
        
    }else if ([type integerValue] == MainMomentsOneImageWidthCell) {
        
        [self.firstImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.contentLabel.mas_bottom).with.offset(14);
            make.left.mas_equalTo(-1);
            make.right.mas_equalTo(1);
            make.height.mas_equalTo(280);
        }];
        
        [self.locationV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.firstImg.mas_bottom).with.offset(10);
            make.left.mas_equalTo(self.contentView.mas_left).with.offset(15);
            make.height.mas_equalTo(20);
            make.right.mas_lessThanOrEqualTo(self.contentView.mas_right).with.offset(-15);
        }];
        
        
    }else if ([type integerValue] == MainMomentsOneImageHeightCell) {
        [self.firstImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.contentLabel.mas_bottom).with.offset(14);
            make.left.mas_equalTo(-1);
            make.right.mas_equalTo(1);
            make.height.mas_equalTo(470);
        }];
        
        [self.locationV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.firstImg.mas_bottom).with.offset(10);
            make.left.mas_equalTo(self.contentView.mas_left).with.offset(15);
            make.height.mas_equalTo(20);
            make.right.mas_lessThanOrEqualTo(self.contentView.mas_right).with.offset(-15);
        }];
        
        
    }else if ([type integerValue] == MainMomentsTwoImageCell) {
        
        [self.firstImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.contentLabel.mas_bottom).with.offset(14);
            make.left.mas_equalTo(self.contentView.mas_left).with.offset(-1);
            make.width.height.mas_equalTo((kSCREEN_WIDTH - 3)/2.0);
        }];
        
        [self.secondImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.firstImg.mas_right).with.offset(3);
            make.right.mas_equalTo(self.contentView.mas_right).with.offset(1);
            make.centerY.mas_equalTo(self.firstImg.mas_centerY);
            make.height.mas_equalTo(self.firstImg.mas_height);
        }];
        
        [self.locationV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.firstImg.mas_bottom).with.offset(10);
            make.left.mas_equalTo(self.contentView.mas_left).with.offset(15);
            make.height.mas_equalTo(20);
            make.right.mas_lessThanOrEqualTo(self.contentView.mas_right).with.offset(-15);
        }];
        
        
    }else if ([type integerValue] == MainMomentsThreeImageCell) {
        
        [self.firstImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.contentLabel.mas_bottom).with.offset(14);
            make.left.mas_equalTo(self.contentView.mas_left).with.offset(-1);
            make.width.height.mas_equalTo((kSCREEN_WIDTH/3)*2);
        }];
        
        [self.secondImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.firstImg.mas_right).with.offset(3);
            make.right.mas_equalTo(self.contentView.mas_right).with.offset(1);
            make.top.mas_equalTo(self.firstImg.mas_top).with.offset(0);
            make.height.mas_equalTo(((kSCREEN_WIDTH/3)*2 - 3)/2.0);
        }];
        
        [self.threeImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.firstImg.mas_right).with.offset(3);
            make.top.mas_equalTo(self.secondImg.mas_bottom).with.offset(3);
            make.right.mas_equalTo(self.contentView.mas_right).with.offset(1);
            make.bottom.mas_equalTo(self.firstImg.mas_bottom).with.offset(0);
        }];
        
        [self.locationV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.firstImg.mas_bottom).with.offset(10);
            make.left.mas_equalTo(self.contentView.mas_left).with.offset(15);
            make.height.mas_equalTo(20);
            make.right.mas_lessThanOrEqualTo(self.contentView.mas_right).with.offset(-15);
        }];
        
    }else if ([type integerValue] == MainMomentsFourImageCell) {
        
        [self.firstImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.contentLabel.mas_bottom).with.offset(14);
            make.left.mas_equalTo(self.contentView.mas_left).with.offset(-1);
            make.width.mas_equalTo((kSCREEN_WIDTH - 3)/2.0);
            make.height.mas_equalTo(140);
        }];
        
        [self.secondImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.firstImg.mas_right).with.offset(3);
            make.right.mas_equalTo(self.contentView.mas_right).with.offset(1);
            make.centerY.mas_equalTo(self.firstImg.mas_centerY);
            make.height.mas_equalTo(self.firstImg.mas_height);
        }];
        
        [self.threeImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.contentView.mas_left).with.offset(-1);
            make.right.mas_equalTo(self.firstImg.mas_right).with.offset(0);
            make.top.mas_equalTo(self.firstImg.mas_bottom).with.offset(3);
            make.height.mas_equalTo(self.firstImg.mas_height);
        }];
        
        [self.fourImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.threeImg.mas_right).with.offset(3);
            make.right.mas_equalTo(self.contentView.mas_right).with.offset(1);
            make.centerY.mas_equalTo(self.threeImg.mas_centerY);
            make.height.mas_equalTo(self.firstImg.mas_height);
        }];
        
        [self.locationV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.threeImg.mas_bottom).with.offset(10);
            make.left.mas_equalTo(self.contentView.mas_left).with.offset(15);
            make.height.mas_equalTo(20);
            make.right.mas_lessThanOrEqualTo(self.contentView.mas_right).with.offset(-15);
        }];
        
    }else if ([type integerValue] == MainMomentsFiveImageCell) {
        
        [self.firstImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.contentLabel.mas_bottom).with.offset(14);
            make.left.mas_equalTo(self.contentView.mas_left).with.offset(-1);
            make.width.mas_equalTo((kSCREEN_WIDTH - 3)/2.0);
            make.height.mas_equalTo(140);
        }];
        
        [self.secondImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.firstImg.mas_right).with.offset(3);
            make.right.mas_equalTo(self.contentView.mas_right).with.offset(1);
            make.centerY.mas_equalTo(self.firstImg.mas_centerY);
            make.height.mas_equalTo(self.firstImg.mas_height);
        }];
        
        [self.fourImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.contentView.mas_centerX).with.offset(0);
            make.top.mas_equalTo(self.firstImg.mas_bottom).with.offset(3);
            make.width.height.mas_equalTo((kSCREEN_WIDTH - 6)/3.0);
        }];
        
        [self.threeImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.firstImg.mas_left).with.offset(0);
            make.right.mas_equalTo(self.fourImg.mas_left).with.offset(-3);
            make.centerY.mas_equalTo(self.fourImg.mas_centerY).with.offset(0);
            make.bottom.mas_equalTo(self.fourImg.mas_bottom).with.offset(0);
        }];
        
        [self.fiveImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.fourImg.mas_right).with.offset(3);
            make.right.mas_equalTo(self.contentView.mas_right).with.offset(1);
            make.centerY.mas_equalTo(self.fourImg.mas_centerY);
            make.bottom.mas_equalTo(self.fourImg.mas_bottom).with.offset(0);
        }];
        
        [self.locationV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.threeImg.mas_bottom).with.offset(10);
            make.left.mas_equalTo(self.contentView.mas_left).with.offset(15);
            make.height.mas_equalTo(20);
            make.right.mas_lessThanOrEqualTo(self.contentView.mas_right).with.offset(-15);
        }];
        
    }else if ([type integerValue] == MainMomentsSixImageCell) {
        
        
        [self.firstImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.contentLabel.mas_bottom).with.offset(14);
            make.left.mas_equalTo(self.contentView.mas_left).with.offset(-1);
            make.right.mas_equalTo(self.secondImg.mas_left).with.offset(-3);
            make.height.mas_equalTo((kSCREEN_WIDTH - 6)/3.0);
        }];
        
        [self.secondImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.firstImg.mas_top).with.offset(0);
            make.centerX.mas_equalTo(self.contentView.mas_centerX).with.offset(0);
            make.height.width.mas_equalTo((kSCREEN_WIDTH - 6)/3.0);
        }];
        
        [self.threeImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.secondImg.mas_right).with.offset(3);
            make.right.mas_equalTo(self.contentView.mas_right).with.offset(1);
            make.centerY.mas_equalTo(self.secondImg.mas_centerY);
            make.bottom.mas_equalTo(self.secondImg.mas_bottom).with.offset(0);
        }];
        
        [self.fiveImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.contentView.mas_centerX).with.offset(0);
            make.top.mas_equalTo(self.secondImg.mas_bottom).with.offset(3);
            make.height.width.mas_equalTo(self.secondImg);
        }];
        
        [self.fourImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.firstImg.mas_left).with.offset(0);
            make.top.mas_equalTo(self.firstImg.mas_bottom).with.offset(3);
            make.right.mas_equalTo(self.firstImg.mas_right).with.offset(0);
            make.bottom.mas_equalTo(self.fiveImg.mas_bottom).with.offset(0);
        }];
        
        [self.sixImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.fiveImg.mas_right).with.offset(3);
            make.right.mas_equalTo(self.contentView.mas_right).with.offset(1);
            make.centerY.mas_equalTo(self.fiveImg.mas_centerY);
            make.bottom.mas_equalTo(self.fiveImg.mas_bottom).with.offset(0);
        }];
        
        [self.locationV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.fourImg.mas_bottom).with.offset(10);
            make.left.mas_equalTo(self.contentView.mas_left).with.offset(15);
            make.height.mas_equalTo(20);
            make.right.mas_lessThanOrEqualTo(self.contentView.mas_right).with.offset(-15);
        }];
        
    }else if ([type integerValue] == MainMomentsSevenImageCell) {
        
        [self.firstImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.contentLabel.mas_bottom).with.offset(14);
            make.left.mas_equalTo(self.contentView.mas_left).with.offset(-1);
            make.width.mas_equalTo((kSCREEN_WIDTH - 3)/2.0);
            make.height.mas_equalTo(140);
        }];
        
        [self.secondImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.firstImg.mas_right).with.offset(3);
            make.right.mas_equalTo(self.contentView.mas_right).with.offset(1);
            make.centerY.mas_equalTo(self.firstImg.mas_centerY);
            make.height.mas_equalTo(self.firstImg.mas_height);
        }];
        
        [self.fourImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.firstImg.mas_bottom).with.offset(3);
            make.centerX.mas_equalTo(self.contentView.mas_centerX).with.offset(0);
            make.width.height.mas_equalTo((kSCREEN_WIDTH - 6)/3.0);
        }];
        
        [self.threeImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.contentView.mas_left).with.offset(-1);
            make.top.mas_equalTo(self.fourImg.mas_top).with.offset(0);
            make.right.mas_equalTo(self.fourImg.mas_left).with.offset(-3);
            make.bottom.mas_equalTo(self.fourImg.mas_bottom).with.offset(0);
        }];
        
        [self.fiveImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.fourImg.mas_right).with.offset(3);
            make.right.mas_equalTo(self.contentView.mas_right).with.offset(1);
            make.centerY.mas_equalTo(self.fourImg.mas_centerY);
            make.bottom.mas_equalTo(self.fourImg.mas_bottom).with.offset(0);
        }];
        
        [self.sixImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.contentView.mas_left).with.offset(-1);
            make.top.mas_equalTo(self.threeImg.mas_bottom).with.offset(3);
            make.right.mas_equalTo(self.firstImg.mas_right).with.offset(0);
            make.height.mas_equalTo(self.firstImg);
        }];
        
        [self.sevenImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.sixImg.mas_right).with.offset(3);
            make.right.mas_equalTo(self.contentView.mas_right).with.offset(1);
            make.centerY.mas_equalTo(self.sixImg.mas_centerY);
            make.height.mas_equalTo(self.firstImg);
        }];
        
        [self.locationV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.sixImg.mas_bottom).with.offset(10);
            make.left.mas_equalTo(self.contentView.mas_left).with.offset(15);
            make.height.mas_equalTo(20);
            make.right.mas_lessThanOrEqualTo(self.contentView.mas_right).with.offset(-15);
        }];
        
    }else if ([type integerValue] == MainMomentsEightImageCell) {
        
        [self.firstImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.contentLabel.mas_bottom).with.offset(14);
            make.left.mas_equalTo(self.contentView.mas_left).with.offset(-1);
            make.width.mas_equalTo((kSCREEN_WIDTH - 3)/2.0);
            make.height.mas_equalTo(140);
        }];
        
        [self.secondImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.firstImg.mas_right).with.offset(3);
            make.right.mas_equalTo(self.contentView.mas_right).with.offset(1);
            make.centerY.mas_equalTo(self.firstImg.mas_centerY);
            make.height.mas_equalTo(self.firstImg);
        }];
        
        [self.fourImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.firstImg.mas_bottom).with.offset(3);
            make.centerX.mas_equalTo(self.contentView.mas_centerX).with.offset(0);
            make.width.height.mas_equalTo((kSCREEN_WIDTH - 6)/3.0);
        }];
        
        [self.threeImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.contentView.mas_left).with.offset(-1);
            make.right.mas_equalTo(self.fourImg.mas_left).with.offset(-3);
            make.top.mas_equalTo(self.fourImg.mas_top).with.offset(0);
            make.bottom.mas_equalTo(self.fourImg.mas_bottom).with.offset(0);
        }];
        
        
        [self.fiveImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.fourImg.mas_right).with.offset(3);
            make.right.mas_equalTo(self.contentView.mas_right).with.offset(1);
            make.centerY.mas_equalTo(self.fourImg.mas_centerY);
            make.bottom.mas_equalTo(self.fourImg.mas_bottom).with.offset(0);
        }];
        
        [self.sevenImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.fourImg.mas_bottom).with.offset(3);
            make.centerX.mas_equalTo(self.contentView.mas_centerX).with.offset(0);
            make.height.width.mas_equalTo(self.fourImg);
        }];
        
        [self.sixImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.contentView.mas_left).with.offset(-1);
            make.top.mas_equalTo(self.sevenImg.mas_top).with.offset(0);
            make.right.mas_equalTo(self.threeImg.mas_right).with.offset(0);
            make.bottom.mas_equalTo(self.sevenImg.mas_bottom).with.offset(0);
        }];
        
        [self.eightImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.sevenImg.mas_right).with.offset(3);
            make.right.mas_equalTo(self.contentView.mas_right).with.offset(1);
            make.centerY.mas_equalTo(self.sevenImg.mas_centerY);
            make.bottom.mas_equalTo(self.sevenImg.mas_bottom).with.offset(0);
        }];
        
        [self.locationV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.sixImg.mas_bottom).with.offset(10);
            make.left.mas_equalTo(self.contentView.mas_left).with.offset(15);
            make.height.mas_equalTo(20);
            make.right.mas_lessThanOrEqualTo(self.contentView.mas_right).with.offset(-15);
        }];
        
    }else if ([type integerValue] == MainMomentsNineImageCell) {
        
        [self.firstImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.contentLabel.mas_bottom).with.offset(14);
            make.left.mas_equalTo(self.contentView.mas_left).with.offset(-1);
            make.right.mas_equalTo(self.secondImg.mas_left).with.offset(-3);
            make.height.mas_equalTo((kSCREEN_WIDTH - 6)/3.0);
        }];
        
        [self.secondImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.firstImg.mas_top).with.offset(0);
            make.centerX.mas_equalTo(self.contentView.mas_centerX).with.offset(0);
            make.height.width.mas_equalTo((kSCREEN_WIDTH - 6)/3.0);
        }];
        
        [self.threeImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.secondImg.mas_right).with.offset(3);
            make.right.mas_equalTo(self.contentView.mas_right).with.offset(1);
            make.centerY.mas_equalTo(self.secondImg.mas_centerY);
            make.bottom.mas_equalTo(self.secondImg.mas_bottom).with.offset(0);
        }];
        
        [self.fiveImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.secondImg.mas_bottom).with.offset(3);
            make.centerX.mas_equalTo(self.secondImg.mas_centerX).with.offset(0);
            make.height.width.mas_equalTo(self.secondImg);
        }];
        
        [self.fourImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.contentView.mas_left).with.offset(-1);
            make.right.mas_equalTo(self.firstImg.mas_right).with.offset(0);
            make.bottom.mas_equalTo(self.fiveImg.mas_bottom).with.offset(0);
            make.top.mas_equalTo(self.fiveImg.mas_top).with.offset(0);
        }];
        
        
        [self.sixImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.fiveImg.mas_right).with.offset(3);
            make.right.mas_equalTo(self.contentView.mas_right).with.offset(1);
            make.top.mas_equalTo(self.fiveImg.mas_top).with.offset(0);
            make.bottom.mas_equalTo(self.fiveImg.mas_bottom).with.offset(0);
        }];
        
        [self.eightImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.fiveImg.mas_bottom).with.offset(3);
            make.centerX.mas_equalTo(self.secondImg.mas_centerX).with.offset(0);
            make.height.width.mas_equalTo(self.secondImg);
        }];
        
        [self.sevenImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.contentView.mas_left).with.offset(-1);
            make.top.mas_equalTo(self.eightImg.mas_top).with.offset(0);
            make.right.mas_equalTo(self.eightImg.mas_left).with.offset(-3);
            make.bottom.mas_equalTo(self.eightImg.mas_bottom).with.offset(0);
        }];
        
        [self.nineImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.eightImg.mas_right).with.offset(3);
            make.right.mas_equalTo(self.contentView.mas_right).with.offset(1);
            make.top.mas_equalTo(self.eightImg.mas_top).with.offset(0);
            make.bottom.mas_equalTo(self.eightImg.mas_bottom).with.offset(0);
        }];
        
        [self.locationV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.sevenImg.mas_bottom).with.offset(10);
            make.left.mas_equalTo(self.contentView.mas_left).with.offset(15);
            make.height.mas_equalTo(20);
            make.right.mas_lessThanOrEqualTo(self.contentView.mas_right).with.offset(-15);
        }];
        
    }
    
    [self.locationImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.locationV.mas_left).with.offset(10);
        make.centerY.mas_equalTo(self.locationV.mas_centerY).with.offset(0);
        make.width.mas_equalTo(8);
        make.height.mas_equalTo(10);
    }];
    
    [self.locationLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.locationImg.mas_right).with.offset(6);
        make.centerY.mas_equalTo(self.locationV.mas_centerY).with.offset(0);
        make.right.mas_equalTo(self.locationV.mas_right).with.offset(-8);
    }];
    
    [self.likeBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView.mas_left).with.offset(10);
        make.height.mas_equalTo(30);
        make.width.mas_greaterThanOrEqualTo(60);
        make.top.mas_equalTo(self.locationV.mas_bottom).with.offset(16);
    }];
    
    [self.commentBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.likeBtn.mas_right).with.offset(12);
        make.centerY.mas_equalTo(self.likeBtn.mas_centerY).with.offset(0);
        make.height.mas_equalTo(self.likeBtn);
        make.width.mas_lessThanOrEqualTo(@60);
    }];
    
    [self.lookBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.commentBtn.mas_right).with.offset(12);
        make.centerY.mas_equalTo(self.commentBtn.mas_centerY).with.offset(0);
        make.height.mas_equalTo(30);
        make.width.mas_greaterThanOrEqualTo(@60);
    }];
    
    
    [self.lineV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.contentView);
        make.height.mas_equalTo(0.7);
        make.top.mas_equalTo(self.lookBtn.mas_bottom).with.offset(23);
        make.bottom.mas_equalTo(self.contentView.mas_bottom).with.offset(0);
    }];
    
}

- (void)userImgClick:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(headImageClick:withId:)]) {
        [self.delegate headImageClick:self withId:_model.createUser];
    }
}

- (void)rightBtnClick:(UIButton *)sender {
    if (self.isSelf) {
        if ([self.delegate respondsToSelector:@selector(deleteCell:)]) {
            [self.delegate deleteCell:self.model];
        }
    }else {
        if ([self.delegate respondsToSelector:@selector(shareModelClick:withId:model:)]) {
            [self.delegate shareModelClick:self withId:self.model.ID model:self.model];
        }
    }
}

- (void)likeBtnClick:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(zanBuAddClick:withId:withLike:)]) {
        [self.delegate zanBuAddClick:self withId:self.model.ID withLike:likeStr];
    }
}

- (void)imageClickWithIndex:(UITapGestureRecognizer *)tap {
    if (kNotNil(self.model.imgs)) {
        UIImageView *img = (UIImageView *)tap.view;
        if ([self.delegate respondsToSelector:@selector(contentImageClick:index:)]) {
            [self.delegate contentImageClick:self.model.imgs index:img.tag - 100];
        }
    }
}
- (void)commentbtnClick:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(commentBtnClick:withID:)]) {
        [self.delegate commentBtnClick:self withID:self.model.createUser];
    }
    
}

- (void)lookBtnClick:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(lookBtnClick:withId:)]) {
        [self.delegate lookBtnClick:self withId:self.model.createUser];
    }
}

- (NSMutableArray *)imageArr {
    if (!_imageArr) {
        _imageArr = [NSMutableArray array];
    }
    return _imageArr;
}
+ (NSString *)mainMomentCellIDWith:(MainMomentCellType)type {
    return [NSString stringWithFormat:@"%ld",(long)type];
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
