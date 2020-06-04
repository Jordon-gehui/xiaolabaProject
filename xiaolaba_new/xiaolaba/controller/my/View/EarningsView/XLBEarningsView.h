//
//  XLBEarningsView.h
//  xiaolaba
//
//  Created by 戴葛辉 on 2018/1/24.
//  Copyright © 2018年 jackzhang. All rights reserved.
//

typedef NS_ENUM(NSUInteger,EarningsBtnTag) {
    EarningsWithDrawTag = 100,
    EarningsConversionTag,
    EarningsQuestionTag,
};

#import <UIKit/UIKit.h>
@protocol XLBEarningsViewDelegate <NSObject>

- (void)earningsBtnClick:(UIButton *)sender;
@end

@interface XLBEarningsView : UIView

@property (nonatomic, weak) id <XLBEarningsViewDelegate>delegate;

@end
