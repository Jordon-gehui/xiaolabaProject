//
//  NSString+Category.m
//  YCYRBank
//
//  Created by 侯荡荡 on 16/4/27.
//  Copyright © 2016年 Hou. All rights reserved.
//

#import "NSString+Category.h"

#define K_CURRENT_TIMESTAMP         [NSString stringWithFormat:@"%ld", (long)[[NSDate date] timeIntervalSince1970]]

/** 验证码长度 */
#define LENGTH_VERIFY_CODE          6


@implementation NSString (Category)


//四舍五入

/**
 *  浮点型数据四舍五入
 *  @param format 保留两位小数  传入@"0.00";
 *  @param floatV 字符数据
 *  @return 四舍五入保留两位后的字符串
 */

-(NSString *) decimalwithFormat:(NSString *)format  floatV:(float)floatV{
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setPositiveFormat:format];
    return  [numberFormatter stringFromNumber:[NSNumber numberWithFloat:floatV]];
    
}


- (NSString*)removeEmoji
{
    __block NSMutableString* temp = [NSMutableString string];
    
    [self enumerateSubstringsInRange: NSMakeRange(0, [self length]) options:NSStringEnumerationByComposedCharacterSequences usingBlock:
     ^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop){
         
         const unichar hs = [substring characterAtIndex: 0];
         
         // surrogate pair
         if (0xd800 <= hs && hs <= 0xdbff) {
             const unichar ls = [substring characterAtIndex: 1];
             const int uc = ((hs - 0xd800) * 0x400) + (ls - 0xdc00) + 0x10000;
             
             [temp appendString: (0x1d000 <= uc && uc <= 0x1f77f)? @"": substring]; // U+1D000-1F77F
             
             // non surrogate
         } else {
             [temp appendString: (0x2100 <= hs && hs <= 0x26ff)? @"": substring]; // U+2100-26FF
         }
     }];
    
    return temp;
}

- (BOOL) isValidMobileNumber {
    if (self.length>11) {
        return NO;
    }
    //手机号以17,13， 15，18开头，八个 \d 数字字符
    NSString *phoneRegex = @"^((14[0-9])|(17[0-9])|(13[0-9])|(15[^4,\\D])|(18[0,0-9]))\\d{8}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    return [phoneTest evaluateWithObject:self];

}

+ (BOOL)hasSpecialChar:(NSString *)string{
    __block BOOL returnValue = NO;
    [string enumerateSubstringsInRange:NSMakeRange(0, [string length])
                               options:NSStringEnumerationByComposedCharacterSequences
                            usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
                                const unichar hs = [substring characterAtIndex:0];
                                if (0xd800 <= hs && hs <= 0xdbff) {
                                    if (substring.length > 1) {
                                        const unichar ls = [substring characterAtIndex:1];
                                        const int uc = ((hs - 0xd800) * 0x400) + (ls - 0xdc00) + 0x10000;
                                        if (0x1d000 <= uc && uc <= 0x1f77f) {
                                            returnValue = YES;
                                        }
                                    }
                                } else if (substring.length > 1) {
                                    const unichar ls = [substring characterAtIndex:1];
                                    if (ls == 0x20e3) {
                                        returnValue = YES;
                                    }
                                } else {
                                    if (0x2100 <= hs && hs <= 0x27ff) {
                                        returnValue = YES;
                                    } else if (0x2B05 <= hs && hs <= 0x2b07) {
                                        returnValue = YES;
                                    } else if (0x2934 <= hs && hs <= 0x2935) {
                                        returnValue = YES;
                                    } else if (0x3297 <= hs && hs <= 0x3299) {
                                        returnValue = YES;
                                    } else if (hs == 0xa9 || hs == 0xae || hs == 0x303d || hs == 0x3030 || hs == 0x2b55 || hs == 0x2b1c || hs == 0x2b1b || hs == 0x2b50) {
                                        returnValue = YES;
                                    }
                                }
                            }];
    
    return returnValue;
}

- (BOOL) isValidVerifyCode {
    
    NSString* const VERIFYCODE = [NSString stringWithFormat:@"^d{%d}$", LENGTH_VERIFY_CODE];
    
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", VERIFYCODE];
    return [predicate evaluateWithObject:self];
}

- (BOOL) isValidBankCardNumber {
    NSString* const BANKCARD = @"^(\\d{15}|\\d{16}|\\d{17}|\\d{18}|\\d{19}|\\d{20})$";
    
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", BANKCARD];
    return [predicate evaluateWithObject:self];
}

- (BOOL) isValidIdentityCard {
    NSString* const IDENTITY = @"^\\d{18,18}|\\d{15,15}|\\d{17,17}x)*$";
    
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", IDENTITY];
    return [predicate evaluateWithObject:self];
}

- (BOOL) isValidChinese {
    NSString* const IDENTITY = @"^[\u4e00-\u9fa5]*$";//@"[a-zA-Z\u4e00-\u9fa5][a-zA-Z0-9\u4e00-\u9fa5]+"
    
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", IDENTITY];
    return [predicate evaluateWithObject:self];
}

- (BOOL) isValidZip {
    NSString* const IDENTITY = @"[1-9]\\d{5}(?!\\d)";
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", IDENTITY];
    return [predicate evaluateWithObject:self];
}

- (BOOL) hasExistedSpace {
    return ([self rangeOfString:@" "].length > 0);
}

+ (BOOL)isBlankString:(NSString *)string{
    
    if (string == nil || string == NULL) {
        return YES;
    }
    if ([string isKindOfClass:[NSNull class]]) {
        return YES;
    }
    if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length] == 0) {
        return YES;
    }
    return NO;
}

- (BOOL)isHaveChinese {
    
    for (NSInteger i = 0; i< [self length]; i++) {
        NSInteger a = [self characterAtIndex:i];
        if ( a > 0x4e00 && a < 0x9fff) {
            return YES;
        }
    }
    return NO;
}

@end



@implementation NSString (urlEncode)

- (NSString *)URLEncodedString {
    NSString *encodedString = (NSString *)
    CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                            (CFStringRef)self,
                                            (CFStringRef)@"!$&'()*+,-./:;=?@_~%#[]",
                                            NULL,
                                            kCFStringEncodingUTF8));
    return encodedString;
}

@end




@implementation NSString (Format)

+ (NSString*) stringMobileFormat:(NSString *)mobile {
    
    if ([mobile isValidMobileNumber]) {
        NSMutableString* value = [[NSMutableString alloc] initWithString:mobile];
        [value insertString:@" " atIndex:3];
        [value insertString:@" " atIndex:8];
        return value;
    }
    
    return nil;
}

+ (NSString*) stringChineseFormat:(CGFloat)value{
    
    if (value / 100000000.0f >= 1) {
        return [NSString stringWithFormat:@"%.2f亿", value / 100000000.0f];
    }
    else if (value / 10000.0f >= 1 && value / 100000000.0f < 1) {
        return [NSString stringWithFormat:@"%.2f万", value / 10000.0f];
    }
    else {
        return [NSString stringWithFormat:@"%.2f", value];
    }
}

+ (NSString *)stringFormatterWithCurrency:(CGFloat)currency {
    
    NSString* value         = [NSString stringWithFormat:@"%.02f", currency];

    NSMutableString* string = [[NSMutableString alloc] init];
    [string appendString:[value substringFromIndex:[value length] - 3]];
    
    NSInteger index = [value length] - 6;
    while (index > 0) {
        NSString* subValue = [value substringWithRange:NSMakeRange(index, 3)];
        [string insertString:subValue atIndex:0];
        [string insertString:@"," atIndex:0];
        index -= 3;
    }
    if (index <= 0) {
        NSString* subValue = [value substringWithRange:NSMakeRange(0, 3 + index)];
        [string insertString:subValue atIndex:0];
    }
    return string;
}

+ (NSString *)stringByAppendingZeroWithString:(NSString *)string {
    
    NSString *str = [self isBlankString:string] ? @"0.00" : @".00";
    return [string stringByAppendingString:str];
}

@end




@implementation NSString (Math)

+ (NSString *)addWithBigNums:(NSString *)num1 num2:(NSString *)num2 {
    
    NSString *result = [NSString string];
    //确保num1大些，如果不是，则调换。
    if (num1.length < num2.length){
        result = [NSString stringWithString:num1];
        num1   = [NSString stringWithString:num2];
        num2   = [NSString stringWithString:result];
        result = [NSString string];
    }
    //进位
    NSInteger carryBit   = 0;
    //加法的最大位
    NSInteger largestBit = 0;
    
    for (NSInteger i = 1 ; i <= num2.length ; i++){
        //num1 的当前位
        NSInteger intNum1 = [[num1 substringWithRange:NSMakeRange(num1.length - i, 1)] integerValue];
        //num2 的当前位
        NSInteger intNum2 = [[num2 substringWithRange:NSMakeRange(num2.length - i, 1)] integerValue];
        
        NSInteger intTemp = intNum1 + intNum2 + carryBit;
        
        if (intTemp > 9){
            carryBit = 1;
            result = [NSString stringWithFormat:@"%zi%@",intTemp % 10,result];
        }else{
            carryBit = 0;
            result = [NSString stringWithFormat:@"%zi%@",intTemp,result];
        }
        if (i == num2.length){
            if (num1.length == num2.length){
                if (carryBit) result = [NSString stringWithFormat:@"%zi%@",carryBit,result];
            }else{
                largestBit = [[num1 substringWithRange:NSMakeRange(num1.length - i - 1, 1)] integerValue];
                NSString *restStringOfNum1 = [num1 substringWithRange:NSMakeRange(0, num1.length - num2.length - 1)];
                result = [NSString stringWithFormat:@"%@%zi%@", restStringOfNum1,largestBit + carryBit,result];
            }
        }
    }
    return result;
}

+ (NSString *)mutiplyWithBigNums:(NSString *)num1 num2:(NSString *)num2 {
    
    NSString *result = [NSString string];
    //按两位来分组每一个乘数
    NSArray *arrayNum1 = [self tearStringToArray:num1];
    NSArray *arrayNum2 = [self tearStringToArray:num2];
    //循环分组内的元素，相乘
    NSString *tempResult ;
    
    for (NSInteger i = 0 ; i < [arrayNum1 count] ; i ++){
        NSInteger item1 = [[arrayNum1 objectAtIndex:i] intValue];
        for (NSInteger j = 0 ; j < [arrayNum2 count]; j ++){
            NSInteger item2 = [[arrayNum2 objectAtIndex:j] intValue];
            NSInteger temp  = item1 * item2;
            tempResult = [NSString stringWithFormat:@"%zi",temp];
            for (NSInteger k = 0 ; k < i + j ; k ++){
                tempResult = [tempResult stringByAppendingString:@"0"];
            }
            if (result.length){
                result = [self addWithBigNums:result num2:tempResult];
            }else{
                result = tempResult;
            }
        }
    }
    return result;
}

+ (NSArray *)tearStringToArray:(NSString *)string {
    
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:string.length];
    for (unsigned long i = string.length; i > 0; i --){
        NSString *temp = [string substringWithRange:NSMakeRange(i - 1, 1)];
        [array addObject:temp];
    }
    return [array mutableCopy];
}


+ (NSString *)roundDown:(double)value afterPoint:(NSInteger)position {
    
    NSDecimalNumberHandler* roundingBehavior = [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:NSRoundDown
                                                                                                      scale:position
                                                                                           raiseOnExactness:NO
                                                                                            raiseOnOverflow:NO
                                                                                           raiseOnUnderflow:NO
                                                                                        raiseOnDivideByZero:NO];
    NSDecimalNumber *ouncesDecimal;
    NSDecimalNumber *roundedOunces;
    
    ouncesDecimal = [[NSDecimalNumber alloc] initWithDouble:value];
    roundedOunces = [ouncesDecimal decimalNumberByRoundingAccordingToBehavior:roundingBehavior];
    
    return [NSString stringWithFormat:@"%@",roundedOunces];
}

+ (NSString *)roundUp:(double)value afterPoint:(NSInteger)position {
    
    NSDecimalNumberHandler* roundingBehavior = [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:NSRoundUp
                                                                                                      scale:position
                                                                                           raiseOnExactness:NO
                                                                                            raiseOnOverflow:NO
                                                                                           raiseOnUnderflow:NO
                                                                                        raiseOnDivideByZero:NO];
    NSDecimalNumber *ouncesDecimal;
    NSDecimalNumber *roundedOunces;
    
    ouncesDecimal = [[NSDecimalNumber alloc] initWithDouble:value];
    roundedOunces = [ouncesDecimal decimalNumberByRoundingAccordingToBehavior:roundingBehavior];
    
    return [NSString stringWithFormat:@"%@",roundedOunces];
}

@end




@implementation NSString (Additions)

- (NSString *)stringValue {
    return self;
}
- (CGSize)boundingRectWithSize:(CGSize)size font:(UIFont*)font  lineSpacing:(CGFloat)lineSpacing
{
    NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:self];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = lineSpacing;
    [attributeString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, self.length)];
    [attributeString addAttribute:NSFontAttributeName value:font range:NSMakeRange(0, self.length)];
    NSStringDrawingOptions options = NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading;
    CGRect rect = [attributeString boundingRectWithSize:size options:options context:nil];
    //文本的高度减去字体高度小于等于行间距，判断为当前只有1行
    if ((rect.size.height - font.lineHeight) <= paragraphStyle.lineSpacing) {
        if ([self containChinese:self]) {  //如果包含中文
            rect = CGRectMake(rect.origin.x, rect.origin.y, rect.size.width, rect.size.height-paragraphStyle.lineSpacing);
        }
    }
    return rect.size;
}

- (BOOL)isMoreThanOneLineWithSize:(CGSize)size font:(UIFont *)font lineSpaceing:(CGFloat)lineSpacing{
    
    if ( [self boundingRectWithSize:size font:font lineSpacing:lineSpacing].height > font.lineHeight  ) {
        return YES;
    }else{
        return NO;
    }
}



//判断是否包含中文
- (BOOL)containChinese:(NSString *)str {
    for(int i=0; i< [str length];i++){
        int a = [str characterAtIndex:i];
        if( a > 0x4e00 && a < 0x9fff){
            return YES;
        }
    }
    return NO;
}


- (CGSize)sizeWithConstrainedSize:(CGSize)size font:(UIFont *)font lineSpacing:(CGFloat)lineSpacing {
    
    CGSize expectedSize = CGSizeZero;
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.lineBreakMode            = NSLineBreakByWordWrapping;
        paragraphStyle.lineSpacing              = lineSpacing;
        NSDictionary *attributes                = @{NSFontAttributeName:font,
                                                    NSParagraphStyleAttributeName:paragraphStyle.copy};
        expectedSize                            = [self boundingRectWithSize:size
                                                                     options:NSStringDrawingUsesLineFragmentOrigin |
                                                                             NSStringDrawingUsesFontLeading
                                                                  attributes:attributes
                                                                     context:nil].size;
    } else {
        expectedSize = [self sizeWithFont:font
                        constrainedToSize:size
                            lineBreakMode:NSLineBreakByWordWrapping];
    }
    
    return CGSizeMake(ceil(expectedSize.width), ceil(expectedSize.height));
}

- (CGSize)sizeWithMaxWidth:(CGFloat)width font:(UIFont *)font {
    return [self sizeWithConstrainedSize:CGSizeMake(width, FLT_MAX) font:font lineSpacing:0];
}

- (CGSize)sizeWithMaxWidth:(CGFloat)width font:(UIFont *)font lineSpacing:(CGFloat)lineSpacing {
    return [self sizeWithConstrainedSize:CGSizeMake(width, FLT_MAX) font:font lineSpacing:lineSpacing];
}

- (CGSize)sizeWithFont:(UIFont *)font maxSize:(CGSize)maxSize {
    
    NSDictionary *dict = @{ NSFontAttributeName : font };
    CGSize textSize = [self boundingRectWithSize:maxSize
                                         options:NSStringDrawingUsesLineFragmentOrigin
                                      attributes:dict
                                         context:nil].size;
    return textSize;
}

+ (NSString *)generateRandomString {
    
    NSString *string = [[NSString alloc]init];
    for (NSInteger i = 0; i < 32; i++) {
        NSInteger number = arc4random() % 36;
        if (number < 10) {
            NSInteger figure = arc4random() % 10;
            NSString *tempString = [NSString stringWithFormat:@"%zi", figure];
            string = [string stringByAppendingString:tempString];
        }else {
            NSInteger figure = (arc4random() % 26) + 97;
            char character = figure;
            NSString *tempString = [NSString stringWithFormat:@"%c", character];
            string = [string stringByAppendingString:tempString];
        }
    }
     return [string stringByAppendingString:K_CURRENT_TIMESTAMP];
}

- (NSString *)ttLegalNickName
{
    //合法字符集合
    NSCharacterSet *legalPunctuationCharacterSet = [NSCharacterSet characterSetWithCharactersInString:@"@&+.-, ~!%*()#"];
    
    //英文和数字字符集合
    NSCharacterSet *alphanumericCharacterSet = [NSCharacterSet alphanumericCharacterSet];
    
    //中文字符集合
    NSCharacterSet *chineseSet = [self ttChineseSet];
    
    //合法字符  英文和数字字符 中文字符 并集的集合
    NSMutableCharacterSet *characterSet  = [[NSMutableCharacterSet alloc] init];
    [characterSet formUnionWithCharacterSet:legalPunctuationCharacterSet];
    [characterSet formUnionWithCharacterSet:alphanumericCharacterSet];
    [characterSet formUnionWithCharacterSet:chineseSet];
    
    // 除去合法字符  英文和数字字符 中文字符 并集的集合的补集
    NSCharacterSet *illegalCharacterSet = characterSet.invertedSet;
    
    // 将非法字符过滤成 @""
    NSString *legalNickName = [[self componentsSeparatedByCharactersInSet:illegalCharacterSet] componentsJoinedByString:@""];
    
    // 将合法字符过滤成 @"·"
    //legalNickName = [[legalNickName componentsSeparatedByCharactersInSet:legalPunctuationCharacterSet] componentsJoinedByString:@"·" ];
    
    return legalNickName;
}

- (NSCharacterSet *)ttChineseSet
{
    // 中文字符集合
    static NSCharacterSet *chineseSet;
    if (chineseSet == nil)
    {
        NSMutableCharacterSet *aCharacterSet = [[NSMutableCharacterSet alloc] init];
        
        NSRange lcEnglishRange;
        lcEnglishRange.location = (unsigned int)0x4e00;
        lcEnglishRange.length = (unsigned int)0x9fa5 - (unsigned int)0x4e00;
        [aCharacterSet addCharactersInRange:lcEnglishRange];
        chineseSet = aCharacterSet;
    }
    return chineseSet;
}

- (NSString *)lowercaseTranfrom:(NSString *)string {
    NSMutableString *pinyin = [string mutableCopy];
    CFStringTransform((__bridge CFMutableStringRef)pinyin, NULL, kCFStringTransformMandarinLatin, NO);
    NSLog(@"%@", pinyin);
    CFStringTransform((__bridge CFMutableStringRef)pinyin, NULL, kCFStringTransformStripCombiningMarks, NO);
    NSLog(@"%@", pinyin);
    return [pinyin lowercaseString];
}

@end






