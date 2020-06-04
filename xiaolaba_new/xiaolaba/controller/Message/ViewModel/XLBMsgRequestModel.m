//
//  XLBMsgRequestModel.m
//  xiaolaba
//
//  Created by lin on 2017/8/10.
//  Copyright © 2017年 jxcode. All rights reserved.
//

#import "XLBMsgRequestModel.h"
#import "BQLChineseString.h"
#import "NetWorking.h"


@implementation XLBMsgRequestModel

+ (void)requestMyFriendWithfriendLike:(NSString *)likeStr type:(NSString *)type menberList:(NSArray *)menberList :(void (^)(NSArray<NSString *> *, NSArray<NSArray<XLBFriendModel *> *> *))success failure:(void (^)(NSString *))failure {
    NSString *url = kFrl;
    if (likeStr.length>0) {
        url = kFrlLike;
    }
    [[NetWorking network] POST:url params:likeStr.length>0?@{@"nickname":likeStr}:nil cache:YES success:^(id result) {
        
        NSLog(@"%@",result);
        NSMutableArray <NSDictionary *>*data = (NSMutableArray *)result;
        NSMutableArray <NSArray <XLBFriendModel *>*>*dataSource = [NSMutableArray array];
        NSMutableArray <NSString *>*nameArray = [NSMutableArray array];
        NSMutableArray <XLBFriendModel *>*modelArray = [NSMutableArray array];
        
        [data enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull respone, NSUInteger idx, BOOL * _Nonnull stop) {
            XLBFriendModel *model = [XLBFriendModel mj_objectWithKeyValues:respone];
            model.ID = [respone objectForKey:@"id"];
            if(kNotNil(model.nickname)) {
                [nameArray addObject:model.nickname];
                [modelArray addObject:model];
            }
            if (kNotNil(menberList)) {
                
                [menberList enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    if ([[model.friendId stringValue] isEqualToString:obj]) {
                        [modelArray removeObject:model];
                        [nameArray removeObject:model.nickname];
                    }
                }];
            }
        }];
        NSMutableArray *indexsArray = [NSMutableArray arrayWithArray:[BQLChineseString IndexArray:nameArray]];
        NSMutableArray <NSArray *>*letterArray = [NSMutableArray arrayWithArray:[BQLChineseString LetterSortArray:nameArray]];
        if([indexsArray containsObject:@"#"] && [[indexsArray firstObject] isEqualToString:@"#"]) {
            [indexsArray removeObjectAtIndex:0];
            [indexsArray addObject:@"#"];
            NSArray *spec = [letterArray firstObject];
            [letterArray removeObjectAtIndex:0];
            [letterArray addObject:spec];
        }
        [letterArray enumerateObjectsUsingBlock:^(NSArray * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            NSMutableArray *temp = [NSMutableArray array];
            [obj enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                
                NSString *name = obj;
                [modelArray enumerateObjectsUsingBlock:^(XLBFriendModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    
                    if([[obj.nickname stringByReplacingOccurrencesOfString:@" " withString:@""] isEqualToString:name]) {
                        [temp addObject:obj];
                    }
                }];
            }];
            [dataSource addObject:temp];
        }];
        success(indexsArray,dataSource);
        
    } failure:^(NSString *description) {
        
        failure(description);
    }];
}

+ (void)requestSessionUserId:(NSString *)userIds groupIds:(NSString *)groupIds session:(NSArray<XLBSessionModel *> *)sessions success:(void (^)(NSMutableArray<XLBSessionModel *> *))success failure:(void (^)(NSString *))failure {
    if(!kNotNil(userIds) && !kNotNil(groupIds)) {
        success((NSMutableArray *)sessions);
        return;
    };
    // 先找cache
    /*
     NSMutableArray <NSString *>*userIdsArray = [NSMutableArray arrayWithArray:[userIds componentsSeparatedByString:@","]];
     [userIdsArray enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
     
     NSDictionary *dic = [[XLBCache cache] cache:obj];
     if(dic) {
     
     if([dic containsObjectForKey:@"img"] && [dic containsObjectForKey:@"nickname"]) {
     
     NSString *ID = [NSString stringWithFormat:@"%@",[dic objectForKey:@"id"]];
     NSString *img = [dic objectForKey:@"img"];
     NSString *nickname = [dic objectForKey:@"nickname"];
     [sessions enumerateObjectsUsingBlock:^(XLBSessionModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
     
     if([obj.em_id isEqualToString:ID]) {
     obj.em_avatar = img;
     obj.em_nickname = nickname;
     }
     }];
     [userIdsArray removeObject:obj];
     }
     }
     }];
     NSString *newUserIds = [userIdsArray componentsJoinedByString:@","];
     
     if(!kNotNil(newUserIds)) {
     success(sessions);
     return;
     }
     */
    // 剩下的去请求
    NSDictionary *dict =@{@"userIds":userIds,@"groupIds":groupIds,};
    [[NetWorking network] POST:kUsli params:dict cache:NO success:^(id result) {
        NSLog(@"%@",result);
        NSArray <NSDictionary *>*data = (NSArray *)result;
        
        [data enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            NSString *ID = [NSString stringWithFormat:@"%@",[obj objectForKey:@"id"]];
            NSString *img = [obj objectForKey:@"img"];
            NSString *nickname = [obj objectForKey:@"nickname"];
            // cache
            //[[XLBCache cache] store:obj key:ID];
            //
            [sessions enumerateObjectsUsingBlock:^(XLBSessionModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                
                if([obj.em_id isEqualToString:ID]) {
                    obj.em_avatar = img;
                    obj.em_nickname = nickname;
                }
                
            }];
        }];
        success((NSMutableArray *)sessions);
        
    } failure:^(NSString *description) {
        
        failure(description);
    }];
}


+ (void)requestSessionUserId:(NSString *)userIds admins:(NSArray *)admins type:(NSString *)type success:(void (^)(NSMutableArray<GroupMemberModel *> *))success groupMenberList:(void (^)(NSArray<NSString *> *, NSArray<NSArray<GroupMemberModel *> *> *))groupMenberList failure:(void (^)(NSString *))failure {
    if (!kNotNil(userIds)) return;
    [[NetWorking network] POST:kGroupAll params:@{@"groupHuanxin":userIds} cache:NO success:^(id result) {
        NSArray <NSDictionary *>*data = (NSArray *)result;
        NSMutableArray *dataSour = [NSMutableArray array];
        
        NSMutableArray <NSArray <GroupMemberModel *>*>*dataSource = [NSMutableArray array];
        NSMutableArray <NSString *>*nameArray = [NSMutableArray array];
        NSMutableArray <GroupMemberModel *>*modelArray = [NSMutableArray array];
        
        [data enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            GroupMemberModel *model = [GroupMemberModel mj_objectWithKeyValues:obj];
            model.isAdmin = @"0";
            [admins enumerateObjectsUsingBlock:^(id  _Nonnull userId, NSUInteger idx, BOOL * _Nonnull stop) {
                if ([model.membersId isEqualToString:userId]) {
                    model.isAdmin = @"1";
                }
            }];
            if (![model.type isEqualToString:@"3"]) {
                [dataSour addObject:model];
                [nameArray addObject:model.membersName];
                [modelArray addObject:model];
            }
        }];
        
        NSMutableArray *indexsArray = [NSMutableArray arrayWithArray:[BQLChineseString IndexArray:nameArray]];
        NSMutableArray <NSArray *>*letterArray = [NSMutableArray arrayWithArray:[BQLChineseString LetterSortArray:nameArray]];
        if([indexsArray containsObject:@"#"] && [[indexsArray firstObject] isEqualToString:@"#"]) {
            [indexsArray removeObjectAtIndex:0];
            [indexsArray addObject:@"#"];
            NSArray *spec = [letterArray firstObject];
            [letterArray removeObjectAtIndex:0];
            [letterArray addObject:spec];
        }
        [letterArray enumerateObjectsUsingBlock:^(NSArray * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            NSMutableArray *temp = [NSMutableArray array];
            [obj enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                
                NSString *name = obj;
                [modelArray enumerateObjectsUsingBlock:^(GroupMemberModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    
                    if([obj.membersName isEqualToString:name]) {
                        [temp addObject:obj];
                    }
                }];
            }];
            [dataSource addObject:temp];
        }];
        groupMenberList(indexsArray,dataSource);
        
        success((NSMutableArray *)dataSour);
        
    } failure:^(NSString *description) {
        
    }];
}

+ (void)requestGroupModelWithParameter:(NSDictionary *)para success:(void (^)(id))success error:(void (^)(id))error {
    [[NetWorking network] POST:kGroupSelf params:para cache:NO success:^(id result) {
        NSDictionary *group = result[@"group"];
        NSDictionary *subGroup = result[@"members"];
        XLBGroupModel *model = [XLBGroupModel mj_objectWithKeyValues:group];
        XLBGroupSubModel *subModel = [XLBGroupSubModel mj_objectWithKeyValues:subGroup];
        model.subModel = subModel;
        success(model);
    } failure:^(NSString *description) {
        error(description);
    }];
}

+ (void)requestGroupListWithParameter:(NSDictionary *)para success:(void (^)(id))success error:(void (^)(id))error {
    [[NetWorking network] POST:kUsli params:para cache:NO success:^(id result) {
        NSMutableArray *arrar = [NSMutableArray array];
        NSArray <NSDictionary *>*data = (NSArray *)result;
        [data enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            XLBGroupListModel *model = [XLBGroupListModel mj_objectWithKeyValues:obj];
            [arrar addObject:model];
        }];
        success(arrar);
    } failure:^(NSString *description) {
        error(description);
    }];
}
@end





