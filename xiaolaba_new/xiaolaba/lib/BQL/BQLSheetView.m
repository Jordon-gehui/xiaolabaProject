//
//  BQLSheetView.m
//  xiaolaba
//
//  Created by lin on 2017/7/12.
//  Copyright © 2017年 jxcode. All rights reserved.
//

#import "BQLSheetView.h"

static CGFloat message_height = 40.f;
static CGFloat item_height = 45.f;
static CGFloat split_height = 1.f;
static CGFloat animation_duration = 0.2;

@interface BQLSheetView ()
{
    BOOL _normal; // 是否为普通样式
    NSArray *_items;
    NSString *_message;
    CGFloat _total_height;
}

@property (nonatomic, strong) UIView *motherView;

@end

@implementation BQLSheetView

- (instancetype)initWith:(NSArray *)items message:(NSString *)message {
    
    _items = items;
    _message = message;
    _normal = YES;
    _total_height = items.count * item_height + (items.count - 1) * split_height;
    if(kNotNil(message)) {
        _total_height += message_height;
        _total_height += split_height;
    }
    return [self init];
}

- (instancetype)initWithDatePickView {
    
    _normal = NO;
    _total_height = item_height * 3;
    return [self init];
}

- (instancetype)init {
    
    if(self = [super init]) {
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)];
        [self addGestureRecognizer:tap];
        self.backgroundColor = RGBA(0, 0, 0, 0.2);
        self.userInteractionEnabled = YES;
        self.motherView.frame = CGRectMake(0, kSCREEN_HEIGHT, kSCREEN_WIDTH, _total_height);
        [self.motherView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        [self.motherView.layer.sublayers makeObjectsPerformSelector:@selector(removeFromSuperview)];
        [self setupSubViews:_normal];
    }
    return self;
}

- (void)setupSubViews:(BOOL)normal {
    
    if(normal) {
        CGFloat top = 0;
        if(kNotNil(_message)) {
            UILabel *messageLabel = [UILabel new];
            messageLabel.font = [UIFont systemFontOfSize:14];
            messageLabel.textAlignment = NSTextAlignmentCenter;
            messageLabel.textColor = RGB(166, 166, 166);
            messageLabel.text = _message;
            messageLabel.backgroundColor = [UIColor whiteColor];
            messageLabel.frame = CGRectMake(0, 0, _motherView.width, message_height);
            [_motherView addSubview:messageLabel];
            CALayer *line_one = [[CALayer alloc] init];
            line_one.frame = CGRectMake(0, messageLabel.bottom, _motherView.width, split_height);
            line_one.backgroundColor = [UIColor colorWithRed:226/255.0 green:226/255.0 blue:226/255.0 alpha:1.0].CGColor;
            [_motherView.layer addSublayer:line_one];
            top = message_height + split_height;
        }
        [_items enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            NSString *string = obj;
            UIButton *button = [UIButton buttonWithType:0];
            [button setTitle:string forState:0];
            [button setTitleColor:RGB(62, 62, 62) forState:0];
            button.titleLabel.font = [UIFont systemFontOfSize:14];
            button.backgroundColor = [UIColor whiteColor];
            button.tag = idx;
            [button addTarget:self action:@selector(itemClick:) forControlEvents:UIControlEventTouchUpInside];
            button.frame = CGRectMake(0, top + (item_height + split_height) * idx, _motherView.width, item_height);
            [_motherView addSubview:button];
            if(idx < _items.count - 1) {
                CALayer *line = [[CALayer alloc] init];
                line.frame = CGRectMake(0, button.bottom, _motherView.width, split_height);
                line.backgroundColor = [UIColor colorWithRed:226/255.0 green:226/255.0 blue:226/255.0 alpha:1.0].CGColor;
                [_motherView.layer addSublayer:line];
            }
        }];
    }
    else {
        UIDatePicker *datePicker = [[UIDatePicker alloc] init];
        [_motherView addSubview:datePicker];
        datePicker.frame = _motherView.bounds;
        datePicker.backgroundColor = [UIColor whiteColor];
        datePicker.locale = [NSLocale localeWithLocaleIdentifier:@"zh"];
        //显示方式是只显示年月日
        datePicker.datePickerMode = UIDatePickerModeDate;
        [datePicker addTarget:self action:@selector(dateChanged:) forControlEvents:UIControlEventValueChanged];
    }
}

- (void)itemClick:(UIButton *)sender {
    if([self.delegate respondsToSelector:@selector(sheetView:items:didSelectAtIndex:)]) {
        [self.delegate sheetView:self items:_items didSelectAtIndex:sender.tag];
    }
    [self dismiss];
}

- (void)dateChanged:(UIDatePicker *)datePicker {
    
    NSDate *theDate = datePicker.date;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"YYYY-MM-dd";
    if([self.delegate respondsToSelector:@selector(sheetView:didSelectDate:)]) {
        [self.delegate sheetView:self didSelectDate:[dateFormatter stringFromDate:theDate]];
    }
}


- (void)show:(UIView *)container {
    
    [container addSubview:self];
    self.frame = container.bounds;
    [UIView animateWithDuration:animation_duration animations:^{
        
        _motherView.top -= _motherView.height;
    }];
}

- (void)dismiss {
    
    if(!(_motherView.top == kSCREEN_HEIGHT)) {
        [UIView animateWithDuration:animation_duration animations:^{
            
            _motherView.top += _motherView.height;
        } completion:^(BOOL finished) {
            
            [self removeFromSuperview];
        }];
    }
    else {
        [self removeFromSuperview];
    }
}

- (UIView *)motherView {
    
    if(!_motherView) {
        _motherView = [[UIView alloc] initWithFrame:CGRectZero];
        _motherView.backgroundColor = RGB(215, 215, 215);
        [self addSubview:_motherView];
    }
    return _motherView;
}

- (void)dealloc {
    NSLog(@"%@ 已经释放",self);
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
