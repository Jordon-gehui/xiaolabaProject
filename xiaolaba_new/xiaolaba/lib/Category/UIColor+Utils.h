//
//  UIColor+MicUtils.h
//  
//
//  Created by cs on 16/7/18.
//  Copyright © 2016年 cs. All rights reserved.
//

@interface UIColor (Utils)

+(UIColor *) colorWithR:(float )r g:(float )g b:(float )b;
+(UIColor *) colorWithR:(float )r g:(float )g b:(float )b a:(float )a;

+ (UIColor *) viewBackColor;
+ (UIColor *) navBackColor;
+ (UIColor *) buttonColor;
+ (UIColor *) naviTintColor;
+ (UIColor *) tipTextColor;

+ (UIColor *) normalTextColor;
+ (UIColor *) clickTextColor;

//90度渐变颜色
+ (UIColor *) shadeStartColor;
+ (UIColor *) shadeEndColor;
//用于特别强调突出的文字以及按钮
+ (UIColor *) emphasizeTextColor;
//用于特别强调突出的文字
+ (UIColor *) extrudeTextColor;
//用于大部分文字，标题文字以及普通段落

+ (UIColor *) textRightColor;

/**
 按钮的字体颜色( 60 66 77)
 @return  60 66 77
 */
+ (UIColor *) buttonTitleColor;

+ (UIColor *) imageLineColor;

+ (UIColor *)imageBackgroundColor;

+ (UIColor *) commonTextColor;
//用于辅助／次要的文字
+ (UIColor *) minorTextColor;
//用于注释性文字
+ (UIColor *) annotationTextColor;
+ (UIColor *) lineColor;

+ (UIColor *) titleTextColor;
+ (UIColor *) valueTextColor;

+ (UIColor *) btnBlackColor;

+ (UIColor *) colorWithHexString: (NSString *)color;

+ (UIColor *)mainColor;

+ (UIColor *)lightColor;
//文字颜色
+ (UIColor *) textBlackColor;
//辅助色
+ (UIColor *)assistColor;

+ (UIColor *)listTitleColor;
@end
