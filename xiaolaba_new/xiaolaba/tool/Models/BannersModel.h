//
//  BannersModel.h
//  xiaolaba
//
//  Created by 斯陈 on 2017/9/8.
//  Copyright © 2017年 jxcode. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BannersModel : NSObject

@property (nonatomic, copy) NSString *url;
@property (nonatomic, copy) NSString *image;

//0：应用内原生页面跳转；1：应用内html页面跳转
@property (nonatomic, copy) NSString *type;
@end
