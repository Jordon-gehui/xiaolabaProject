//
//  XLBCache.h
//  xiaolaba
//
//  Created by lin on 2017/6/28.
//  Copyright © 2017年 jxcode. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XLBCache : NSObject

+ (instancetype)cache;

- (id)cache:(NSString *)key;

- (void)store:(id )object key:(NSString *)key;

- (void)removeCacheForKey:(NSString *)key;

- (void)removeAllCache;

@end
