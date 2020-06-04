//
//  XLBSeleDateView.h
//  xiaolaba
//
//  Created by 戴葛辉 on 2017/9/16.
//  Copyright © 2017年 jackzhang. All rights reserved.
//


@class XLBSeleDateView ;
@protocol XLBSeleDateViewDelegate <NSObject>

@optional
- (void)dateSelectView:(XLBSeleDateView *)view
     didSelectbirthday:(NSString *)birthday;



@end


@interface XLBSeleDateView : UIView

@property (nonatomic, copy) NSString *currentDate;
@property (nonatomic, weak) id<XLBSeleDateViewDelegate> delegate;
- (void)show:(UIView *)container;

@end
