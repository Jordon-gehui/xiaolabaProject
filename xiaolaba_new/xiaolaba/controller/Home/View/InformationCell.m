//
//  InformationCell.m
//  xiaolaba
//
//  Created by 斯陈 on 2018/4/25.
//  Copyright © 2018年 jackzhang. All rights reserved.
//

#import "InformationCell.h"

@interface InformationCell()
{
    UILabel*titleLbl;
    UIImageView *titleImg;
    UILabel *sourceLbl;
    UIImageView *seeImg;
    UILabel *seeLbl;
    UIView *lineV;
}
@end
@implementation InformationCell

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
    titleLbl.numberOfLines = 0;
    [self addSubview:titleLbl];
    
    titleImg =[UIImageView new];
    titleImg.layer.cornerRadius = 10;
    titleImg.layer.masksToBounds = YES;
    [titleImg setContentMode:UIViewContentModeScaleAspectFill];
    [self addSubview:titleImg];
    
    sourceLbl = [UILabel new];
    sourceLbl.font = [UIFont systemFontOfSize:12];
    sourceLbl.textColor = [UIColor textRightColor];
    [self addSubview:sourceLbl];
    
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
    [titleImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(10);
        make.right.mas_equalTo(self.mas_right).with.offset(-15);
        make.width.height.mas_equalTo(80);
        make.centerY.mas_equalTo(self);
    }];
    [titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(20);
        make.left.mas_equalTo(15);
        make.height.mas_lessThanOrEqualTo(40);
        make.right.mas_equalTo(titleImg.mas_left).with.offset(-15);
    }];
    [sourceLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(titleImg.mas_left).with.offset(-15);
        make.bottom.mas_equalTo(titleImg.mas_bottom).with.offset(-3);
    }];
    [seeLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(titleImg.mas_left).with.offset(-15);
        make.centerY.mas_equalTo(sourceLbl);
    }];
    [seeImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(20);
        make.height.mas_equalTo(20);
        make.right.mas_equalTo(seeLbl.mas_left).with.offset(-10);
        make.centerY.mas_equalTo(seeLbl);
    }];
    [lineV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(sourceLbl.mas_bottom).with.offset(12);
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(self).with.offset(-15);
        make.bottom.mas_equalTo(self);
        make.height.mas_equalTo(1);
    }];
}

-(void)setViewData:(id)dic {
    NSDictionary *tempDic = dic;
    titleLbl.text = [tempDic objectForKey:@"title"];
    NSArray *imgs = [tempDic objectForKey:@"imgs"];
    if ([imgs isKindOfClass:[NSArray class]]&& imgs.count>=1) {
        [titleImg sd_setImageWithURL:[NSURL URLWithString:[JXutils judgeImageheader:[imgs firstObject] Withtype:IMGNormal]] placeholderImage:nil];
    }else{
        titleImg.image = [UIImage imageNamed:@""];
    }
    NSString *string =[NSString stringWithFormat:@"%@·%@",[tempDic objectForKey:@"fromName"],[tempDic objectForKey:@"pushTime"]];
    sourceLbl.text = string;
    seeLbl.text = [NSString stringWithFormat:@"%@",[tempDic objectForKey:@"views"]];
    [self layoutIfNeeded];
}

+(NSString *)cellReuseIdentifier {
    return @"InformationCell";
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
