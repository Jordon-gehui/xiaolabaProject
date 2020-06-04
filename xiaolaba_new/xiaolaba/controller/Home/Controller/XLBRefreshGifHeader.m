//
//  XLBRefreshGifHeader.m
//  xiaolaba
//
//  Created by 戴葛辉 on 2018/4/27.
//  Copyright © 2018年 jackzhang. All rights reserved.
//
#import "UIImage+GIF.h"

#import "XLBRefreshGifHeader.h"
@interface XLBRefreshGifHeader ()


@end

@implementation XLBRefreshGifHeader
- (void)prepare {
    [super prepare];
    NSMutableArray *idleImages = [NSMutableArray array];
    NSArray *arr = @[@"refresh2",@"refresh3",@"refresh4",@"refresh5",@"refresh6",@"refresh7",@"refresh8",@"refresh9",@"refresh10",@"refresh11",@"refresh12",@"refresh13",@"refresh14",@"refresh15",@"refresh16",@"refresh17",@"refresh18",@"refresh19",@"refresh20",@"refresh21",@"refresh22",@"refresh23",@"refresh24",@"refresh25",@"refresh26",@"refresh27",@"refresh28",@"refresh29",@"refresh30",@"refresh31",];
    for (NSUInteger i = 0; i<arr.count; i++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"%@", arr[i]]];
        [idleImages addObject:image];
    }
    [self setImages:idleImages forState:MJRefreshStateIdle];

    // 设置即将刷新状态的动画图片（一松开就会刷新的状态）
    NSMutableArray *refreshingImages = [NSMutableArray array];
    for (NSUInteger i = 0; i<arr.count; i++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"%@",arr[i]]];
        [refreshingImages addObject:image];
    }
    [self setImages:refreshingImages forState:MJRefreshStatePulling];
    // 设置正在刷新状态的动画图片
    [self setImages:refreshingImages forState:MJRefreshStateRefreshing];
    //隐藏时间
    self.lastUpdatedTimeLabel.hidden = YES;
    //隐藏状态
    self.stateLabel.hidden = YES;

}
- (void)placeSubviews {
    [super placeSubviews];
    
    self.gifView.bounds = CGRectMake(0, 0, 80, 45);
    self.gifView.center = CGPointMake(self.mj_w * 0.5, self.mj_h * 0.5);
    
}


@end
