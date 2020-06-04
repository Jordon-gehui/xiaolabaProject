//
//  XLBScreeningView.h
//  xiaolaba
//
//  Created by lin on 2017/7/19.
//  Copyright © 2017年 jxcode. All rights reserved.
//

#import "UIView+Category.h"
@class FindScreenModel;

@interface XLBScreenItem : UIButton
- (instancetype)initWithFrame:(CGRect)frame title:(NSString *)title suit:(BOOL )suit;
@property (nonatomic, copy, readonly) NSString *title;
@property (nonatomic, strong) UIImageView *logo;
@property (nonatomic, copy) NSString *value; // params
@property (nonatomic, copy) NSString *type; // 类型：sex、city
// @property (nonatomic, assign) BOOL selected; // 是否被选中
// @property (nonatomic, strong) UIButton *touch;
@end

@class XLBScreeningView;
@protocol XLBScreeningViewDelegate <NSObject>

- (void)screenView:(XLBScreeningView *)screenView didClickMore:(BOOL )more;
//- (void)screenView:(XLBScreeningView *)screenView didSelectParams:(NSDictionary *)params;

@end
@interface XLBScreeningView : UIView

/**
 筛选view初始化

 @param frame       frame
 @param classify    分类（[{@"sex":[0,1]},{@"age":[90,00]}]）

 @return 筛选view
 */
- (instancetype)initWithFrame:(CGRect)frame
                     classify:(NSArray <FindScreenModel *>*)classify;

@property (nonatomic, strong, readonly) NSDictionary *params;

@property (nonatomic, weak) id<XLBScreeningViewDelegate>delegate;

@end
