//
//  FindCardView.h
//  xiaolaba
//
//  Created by 斯陈 on 2017/9/12.
//  Copyright © 2017年 jackzhang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FindCard.h"

@class FindCard;
@protocol FindCardViewDelegate <NSObject>
/**
 当前所选卡片
 
 @param cardView 所选卡片
 @param model    对应模型
 @param index    索引
 */
- (void)cardView:(FindCard *)cardView card:(XLBFindUserModel *)model didSelectAtIndex:(NSInteger )index;

/**
 点击图片查看大图
 
 @param cardView 所选卡片
 @param images   大图地址数组
 */
- (void)cardView:(FindCard *)cardView didTouchCardImages:(NSArray <NSString *>*)images;

/**
 当前滚动到某个索引下
 
 @param cardView 所选卡片
 @param index    索引
 */
- (void)cardView:(FindCard *)cardView didScrollAtIndex:(NSInteger )index;

/**
 滚动
 
 @param cardView 所选卡片
 @param index    索引
 @param backwards 是否向后滚动
 */
- (void)cardView:(FindCard *)cardView didScrollAtIndex:(NSInteger )index direction:(BOOL )backwards;

@end

@interface FindCardView : UIView
@property (nonatomic, strong) NSMutableArray *dataSource;

/**
 代理
 */
@property (nonatomic, weak) id<FindCardViewDelegate>delegate;


- (void)cycleViewModelConfig;

@end
