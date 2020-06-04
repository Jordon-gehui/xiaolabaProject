//
//  BackMusicCell.m
//  xiaolaba
//
//  Created by 斯陈 on 2018/5/31.
//  Copyright © 2018年 jackzhang. All rights reserved.
//

#import "BackMusicCell.h"

@interface BackMusicCell()
@property (nonatomic ,strong)UIImageView *musicImg;
@property (nonatomic ,strong)UILabel *musicName;
@property (nonatomic ,strong)UILabel *musicTime;
@property (nonatomic ,strong)UIImageView *chooseImg;
@property (nonatomic ,strong)UIView *lineView;

@end
@implementation BackMusicCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
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
    self.musicImg = [UIImageView new];
    self.musicImg.image = [UIImage imageNamed:@"weitouxiang"];
    [self addSubview:self.musicImg];
    
    self.musicName = [UILabel new];
    self.musicName.textColor = [UIColor commonTextColor];
    self.musicName.font = [UIFont systemFontOfSize:16];
    [self addSubview:self.musicName];
    
    self.musicTime = [UILabel new];
    self.musicTime.textColor = [UIColor annotationTextColor];
    self.musicTime.font = [UIFont systemFontOfSize:13];
    [self addSubview:self.musicTime];
    
    self.chooseImg = [UIImageView new];
    self.chooseImg.image = [UIImage imageNamed:@"icon_syth_wx"];
    [self addSubview:self.chooseImg];
    
    _lineView = [UIView new];
    _lineView.backgroundColor = [UIColor lineColor];
    [self addSubview:_lineView];
    
}
-(void)setModel:(NSDictionary *)model choose:(BOOL)isChoose {
    [self.musicImg sd_setImageWithURL:[NSURL URLWithString:[JXutils judgeImageheader:[model objectForKey:@"value"] Withtype:IMGNormal]]];
    self.musicName.text = [model objectForKey:@"label"];
    self.musicTime.text = [model objectForKey:@"description"];
    if (isChoose) {
        self.chooseImg.image = [UIImage imageNamed:@"icon_syth_yx"];
    }else{
        self.chooseImg.image = [UIImage imageNamed:@"icon_syth_wx"];
    }
    [self layoutIfNeeded];
}
-(void)layoutSubviews {
    [self.musicImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.top.mas_equalTo(self).with.offset(10);
        make.width.height.mas_equalTo(45);
        make.bottom.mas_equalTo(self).with.offset(-10);
    }];
    [self.musicName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.musicImg).with.offset(5);
        make.left.mas_equalTo(self.musicImg.mas_right).with.offset(10);
        make.right.mas_equalTo(self.chooseImg.mas_left).with.offset(-10);
    }];
    [self.musicTime mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.musicName.mas_bottom).with.offset(5);
        make.left.mas_equalTo(self.musicImg.mas_right).with.offset(10);
        make.right.mas_equalTo(self.chooseImg.mas_left).with.offset(-10);
    }];
    [self.chooseImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self);
        make.right.mas_equalTo(self).with.offset(-15);
        make.width.height.mas_equalTo(23);
    }];
    [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(self.mas_right);
        make.height.mas_equalTo(@1);
        make.bottom.mas_equalTo(self);
    }];
}

@end

