//
//  XLBMsgNotifitionCell.m
//  xiaolaba
//
//  Created by lin on 2017/7/26.
//  Copyright © 2017年 jxcode. All rights reserved.
//

#import "XLBMsgNotifitionCell.h"

@interface XLBMsgNotifitionCell ()
@property (nonatomic,retain) UIButton *handle;

@property (nonatomic,retain) UIImageView *image;
@property (nonatomic,retain) UILabel *title;
@property (nonatomic,retain) UILabel *subtitle;

@end

@implementation XLBMsgNotifitionCell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.image = [UIImageView new];
        self.image.layer.cornerRadius = 70*0.75/2.0;
        self.image.layer.masksToBounds = YES;
        [self addSubview:self.image];
        _title = [UILabel new];
        _title.textColor = RGB(23, 23, 23);
        _title.font = [UIFont systemFontOfSize:14];
        [self addSubview:self.title];
        _subtitle = [UILabel new];
        _subtitle.textColor = RGB(168, 168, 168);
        _subtitle.font = [UIFont systemFontOfSize:12];
        _subtitle.numberOfLines = 0;
        [self addSubview:self.subtitle];
        self.handle = [UIButton new];
        self.handle.titleLabel.font = [UIFont systemFontOfSize:13];
        [self.handle addTarget:self action:@selector(handleClick:) forControlEvents:UIControlEventTouchUpInside];
        self.handle.layer.masksToBounds = YES;
        self.handle.layer.cornerRadius = 5;
        self.handle.layer.borderWidth = 1;
        self.handle.layer.borderColor = [UIColor colorWithHexString:@"#e1e6f0"].CGColor;
        [self addSubview:self.handle];
        self.lineV =[UIView new];
        self.lineV.backgroundColor = [UIColor lineColor];
        [self addSubview:self.lineV];
        [self.lineV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(15);
            make.right.mas_equalTo(self);
            make.height.mas_equalTo(1);
            make.bottom.mas_equalTo(self);
        }];
        [self.image mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.mas_equalTo(self).with.offset(15);
            make.width.height.mas_equalTo(70*0.75);
//            make.bottom.lessThanOrEqualTo(self).with.offset(-15);
        }];
        [self.handle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self).with.offset(-15);
            make.centerY.mas_equalTo(self);
            make.width.mas_equalTo(80);
            make.height.mas_equalTo(30);
        }];
        [self.title mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.image).with.offset(10);
            make.left.mas_equalTo(self.image.mas_right).with.offset(10);
            make.right.mas_equalTo(self.handle.mas_left).with.offset(-10);
        }];
        [self.subtitle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.title.mas_bottom).with.offset(10);
            make.left.mas_equalTo(self.image.mas_right).with.offset(10);
            make.right.mas_equalTo(self.handle.mas_left).with.offset(-10);
            make.bottom.lessThanOrEqualTo(self).with.offset(-10);
        }];
    }
    return self;
}

- (void)setModel:(MsgNoticeModel *)model {
    [self.image sd_setImageWithURL:[NSURL URLWithString:[JXutils judgeImageheader:model.img Withtype:IMGAvatar]] placeholderImage:[UIImage imageNamed:@""]];

    self.title.text = model.nickName;
    self.subtitle.text = model.message;

    NSLog(@"status = %@",model.status);
    switch ([model.status integerValue]) {
        case 0: {
            if ([model.parentId integerValue] ==0) {
                [self.handle setTitle:@"等待验证" forState:0];
                [self.handle setTitleColor:[UIColor colorWithHexString:@"#aeb5c2"] forState:0];
                self.handle.enabled = NO;
            }else {
                [self.handle setTitle:@"接受" forState:0];
                [self.handle setTitleColor:[UIColor colorWithHexString:@"#2e3033"] forState:0];
                self.handle.enabled = YES;
            }
        }
            break;
        
        default: {
            [self.handle setTitle:@"发消息" forState:0];
            [self.handle setTitleColor:[UIColor colorWithHexString:@"#2e3033"] forState:0];
            self.handle.enabled = YES;
        }
            break;
            
    }
    _model = model;
}

- (void)handleClick:(id)sender {
    if (self.returnBlock) {
        self.returnBlock(_model.friendId);
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
