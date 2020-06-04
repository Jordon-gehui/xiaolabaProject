//
//  SLNavigationBar.m
//  Micfunding
//
//  Created by smilelu on 16/8/13.
//  Copyright © 2016年 smilelu. All rights reserved.
//

#import "SLNavigationBar.h"

@interface SLNavigationBar()

@property (nonatomic, retain) UIView *leftView;

@property (nonatomic, retain) UIView *rightView;



@end

@implementation SLNavigationBar

- (id) init {
    self = [super init];
    if (self) {
        [self initializer];
    }
    return self;
}

- (id) initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initializer];
    }
    return self;
}

- (void) initializer {
    _naviBgColor = [UIColor navBackColor];
    _naviTintColor = [UIColor naviTintColor];
    _leftView = [UIView new];
    [self addSubview:_leftView];
    
    _rightView = [UIView new];
    [self addSubview:_rightView];
    
    _slTitleView = [UIView new];
    [self addSubview:_slTitleView];
    
    _slTitleLabel = [UILabel new];
    _slTitleLabel.font = [UIFont systemFontOfSize:18];
    _slTitleLabel.textColor = [UIColor buttonTitleColor];
    [self.slTitleView addSubview:_slTitleLabel];
    
    _lineView = [UIView new];
    _lineView.backgroundColor = [UIColor viewBackColor];
    [self addSubview:_lineView];
}

- (void) layoutSubviews {
    kWeakSelf(self)
    [_leftView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(weakSelf.mas_bottom).with.offset(-10);
        make.left.mas_equalTo(weakSelf);
//        make.bottom.mas_equalTo(weakSelf);
//        make.height.mas_equalTo(@30);
    }];
    
    [_rightView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(weakSelf).with.offset(20);
        make.width.mas_equalTo(weakSelf.leftView);
        make.bottom.mas_equalTo(weakSelf.mas_bottom).with.offset(-10);
//        make.height.mas_equalTo(@30);
        make.right.mas_equalTo(weakSelf);
    }];
    
    [_slTitleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.leftView.mas_right);
        make.right.mas_equalTo(weakSelf.rightView.mas_left);
        make.bottom.mas_equalTo(weakSelf).with.offset(-10);
        make.centerX.mas_equalTo(weakSelf);
//        make.bottom.mas_equalTo(weakSelf);
//        make.height.mas_equalTo(@30);
    }];
    
    [_slTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(weakSelf.slTitleView);
        make.bottom.mas_equalTo(weakSelf.slTitleView);
        make.center.mas_equalTo(weakSelf.slTitleView);
        make.left.mas_greaterThanOrEqualTo(weakSelf.slTitleView);
    }];
    
    [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(@0.7);
        make.left.right.bottom.mas_equalTo(weakSelf);
    }];
    
}

- (void) setLeftItem:(UIView *)leftItem {
    _leftItem = leftItem;
    for(UIView *v in [self.leftView subviews]) {
        [v removeFromSuperview];
    }
    [self.leftView addSubview:leftItem];
    _leftItem = leftItem;
    
    [self layoutIfNeeded];
    kWeakSelf(self)
    [leftItem mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.mas_equalTo(weakSelf.leftView);
        make.width.mas_greaterThanOrEqualTo(@30);
        make.left.mas_equalTo(weakSelf.leftView).with.offset(15);
        make.right.mas_lessThanOrEqualTo(weakSelf.leftView).with.offset(-8);
    }];
}

- (void) setLeftItems:(NSArray *)leftItems {
    for(UIView *v in [self.leftView subviews]) {
        [v removeFromSuperview];
    }

    kWeakSelf(self)
    for (int i = 0; i < leftItems.count; i++) {
        UIView *v = leftItems[i];
        [self.leftView addSubview:v];
        [self layoutIfNeeded];
        [v mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.mas_equalTo(weakSelf.leftView);
            make.width.mas_greaterThanOrEqualTo(@30);
            make.left.mas_equalTo(i > 0?((UIView *)leftItems[i-1]).mas_right:weakSelf.leftView).with.offset(8);
            if (i == leftItems.count - 1) {
                make.right.equalTo(weakSelf.leftView);
            }
        }];
    }
}

- (void) setRightItem:(UIView *)rightItem {
    for(UIView *v in [self.rightView subviews]) {
        [v removeFromSuperview];
    }
    if (rightItem == nil) {
        return;
    }
    [self.rightView addSubview:rightItem];
    _rightItem = rightItem;
    
    [self layoutIfNeeded];
    kWeakSelf(self)
    [rightItem mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.mas_equalTo(weakSelf.rightView);
        make.width.mas_greaterThanOrEqualTo(@30);
        make.right.mas_equalTo(weakSelf.rightView).with.offset(-15);
        make.left.mas_equalTo(weakSelf.rightView).with.offset(8);
        
    }];
}

- (void) setRightItems:(NSArray *)rightItems {
    for(UIView *v in [self.rightView subviews]) {
        [v removeFromSuperview];
    }
    
    kWeakSelf(self)
    for (int i = 0; i < rightItems.count; i++) {
        UIView *v = rightItems[i];
        [self.rightView addSubview:v];
        
        [self layoutIfNeeded];
        [v mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.mas_equalTo(weakSelf.rightView);
            make.width.mas_greaterThanOrEqualTo(@30);
            make.right.mas_equalTo(i > 0?((UIView *)rightItems[i-1]).mas_left:weakSelf.rightView).with.offset(-15);
            if (i == rightItems.count - 1) {
                make.left.mas_greaterThanOrEqualTo(weakSelf.rightView);
            }
        }];
    }

}

- (void) setNaviBgColor:(UIColor *)naviBgColor {
    _naviBgColor = naviBgColor;
    self.backgroundColor = naviBgColor;
}

- (void) setNaviTintColor:(UIColor *)naviTintColor {
    _naviTintColor = naviTintColor;
    _slTitleLabel.textColor = naviTintColor;
    if (_leftItem != nil) {
        _leftItem.tintColor = naviTintColor;
    }
    if (_rightItem != nil) {
        _rightItem.tintColor = naviTintColor;
    }
}

@end
