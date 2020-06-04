//
//  ZZCHelper.m
//  xiaolaba
//
//  Created by jackzhang on 2017/9/12.
//  Copyright © 2017年 jackzhang. All rights reserved.
//

#import "ZZCHelper.h"

@implementation ZZCHelper

+(NSString *)dateStringFromNumberTimer:(NSString *)timerStr{

    // iOS 生成的时间戳是10位
    NSTimeInterval interval    =[timerStr doubleValue] / 1000.0;
    NSDate *date               = [NSDate dateWithTimeIntervalSince1970:interval];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MM-dd HH:mm:ss"];
    NSString *dateString       = [formatter stringFromDate: date];
    return dateString;
 
}
+ (NSString *)dateStringFromString:(NSString *)timeStr type:(NSInteger)type {
    
    // 日期格式化类
    NSLog(@"%@",timeStr);
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    
    // 设置日期格式 为了转换成功
    
    if (type == 0) {
        format.dateFormat = @"yyyyMMdd";
        NSDate *date = [format dateFromString:timeStr];
        return [format stringFromDate:date];
    }else{
        NSTimeInterval interval    =[timeStr doubleValue] / 1000.0;
        [format setDateFormat:@"yyyy-MM-dd"];
        NSDate *date  = [NSDate dateWithTimeIntervalSince1970:interval];
        return [format stringFromDate:date];

    }
    
    
}

+ (NSString *)dateStringFromNumberTimer:(NSString *)timerStr type:(NSInteger)type {
    //转化为double
    double t = [timerStr doubleValue];
    //计算出距离1970的nsdate；
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:t/1000];
    //转化为 时间格式化字符串
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    //yyyy-MM-dd HH:mm:ss
    if (type == 0) {
        df.dateFormat = @"mm:ss";
    }
    if (type == 1) {
        df.dateFormat = @"yyyy-MM-dd";
    }
    if (type == 2) {
        df.dateFormat = @"yyyy年MM月dd日 hh:mm:ss";

    }
    //转化为 时间字符串
    return [df stringFromDate:date];
}

//动态 计算行高
//根据字符串的实际内容的多少 在固定的宽度和字体的大小，动态的计算出实际的高度
+ (CGFloat)textHeightFromTextString:(NSString *)text width:(CGFloat)textWidth fontSize:(CGFloat)size{
    if ([ZZCHelper getCurrentIOS] >= 7.0) {
        //iOS7之后
        /*
         第一个参数: 预设空间 宽度固定  高度预设 一个最大值
         第二个参数: 行间距 如果超出范围是否截断
         第三个参数: 属性字典 可以设置字体大小
         */
        NSDictionary *dict = @{NSFontAttributeName:[UIFont systemFontOfSize:size]};
        CGRect rect = [text boundingRectWithSize:CGSizeMake(textWidth, MAXFLOAT) options:NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil];
        //返回计算出的行高
        return rect.size.height;
        
    }else {
        //iOS7之前
        /*
         1.第一个参数  设置的字体固定大小
         2.预设 宽度和高度 宽度是固定的 高度一般写成最大值
         3.换行模式 字符换行
         */
        CGSize textSize = [text sizeWithFont:[UIFont systemFontOfSize:size] constrainedToSize:CGSizeMake(textWidth, MAXFLOAT) lineBreakMode:NSLineBreakByCharWrapping];
        return textSize.height;//返回 计算出得行高
    }
}
+(NSString*)getCurrentTimestamp{
    
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    
    NSTimeInterval a=[dat timeIntervalSince1970];
    
    NSString*timeString = [NSString stringWithFormat:@"%0.f", a];//转为字符型
    
    return timeString;
    
}

+(NSString *)dateStringFromNow:(NSString *)timeStr {
    double time=[timeStr doubleValue]/1000;
    double now = [[ZZCHelper getCurrentTimestamp] doubleValue];
    double interval = now - time;
    if (now<=time) {
        return @"刚刚";
    }else if (interval>24*3600){
        return [NSString stringWithFormat:@"%i天前",(int)interval/24/3600];
    }else if (interval>3600) {
        return [NSString stringWithFormat:@"%i小时前",(int)interval/3600];
    }else if (interval>60) {
        return [NSString stringWithFormat:@"%i分钟前",(int)interval/60];
    }else{
        return @"刚刚";
    }
}
+ (NSDate *)getInternetDate
{
    NSString *urlString = @"http://m.baidu.com";
    urlString = [urlString stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString: urlString]];
    [request setCachePolicy:NSURLRequestReloadIgnoringCacheData];
    [request setTimeoutInterval: 2];
    [request setHTTPShouldHandleCookies:FALSE];
    [request setHTTPMethod:@"GET"];
    NSHTTPURLResponse *response;
    [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:nil];
    
    NSString *date = [[response allHeaderFields] objectForKey:@"Date"];
    date = [date substringFromIndex:5];
    date = [date substringToIndex:[date length]-4];
    NSDateFormatter *dMatter = [[NSDateFormatter alloc] init];
    dMatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
    [dMatter setDateFormat:@"dd MMM yyyy HH:mm:ss"];
    NSDate *netDate = [[dMatter dateFromString:date] dateByAddingTimeInterval:60*60*8];
    
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSInteger interval = [zone secondsFromGMTForDate: netDate];
    NSDate *localeDate = [netDate  dateByAddingTimeInterval: interval];
    return localeDate;
}

//获取iOS版本号
+ (double)getCurrentIOS {
    return [[[UIDevice currentDevice] systemVersion] doubleValue];
}
+ (CGSize)getScreenSize {
    return [[UIScreen mainScreen] bounds].size;
}

+(CAShapeLayer*)cornerRadiusUIBezierPath:(CellImgType)type :(CGRect)rect size:(CGSize)size {
    UIBezierPath *path;
    switch (type) {
        case XLBRoundCornerCellTypeLeft: {
            path = [UIBezierPath bezierPathWithRoundedRect:rect byRoundingCorners:UIRectCornerTopLeft | UIRectCornerBottomLeft cornerRadii:size];
            
            break;
        }
        case XLBRoundCornerCellTypeTop: {
            path = [UIBezierPath bezierPathWithRoundedRect:rect byRoundingCorners:UIRectCornerTopRight | UIRectCornerTopLeft cornerRadii:size];
            break;
        }
        case XLBRoundCornerCellTypeBottom: {
            path = [UIBezierPath bezierPathWithRoundedRect:rect byRoundingCorners:UIRectCornerBottomRight | UIRectCornerBottomLeft cornerRadii:size];
            break;
        }
            
        case XLBRoundCornerCellTypeRight: {
            path = [UIBezierPath bezierPathWithRoundedRect:rect byRoundingCorners:UIRectCornerTopRight | UIRectCornerBottomRight cornerRadii:size];
            break;
        }
        case XLBRoundCornerCellTypeTopRight: {
            path = [UIBezierPath bezierPathWithRoundedRect:rect byRoundingCorners:UIRectCornerTopRight cornerRadii:size];
            break;
        }
        case XLBRoundCornerCellTypeBottomRight: {
            path = [UIBezierPath bezierPathWithRoundedRect:rect byRoundingCorners:UIRectCornerBottomRight cornerRadii:size];
            break;
        }
        default:
            return nil;
    }
    
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.frame = rect;
    maskLayer.path = path.CGPath;
    return maskLayer;
}

@end
