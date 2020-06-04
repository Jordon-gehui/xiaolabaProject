//
//  XLBSeleDateView.m
//  xiaolaba
//
//  Created by 戴葛辉 on 2017/9/16.
//  Copyright © 2017年 jackzhang. All rights reserved.
//

static CGFloat mother_header_height = 40.f;
static CGFloat mother_height = 200.f;

#import "XLBSeleDateView.h"

@interface XLBSeleDateView ()


@property (nonatomic, strong) UIDatePicker *datePicker;
@property (nonatomic, strong) NSArray *dataSource;
@property (nonatomic, strong) UIView *motherView;
@property (nonatomic, strong) NSString *birthday;

@end

@implementation XLBSeleDateView


- (instancetype)init {
    
    if(self = [super init]) {
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)];
        [self addGestureRecognizer:tap];
        self.backgroundColor = RGBA(0, 0, 0, 0.2);
        self.userInteractionEnabled = YES;
        //[self.motherView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        //[self.motherView.layer.sublayers makeObjectsPerformSelector:@selector(removeFromSuperview)];
        CGFloat y;
        if (iPhoneX) {
            y = kSCREEN_HEIGHT-30;
        }else {
            y = kSCREEN_HEIGHT;
        }
        self.motherView.frame = CGRectMake(0, y, kSCREEN_WIDTH, mother_height);
        self.datePicker.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)resetPickerSelectRow {
    
    
//    
//    [self.pickerView selectRow:_provinceIndex inComponent:0 animated:YES];
//    [self.pickerView selectRow:_cityIndex inComponent:1 animated:YES];
//    [self.pickerView selectRow:_districtIndex inComponent:2 animated:YES];
}
- (void)setCurrentDate:(NSString *)currentDate {
    if (!kNotNil(currentDate) || [currentDate isEqualToString:@"未填写"]) {
        return;
    }
    NSDateFormatter* dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd"];
    NSDate *date =[dateFormat dateFromString:currentDate];
    [self.datePicker setDate:date animated:YES];
    _currentDate = currentDate;
}
- (void)show:(UIView *)container {
    
    [container addSubview:self];
    self.frame = container.bounds;
    [UIView animateWithDuration:0.1 animations:^{
        
        _motherView.top -= _motherView.height;;
    }];
}

- (void)dismiss {
    
    if(!(_motherView.top == kSCREEN_HEIGHT - 64)) {
        [UIView animateWithDuration:0.1 animations:^{
            
            _motherView.top += _motherView.height;
        } completion:^(BOOL finished) {
            
            [self removeFromSuperview];
        }];
    }
    else {
        [self removeFromSuperview];
    }
}

- (void)seletedDatePicker:(UIDatePicker *)datePicker {
    NSString *dateFor = @"yyyy-MM-dd";
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:dateFor];
    NSString *seletedDate = [formatter stringFromDate:datePicker.date];
    self.birthday = seletedDate;
}

- (void)okClick {
    if ([self.delegate respondsToSelector:@selector(dateSelectView:didSelectbirthday:)]) {
        [self.delegate dateSelectView:self didSelectbirthday:self.birthday];
    }
    [self dismiss];
}

- (UIDatePicker *)datePicker {
    
    if(!_datePicker) {
        _datePicker = [[UIDatePicker alloc] init];
        _datePicker.backgroundColor = [UIColor clearColor];
        _datePicker.maximumDate = [NSDate date];
        _datePicker.datePickerMode = UIDatePickerModeDate;
        [_datePicker addTarget:self action:@selector(seletedDatePicker:) forControlEvents:UIControlEventValueChanged];
        self.datePicker.backgroundColor = [UIColor redColor];
        [self.motherView addSubview:_datePicker];
        [_datePicker mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.bottom.right.mas_equalTo(0);
            make.top.mas_equalTo(mother_header_height);
        }];
    }
    return _datePicker;
}

- (UIView *)motherView {
    
    if(!_motherView) {
        
        _motherView = [[UIView alloc] init];
        _motherView.backgroundColor = RGB(236, 236, 236);
        //_motherView.backgroundColor = [UIColor redColor];
        [self addSubview:_motherView];
        UIView *header = [[UIView alloc] init];
        header.backgroundColor = [UIColor whiteColor];
        [_motherView addSubview:header];
        [header mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.left.right.mas_equalTo(0);
            make.height.mas_equalTo(mother_header_height);
        }];
        UIButton *cancel = [UIButton buttonWithType:0];
        [cancel addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
        [header addSubview:cancel];
        [cancel setTitle:@"取消" forState:0];
        [cancel setTitleColor:[UIColor commonTextColor] forState:0];
        cancel.titleLabel.font = [UIFont systemFontOfSize:17];
        [cancel mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.left.bottom.mas_equalTo(0);
            make.width.mas_equalTo(50);
        }];
        UIButton *ok = [UIButton buttonWithType:0];
        [ok addTarget:self action:@selector(okClick) forControlEvents:UIControlEventTouchUpInside];
        [header addSubview:ok];
        [ok setTitle:@"确定" forState:0];
        [ok setTitleColor:[UIColor commonTextColor] forState:0];
        ok.titleLabel.font = [UIFont systemFontOfSize:17];
        [ok mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.right.bottom.mas_equalTo(0);
            make.width.mas_equalTo(50);
        }];
    }
    return _motherView;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
