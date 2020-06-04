//
//  XLBEaseMobManager.h
//  xiaolaba
//
//  Created by lin on 2017/8/8.
//  Copyright © 2017年 jxcode. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Hyphenate/Hyphenate.h>

@interface XLBEaseMobManager : NSObject

/**
 登陆环信
 
 @param complete error为nil为成功
 */
+ (void)xlbLoginEaseMob:(void(^)(NSError *error))complete;

@end
