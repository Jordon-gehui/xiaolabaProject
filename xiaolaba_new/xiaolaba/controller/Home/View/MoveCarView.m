//
//  MoveCarView.m
//  xiaolaba
//
//  Created by 斯陈 on 2017/9/15.
//  Copyright © 2017年 jackzhang. All rights reserved.
//

#import "MoveCarView.h"

@interface MoveCarView()
@property(nonatomic ,strong)UILabel *carContentLbl;
@property(nonatomic ,strong)UILabel *carNoLbl;

@property(nonatomic ,strong)UILabel *carLocLbl;

@property(nonatomic ,strong)UILabel *carImgLbl;

@property(nonatomic ,strong)UILabel *carTipLbl;
@end
@implementation MoveCarView

//- (instancetype)init
//{
//    self = [super init];
//    if (self) {
//        [self initViews];
//    }
//    return self;
//}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initViews];
    }
    return self;
}

-(void)initViews{
    _carContentLbl = [self addLbl:@"给车主留言"];
    
    _textView = [SZTextView new];
    _textView.font = [UIFont systemFontOfSize:14];
    _textView.placeholderTextColor = RGB(200, 200, 200);
    _textView.placeholder = @"说点什么吧...";
    [self addSubview:_textView];
    
    _carNoLbl = [self addLbl:@"当前位置"];
    
    _carNoText = [self addText];
    
    _carLocLbl = [self addLbl:@"当前位置"];
    
    _carLocText = [self addText];
    
    _carImgLbl = [self addLbl:@"相关图片(最多上传3张)"];
    
    _addImageView = [AddImageView new];
    [_addImageView setBackgroundColor:[UIColor whiteColor]];
    [_addImageView setMaxImgCount:3 rowNumber:0];
    [_addImageView initViewWith:@[]];
    [self addSubview:_addImageView];
    
    _carSureBtn = [UIButton new];
    [_carSureBtn setTitle:@"通知车主挪车" forState:UIControlStateNormal];
    [_carSureBtn setBackgroundColor:[UIColor orangeColor]];
    [_carSureBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _carSureBtn.layer.cornerRadius = 3;
    _carSureBtn.layer.masksToBounds = YES;
    [self addSubview:_carSureBtn];
    
    _carTipLbl= [UILabel new];
    _carTipLbl.font = [UIFont systemFontOfSize:14];
    _carTipLbl.text = @"恶意通知车主挪车，将被拉进黑名单哦!";
    _carTipLbl.textColor = [UIColor textBlackColor];
    _carTipLbl.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_carTipLbl];

}

-(UILabel*)addLbl:(NSString*)text {
    UILabel *lbl= [UILabel new];
    lbl.font = [UIFont systemFontOfSize:18];
    lbl.text = text;
    lbl.textColor = [UIColor textBlackColor];
    [self addSubview:lbl];
    return lbl;
}

-(UITextField *)addText {
    UITextField *text = [UITextField new];
    text.layer.borderColor= [UIColor lineColor].CGColor;
    text.layer.borderWidth= 1.0f;
    text.layer.cornerRadius = 3;
    text.layer.masksToBounds = YES;
    [self addSubview:text];
    return text;
}



-(void)layoutSubviews {
    kWeakSelf(self)
    [_carContentLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.mas_equalTo(15);
        make.right.mas_equalTo(weakSelf.right).with.offset(-15);
    }];
    [_textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.top.mas_equalTo(_carContentLbl.mas_bottom).with.offset(10);
        make.width.mas_equalTo(kSCREEN_WIDTH-30);
        make.height.mas_equalTo(120);
    }];
    [_carNoLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.top.mas_equalTo(_textView.mas_bottom).with.offset(10);
        make.right.mas_equalTo(weakSelf.right).with.offset(-15);
    }];
    [_carNoText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.top.mas_equalTo(_carNoLbl.mas_bottom).with.offset(10);
        make.right.mas_equalTo(weakSelf.right).with.offset(-15);
        make.height.mas_equalTo(44);
    }];
    
    [_carLocLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.top.mas_equalTo(_carNoText.mas_bottom).with.offset(10);
        make.right.mas_equalTo(weakSelf.right).with.offset(-15);
    }];
    
    [_carLocText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.top.mas_equalTo(_carLocLbl.mas_bottom).with.offset(10);
        make.right.mas_equalTo(weakSelf.right).with.offset(-15);
        make.height.mas_equalTo(44);
    }];
    
    [_carImgLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.top.mas_equalTo(_carLocText.mas_bottom).with.offset(10);
        make.right.mas_equalTo(weakSelf.right).with.offset(-15);
    }];
    
    [_addImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.top.mas_equalTo(_carImgLbl.mas_bottom).with.offset(10);
        make.width.mas_equalTo(kSCREEN_WIDTH-20);
        make.width.mas_equalTo(90);
    }];
    
    [_carSureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.top.mas_equalTo(weakSelf.addImageView.mas_bottom).with.offset(100);
        make.right.mas_equalTo(weakSelf.right).with.offset(-15);
        make.width.mas_equalTo(44);
    }];
    [_carTipLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.top.mas_equalTo(_carSureBtn.mas_bottom).with.offset(10);
        make.right.mas_equalTo(weakSelf.right).with.offset(-15);
        make.width.mas_equalTo(44);
        make.bottom.lessThanOrEqualTo(weakSelf.mas_bottom).with.offset(-10);
    }];
}

@end
