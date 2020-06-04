//
//  BQLSheetView.h
//  xiaolaba
//
//  Created by lin on 2017/7/12.
//  Copyright © 2017年 jxcode. All rights reserved.
//

#import <UIKit/UIKit.h>
@class BQLSheetView;
@protocol BQLSheetViewDelegate <NSObject>

/**
 所选item索引

 @param sheetView BQLSheetView
 @param index     索引
 */
- (void)sheetView:(BQLSheetView *)sheetView items:(NSArray *)items didSelectAtIndex:(NSUInteger )index;

/**
 所选年月日

 @param sheetView BQLSheetView
 @param date      年月日
 */
- (void)sheetView:(BQLSheetView *)sheetView didSelectDate:(NSString *)date;

@end

@interface BQLSheetView : UIView

@property (nonatomic, weak) id<BQLSheetViewDelegate>delegate;

/**
 普通模式

 @param items   条目
 @param message 标题

 @return BQLSheetView
 */
- (instancetype)initWith:(NSArray *)items message:(NSString *)message;

/**
 年月日选择

 @return BQLSheetView
 */
- (instancetype)initWithDatePickView;

- (void)show:(UIView *)container;

@end
