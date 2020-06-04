//
//  XLBEarningsListView.h
//  xiaolaba
//
//  Created by 戴葛辉 on 2018/1/24.
//  Copyright © 2018年 jackzhang. All rights reserved.
//

typedef NS_ENUM(NSUInteger,BillDetailBtnTag) {
    BillDetailRechargeBtnTag = 100,//充值
    BillDetailWithdrawBtnTag,//提现
    BillDetailConversionBtnTag,//兑换
    
};


#import <UIKit/UIKit.h>

@protocol XLBEarningsListViewDelegate <NSObject>

- (void)billDetailButtonClick:(UIButton *)sender;
@end

@interface XLBEarningsListView : UIView

@property (nonatomic, strong) UIButton *rechargeBtn;
@property (nonatomic, strong) UIButton *withdrawBtn;
@property (nonatomic, strong) UIButton *conversionBtn;

@property (nonatomic, weak)id <XLBEarningsListViewDelegate>delegate;
@end
