//
//  XLBLocation.h
//  xiaolaba
//
//  Created by lin on 2017/6/28.
//  Copyright © 2017年 jxcode. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface XLBLocation : NSObject

+ (instancetype)location;

/**
 * 获取当前地理位置信息
 * @param complete 获取完成后的调用的block
 *  City = "上海市";
 *  Country = "中国";
 *  CountryCode = CN;
 *  FormattedAddressLines =     (
 *      "中国上海市宝山区杨行镇"
 *  );
 *  Latitude = "31.36503075068198";
 *  Longitude = "121.410844460607";
 *  Name = "中国上海市宝山区杨行镇";
 *  State = "上海市";
 *  SubLocality = "宝山区";
 */
- (void)getCurrentLocationComplete:(void (^)(NSDictionary *location))complete;

/**
 * 取消获取地理位置信息
 */
- (void)cancelGetLocation;

@end
