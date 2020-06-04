//
//  NSString+Category.h
//  YCYRBank
//
//  Created by 侯荡荡 on 16/4/27.
//  Copyright © 2016年 Hou. All rights reserved.

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSString (Category)
/**
 *  判断是不是正确的手机格式
 *
 *  @return 判断值
 */
- (BOOL) isValidMobileNumber;
/**
 *  判断是不是正确的验证码格式
 *
 *  @return 判断值
 */
- (BOOL) isValidVerifyCode;
/**
 *  判断是不是正确的银行卡号
 *
 *  @return 判断值
 */
- (BOOL) isValidBankCardNumber;
/**
 *  判断是不是正确的身份证格式
 *
 *  @return 判断值
 */
- (BOOL) isValidIdentityCard;
/**
 *  判断是不是中文格式
 *
 *  @return 判断值
 */
- (BOOL) isValidChinese;
/**
 *  判断是不是正确的邮政编码
 *
 *  @return 判断值
 */
- (BOOL) isValidZip;
/**
 *  判断是不是含有空格
 *
 *  @return 判断值
 */
- (BOOL) hasExistedSpace;
/**
 *  判断字符串是否为空
 *
 *  @param string 要判断的值
 *
 *  @return 判断值
 */
+ (BOOL) isBlankString:(NSString *)string;

/**
 *  判断是不是含有中文
 *
 *  @return 判断值
 */
- (BOOL)isHaveChinese;

@end



@interface NSString (urlEncode)
/**
*  url编码
*
*  @return url编码
*/
- (NSString *)URLEncodedString;
@end



@interface NSString (Format)
/**
*  手机格式
*
*  @param mobile 传入的值
*
*  @return (例：138 1844 2762)
*/
+ (NSString *)stringMobileFormat:(NSString*)mobile;

/**
 *  大数显示中文格式
 *
 *  @param value 传入的值
 *
 *  @return 中文格式的值(例:10000000 -> 1.00千万)
 */
+ (NSString *)stringChineseFormat:(CGFloat)value;
/**
 *  货币格式
 *
 *  @param currency 货币值
 *
 *  @return 货币格式的值(例:1234 -> 1,234.00)
 */
+ (NSString *)stringFormatterWithCurrency:(CGFloat)currency;
/**
 *  在String后面拼接.00
 *
 *  @param string 要拼接的值
 *
 *  @return 拼接后的值
 */
+ (NSString *)stringByAppendingZeroWithString:(NSString *)string;

@end



@interface NSString (Math)
/**
*  两大数相加
*
*  @param num1 数值1
*  @param num2 数值2
*
*  @return 相加后值的NSString对象
*/
+ (NSString *)addWithBigNums:(NSString *)num1 num2:(NSString *)num2;
/**
 *  两大数相乘
 *
 *  @param num1 数值1
 *  @param num2 数值2
 *
 *  @return 相乘后值的NSString对象
 */
+ (NSString *)mutiplyWithBigNums:(NSString *)num1 num2:(NSString *)num2;
/**
 *  只舍不入
 *
 *  @param value    数值
 *  @param position 保留小数点后几位
 *
 *  @return 只舍不入的值
 */
+ (NSString *)roundDown:(double)value afterPoint:(NSInteger)position;
/**
 *  只入不舍
 *
 *  @param value    数值
 *  @param position 保留小数点后几位
 *
 *  @return 只入不舍的值
 */
+ (NSString *)roundUp:(double)value afterPoint:(NSInteger)position;

@end



@interface NSString (Additions)
/**
 *  防止String类型进行stringValue的转型
 *
 *  @return string对象本身
 */
- (NSString *)stringValue;
/**
 *  获取文字的Size
 *
 *  @param size        文字容器的宽高
 *  @param font        文字字体
 *  @param lineSpacing 文字之间的间距
 *
 *  @return 文字的宽高
 */
- (CGSize)sizeWithConstrainedSize:(CGSize)size font:(UIFont *)font lineSpacing:(CGFloat)lineSpacing;

- (CGSize)boundingRectWithSize:(CGSize)size font:(UIFont*)font  lineSpacing:(CGFloat)lineSpacing;

/**
 *  计算是否超过一行
 */
- (BOOL)isMoreThanOneLineWithSize:(CGSize)size font:(UIFont *)font lineSpaceing:(CGFloat)lineSpacing;
/**
 *  固定宽度获取文字的Size
 *
 *  @param width 文字容器的最大宽度
 *  @param font  文字字体
 *
 *  @return 文字的宽高
 */
- (CGSize)sizeWithMaxWidth:(CGFloat)width font:(UIFont *)font;
/**
 *  固定宽度获取文字的Size
 *
 *  @param width       文字容器的最大宽度
 *  @param font        文字字体
 *  @param lineSpacing 文字之间的间距
 *
 *  @return 文字的宽高
 */
- (CGSize)sizeWithMaxWidth:(CGFloat)width font:(UIFont *)font lineSpacing:(CGFloat)lineSpacing;
/**
 *  获取文字的Size
 *
 *  @param font    文字字体
 *  @param maxSize 文字容器的最大宽高
 *
 *  @return 文字的宽高
 */
- (CGSize)sizeWithFont:(UIFont *)font maxSize:(CGSize)maxSize;

/**
 *  生成随机串
 *
 *  @return 随机串
 */
+ (NSString *)generateRandomString;

/**
 *  iOS 过滤特殊字符和Emoji表情
 *
 *  @return 过滤后的字符串
 */
- (NSString *)ttLegalNickName;

/**
 *  iOS 字符串是否包含特殊(表情)字符
 *
 *  @return 是否包含特殊字符
 */
+ (BOOL)hasSpecialChar:(NSString *)string;
/**
 *  iOS 移除特殊字符
 *
 *  @return 移除特殊字符后的字符串
 */
- (NSString*)removeEmoji;

//四舍五入

/**
 *  浮点型数据四舍五入
 *  @param format 保留两位小数  传入@"0.00";
 *  @param floatV 字符数据
 *  @return 四舍五入保留两位后的字符串
 */

-(NSString *) decimalwithFormat:(NSString *)format  floatV:(float)floatV;
/**
 *  iOS 汉字转小写
 *
 *  @return 转换之后的pinyin
 */
-(NSString *)lowercaseTranfrom:(NSString *)string;
@end






