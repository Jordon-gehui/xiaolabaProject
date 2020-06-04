//
//  PayCheTieView.h
//  xiaolaba
//
//  Created by 戴葛辉 on 2018/7/13.
//  Copyright © 2018年 jackzhang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SZTextView.h"
#import "PayCheTieModel.h"

typedef NS_ENUM(NSUInteger, PayCheTieViewType) {
    PayCheTieChargeType = 100,
    PayCheTieBuy,
};


typedef NS_ENUM(NSUInteger, PayCheTieViewBtnTag) {
    PayCheTieViewBuyBtn = 300,
    PayCheTieChargeBtn,
};

@protocol PayCheTieViewDelegate <NSObject>


- (void)seletedCity;
- (void)payCheTieViewBtnClick:(UIButton *)sender count:(NSInteger)count;

@end

@interface PayCheTieView : UIView

@property (nonatomic, strong) UITextField *nameTextField;
@property (nonatomic, strong) UITextField *phoneTextField;
@property (nonatomic, strong) UILabel *adressLabel;
@property (nonatomic, strong) SZTextView *adressTextView;

@property (nonatomic, strong) PayCheTieModel *model;
@property (nonatomic, weak) id<PayCheTieViewDelegate> delegate;
- (instancetype)initWithFrame:(CGRect)frame type:(PayCheTieViewType)type;

@end
