//
//  XLBRadarView.h
//  xiaolaba
//
//  Created by 戴葛辉 on 2018/1/6.
//  Copyright © 2018年 jackzhang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <BaiduMapAPI_Location/BMKLocationService.h>

@interface XLBRadarView : UIView
@property (nonatomic, strong)BMKLocationService *service;

- (void)setIconImageViewImg;
@end
