//
//  CSRouter.h
//  xiaolaba
//
//  Created by 斯陈 on 2017/9/26.
//  Copyright © 2017年 jackzhang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CSRouter : NSObject

+ (instancetype)share;

/**
 系统跳转 如跳转至appstore中的某个应用下载页面、打电话、跳转到其他app(需配置白名单)
 
 @param url url
 @return 打开成功or失败
 */
- (BOOL )open:(NSString *)url;

/**
 控制器push跳转
 
 @param route 类似url的一个路径 例如跳转至XXController route=@"XXController"
 若带参数跳转如参数id=1001，参数type=1 则params = @{@"id":@"1001",@"type":@"1"}
 @return 能成功跳转返回YES 否则返回NO
 */
- (BOOL )push:(NSString *)route Params:(NSDictionary*)params hideBar:(BOOL )hide;

/**
 控制器present跳转
 
 @param route 类似url的一个路径 例如跳转至XXController route=@"XXController"
 若带参数跳转如参数id=1001，参数type=1 则params = @{@"id":@"1001",@"type":@"1"}
 @return 能成功跳转返回YES 否则返回NO
 */
- (BOOL )present:(NSString *)route Params:(NSDictionary*)params;

@end
