//
//  JXutils.m
//  xiaolaba
//
//  Created by 斯陈 on 2017/8/31.
//  Copyright © 2017年 jxcode. All rights reserved.
//

#import "JXutils.h"
#import <CommonCrypto/CommonDigest.h>


@implementation JXutils

+(NSString *)judgeImageheader:(NSString*)img Withtype:(IMGSTATE)Type {
    NSString *imgUrl = img;
    if (!kNotNil(img)) {
        return @"";
    }
    if (!([imgUrl hasPrefix:@"http://"]||[imgUrl hasPrefix:@"https://"])) {
        imgUrl = [NSString stringWithFormat:@"%@%@",kImagePrefix,imgUrl];
        
        for (NSString *suffix in @[@"-circle",@"-square",@"-square2"]) {
            if ([imgUrl hasSuffix:suffix]) {
                imgUrl = [imgUrl substringToIndex:imgUrl.length-suffix.length];//去掉尾部
            }
        }
        switch (Type) {
//            case IMGCircle:
//                imgUrl = [imgUrl stringByAppendingString:@"-circle"];
//                break;
            case IMGMoment:
                imgUrl = [imgUrl stringByAppendingString:@"-moment"];
                break;
            case IMGPick_OW:
                imgUrl = [imgUrl stringByAppendingString:@"-pick_ow"];
                break;
            case IMGPick:
                imgUrl = [imgUrl stringByAppendingString:@"-pick"];
                break;
            case IMGREC:
                imgUrl = [imgUrl stringByAppendingString:@"-rec"];
                break;
            case IMGAvatar:
                imgUrl = [imgUrl stringByAppendingString:@"-avatar"];
                break;
            case IMGMoment_single_w:
                imgUrl = [imgUrl stringByAppendingString:@"-moment_single_w"];
                break;
            case IMGMoment_single_h:
                imgUrl = [imgUrl stringByAppendingString:@"-moment_single_h"];
                break;
            case IMGMoment_square:
                imgUrl = [imgUrl stringByAppendingString:@"-moment_square"];
                break;
            case IMGMoment_rectangle:
                imgUrl = [imgUrl stringByAppendingString:@"-moment_rectangle"];
                break;
            default:
                break;
        }

    }else {
        if ([imgUrl hasPrefix:@""]) {
            for (NSString *suffix in @[@"-circle",@"-square",@"-square2"]) {
                if ([imgUrl hasSuffix:suffix]) {
                    imgUrl = [imgUrl substringToIndex:imgUrl.length-suffix.length];//去掉尾部
                }
            }
            switch (Type) {
                    //            case IMGCircle:
                    //                imgUrl = [imgUrl stringByAppendingString:@"-circle"];
                    //                break;
                case IMGMoment:
                    imgUrl = [imgUrl stringByAppendingString:@"-moment"];
                    break;
                case IMGPick:
                    imgUrl = [imgUrl stringByAppendingString:@"-pick"];
                    break;
                case IMGPick_OW:
                    imgUrl = [imgUrl stringByAppendingString:@"-pick_ow"];
                    break;
                case IMGREC:
                    imgUrl = [imgUrl stringByAppendingString:@"-rec"];
                    break;
                case IMGAvatar:
                    imgUrl = [imgUrl stringByAppendingString:@"-avatar"];
                    break;
                default:
                    break;
            }
        }else {
            return imgUrl;
        }
    }
        return imgUrl;
}

+ (BOOL)isValidPhone:(NSString *)phone {
    return (phone.length == max_phone_length);
}

+ (BOOL)isValidCode:(NSString *)code {
    return (code.length == max_code_length);
}

//获取当前屏幕显示的viewcontroller
+ (UIViewController *)getCurrentVC
{
    UIViewController *rootViewController = [UIApplication sharedApplication].keyWindow.rootViewController;
    
    UIViewController *currentVC = [self getCurrentVCFrom:rootViewController];
    
    return currentVC;
}

+ (UIViewController *)getCurrentVCFrom:(UIViewController *)rootVC
{
    UIViewController *currentVC;
    
    if ([rootVC presentedViewController]) {
        // 视图是被presented出来的
        
        rootVC = [rootVC presentedViewController];
    }
    
    if ([rootVC isKindOfClass:[UITabBarController class]]) {
        // 根视图为UITabBarController
        
        currentVC = [self getCurrentVCFrom:[(UITabBarController *)rootVC selectedViewController]];
        
    } else if ([rootVC isKindOfClass:[UINavigationController class]]){
        // 根视图为UINavigationController
        
        currentVC = [self getCurrentVCFrom:[(UINavigationController *)rootVC visibleViewController]];
        
    } else {
        // 根视图为非导航类
        
        currentVC = rootVC;
    }
    
    return currentVC;
}

+ (BOOL)isLocationServiceOpen {
    if ([ CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied) {
        return NO;
    } else
        return YES;
}

+ (CGFloat )textWidthWithFont:(CGFloat)font WithString:(NSString*)text Size:(CGSize)size {
    
    CGRect rect=[text boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:font],NSFontAttributeName, nil] context:nil];
    return rect.size.width;
}

+(BOOL)checkCarID:(NSString *)carID{
    if (carID.length!=7) {
        return NO;
    }
    NSString *carRegex = @"^[\u4e00-\u9fa5]{1}[a-hj-zA-HJ-Z]{1}[a-hj-zA-HJ-Z_0-9]{4}[a-hj-zA-HJ-Z_0-9_\u4e00-\u9fa5]$";
    NSPredicate *carTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",carRegex];
    return [carTest evaluateWithObject:carID];
    
    return YES;
}

#pragma mark - 32位 小写
+(NSString *)MD5ForLower32Bate:(NSString *)str{
    
    //要进行UTF8的转码
    const char* input = [str UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(input, (CC_LONG)strlen(input), result);
    
    NSMutableString *digest = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for (NSInteger i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        [digest appendFormat:@"%02x", result[i]];
    }
    
    return digest;
}

#pragma mark - 32位 大写
+(NSString *)MD5ForUpper32Bate:(NSString *)str{
    
    //要进行UTF8的转码
    const char* input = [str UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(input, (CC_LONG)strlen(input), result);
    
    NSMutableString *digest = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for (NSInteger i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        [digest appendFormat:@"%02X", result[i]];
    }
    
    return digest;
}

+ (BOOL)isNum:(NSString *)checkedNumString {
    checkedNumString = [checkedNumString stringByTrimmingCharactersInSet:[NSCharacterSet decimalDigitCharacterSet]];
    if(checkedNumString.length > 0) {
        return NO;
    }
    return YES;
}

+ (UIImage *)compressImageQuality:(UIImage *)image toByte:(NSInteger)maxLength {
    CGFloat compression = 1;
    NSData *data = UIImageJPEGRepresentation(image, compression);
    if (data.length < maxLength) return image;
    CGFloat max = 1;
    CGFloat min = 0;
    for (int i = 0; i < 6; ++i) {
        compression = (max + min) / 2;
        data = UIImageJPEGRepresentation(image, compression);
        if (data.length < maxLength * 0.9) {
            min = compression;
        } else if (data.length > maxLength) {
            max = compression;
        } else {
            break;
        }
    }
    UIImage *resultImage = [UIImage imageWithData:data];
    return resultImage;
}
@end
