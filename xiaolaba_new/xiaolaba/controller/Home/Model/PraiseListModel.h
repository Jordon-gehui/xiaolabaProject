//
//  PraiseListModel.h
//  xiaolaba
//
//  Created by 戴葛辉 on 2017/12/16.
//  Copyright © 2017年 jackzhang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PraiseListModel : NSObject
@property (nonatomic, copy)NSString *userID;
@property (nonatomic, copy)NSString *img;
@property (nonatomic, copy)NSString *nickname;
@property (nonatomic, copy)NSString *sex;
@property (nonatomic, strong)NSArray<UserTagsModel *>*tags;
@end
