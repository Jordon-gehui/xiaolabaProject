//
//  ZZCHelper.h
//  xiaolaba
//
//  Created by jackzhang on 2017/9/12.
//  Copyright © 2017年 jackzhang. All rights reserved.
//


#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <ImageIO/ImageIO.h>
typedef NS_ENUM(NSInteger,CellImgType) {
    XLBRoundCornerCellTypeLeft,
    XLBRoundCornerCellTypeTop,
    XLBRoundCornerCellTypeRight,
    XLBRoundCornerCellTypeBottom,
    XLBRoundCornerCellTypeDefault,
    XLBRoundCornerCellTypeTopRight,
    XLBRoundCornerCellTypeBottomRight
};
@interface ZZCHelper : NSObject

//把一个秒字符串 转化成真正的本地时间
+ (NSString *)dateStringFromNumberTimer:(NSString *)timerStr;

//把一个秒字符串 转化成真正的本地时间
+ (NSString *)dateStringFromNumberTimer:(NSString *)timerStr type:(NSInteger)type;

+ (NSString *)dateStringFromString:(NSString *)timeStr type:(NSInteger)type;
//根据字符串内容的多少  在固定宽度 下计算出实际的行高
+ (CGFloat)textHeightFromTextString:(NSString *)text width:(CGFloat)textWidth fontSize:(CGFloat)size;

+(NSString*)getCurrentTimestamp;
//对比当前时间
+(NSString *)dateStringFromNow:(NSString *)timeStr;
//获取网络时间
+ (NSDate *)getInternetDate;

//获取 当前设备版本
+ (double)getCurrentIOS;
//获取当前设备屏幕的大小
+ (CGSize)getScreenSize;
+(CAShapeLayer*)cornerRadiusUIBezierPath:(CellImgType)type :(CGRect)rect size:(CGSize)size;
@end
