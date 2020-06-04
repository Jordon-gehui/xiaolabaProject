//
//  XLBGroupShareView.m
//  xiaolaba
//
//  Created by 戴葛辉 on 2018/6/8.
//  Copyright © 2018年 jackzhang. All rights reserved.
//

#import "XLBGroupShareView.h"

@interface XLBGroupShareView ()
@property (nonatomic, strong) UIImageView *userImg;
@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UILabel *nickName;

@property (nonatomic, strong) UILabel *contentLabel;
@end

@implementation XLBGroupShareView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setSubViews];
        self.layer.shadowOpacity = 0.5;// 阴影透明度
        self.layer.shadowColor = [UIColor grayColor].CGColor;// 阴影的颜色
        self.layer.shadowOffset = CGSizeMake(0, 3);
    }
    return self;
}

- (void)setModel:(XLBGroupModel *)model {
    _model = model;

    [self.userImg sd_setImageWithURL:[NSURL URLWithString:[JXutils judgeImageheader:model.groupImg Withtype:IMGAvatar]] placeholderImage:[UIImage imageNamed:@"weitouxiang"]];
    if (kNotNil(model.groupName) && model.groupName.length > 15) {
        self.nickName.text = [NSString stringWithFormat:@"%@...",[model.groupName substringWithRange:NSMakeRange(0, 15)]];
    }else {
        self.nickName.text = kNotNil(model.groupName) ? model.groupName : @"";
    }
    
//    NSDate *date = [NSDate date];
//    NSDate *newDate = [date dateByAddingTimeInterval:24 * 60 * 60  * 7];
//    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc]init];
//    dateFormatter.dateFormat=@"M月dd日";
//    NSString *contentStr = [NSString stringWithFormat:@"此二维码七天内有效(%@前)有效\n过期后请扫描新二维码",[dateFormatter stringFromDate:newDate]];
    NSString *contentStr = @"长按识别二维码下载小喇叭APP\n用小喇叭APP扫描二维码，加入该群";
    NSMutableParagraphStyle *muParagraph = [[NSMutableParagraphStyle alloc]init];
    muParagraph.lineSpacing = 5;
    NSRange range = NSMakeRange(0, contentStr.length);
    NSMutableAttributedString *contentText = [[NSMutableAttributedString alloc] initWithString:contentStr];
    [contentText addAttribute:NSParagraphStyleAttributeName value:muParagraph range:range];
    self.contentLabel.attributedText = contentText;
    self.contentLabel.textAlignment = NSTextAlignmentCenter;
}

- (void)setSubViews {
    self.bgView = [UIView new];
    self.bgView.layer.masksToBounds = YES;
    self.bgView.layer.cornerRadius = 10;
    self.bgView.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.bgView];
    
    self.userImg = [UIImageView new];
    self.userImg.layer.cornerRadius = 37;
    self.userImg.layer.masksToBounds = YES;
    self.userImg.backgroundColor = [UIColor redColor];
    self.userImg.layer.borderColor = [UIColor colorWithR:174 g:181 b:194].CGColor;
    self.userImg.layer.borderWidth = 2;
    self.userImg.image = [UIImage imageNamed:@"weitouxiang"];
    [self addSubview:self.userImg];
    
    self.nickName = [UILabel new];
    self.nickName.textColor = [UIColor commonTextColor];
    self.nickName.font = [UIFont systemFontOfSize:18];
    self.nickName.text = @"战神";
    self.nickName.textAlignment = NSTextAlignmentCenter;
    [self.bgView addSubview:self.nickName];
    
    self.codeImg = [UIImageView new];
    self.codeImg.backgroundColor = [UIColor whiteColor];
    self.codeImg.image = [UIImage imageNamed:@"xlbdl"];
    [self.bgView addSubview:self.codeImg];
    
    self.contentLabel = [UILabel new];
    self.contentLabel.textColor = [UIColor minorTextColor];
    self.contentLabel.font = [UIFont systemFontOfSize:14];
    self.contentLabel.numberOfLines = 0;
    self.contentLabel.textAlignment = NSTextAlignmentCenter;
    self.contentLabel.text = @"此二维码七天内有效（6月14日前）有效\n过期后请扫描新二维码";
    [self.bgView addSubview:self.contentLabel];
    
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(60);
        make.left.mas_equalTo(24);
        make.right.mas_equalTo(-24);
        make.centerX.mas_equalTo(0);
        make.height.mas_equalTo(400);
    }];
    
    [self.userImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.bgView.mas_top).with.offset(-35);
        make.width.height.mas_equalTo(74);
        make.centerX.mas_equalTo(self.bgView.mas_centerX).with.offset(0);
    }];
    
    [self.nickName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.userImg.mas_bottom).with.offset(20);
        make.left.right.mas_equalTo(0);
        make.centerX.mas_equalTo(0);
    }];
    
    [self.codeImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(206);
        make.centerX.mas_equalTo(self.bgView.mas_centerX).with.offset(0);
        make.centerY.mas_equalTo(self.bgView.mas_centerY).with.offset(0);
    }];
    
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.codeImg.mas_bottom).with.offset(25);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
    }];
}

- (UIImage*)imageWithUIView:(UIView *)view {
    
    UIGraphicsBeginImageContext(view.bounds.size);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    [view.layer renderInContext:context];
    
    UIImage* tImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return tImage;
    
}


@end
