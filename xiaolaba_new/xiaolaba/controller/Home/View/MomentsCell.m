//
//  MomentsCell.m
//  xiaolaba
//
//  Created by 斯陈 on 2017/10/21.
//  Copyright © 2017年 jackzhang. All rights reserved.
//

#import "MomentsCell.h"
#import "XLBDEvaluateView.h"

@interface MomentsCell()
{
    UITableViewCellStyle cellStyle;
//    UIButton *headerView;
    UILabel *nameLbl;
    UILabel *timeLbl;
//    UIButton *followBtn;
    XLBDEvaluateView *eveView;
    UILabel *contentLbl;
    UIImageView *oneImgView;
    UIImageView *twoImgView;
    UIImageView *thirdImgView;
    UIButton *lastBtn;
    
    UIImageView *locationView;
    UILabel *locationLbl;
//    UIButton *likeBtn;
    UIButton *commentBtn;
    UIButton *seeBtn;
    UIView *lineV;
    
    NSString *likedStr; //1 是已点赞 0是未点赞
}
@property(nonatomic,assign)CGFloat cellHeight;
@property(nonatomic,assign)BOOL isFollows;

@property(nonatomic,assign)BOOL hanggao;

@end
/*
 UITableViewCellStyleDefault, 纯文字
 UITableViewCellStyleValue1,     一张图
 UITableViewCellStyleValue2      多张图
 */
static NSString *const celldef = @"celldef"; //UITableViewCellStyleDefault, 纯文字
static NSString *const cellvalue1 = @"cellvalue1";// UITableViewCellStyleValue1,     一张图
static NSString *const cellvalue2 = @"cellvalue2";// UITableViewCellStyleValue2      多张图

@implementation MomentsCell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self initViewWith:style];
        cellStyle = style;
    }
    return self;
}
-(void)initViewWith:(UITableViewCellStyle)style{
    _hanggao = NO;
    _headerView = [UIButton new];
    _headerView.layer.cornerRadius = 20;
    _headerView.layer.masksToBounds = YES;
    [_headerView addTarget:self action:@selector(headerViewClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_headerView];
    nameLbl = [UILabel new];
    nameLbl.font = [UIFont systemFontOfSize:14];
    [self addSubview:nameLbl];
    
    _followBtn = [UIButton new];
    [_followBtn addTarget:self action:@selector(followBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_followBtn];
    
    timeLbl = [UILabel new];
    timeLbl.font = [UIFont systemFontOfSize:12];
    timeLbl.textColor = [UIColor colorWithR:145 g:145 b:145];
    [self addSubview:timeLbl];
    eveView = [XLBDEvaluateView new];
    eveView.backgroundColor = [UIColor whiteColor];
    [eveView setFont:7];
    [eveView setlHeight:12];
    [eveView setLwidth:15];
    [eveView setRadius:2];
    [self addSubview:eveView];
    contentLbl = [UILabel new];
    contentLbl.font = [UIFont systemFontOfSize:15];
    contentLbl.textColor = [UIColor colorWithR:145 g:145 b:145];
    contentLbl.numberOfLines = 0;
    [self addSubview:contentLbl];
    
    if (self.reuseIdentifier == cellvalue1) {
        oneImgView = [UIImageView new];
        oneImgView.contentMode = UIViewContentModeScaleAspectFill;
        oneImgView.layer.cornerRadius = 10;
        oneImgView.layer.masksToBounds = YES;
        [self addSubview:oneImgView];
    }
    if (self.reuseIdentifier == cellvalue2) {
        oneImgView = [UIImageView new];
        oneImgView.contentMode = UIViewContentModeScaleAspectFill;
        oneImgView.layer.cornerRadius = 10;
        oneImgView.layer.masksToBounds = YES;
        [self addSubview:oneImgView];
        
        twoImgView = [UIImageView new];
        twoImgView.contentMode = UIViewContentModeScaleAspectFill;
        twoImgView.layer.cornerRadius = 10;
        twoImgView.layer.masksToBounds = YES;
        [self addSubview:twoImgView];

        thirdImgView = [UIImageView new];
        thirdImgView.contentMode = UIViewContentModeScaleAspectFill;
        thirdImgView.layer.cornerRadius = 10;
        thirdImgView.layer.masksToBounds = YES;
        [self addSubview:thirdImgView];
        
        lastBtn = [UIButton new];
        lastBtn.backgroundColor = [UIColor textBlackColor];
        lastBtn.alpha = 0.6;
        lastBtn.layer.borderWidth = 0.5;
        [lastBtn.layer setMasksToBounds:YES];
        [lastBtn.layer setCornerRadius:10];
        lastBtn.titleLabel.font = [UIFont systemFontOfSize:30];
        lastBtn.userInteractionEnabled = YES;
        [lastBtn setTitle:@"查看更多" forState:UIControlStateNormal];
        [lastBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        lastBtn.enabled = NO;
        lastBtn.hidden = NO;
        [self addSubview:lastBtn];
    }
    locationView = [UIImageView new];
    locationView.image = [UIImage imageNamed:@"icon_fx_dw"];
    [self addSubview:locationView];
    
    locationLbl = [UILabel new];
    locationLbl.textColor = [UIColor colorWithR:153 g:153 b:153];
    locationLbl.font = [UIFont systemFontOfSize:11];
    [self addSubview:locationLbl];
    
    _likeBtn = [UIButton new];
    [_likeBtn setEnlargeEdge:8];

    [_likeBtn setTitleColor:[UIColor colorWithR:153 g:153 b:153] forState:0];
    _likeBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [_likeBtn addTarget:self action:@selector(likeClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_likeBtn];
    
    commentBtn = [UIButton new];
    [commentBtn setTitleColor:[UIColor colorWithR:153 g:153 b:153] forState:0];
    [commentBtn setImage:[UIImage imageNamed:@"icon_home_pl"] forState:0];
    [commentBtn setUserInteractionEnabled:NO];
    [commentBtn addTarget:self action:@selector(commentClick:) forControlEvents:UIControlEventTouchUpInside];
    commentBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [self addSubview:commentBtn];
    
    seeBtn = [UIButton new];
    [seeBtn setTitleColor:[UIColor colorWithR:153 g:153 b:153] forState:0];
    [seeBtn setImage:[UIImage imageNamed:@"pic_home_ll"] forState:0];
    [seeBtn setUserInteractionEnabled:NO];
    seeBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [self addSubview:seeBtn];
    
    lineV = [UIView new];
    lineV.backgroundColor = [UIColor lineColor];
    [self addSubview:lineV];

}
-(void)headerViewClick:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(headImageClick:withId:)]) {
        [self.delegate headImageClick:self withId:_cellModel.createUser];
    }
}
-(void)followBtnClick:(UIButton *)sender {
    if (_isSelf) {
        if ([self.delegate respondsToSelector:@selector(deleteCell:)]) {
            [self.delegate deleteCell:_cellModel];
        }
    }else{
        if ([self.delegate respondsToSelector:@selector(followClick:withId:)]) {
            [self.delegate followClick:self withId:_cellModel.createUser];
        }
    }
    
}
-(void)likeClick:(UIButton *)sender {
    if (self.delegate) {
        [self.delegate zanBuAddClick:self withId:_cellModel.ID withLike:likedStr];
    }
}
-(void)commentClick:(UIButton *)sender {
    if (self.delegate) {
        [self.delegate reportClick:self];
    }
}
-(void)setModel:(LittleHornTableViewModel*)model {
    _cellModel = model;
    NSString *creatUser = [NSString stringWithFormat:@"%@",[XLBUser user].userModel.ID];
    if ([creatUser isEqualToString:model.createUser]) {
        if (_isSelf) {
            [_followBtn setImage:[UIImage imageNamed:@"icon_sc"] forState:0];
        }else {
            _followBtn.hidden = YES;
        }
    }else{
        _followBtn.hidden = NO;
        self.isFollows = [model.follows isEqualToString:@"1"];
    }
    [_headerView sd_setImageWithURL:[NSURL URLWithString:[JXutils judgeImageheader:model.avatar Withtype:IMGAvatar]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"weitouxiang"]];
    nameLbl.text = model.nickName;
    timeLbl.text = model.publishDate;
    [eveView insertSign:model.tags];

    if ([model.moment hasSuffix:@"\n"]) {
        NSString *b = [model.moment stringByReplacingOccurrencesOfString:@"\n" withString:@" "];
        contentLbl.text = b;
    }else{
        contentLbl.text = model.moment;
    }
    if (self.reuseIdentifier == cellvalue1) {
        NSString *urlStrAll = [JXutils judgeImageheader:model.imgs[0] Withtype:IMGMoment];
        oneImgView.image = nil;
        [oneImgView sd_setImageWithURL:[NSURL URLWithString:urlStrAll] placeholderImage:[UIImage imageNamed:@"pic_home_jz"]];

    }else if(self.reuseIdentifier == cellvalue2) {
        [oneImgView setImage:nil];
        NSString *urlStrAll = [JXutils judgeImageheader:model.imgs[0] Withtype:IMGMoment];
        [oneImgView sd_setImageWithURL:[NSURL URLWithString:urlStrAll] placeholderImage:[UIImage imageNamed:@"pic_home_jz"]];
        [twoImgView setImage:nil];
        NSString *urlStrAll1 = [JXutils judgeImageheader:model.imgs[1] Withtype:IMGMoment];
        [twoImgView sd_setImageWithURL:[NSURL URLWithString:urlStrAll1] placeholderImage:[UIImage imageNamed:@"pic_home_jz"]];
        if (model.imgs.count >=3) {
            [thirdImgView setImage:nil ];
            NSString *urlStrAll2 = [JXutils judgeImageheader:model.imgs[2] Withtype:IMGMoment];
            [thirdImgView sd_setImageWithURL:[NSURL URLWithString:urlStrAll2] placeholderImage:[UIImage imageNamed:@"pic_home_jz"]];
        }else {
            [thirdImgView setImage:nil];
        }
        NSString *countImageCount = [NSString stringWithFormat:@"+ %ld",model.imgs.count-3];
        lastBtn.titleLabel.numberOfLines = 0;
        lastBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        lastBtn.titleLabel.textAlignment = 1;
        [lastBtn setTitle:countImageCount forState:UIControlStateNormal];
        if(model.imgs.count > 3){
            lastBtn.hidden = NO;
        }else{
            lastBtn.hidden = YES;
        }
    }
    if (kNotNil(model.location)) {
        locationLbl.text = model.location;
        locationView.hidden = NO;
        locationLbl.hidden = NO;
        [_likeBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(locationView.mas_bottom).with.offset(10);
            make.left.mas_offset(15);
            make.height.mas_equalTo(30);
        }];
    }else {
        locationView.hidden = YES;
        locationLbl.hidden = YES;
        [_likeBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(locationView);
            make.left.mas_offset(15);
            make.height.mas_equalTo(30);
        }];
    }
    likedStr = model.liked;
    if (![model.liked isEqualToString:@"0"]) {
        [_likeBtn setImage:[UIImage imageNamed:@"icon_fx_dz_s"] forState:UIControlStateNormal];
    }else{
        [_likeBtn setImage:[UIImage imageNamed:@"icon_fx_dz_n"] forState:UIControlStateNormal];
    }
    
    [_likeBtn setTitle:[NSString stringWithFormat:@" %@",kNotNil(model.likes)?model.likes:@"0"] forState:0];
    //评论
    [commentBtn setTitle:[NSString stringWithFormat:@" %@",kNotNil(model.discussCount)?model.discussCount:@"0"]  forState:0];
    //查看
    [seeBtn setTitle:[NSString stringWithFormat:@" %@",kNotNil(model.views)?model.views:@"0"]  forState:0];

    [self layoutIfNeeded];
}

- (void)downloadImage:(NSString *)imageURL forIndexPath:(NSIndexPath *)indexPath {
    // 利用 SDWebImage 框架提供的功能下载图片
    [[SDWebImageDownloader sharedDownloader] downloadImageWithURL:[NSURL URLWithString:imageURL] options:SDWebImageDownloaderUseNSURLCache progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        // do nothing
    } completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished) {
        [[SDImageCache sharedImageCache] storeImage:image forKey:imageURL toDisk:YES];
        [self reloadCell];
    }];
}
-(void) reloadCell {
    if (self.delegate) {
        [self.delegate cellReLoadDelegate:self.indexPath];
    }
}
-(void)setIsFollows:(BOOL)isFollows {
    _isFollows = isFollows;
    //关注
    if (_isFollows) {
        _followBtn.selected = YES;
        [_followBtn setBackgroundImage:[UIImage imageNamed:@"btn_ygz-1"] forState:UIControlStateNormal];
    }else{
        _followBtn.selected = NO;
        [_followBtn setBackgroundImage:[UIImage imageNamed:@"btn_gz-1"] forState:UIControlStateNormal];
    }
}
-(void)layoutSubviews {
    [_headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self).with.offset(20);
        make.left.mas_equalTo(self).with.offset(15);
        make.height.width.with.mas_equalTo(40);
    }];
    [nameLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_headerView.mas_right).with.offset(10);
        make.top.mas_equalTo(_headerView.mas_top);
        make.right.lessThanOrEqualTo(_followBtn.mas_left).with.offset(-10);
    }];
    [timeLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(nameLbl);
        make.bottom.mas_equalTo(_headerView.mas_bottom);
        make.right.lessThanOrEqualTo(_followBtn.mas_left).with.offset(-10);
    }];
    [_followBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_offset(60);
        make.height.mas_offset(30);
        if (_isSelf) {
            make.right.mas_equalTo(self).with.offset(-5);
        }else {
            make.right.mas_equalTo(self).with.offset(-15);
        }
        make.top.mas_equalTo(nameLbl);
    }];
    [eveView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(-15);
        make.top.mas_equalTo(_headerView.mas_bottom).with.offset(10);
        make.height.mas_equalTo(15);
    }];
    [contentLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.top.mas_equalTo(eveView.mas_bottom).with.offset(10);
        make.right.mas_equalTo(-15);
    }];
    if(self.reuseIdentifier == cellvalue1) {
        [oneImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(contentLbl.mas_bottom).with.offset(10);
            make.left.mas_offset(15);
            make.width.mas_lessThanOrEqualTo(kSCREEN_WIDTH * 2 / 3.0);
            make.height.mas_equalTo(kSCREEN_WIDTH * 2 / 3.0);
        }];
        [locationView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(oneImgView.mas_bottom).with.offset(10);
            make.width.mas_equalTo(8);
            make.height.mas_equalTo(10);
            make.left.mas_equalTo(_headerView);
        }];
    }else if(self.reuseIdentifier == cellvalue2) {
        [oneImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(contentLbl.mas_bottom).with.offset(10);
            make.left.mas_equalTo(self).with.offset(15);
            make.width.height.mas_equalTo(@((kSCREEN_WIDTH - 50)/3.0));
        }];
        [twoImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(oneImgView);
            make.left.mas_equalTo(oneImgView.mas_right).with.offset(10);
            make.width.height.mas_equalTo(@((kSCREEN_WIDTH - 50)/3.0));
        }];
        [thirdImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(oneImgView);
            make.left.mas_equalTo(twoImgView.mas_right).with.offset(10);
            make.width.height.mas_equalTo(@((kSCREEN_WIDTH - 50)/3.0));
        }];
        [lastBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(oneImgView);
            make.left.mas_equalTo(twoImgView.mas_right).with.offset(10);
            make.width.height.mas_equalTo(@((kSCREEN_WIDTH - 50)/3.0));
        }];
        
        [locationView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(oneImgView.mas_bottom).with.offset(10);
            make.width.mas_equalTo(8);
            make.height.mas_equalTo(10);
            make.left.mas_equalTo(_headerView);
        }];
    }else {
        [locationView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(contentLbl.mas_bottom).with.offset(10);
            make.width.mas_equalTo(8);
            make.height.mas_equalTo(10);
            make.left.mas_equalTo(_headerView);
        }];
        
    }
    [locationLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(locationView);
        make.left.mas_equalTo(locationView.mas_right).with.offset(5);
    }];
    [_likeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(locationView.mas_bottom).with.offset(10);
        make.left.mas_offset(15);
        make.height.mas_equalTo(30);
    }];
    [commentBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_likeBtn.mas_right).with.offset(10);
        make.top.mas_equalTo(_likeBtn);
        make.height.mas_equalTo(30);
    }];
    [seeBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(commentBtn.mas_right).with.offset(10);
        make.top.mas_equalTo(_likeBtn);
        make.height.mas_equalTo(30);
    }];
    [lineV mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_likeBtn.mas_bottom).with.offset(10);
        make.width.mas_equalTo(self);
        make.height.mas_equalTo(@0.5);
        make.left.mas_equalTo(self);
        make.bottom.mas_equalTo(self.mas_bottom);
    }];
//    NSLog(@"++++++%lf",lineV.frame.origin.y);
//    if (lineV.frame.origin.y>44) {
//        self.cellHeight = lineV.frame.origin.y;
//    }
}
-(CGFloat) cellHeight {
    if (self.cellHeight > 0) {
        return self.cellHeight;
    }
    return 0;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
