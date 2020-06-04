//
//  XLBMyInfoShowHeaderView.h
//  xiaolaba
//
//  Created by 戴葛辉 on 2017/9/7.
//  Copyright © 2017年 jxcode. All rights reserved.
//



@protocol XLBMyInfoShowHeaderViewDelegate <NSObject>

- (void)imageShowWithIndex:(NSString *)index images:(NSMutableArray *)images;
@end
@interface XLBMyInfoShowHeaderView : UIView
@property (nonatomic, weak) id delegate;

- (id)initWithFrame:(CGRect)frame user:(XLBUser *)user;

@property (nonatomic, strong) UICollectionView *imageCollectionView;
- (void)updateUser:(XLBUser *)user;

@end
