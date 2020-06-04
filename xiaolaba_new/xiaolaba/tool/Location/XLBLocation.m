//
//  XLBLocation.m
//  xiaolaba
//
//  Created by lin on 2017/6/28.
//  Copyright © 2017年 jxcode. All rights reserved.
//

#import "XLBLocation.h"
#import "XLBUser.h"
typedef void(^complete)(NSDictionary *location);

@interface XLBLocation () <CLLocationManagerDelegate>

@property (strong, nonatomic) CLLocationManager *locationManager;

@property (copy, nonatomic) complete complete;

@end

@implementation XLBLocation

+ (instancetype)location {
    
    static dispatch_once_t onceToken;
    static XLBLocation *locationTool;
    
    dispatch_once(&onceToken, ^{
        locationTool = [[XLBLocation alloc] init];
    });
    return locationTool;
}

- (void)cancelGetLocation{
    
    if (self.locationManager!=nil) {
        
        [self.locationManager stopUpdatingLocation];
    }
}

- (void)getCurrentLocationComplete:(void (^)(NSDictionary *location))complete {
    
    self.complete = complete;
    [self getCurrentLocation];
}

- (void)getCurrentLocation {
    
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue]  >= 8.0) {
        //使用期间
        [self.locationManager requestWhenInUseAuthorization];
        //始终
        //or [self.locationManage requestAlwaysAuthorization]
    }
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    self.locationManager.distanceFilter = 10.0f;
    [self.locationManager startUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    
    if (error.code == kCLErrorDenied) {
        
        NSLog(@"访问被拒绝");
        // 提示用户出错原因，可按住Option键点击 KCLErrorDenied的查看更多出错信息，可打印error.code值查找原因所在
        if (self.complete!=nil) {
            
            self.complete(nil);
        }
        return;
    }
    if ([error code] == kCLErrorLocationUnknown) {
        //无法获取位置信息
        if (self.complete!=nil) {
            
            self.complete(nil);
        }
        return;
    }
}

//定位代理经纬度回调
-(void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
    
    [_locationManager stopUpdatingLocation];
    
    CLGeocoder *geoCoder = [[CLGeocoder alloc] init];
    
    [geoCoder reverseGeocodeLocation:newLocation completionHandler:^(NSArray *placemarks, NSError *error) {
        for (CLPlacemark * placemark in placemarks) {
            
            if(!error && self.complete != nil) {
                
                NSMutableDictionary *info = [NSMutableDictionary dictionaryWithDictionary:[placemark addressDictionary]];
                [info setValue:@(newLocation.coordinate.longitude) forKey:@"Longitude"];
                [info setValue:@(newLocation.coordinate.latitude) forKey:@"Latitude"];
                if(info) {
                    [XLBUser user].longitude = [info objectForKey:@"Longitude"];
                    [XLBUser user].latitude = [info objectForKey:@"Latitude"];
                    if ([[info allKeys] containsObject:@"Country"]) {
                        [XLBUser user].country = [info objectForKey:@"Country"];
                    }
                    if ([[info allKeys] containsObject:@"Province"]) {
                        [XLBUser user].province = [info objectForKey:@"Province"];
                    }else{
                        [XLBUser user].province = [info objectForKey:@"City"];
                    }
                    if ([[info allKeys] containsObject:@"City"]) {
                        [XLBUser user].city = [info objectForKey:@"City"];
                    }
                    if ([[info allKeys] containsObject:@"SubLocality"]) {
                        [XLBUser user].subLocality = [info objectForKey:@"SubLocality"];
                    }


                    if([info objectForKey:@"FormattedAddressLines"] &&
                       [[info objectForKey:@"FormattedAddressLines"] firstObject]) {
                        [XLBUser user].location = [[info objectForKey:@"FormattedAddressLines"] firstObject];
                    }
                    else {
                        [XLBUser user].location = info[@"City"];
                    }
                    self.complete(info);
                }
                else {
                    self.complete(nil);
                }
            }
            else {
                if(self.complete) {
                    self.complete(nil);
                }
            }
        }
    }];
}

@end
