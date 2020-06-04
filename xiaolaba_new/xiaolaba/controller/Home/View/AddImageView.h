//
//  AddImageView.h
//  xiaolaba
//
//  Created by 斯陈 on 2017/9/13.
//  Copyright © 2017年 jackzhang. All rights reserved.
//

#import <UIKit/UIKit.h>
@class AddImageView;
@protocol AddImageViewViewDelegate <NSObject>

@optional
/**
 添加图片
 @param  index  //当前点击第几张图片
 */
- (void)selectBtnImageView:(NSString *)index;

- (void)addImageView:(NSInteger)index;

- (void)updateAddimageViewHeight:(CGFloat)heifloat;

@end

@interface AddImageView : UIView

-(void)setMaxImgCount:(NSInteger )count rowNumber:(NSInteger)number;
-(void)initViewWith:(NSArray*)array;

/**
 代理
 */
@property (nonatomic, weak) id<AddImageViewViewDelegate>delegate;
@end
