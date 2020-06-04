//
//  MsgDeatilCell.m
//  xiaolaba
//
//  Created by 斯陈 on 2017/9/25.
//  Copyright © 2017年 jackzhang. All rights reserved.
//

#import "MsgDeatilCell.h"

@interface MsgDeatilCell()
@property (nonatomic,strong)UIImageView *headerView;
@property (nonatomic,strong)UILabel *nameLbl;
@property (nonatomic,strong)UIImageView *rightImgV;

@property (nonatomic,strong)UILabel *titleLbl;

@end
@implementation MsgDeatilCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setSubViewsWith:style];
    }
    return  self;
}

-(void)setSubViewsWith:(UITableViewCellStyle)style {
    _headerView = [UIImageView new];
    _headerView.layer.cornerRadius = 20;
    _headerView.layer.masksToBounds = YES;
    [self.contentView addSubview:_headerView];
    _nameLbl = [UILabel new];
    _nameLbl.textColor = [UIColor commonTextColor];
    _nameLbl.font = [UIFont systemFontOfSize:14];
    [self.contentView addSubview:_nameLbl];
    _rightImgV = [UIImageView new];
    _rightImgV.image =[UIImage imageNamed:@"icon_wd_fh"];
    [self.contentView addSubview:_rightImgV];
    _lineV =[UIView new];
    _lineV.backgroundColor = [UIColor lineColor];
    [self.contentView addSubview:_lineV];
    _titleLbl = [UILabel new];
    _titleLbl.textColor = [UIColor commonTextColor];
    _titleLbl.font = [UIFont systemFontOfSize:14];
    [self.contentView addSubview:_titleLbl];
    _switchV = [UISwitch new];
    [self.contentView addSubview:_switchV];
}

-(void)setViewData:(id)dic With:(CellStyle)style {
    for (UIView *view in self.contentView.subviews) {
        [view setHidden:YES];
    }
    _headerView.image =[UIImage imageNamed:@"icon_wd_fh"];
    switch (style) {
        case HeaderCellStyle:
            [_headerView setHidden:NO];
            [_rightImgV setHidden:NO];
            [_nameLbl setHidden:NO];
            _nameLbl.text = [(NSDictionary*)dic objectForKey:@"name"];
            [_headerView sd_setImageWithURL:[NSURL URLWithString:[JXutils judgeImageheader:[(NSDictionary*)dic objectForKey:@"headerImg"] Withtype:IMGAvatar]]];
            break;
        case SwitchCellStyle:
            [_switchV setHidden:NO];
            [_titleLbl setHidden:NO];
            _titleLbl.text = (NSString*)dic;
            break;
        default:
            [_titleLbl setHidden:NO];
            _titleLbl.text = (NSString*)dic;
            break;
    }
}

-(void)layoutSubviews {
    kWeakSelf(self)
    [_headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(5);
        make.left.mas_equalTo(15);
        make.width.height.mas_equalTo(40);
    }];
    [_nameLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_headerView.mas_right).with.offset(15);
        make.centerY.mas_equalTo(weakSelf.contentView);
    }];
    [_rightImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(weakSelf.mas_right).with.offset(-15);
        make.centerY.mas_equalTo(weakSelf.contentView);
    }];
    [_lineV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(weakSelf.contentView);
        make.left.mas_equalTo(30);
        make.width.mas_equalTo(kSCREEN_WIDTH-30);
        make.height.mas_equalTo(1);
    }];
    [_titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.contentView).with.offset(15);
        make.centerY.mas_equalTo(weakSelf.contentView);
    }];
    [_switchV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(weakSelf.mas_right).with.offset(-15);
        make.centerY.mas_equalTo(weakSelf.contentView);
    }];
}
+ (NSString*)reuseIdentifier {
    return @"msgDeatilCell";
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
