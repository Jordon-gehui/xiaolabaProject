//
//  XLBScreeningView.m
//  xiaolaba
//
//  Created by lin on 2017/7/19.
//  Copyright © 2017年 jxcode. All rights reserved.
//

#import "XLBScreeningView.h"
#import "XLBFindUserModel.h"

@interface XLBScreeningView ()

@property (nonatomic, strong) NSArray *classify;
@property (nonatomic, strong) UIScrollView *contentScroll;
@property (nonatomic, strong) NSMutableArray *allItemsArray;
@property (nonatomic, strong) NSMutableArray *ageArray;
@property (nonatomic, strong) NSMutableArray *brandsArray;
@property (nonatomic, strong) NSMutableDictionary *temp_params;

@end

@implementation XLBScreeningView

- (instancetype)initWithFrame:(CGRect)frame
                     classify:(NSArray <FindScreenModel *>*)classify {
    
    if(self = [super initWithFrame:frame]) {
        if ([XLBUser user].shaiXuanKey) {
            _temp_params = [[XLBUser user].shaiXuanKey mutableCopy];
            if ([[_temp_params allKeys] containsObject:@"age"]) {
                self.ageArray = [_temp_params objectForKey:@"age"];
            }
            if ([[_temp_params allKeys] containsObject:@"brands"]) {
                self.brandsArray = [_temp_params objectForKey:@"brands"];
            }
        }
        self.backgroundColor = [UIColor whiteColor];
        self.userInteractionEnabled = YES;
        self.classify = classify;
        [self setupSubViews:classify];
        
    }
    return self;
}

- (void)setupSubViews:(NSArray <FindScreenModel *>*)classify {
    
    if(classify.count == 0) return;
    __block UIView *lastView = nil;
    CGFloat claHeight = 20.f;
    CGFloat itemHeight = 28.f;
    
    [classify enumerateObjectsUsingBlock:^(FindScreenModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        NSUInteger index = idx;
        NSMutableArray *items = [NSMutableArray array];
        
        NSString *title = obj.descr;
        UILabel *label = [[UILabel alloc] init];
        label.textColor = UIColorFromRGB(0x5b5b5b);
        label.font = [UIFont systemFontOfSize:15];
        label.text = title;
        [self.contentScroll addSubview:label];
        if(lastView) {
            label.frame = CGRectMake(14, lastView.bottom + 15, 0, claHeight);
        }
        else {
            label.frame = CGRectMake(14, 18, 0, claHeight);
        }
        [label sizeToFit];
        if([title isEqualToString:@"车辆品牌"]) {
            
            UIImageView *more_img = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_wd_fh"]];
            more_img.frame = CGRectMake(self.contentScroll.width - (15 + 10), label.centerY - 7.5, 8, 15);
            [self.contentScroll addSubview:more_img];
            UIButton *more = [UIButton buttonWithType:0];
            [more setTitle:@"更多" forState:0];
            [more setTitleColor:UIColorFromRGB(0xa5a5a5) forState:0];
            more.titleLabel.font = [UIFont systemFontOfSize:12];
            [self.contentScroll addSubview:more];
            more.frame = CGRectMake(more_img.left - 43, more_img.centerY - 10, 38, 20);
            [more addTarget:self action:@selector(moreClick) forControlEvents:UIControlEventTouchUpInside];
        }
        
        lastView = label;
        
        NSString *type = obj.type;
        NSArray <FindScreenDetailModel *>*itemsArray = obj.listDict;
        [itemsArray enumerateObjectsUsingBlock:^(FindScreenDetailModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            NSString *item_title = obj.label;
            NSString *item_value = obj.value;
            CGFloat left_width = self.contentScroll.width - lastView.right - 15;
            
            XLBScreenItem *item = [[XLBScreenItem alloc] initWithFrame:CGRectMake(lastView.left, lastView.bottom + 15, 10, itemHeight) title:item_title suit:NO];
            item.type = type;
            item.value = item_value;
            [self.contentScroll addSubview:item];
            if(idx > 0) {
                if(item.width > left_width) {
                    
                    item.left = 15;
                    item.top = lastView.bottom + 15;
                }
                else {
                    item.left = lastView.right + 15;
                    item.top = lastView.top;
                }
            }
            if([[_temp_params allKeys] containsObject:type]) {
                if ([type isEqualToString:@"brands"]||[type isEqualToString:@"age"]) {
                    NSArray *arr =[_temp_params objectForKey:type];
                    BOOL isequal = NO;
                    for (NSString* temp in arr) {
                        if ([item_value isEqualToString:temp]) {
                            isequal =YES;
                            break;
                        }
                    }
                    item.selected = isequal;
                }else{
                    item.selected = [item_value isEqualToString:[_temp_params objectForKey:type]];
                }
            }else {
                item.selected = NO;
            }
            item.tag = index;
            lastView = item;
            
            [item addTarget:self action:@selector(itemClick:) forControlEvents:UIControlEventTouchUpInside];
            [items addObject:item];
        }];
        [self.allItemsArray addObject:items];
    }];
    self.contentScroll.contentSize = CGSizeMake(kSCREEN_WIDTH, lastView.bottom + 15);
}

- (void)moreClick {
    
    if([self.delegate respondsToSelector:@selector(screenView:didClickMore:)]) {
        [self.delegate screenView:self didClickMore:YES];
    }
}

- (void)itemClick:(XLBScreenItem *)item {
    NSArray <XLBScreenItem *>*itemArray = [self.allItemsArray objectAtIndex:item.tag];
    [itemArray enumerateObjectsUsingBlock:^(XLBScreenItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSInteger isselect = obj.logo.isHidden;
        if ([item.type isEqualToString:@"brands"]||[item.type isEqualToString:@"age"]) {
            
            if ([item isEqual:obj]) {
                NSLog(@"===%i",obj.logo.isHidden);
                if (!isselect) {
                    if ([item.type isEqualToString:@"age"]) {
                        obj.selected = NO;
                        [_ageArray removeObject:obj.value];
                    }
                    if ([item.type isEqualToString:@"brands"]) {
                        obj.selected = NO;
                        [_brandsArray removeObject:obj.value];
                    }
                }else {
                    obj.selected = YES;
                    if (item.tag ==2) {
                        [self.ageArray addObject:obj.value];
                    }else{
                        [self.brandsArray addObject:obj.value];
                        
                    }
                }
            }
        }else{
            if([item isEqual:obj]&&isselect) {
                obj.selected = YES;
            }else {
                obj.selected = NO;
            }
        }
    }];
    

    NSString *type = item.type;
    NSString *value = item.value;
    if (item.logo.isHidden) {
        value =nil;
    }
    
    if (item.tag==2) {
        [self.temp_params setValue:_ageArray forKey:type];
    }else if(item.tag ==4){
        [self.temp_params setValue:_brandsArray forKey:type];
    }else{
        [self.temp_params setValue:value forKey:type];
    }
}

- (NSDictionary *)params {
    
    return self.temp_params;
}

- (UIScrollView *)contentScroll {
    
    if(!_contentScroll) {
        _contentScroll = [[UIScrollView alloc] init];
        _contentScroll.showsVerticalScrollIndicator = NO;
        _contentScroll.showsHorizontalScrollIndicator = NO;
        _contentScroll.frame = self.bounds;
        [self addSubview:_contentScroll];
    }
    return _contentScroll;
}

- (NSMutableArray *)allItemsArray {
    
    if(!_allItemsArray) {
        _allItemsArray = [NSMutableArray array];
    }
    return _allItemsArray;
}
- (NSMutableArray *)ageArray {
    
    if(!_ageArray) {
        _ageArray = [NSMutableArray array];
    }
    return _ageArray;
}
- (NSMutableArray *)brandsArray {
    
    if(!_brandsArray) {
        _brandsArray = [NSMutableArray array];
    }
    return _brandsArray;
}

- (NSMutableDictionary *)temp_params {
    
    if(!_temp_params) {
        _temp_params = [NSMutableDictionary dictionary];
    }
    return _temp_params;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end



#import "masonry.h"
@interface XLBScreenItem ()
@property (nonatomic, strong) UILabel *label;
@end
@implementation XLBScreenItem
- (instancetype)initWithFrame:(CGRect)frame title:(NSString *)title suit:(BOOL )suit {
    
    if(self = [super initWithFrame:frame]) {
        
        self.layer.borderWidth = 1.0;
        _label = [[UILabel alloc] init];
        _label.font = [UIFont systemFontOfSize:16];
        _label.textAlignment = NSTextAlignmentCenter;
        _label.text = title;
        [self addSubview:_label];
        [_label mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.left.bottom.right.mas_equalTo(0);
        }];
        _logo = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"chacha"]];
        [self addSubview:_logo];
        [_logo mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.right.bottom.mas_equalTo(0);
            make.height.with.equalTo(self.mas_height).dividedBy(1.56);
        }];
        _logo.hidden = YES;
//        _touch = [UIButton buttonWithType:0];
//        [self addSubview:_touch];
//        [_touch mas_makeConstraints:^(MASConstraintMaker *make) {
//            
//            make.top.left.bottom.right.mas_equalTo(0);
//        }];
        
        if(suit) {
            CGFloat titleWidth = [JXutils textWidthWithFont:16 WithString:_label.text Size:CGSizeMake(0, self.height)];
            self.width = titleWidth + 30;
        }
        else {
            // 需求变动
            if(title.length < 4) {
                self.width = iPhone5s ? 75 : (iPhone6 ? 80:85);
            }
            else if (title.length > 4 && title.length < 8) {
                self.width = iPhone5s ? 90 : (iPhone6 ? 95:100);
            }
            else {
                self.width = iPhone5s ? 100 : (iPhone6 ? 105:110);
            }
        }
        //CGFloat titleWidth = [_label bql_WidthWithSize:CGSizeMake(0, self.height)];
        //self.width = titleWidth + 50;
    }
    return self;
}
- (NSString *)title {
    
    return _label.text;
}
#define kThemeColor RGB(34, 180, 153)
#define KThemeColorA(a) RGBA(34, 180, 183, a)
- (void)setSelected:(BOOL)selected {
    
    self.label.textColor = selected ? RGB(34, 180, 153):UIColorFromRGB(0x828282);
    self.backgroundColor = selected ? RGBA(34, 180, 183, 0.1):RGB(255, 255, 255);
    self.layer.borderColor = selected ? [UIColor colorWithRed:34/255.0 green:180/255.0 blue:153/255.0 alpha:1.0].CGColor:[UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1.0].CGColor;
    self.logo.hidden = !selected;
    // _selected = selected;
}
@end

















