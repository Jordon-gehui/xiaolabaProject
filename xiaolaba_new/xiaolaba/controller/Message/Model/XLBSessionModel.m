//
//  XLBSessionModel.m
//  xiaolaba
//
//  Created by lin on 2017/8/16.
//  Copyright © 2017年 jxcode. All rights reserved.
//

#import "XLBSessionModel.h"

@implementation XLBSessionModel

- (NSString *)em_nickname {
    return kNotNil(_em_nickname) ? _em_nickname:@"";
}

- (NSString *)em_time {
    
    if(kNotNil(_em_time)) {
        NSCalendar *calendar = [NSCalendar currentCalendar];
        NSDate *currentDate = [NSDate date];
        
        // 获取当前时间的年、月、日
        NSDateComponents *components = [calendar components:NSCalendarUnitYear| NSCalendarUnitMonth|NSCalendarUnitDay fromDate:currentDate];
        NSInteger currentYear = components.year;
        NSInteger currentMonth = components.month;
        NSInteger currentDay = components.day;
        
        // 获取消息发送时间的年、月、日
        NSDate *msgDate = [NSDate dateWithTimeIntervalSince1970:[_em_time doubleValue]/1000.0];
        components = [calendar components:NSCalendarUnitYear| NSCalendarUnitMonth|NSCalendarUnitDay fromDate:msgDate];
        CGFloat msgYear = components.year;
        CGFloat msgMonth = components.month;
        CGFloat msgDay = components.day;
        
        // 判断
        NSDateFormatter *dateFmt = [[NSDateFormatter alloc] init];
        if (currentYear == msgYear && currentMonth == msgMonth && currentDay == msgDay) {
            //今天
            dateFmt.dateFormat = @"HH:mm";
        }else if (currentYear == msgYear && currentMonth == msgMonth && currentDay-1 == msgDay ){
            //昨天
            dateFmt.dateFormat = @"昨天 HH:mm";
        }else if (currentYear == msgYear){
            //今年
            dateFmt.dateFormat = @"MM-dd HH:mm";
        }else{
            //今年以前
            dateFmt.dateFormat = @"yyyy-MM-dd HH:mm";
        }
        
        return [dateFmt stringFromDate:msgDate];
    }
    else {
        return @"";
    }
}


- (NSString *)em_date {
    
    if(kNotNil(_em_date)) {
        NSCalendar *calendar = [NSCalendar currentCalendar];
        NSDate *currentDate = [NSDate date];
        // 获取当前时间的年、月、日
        NSDateComponents *components = [calendar components:NSCalendarUnitYear| NSCalendarUnitMonth|NSCalendarUnitDay fromDate:currentDate];
        // 获取消息发送时间的年、月、日
        NSDate *msgDate = [NSDate dateWithTimeIntervalSince1970:[_em_time doubleValue]/1000.0];
        components = [calendar components:NSCalendarUnitYear| NSCalendarUnitMonth|NSCalendarUnitDay fromDate:msgDate];
        // 判断
        NSDateFormatter *dateFmt = [[NSDateFormatter alloc] init];
        dateFmt.dateFormat = @"yyyy-MM-dd HH:mm";
        
        return [dateFmt stringFromDate:msgDate];
    }
    else {
        return @"";
    }
}

- (NSString *)em_lastMsg {
    return kNotNil(_em_lastMsg) ? _em_lastMsg:@"";
}

- (NSString *)em_unRead {
    return kNotNil(_em_unRead) ? _em_unRead:@"";
}

- (NSString *)em_avatar {
    return kNotNil(_em_avatar) ? [_em_avatar containsString:@"http"] ? _em_avatar:[NSString stringWithFormat:@"%@%@",kImagePrefix,_em_avatar]:@"";
}

@end
