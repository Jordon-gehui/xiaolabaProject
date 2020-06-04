//
//  BQLChineseString.h
//  BQLDemo
//
//  Created by hao 好享购 on 16/8/1.
//  Copyright © 2016年 毕青林. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "pinyin.h"

@interface BQLChineseString : NSObject

@property(strong,nonatomic)NSString *string;
@property(strong,nonatomic)NSString *pinYin;

/**
 *  返回tableview右方indexArray
 */
+(NSMutableArray*)IndexArray:(NSArray*)stringArr;

/**
 *  返回联系人
 */
+(NSMutableArray*)LetterSortArray:(NSArray*)stringArr;

/**
 *  返回一组字母排序数组(中英混排)
 */
+(NSMutableArray*)SortArray:(NSArray*)stringArr;

@end
