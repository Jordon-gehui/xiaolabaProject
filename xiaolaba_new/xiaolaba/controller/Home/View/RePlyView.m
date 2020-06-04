//
//  RePlyView.m
//  xiaolaba
//
//  Created by 斯陈 on 2017/9/19.
//  Copyright © 2017年 jackzhang. All rights reserved.
//

#import "RePlyView.h"

@interface RePlyView()
@property (nonatomic,strong)UIView *backView;
@property (nonatomic,strong)UIView *contentView;
@property (nonatomic,strong)UILabel *titleLbl;
@property (nonatomic,strong)UIButton *megButton;
@property (nonatomic,copy)NSArray *array;
@end
@implementation RePlyView

- (instancetype)initWithArr:(NSArray*)array
{
    self = [super init];
    if (self) {
        [self initViewWithArr:array];
    }
    return self;
}

- (void)initViewWithArr:(NSArray*)array {
    _array = array;
    self.backView = [UIView new];
    self.backView.backgroundColor = [UIColor textBlackColor];
    self.backView.alpha = 0.4;
    [self addSubview:_backView];
    
    self.contentView = [UIView new];
    self.contentView.backgroundColor = [UIColor whiteColor];
    self.contentView.layer.cornerRadius =5;
    self.contentView.layer.masksToBounds = YES;
    [self addSubview:_contentView];
    
    _titleLbl = [UILabel new];
    _titleLbl.font = [UIFont systemFontOfSize:18];
    _titleLbl.textColor = [UIColor textBlackColor];
    _titleLbl.text = @"快捷回复";
    [self.contentView addSubview:_titleLbl];

    _textView = [SZTextView new];
    _textView.font = [UIFont systemFontOfSize:14];
    _textView.placeholderTextColor = RGB(200, 200, 200);
    _textView.placeholder = @"说点什么吧...";
    [self.contentView addSubview:_textView];
    
    self.closeBtn = [UIButton new];
    UIImage *imge = [[UIImage imageNamed:@"icon_gb"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    self.closeBtn.tintColor = [UIColor lightColor];
    [self.closeBtn setImage:imge forState:0];
    [self.contentView addSubview:_closeBtn];
    
    _sendBtn = [UIButton new];
    _sendBtn.clipsToBounds = YES;
    _sendBtn.layer.cornerRadius = 5;
    [_sendBtn setTitle:@"发送给对方" forState:UIControlStateNormal];
    [_sendBtn setTitleColor:[UIColor textBlackColor] forState:UIControlStateNormal];
    self.sendBtn.backgroundColor = RGB(251, 218, 60);
    _sendBtn.tag = 100;
    _sendBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [self.contentView addSubview:_sendBtn];
}

-(void)layoutSubviews {
    kWeakSelf(self)
    [_backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.mas_equalTo(weakSelf);
    }];
    [_contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(weakSelf);
        make.left.mas_equalTo(15);
    }];
    [_titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(weakSelf.contentView.mas_top).with.offset(10);
        make.centerX.mas_equalTo(weakSelf.contentView);
    }];
    [_closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(weakSelf.contentView.mas_top).with.offset(5);
        make.right.mas_equalTo(weakSelf.contentView.mas_right).with.offset(-5);
    }];
    [_textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(weakSelf.titleLbl.mas_bottom).with.offset(10);
        make.left.mas_equalTo(weakSelf.contentView.mas_left).with.offset(5);
        make.right.mas_equalTo(weakSelf.contentView.mas_right).with.offset(-5);
        make.height.mas_equalTo(120);
    }];
    _megButton = nil;
    if (kNotNil(_array)) {
        for (NSString *messageStr in _array) {
            UIButton *button = [UIButton new];
            button.clipsToBounds = YES;
            button.layer.cornerRadius = 5;
            [button setTitle:messageStr forState:UIControlStateNormal];
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            button.backgroundColor = [UIColor lightGrayColor];
            [button addTarget:self action:@selector(messageClick:) forControlEvents:UIControlEventTouchUpInside];
            button.titleLabel.font = [UIFont systemFontOfSize:12];
            [self.contentView addSubview:button];
            if (_megButton ==nil) {
                [button mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.mas_equalTo(weakSelf.textView.mas_bottom).with.offset(10);
                    make.left.mas_equalTo(weakSelf.contentView.mas_left).with.offset(5);
                    make.height.mas_equalTo(30);
                }];
            }else {
                [button mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.mas_equalTo(weakSelf.megButton.mas_bottom).with.offset(10);
                    make.left.mas_equalTo(weakSelf.contentView.mas_left).with.offset(5);
                    make.height.mas_equalTo(30);
                }];
            }
            _megButton = button;
        }
        [_sendBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(weakSelf.megButton.mas_bottom).with.offset(10);
            make.left.mas_equalTo(weakSelf.contentView.mas_left).with.offset(5);
            make.right.mas_equalTo(weakSelf.contentView.mas_right).with.offset(-5);
            make.height.mas_equalTo(44);
            make.bottom.mas_equalTo(weakSelf.contentView.mas_bottom).with.offset(-10);
        }];
    }else{
        [_sendBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(weakSelf.textView.mas_bottom).with.offset(10);
            make.left.mas_equalTo(weakSelf.contentView.mas_left).with.offset(5);
            make.right.mas_equalTo(weakSelf.contentView.mas_right).with.offset(-5);
            make.height.mas_equalTo(44);
            make.bottom.mas_equalTo(weakSelf.contentView.mas_bottom).with.offset(-10);
        }];
    }
}
-(void)messageClick:(UIButton *)button {
    _textView.text = [NSString stringWithFormat:@"%@ %@",_textView.text,button.titleLabel.text];
}
@end
