//
//  XLBCache.m
//  xiaolaba
//
//  Created by lin on 2017/6/28.
//  Copyright © 2017年 jxcode. All rights reserved.
//

#import "XLBCache.h"
#import "SFHFKeychainUtils.h"
//#import "YYCache.h"

static NSString *const Xlb_Cache_Key = @"";
//static YYCache *_xlbCache;

@implementation XLBCache

+ (instancetype)cache {
    
    static XLBCache *cache;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        cache = [[self.class alloc] init];
//        _xlbCache = [YYCache cacheWithName:Xlb_Cache_Key];
    });
    return cache;
}

- (id)cache:(NSString *)key {
   
    return [[NSUserDefaults standardUserDefaults] objectForKey:key];

//    if([_xlbCache objectForKey:key]) {
//        
//        return [_xlbCache objectForKey:key];
//    }
//    return nil;
}

- (void)store:(id )object key:(NSString *)key {
    
    if(object) {
        [[NSUserDefaults standardUserDefaults] setObject:object forKey:key];
        [[NSUserDefaults standardUserDefaults] synchronize];
//        [_xlbCache setObject:object forKey:key withBlock:nil];
    }
}

- (void)removeCacheForKey:(NSString *)key {
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:key];

//    [_xlbCache removeObjectForKey:key];
}

- (void)removeAllCache {
    [SFHFKeychainUtils deleteItemForUsername:[XLBUser user].em_username andServiceName:@"xiaolaba" error:nil];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"weixinIdKey"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"weiboIdKey"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"tokenKey"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"MessageKey"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"userKey"];
    [[XLBUser user] setIsLogin:NO];
//    [XLBUser user
//    [_xlbCache removeAllObjects];
}

@end
