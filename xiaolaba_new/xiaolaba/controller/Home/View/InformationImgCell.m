//
//  InformationImgCell
//  xiaolaba
//
//  Created by 斯陈 on 2018/4/25.
//  Copyright © 2018年 jackzhang. All rights reserved.
//

#import "InformationImgCell.h"

@interface InformationImgCell()
{
    UILabel*titleLbl;
    
    UIImageView *titleImg;
    
    UIImageView *threeLeftImg;
    UIImageView *threeTopRightImg;
    UIImageView *threeBottomRightImg;

    UILabel *timeLbl;
    UIImageView *seeImg;
    UILabel *seeLbl;
    
    UIView *lineV;
}
@end

@implementation InformationImgCell
#define kCellOneImg @"cellOneImg"
#define kCellThreeImg @"cellThreeImg"

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self initializer];
    }
    return self;
}

- (id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self initializer];
    }
    return self;
}
-(void)initializer {
    titleLbl = [UILabel new];
    titleLbl.font = [UIFont systemFontOfSize:16];
    titleLbl.textColor = [UIColor commonTextColor];
    [self addSubview:titleLbl];
    
    if ([self.reuseIdentifier isEqualToString:kCellOneImg]) {
        titleImg =[UIImageView new];
        titleImg.layer.cornerRadius = 10;
        titleImg.layer.masksToBounds = YES;
        [titleImg setContentMode:UIViewContentModeScaleAspectFill];
        [self addSubview:titleImg];
    }else{
        threeLeftImg =[UIImageView new];
        [self addSubview:threeLeftImg];
        
        threeTopRightImg =[UIImageView new];
        [self addSubview:threeTopRightImg];
        
        threeBottomRightImg =[UIImageView new];
        [self addSubview:threeBottomRightImg];
        [threeLeftImg setContentMode:UIViewContentModeScaleAspectFill];
        [threeTopRightImg setContentMode:UIViewContentModeScaleAspectFill];
        [threeBottomRightImg setContentMode:UIViewContentModeScaleAspectFill];
    }
    
    timeLbl = [UILabel new];
    timeLbl.font = [UIFont systemFontOfSize:13];
    timeLbl.textColor = [UIColor textRightColor];
    [self addSubview:timeLbl];
    
    seeImg = [UIImageView new];
    seeImg.image = [UIImage imageNamed:@"icon_kan"];
    [self addSubview:seeImg];
    
    seeLbl = [UILabel new];
    seeLbl.font = [UIFont systemFontOfSize:13];
    seeLbl.textColor = [UIColor textRightColor];
    [self addSubview:seeLbl];
    
    lineV = [UIView new];
    lineV.backgroundColor = [UIColor lineColor];
    [self addSubview:lineV];
}

- (void)layoutSubviews {
    [titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(15);
        make.left.mas_equalTo(15);
        make.width.mas_equalTo(kSCREEN_WIDTH -30);
    }];
    if ([self.reuseIdentifier isEqualToString:kCellOneImg]) {
        [titleImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(titleLbl.mas_bottom).with.offset(10);
            make.left.mas_equalTo(15);
            make.right.mas_equalTo(-15);
            make.height.mas_equalTo((kSCREEN_WIDTH-30)*140/345);
        }];
        [timeLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(titleImg.mas_bottom).with.offset(12);
            make.left.mas_equalTo(15);
        }];
    }else{
        [threeLeftImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(titleLbl.mas_bottom).with.offset(10);
            make.left.mas_equalTo(15);
            make.width.mas_equalTo((kSCREEN_WIDTH-35)*2/3.0);
            make.height.mas_equalTo((kSCREEN_WIDTH-30)*140/345);
        }];
        
        [threeTopRightImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(titleLbl.mas_bottom).with.offset(10);
            make.left.mas_equalTo(threeLeftImg.mas_right).with.offset(5);
            make.width.mas_equalTo((kSCREEN_WIDTH-35)/3.0);
            make.height.mas_equalTo((kSCREEN_WIDTH-30)*140/345/2.0-2.5);
        }];
        [threeBottomRightImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(threeTopRightImg.mas_bottom).with.offset(5);
            make.left.mas_equalTo(threeTopRightImg);
            make.width.mas_equalTo((kSCREEN_WIDTH-35)/3.0);
            make.height.mas_equalTo((kSCREEN_WIDTH-30)*140/345/2.0-2.5);
        }];
        
        [timeLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(threeLeftImg.mas_bottom).with.offset(12);
            make.left.mas_equalTo(15);
        }];
    }
    
    [seeLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15);
        make.centerY.mas_equalTo(timeLbl);
    }];
    [seeImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(20);
        make.height.mas_equalTo(20);
        make.right.mas_equalTo(seeLbl.mas_left).with.offset(-10);
        make.centerY.mas_equalTo(seeLbl);
    }];
    [lineV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(seeLbl.mas_bottom).with.offset(10);
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(self).with.offset(-15);
        make.bottom.mas_equalTo(self);
        make.height.mas_equalTo(1);
    }];
    threeLeftImg.layer.mask = [ZZCHelper cornerRadiusUIBezierPath:XLBRoundCornerCellTypeLeft :threeLeftImg.bounds size:CGSizeMake(10, 10)];
    threeTopRightImg.layer.mask = [ZZCHelper cornerRadiusUIBezierPath:XLBRoundCornerCellTypeTopRight :threeTopRightImg.bounds size:CGSizeMake(10, 10)];
    threeBottomRightImg.layer.mask = [ZZCHelper cornerRadiusUIBezierPath:XLBRoundCornerCellTypeBottomRight :threeBottomRightImg.bounds size:CGSizeMake(10, 10)];

}

-(void)setViewData:(id)dic {
    NSDictionary *tempDic = dic;
    titleLbl.text = [tempDic objectForKey:@"title"];
    NSArray *imgs = [tempDic objectForKey:@"imgs"];
    
    //model 1大图  3 多图
    NSString *modelStr = [NSString stringWithFormat:@"%@",[dic objectForKey:@"mode"]];

    if ([modelStr isEqualToString:@"1"]) {
        if ([imgs isKindOfClass:[NSArray class]]&& imgs.count>=1) {
            [titleImg sd_setImageWithURL:[NSURL URLWithString:[JXutils judgeImageheader:[imgs firstObject] Withtype:IMGNormal]] placeholderImage:nil];
        }else{
            titleImg.image = [UIImage imageNamed:@""];
        }
    }else{
        if ([imgs isKindOfClass:[NSArray class]]&& imgs.count==3) {
            [threeLeftImg sd_setImageWithURL:[NSURL URLWithString:[JXutils judgeImageheader:[imgs firstObject] Withtype:IMGNormal]] placeholderImage:nil];
            [threeTopRightImg sd_setImageWithURL:[NSURL URLWithString:[JXutils judgeImageheader:imgs[1] Withtype:IMGNormal]] placeholderImage:nil];
            [threeBottomRightImg sd_setImageWithURL:[NSURL URLWithString:[JXutils judgeImageheader:imgs[2] Withtype:IMGNormal]] placeholderImage:nil];
        }else{
            threeLeftImg.image = [UIImage imageNamed:@""];
            threeTopRightImg.image = [UIImage imageNamed:@""];
            threeBottomRightImg.image = [UIImage imageNamed:@""];
        }
    }
    timeLbl.text = [NSString stringWithFormat:@"%@",[tempDic objectForKey:@"pushTime"]];

    seeLbl.text = [NSString stringWithFormat:@"%@",[tempDic objectForKey:@"views"]];

    [self layoutIfNeeded];
}

+(NSString *)cellOneIdentifier {
    return kCellOneImg;
}
+(NSString *)cellImgsIdentifier{
    return kCellThreeImg;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
