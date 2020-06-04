//
//  XLBErrorView.h
//  xiaolaba
//
//  Created by 戴葛辉 on 2017/10/11.
//  Copyright © 2017年 jackzhang. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol XLBErrorViewDelegate <NSObject>

@optional
- (void)errorViewTap;

@end

@interface XLBErrorView : UIView

- (id)initWithFrame:(CGRect)frame;


-(void)showErrorView;

-(void)hideErrorView;

@property (nonatomic, weak) id<XLBErrorViewDelegate>delegate;


- (void)setSubViewsWithImgName:(NSString *)imgName remind:(NSString *)reminds;
@end
