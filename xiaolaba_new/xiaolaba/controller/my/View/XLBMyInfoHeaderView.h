//
//  XLBMyInfoHeaderView.h
//  xiaolaba
//
//  Created by 戴葛辉 on 2017/9/6.
//  Copyright © 2017年 jxcode. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol XLBMyInfoHeaderViewDelegate <NSObject>
- (void)addClick:(NSUInteger )max;
- (void)saveClick:(NSMutableArray *)saveArray userPictureUrl:(NSString *)userPictureUrl;
- (void)changedViewHeight:(CGFloat)height;
- (void)changedImageIndex;
- (void)deleteImgWithIndex:(NSInteger)idex max:(NSUInteger)max;

@end

@interface XLBMyInfoHeaderView : UIView



@property (nonatomic, weak) id<XLBMyInfoHeaderViewDelegate>delegate;
@property (nonatomic, strong, readonly) NSArray *delArray;
@property (nonatomic, strong, readonly) NSArray <UIImage *>*addArray;
@property (nonatomic, assign) BOOL addHide;
@property (nonatomic, copy) NSString *userImageUrl;

- (instancetype)initWithFrame:(CGRect)frame user:(XLBUser *)user;
- (void)insertImages:(NSArray *)images;
- (void)deleteImageWithIndex:(NSInteger)idx;
- (void)selectImgWithImgDict:(NSDictionary *)dict index:(NSInteger)index;
- (void)saveClick;

@end


