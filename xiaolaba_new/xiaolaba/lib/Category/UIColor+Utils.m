//
//  UIColor+Utils.h
//
//  Created by cs on 16/7/18.
//  Copyright © 2016年 . All rights reserved.
//


#import "UIColor+Utils.h"

@implementation UIColor (Utils)

+(UIColor *) colorWithR:(float )r g:(float )g b:(float )b{
    
    return  [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1];
    
}

+(UIColor *) colorWithR:(float )r g:(float )g b:(float )b a:(float )a{
    return  [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a];
}

+ (UIColor *) viewBackColor {
    return [self colorWithR:248.0 g:248.0 b:248.0]; //333333
}
//用于内容模块分割底色
+ (UIColor *) navBackColor {
    return [UIColor whiteColor];
//    return UIColorFromRGB(0xF5F5F5);
}
+ (UIColor *)assistColor {
    return RGB(46, 48, 51);
}

+ (UIColor *) naviTintColor { //3EABC4
    return [UIColor whiteColor];
}
+ (UIColor *) tipTextColor { //204,204,204
    return UIColorFromRGB(0xcccccc);
}
+ (UIColor *) buttonColor { //C7C7C7
    return RGB(199, 199, 199);
}

+ (UIColor *) normalTextColor { //3D3D3D
    return RGB(61, 61, 61);
}

+ (UIColor *) clickTextColor { //00C34B
    return RGB(0, 195, 75);
}

+ (UIColor *) shadeStartColor { //255,192,2
    return UIColorFromRGB(0xffc002);
}
+ (UIColor *) shadeEndColor { //255,232,78
    return UIColorFromRGB(0xffe84e);
}

//用于特别强调突出的文字以及按钮
+ (UIColor *) emphasizeTextColor { //34,180,153
    return UIColorFromRGB(0x22B499);
}
//用于特别强调突出的文字
+ (UIColor *) extrudeTextColor { //64,171,198
    return UIColorFromRGB(0x40ABC6);
}
//用于大部分文字，标题文字以及普通段落
+ (UIColor *) commonTextColor { //51 51 51
    return UIColorFromRGB(0x333333);
}

+ (UIColor *)imageBackgroundColor {
    return [UIColor colorWithR:246.0 g:246.0 b:246.0];
}
//用于辅助／次要的文字
+ (UIColor *) minorTextColor { //102,102,102
    return UIColorFromRGB(0x666666);
}
//用于注释性文字
+ (UIColor *) annotationTextColor {//153,153,153
    return UIColorFromRGB(0x999999);
}
//用于图片边线颜色
+ (UIColor *)imageLineColor {
    return RGB(234, 234, 234);
}

+ (UIColor *) buttonTitleColor {
    return RGB(60, 66, 77);
}
//用于分割线颜色
+ (UIColor *) lineColor { //229,229,229
    return UIColorFromRGB(0xE5E5E5);
}
+ (UIColor *) titleTextColor { //155,155,155
    return UIColorFromRGB(0x9b9b9b);
}
+ (UIColor *) valueTextColor { //87,87,87
    return UIColorFromRGB(0x575757);
}

+ (UIColor *) btnBlackColor { //239,237,232
    return UIColorFromRGB(0xefede8);
}
+ (UIColor *) textBlackColor { //61,66,76
    return UIColorFromRGB(0x3d424c);
}
//文字
+ (UIColor *) textRightColor { //174,181,194
    return RGB(174, 181, 194);
}
+ (UIColor *)mainColor {
    return [self colorWithHexString:@"#3d424c"];
}

+ (UIColor *)lightColor { //255,222,2
    return [self colorWithHexString:@"#ffde02"];
}

+ (UIColor *)listTitleColor {
    return [self colorWithR:31 g:31 b:31];
}

+ (UIColor *) colorWithHexString: (NSString *)color
{
    NSString *cString = [[color stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    // String should be 6 or 8 characters
    if ([cString length] < 6) {
        return [UIColor clearColor];
    }
    // 判断前缀
    if ([cString hasPrefix:@"0X"])
        cString = [cString substringFromIndex:2];
    if ([cString hasPrefix:@"#"])
        cString = [cString substringFromIndex:1];
    if ([cString length] != 6)
        return [UIColor clearColor];
    // 从六位数值中找到RGB对应的位数并转换
    NSRange range;
    range.location = 0;
    range.length = 2;
    //R、G、B
    NSString *rString = [cString substringWithRange:range];
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f) green:((float) g / 255.0f) blue:((float) b / 255.0f) alpha:1.0f];
}
@end
