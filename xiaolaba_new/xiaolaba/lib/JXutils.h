//
//  JXutils.h
//  xiaolaba
//
//  Created by 斯陈 on 2017/8/31.
//  Copyright © 2017年 jxcode. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef NS_ENUM(NSInteger, IMGSTATE) {
    IMGNormal = 0,      ///< 默认
    IMGMoment,      ///< 450*450
//    IMGCircle,          ///< 头像切圆角
    IMGPick,           ///750*750
    IMGPick_OW,         ///750*600
    IMGREC,             ///单张动态处理 600*600
    IMGAvatar,           ///< 头像
    IMGMoment_rectangle, ///186 * 140
    IMGMoment_square,/// 250 * 250
    IMGMoment_single_w,/// 375 * 280
    IMGMoment_single_h,/// 375 * 470
    //circle square square2
};

typedef NSUInteger BMKAnnotationViewDragState;
@interface JXutils : NSObject

+(NSString *)judgeImageheader:(NSString*)img Withtype:(IMGSTATE)Type;

+ (BOOL)isValidPhone:(NSString *)phone;

+ (BOOL)isValidCode:(NSString *)code;
//定位是否打开
+ (BOOL)isLocationServiceOpen;
//获取当前屏幕显示的viewcontroller
+ (UIViewController *)getCurrentVC;

+ (CGFloat )textWidthWithFont:(CGFloat)font WithString:(NSString*)text Size:(CGSize)size;

+(BOOL)checkCarID:(NSString *)carID;

+(NSString *)MD5ForLower32Bate:(NSString *)str;

+(NSString *)MD5ForUpper32Bate:(NSString *)str;

+(BOOL)isNum:(NSString *)checkedNumString;
+ (UIImage *)compressImageQuality:(UIImage *)image toByte:(NSInteger)maxLength;
@end
