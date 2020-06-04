//
//  XLBEaseMobManager.m
//  xiaolaba
//
//  Created by lin on 2017/8/8.
//  Copyright © 2017年 jxcode. All rights reserved.
//

#import "XLBEaseMobManager.h"
#import "XLBUser.h"

#define KError [NSError errorWithDomain:@"10000" code:10000 userInfo:nil]

@implementation XLBEaseMobManager

+ (void)xlbLoginEaseMob:(void(^)(NSError *error))complete {
    
    if(![EMClient sharedClient].isLoggedIn) {
        if(kNotNil([XLBUser user].em_username) && [XLBUser user].em_password) {
            [[EMClient sharedClient] loginWithUsername:[XLBUser user].em_username
                                              password:[XLBUser user].em_password
                                            completion:^(NSString *aUsername, EMError *aError) {
                                                if (!aError) {
                                                    complete(nil);
                                                } else {
                                                    complete(KError);
                                                }
                                            }];
        }
        else {
            complete(KError);
        }
    }
}

@end
