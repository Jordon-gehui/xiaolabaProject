//
//  homeSYRecommendCell.m
//  xiaolaba
//
//  Created by 斯陈 on 2018/4/25.
//  Copyright © 2018年 jackzhang. All rights reserved.
//

#import "homeSYRecommendCell.h"
#import "SLCycleScrollView.h"
#import "XLBDEvaluateView.h"

@interface homeSYRecommendCell()<SLCycleScrollViewDelegate,SLCycleScrollViewDatasource>
{
    UILabel *titleLbl;
    UILabel *titleRightLbl;
    SLCycleScrollView *syScrollView;
    UIView *scView;
    UIView *lineV;
    NSArray *sy_array;
    NSInteger is_sy;
}
@end
@implementation homeSYRecommendCell

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
    titleLbl.font = [UIFont boldSystemFontOfSize:16];
    titleLbl.textColor = [UIColor commonTextColor];
    [self addSubview:titleLbl];
    
    titleRightLbl = [UILabel new];
    titleRightLbl.font = [UIFont systemFontOfSize:13];
    titleRightLbl.textColor = [UIColor textRightColor];
    titleRightLbl.text = @"更多 >";
    [self addSubview:titleRightLbl];
    
    syScrollView = [[SLCycleScrollView alloc] initWithFrame:CGRectMake(0, 40, kSCREEN_WIDTH, 125)];
    [syScrollView setDelegate:self];
    [syScrollView setDataource:self];
    [syScrollView.pageControl setHidden:YES];
    [self addSubview:syScrollView];
    
    lineV = [UIView new];
    lineV.backgroundColor = [UIColor lineColor];
    [self addSubview:lineV];
}

- (void)layoutSubviews {
    [titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(20);
        make.left.mas_equalTo(15);
    }];
    [titleRightLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self).with.offset(-15);
        make.centerY.mas_equalTo(titleLbl);
    }];

    [lineV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(syScrollView.mas_bottom).with.offset(10);
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(self).with.offset(-15);
        make.bottom.mas_equalTo(self);
        make.height.mas_equalTo(1);
    }];
}

-(void)setViewData:(id)dic :(NSInteger)isSY {
    is_sy = isSY;
    sy_array = dic;
    if (is_sy) {
        [titleRightLbl setHidden:NO];
        titleLbl.text = @"声优推荐";
    }else{
        [titleRightLbl setHidden:YES];
        titleLbl.text = @"车友推荐";
    }
    [syScrollView reloadData];
    [syScrollView.pageControl setHidden:YES];
    [self layoutIfNeeded];
}

#pragma mark -SLCycleScrollViewDatasource
- (NSInteger)numberOfPages {
    return sy_array.count;
}

- (UIView *)pageAtIndex:(NSInteger)index {
    if(index >= sy_array.count-1) {
        index = index % sy_array.count;
    }
    NSDictionary *dic = [sy_array objectAtIndex:index];
    UIView *syView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, 125)];
    UIView *v = [[UIView alloc] initWithFrame:CGRectMake(15, 10, kSCREEN_WIDTH-30, 105)];
     v.layer.borderWidth = 1;
     v.layer.borderColor = [UIColor lineColor].CGColor;
     v.layer.cornerRadius = 10;
     v.layer.masksToBounds = YES;
    UIImageView *headerImg = [[UIImageView alloc]initWithFrame:CGRectMake(15, 15, 75, 75)];
    headerImg.layer.cornerRadius = 37.5;
    headerImg.layer.masksToBounds = YES;
    [headerImg sd_setImageWithURL:[NSURL URLWithString:[JXutils judgeImageheader:[dic objectForKey:@"img"] Withtype:IMGAvatar]] placeholderImage:[UIImage imageNamed:@"weitouxiang"]];
    [v addSubview:headerImg];
    UILabel *nicknameL = [UILabel new];
    nicknameL.font = [UIFont systemFontOfSize:16];
    nicknameL.textColor = [UIColor commonTextColor];
    nicknameL.text = [dic objectForKey:@"nickname"];
    [v addSubview:nicknameL];
    [nicknameL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(headerImg);
        make.left.mas_equalTo(headerImg.mas_right).with.offset(10);
    }];
    if (is_sy) { //声优推荐
        UILabel *contentL = [UILabel new];
        contentL.font = [UIFont systemFontOfSize:12];
        contentL.textColor = [UIColor annotationTextColor];
        NSString *contentStr = [NSString stringWithFormat:@"%@",[dic objectForKey:@"signature"]];
        if (kNotNil(contentStr)) {
            contentL.text = contentStr;
            
        }else{
            contentL.text = @"这个人很懒，什么也没留下";
        }
        [v addSubview:contentL];
        
        UIView *videoV = [UIView new];
        videoV.layer.masksToBounds = YES;
        videoV.layer.cornerRadius = 10;
        videoV.backgroundColor = [[UIColor textBlackColor] colorWithAlphaComponent:0.7];
        [v addSubview:videoV];
        
        UIImageView *videoImg = [UIImageView new];
        videoImg.layer.masksToBounds = YES;
        videoImg.layer.cornerRadius = 10;
        videoImg.image = [UIImage imageNamed:@"btn_sy_bf"];
        [v addSubview:videoImg];
        
        UILabel *videoLabel = [UILabel new];
        videoLabel.text = [NSString stringWithFormat:@"%@''",[dic objectForKey:@"voiceTime"]];
        videoLabel.textColor = [UIColor whiteColor];
        videoLabel.font = [UIFont systemFontOfSize:12];
        videoLabel.textAlignment = NSTextAlignmentCenter;
        [v addSubview:videoLabel];
        
        UIImageView *callImg = [[UIImageView alloc]initWithFrame:CGRectMake(15, 15, 75, 75)];
        callImg.image  =[UIImage imageNamed:@"icon_sy_th"];
        [v addSubview:callImg];
        UILabel *callLbl = [UILabel new];
        callLbl.font = [UIFont systemFontOfSize:11];
        callLbl.textColor = [UIColor minorTextColor];
        NSString* price;
        if (([[[XLBUser user].userModel.ID stringValue] isEqualToString:@"42327218134736896"] || [[[XLBUser user].userModel.ID stringValue] isEqualToString:@"22099512457715712"]) || (![XLBUser user].isLogin || !kNotNil([XLBUser user].token))) {
            price = @"";
        }else {
            price = [NSString stringWithFormat:@"%@车币/分",[dic objectForKey:@"priceAkira"]];
        }
        callLbl.text = price;
        [v addSubview:callLbl];

        [contentL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(nicknameL.mas_bottom).with.offset(10);
            make.left.mas_equalTo(nicknameL);
            make.right.mas_equalTo(callImg.mas_left).with.offset(-5);
        }];
        [videoV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(headerImg.mas_bottom);
            make.left.mas_equalTo(nicknameL);
            make.width.mas_equalTo(70);
            make.height.mas_equalTo(20);
        }];
        
        [videoImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(videoV.mas_left);
            make.width.height.mas_equalTo(20);
            make.centerY.mas_equalTo(videoV.mas_centerY);
        }];
        
        [videoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(videoImg.mas_right).with.offset(0);
            make.right.mas_equalTo(videoV.mas_right).with.offset(0);
            make.centerY.mas_equalTo(videoV.mas_centerY);
        }];
        [callImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(v.mas_right).with.offset(-30);
            make.centerY.mas_equalTo(v).with.offset(-10);
            make.width.height.mas_equalTo(28);
        }];
        [callLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(callImg.mas_bottom).with.offset(5);
            make.centerX.mas_equalTo(callImg);
        }];
    }else{
        NSLog(@"%@",dic);
        XLBFindUserModel *findModel = [XLBFindUserModel mj_objectWithKeyValues:dic];
        findModel.ID = [dic objectForKey:@"id"];
        NSMutableArray *tags = [NSMutableArray array];
        [[dic objectForKey:@"tags"] enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            UserTagsModel *tag = [UserTagsModel mj_objectWithKeyValues:obj];
            [tags addObject:tag];
        }];
        findModel.tags = tags;
        XLBDEvaluateView *tagV = [XLBDEvaluateView new];
        tagV.backgroundColor = [UIColor whiteColor];
        [tagV setFont:7];
        [tagV setlHeight:12];
        [tagV setLwidth:15];
        [tagV setRadius:2];
        [v addSubview:tagV];
        [tagV insertSign:findModel.tags];

        UILabel *informationLbl = [UILabel new];
        NSRange range = [findModel.distance rangeOfString:@"--"];
        NSString*locationStr = @"";
        if ([[XLBUser user].userModel.city isEqualToString:findModel.city]) {
            if (kNotNil(findModel.district)) {
                locationStr = [NSString stringWithFormat:@"%@",findModel.district];
                
            }
        }else{
            if (kNotNil(findModel.city)) {
                locationStr = [NSString stringWithFormat:@"%@",findModel.city];
            }
        }
        if (locationStr.length>6) {
            locationStr =[NSString stringWithFormat:@"%@...",[locationStr substringToIndex:6]];
        }
        if (range.location == NSNotFound){
            if (!kNotNil(locationStr)) {
                locationStr = [NSString stringWithFormat:@"%@ • %@",findModel.distance,[ZZCHelper dateStringFromNow:findModel.updateDate]];
            }else{
                locationStr = [NSString stringWithFormat:@"%@  %@ • %@",locationStr,findModel.distance,[ZZCHelper dateStringFromNow:findModel.updateDate]];
            }
            
        }else{
            if (!kNotNil(locationStr)) {
                locationStr = [NSString stringWithFormat:@"%@",[ZZCHelper dateStringFromNow:findModel.updateDate]];
            }else{
                locationStr = [NSString stringWithFormat:@"%@ • %@",locationStr,[ZZCHelper dateStringFromNow:findModel.updateDate]];
            }
        }
        informationLbl.text = locationStr;
        informationLbl.textColor = [UIColor minorTextColor];
        informationLbl.font = [UIFont systemFontOfSize:12];
        [v addSubview:informationLbl];
        UIImageView *carImg = [UIImageView new];
        [v addSubview:carImg];
        UIImageView *brandImg = [UIImageView new];
        [v addSubview:brandImg];
        [carImg sd_setImageWithURL:[NSURL URLWithString:findModel.serieImg] placeholderImage:nil];
        [brandImg sd_setImageWithURL:[NSURL URLWithString:[JXutils judgeImageheader:findModel.brandImg Withtype:IMGNormal]]];
        [tagV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(nicknameL.mas_bottom).with.offset(10);
            make.left.mas_equalTo(nicknameL);
            make.height.mas_equalTo(25);
            make.right.mas_equalTo(carImg.mas_left).with.offset(-5);
        }];
        [informationLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(tagV.mas_bottom).with.offset(10);
            make.left.mas_equalTo(nicknameL);
            make.height.mas_equalTo(18);
            make.right.mas_equalTo(carImg.mas_left).with.offset(-5);
        }];
        [carImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(v.mas_right).with.offset(-30);
            make.centerY.mas_equalTo(v);
            make.width.height.mas_equalTo(75);
            make.width.mas_equalTo(75);
            make.height.mas_equalTo(75*3/4);
        }];
        [brandImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(carImg.mas_top);
            make.right.mas_equalTo(carImg.mas_left);
            make.width.mas_equalTo(25);
            make.height.mas_equalTo(20);
        }];
    }
    [syView addSubview:v];

    return syView;
}

#pragma mark -SLCycleScrollViewDelegate
- (void)didClickPage:(SLCycleScrollView *)csView atIndex:(NSInteger)index {
    if(index >= sy_array.count-1) {
        index = index % sy_array.count;
    }
    NSDictionary *dic = [sy_array objectAtIndex:index];
    NSString *userId = [NSString stringWithFormat:@"%@",[dic objectForKey:@"id"]];
    if ([self.delegate respondsToSelector:@selector(didSeletedWithuserId::)]) {
        [self.delegate didSeletedWithuserId:userId :is_sy];
    }
}

+(NSString *)cellReuseIdentifier {
    return @"homeSYRecommendCell";
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}
@end
