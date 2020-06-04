//
//  RechargeView.h
//  xiaolaba
//
//  Created by 戴葛辉 on 2018/4/24.
//  Copyright © 2018年 jackzhang. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol RechargeViewDelegate <NSObject>

- (void)didConfirmWithMoney:(NSString *)money;
@end


@interface RechargeView : UIView
@property (nonatomic, copy) NSString *account;
@property (nonatomic, copy) NSString *style;
@property (nonatomic, weak) id <RechargeViewDelegate>delegate;

@end
