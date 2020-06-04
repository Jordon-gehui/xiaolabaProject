//
//  XLBAreaSelectView.m
//  xiaolaba
//
//  Created by lin on 2017/7/25.
//  Copyright © 2017年 jxcode. All rights reserved.
//

#import "XLBAreaSelectView.h"

static CGFloat mother_header_height = 40.f;
static CGFloat mother_height = 200.f;

@interface XLBAreaSelectView () <UIPickerViewDataSource,UIPickerViewDelegate>
{
    NSInteger _provinceIndex;   // 省份选择 记录
    NSInteger _cityIndex;       // 市选择 记录
    NSInteger _districtIndex;   // 区选择 记录
    
    NSString *_province;
    NSString *_city;
    NSString *_district;
}

@property (nonatomic, strong) UIPickerView *pickerView;
@property (nonatomic, strong) NSArray *dataSource;
@property (nonatomic, strong) UIView *motherView;

@end

@implementation XLBAreaSelectView

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
            y = kSCREEN_HEIGHT - 30;
        }else{
            y = kSCREEN_HEIGHT;
        }
        self.motherView.frame = CGRectMake(0, y, kSCREEN_WIDTH, mother_height);
        
        self.pickerView.delegate = self;
        self.pickerView.dataSource = self;
        
        // load
        NSString *jsonPath = [[NSBundle mainBundle] pathForResource:@"area" ofType:@"json"];
        NSData *data=[NSData dataWithContentsOfFile:jsonPath];
        NSError *error;
        id jsonObject=[NSJSONSerialization JSONObjectWithData:data
                                                      options:NSJSONReadingAllowFragments
                                                        error:&error];
        
        self.dataSource = (NSArray *)jsonObject;
        _provinceIndex = _cityIndex = _districtIndex = 0;
        _province = @"";
        _city = @"";
        _district = @"";
    }
    return self;
}

- (void)resetPickerSelectRow {
    
    [self.pickerView selectRow:_provinceIndex inComponent:0 animated:YES];
    [self.pickerView selectRow:_cityIndex inComponent:1 animated:YES];
    [self.pickerView selectRow:_districtIndex inComponent:2 animated:YES];
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

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    
    return 3;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    
    NSInteger count = 0;
    switch (component) {
        case 0:
            count = self.dataSource.count;
            break;
        case 1:
            count = [self.dataSource[_provinceIndex][@"city"] count];
            break;
        case 2:
            count = [self.dataSource[_provinceIndex][@"city"][_cityIndex][@"districts"] count];
            break;
            
        default:
            break;
    }
    return count;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    
    return 40;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    
    if(component == 0) {
        _province = self.dataSource[row][@"name"];
        return _province;
    }
    else if (component == 1) {
        _city = self.dataSource[_provinceIndex][@"city"][row][@"name"];
        return _city;
    }
    else{
        _district = self.dataSource[_provinceIndex][@"city"][_cityIndex][@"districts"][row][@"name"];
        return _district;
    }
}

-(UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    
    UILabel *lbl = (UILabel *)view;
    if (lbl == nil) {
        lbl = [[UILabel alloc] init];
        lbl.font = [UIFont systemFontOfSize:18];
        lbl.textColor = [UIColor blackColor];
        [lbl setTextAlignment:1];
        [lbl setBackgroundColor:[UIColor clearColor]];
    }
    //重新加载lbl的文字内容
    lbl.text = [self pickerView:pickerView titleForRow:row forComponent:component];
    return lbl;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
    if(component == 0){
        _provinceIndex = row;
        _cityIndex = 0;
        _districtIndex = 0;
        _province = self.dataSource[row][@"name"];

        [self.pickerView reloadComponent:1];
        [self.pickerView reloadComponent:2];
    }
    else if (component == 1){
        _cityIndex = row;
        _districtIndex = 0;
        _city = self.dataSource[_provinceIndex][@"city"][row][@"name"];

        [self.pickerView reloadComponent:2];
    }
    else{
        _districtIndex = row;
        _district = self.dataSource[_provinceIndex][@"city"][_cityIndex][@"districts"][row][@"name"];
    }

    // 重置当前选中项
    [self resetPickerSelectRow];
}

- (void)okClick {
    
    if([self.delegate respondsToSelector:@selector(areaSelectView:didSelectArea:province:city:district:)]) {
        
        NSString *area = [NSString stringWithFormat:@"%@%@%@",_province,_city,_district];
        [self.delegate areaSelectView:self didSelectArea:area province:_province city:_city district:_district];
    }
    [self dismiss];
}

- (UIPickerView *)pickerView {
    
    if(!_pickerView) {
        _pickerView = [[UIPickerView alloc] init];
        _pickerView.backgroundColor = [UIColor whiteColor];
        [self.motherView addSubview:_pickerView];
        [_pickerView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.bottom.right.mas_equalTo(0);
            make.top.mas_equalTo(mother_header_height);
        }];
    }
    return _pickerView;
}

- (UIView *)motherView {
    
    if(!_motherView) {
        
        _motherView = [[UIView alloc] init];
        _motherView.backgroundColor = RGB(236, 236, 236);
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
