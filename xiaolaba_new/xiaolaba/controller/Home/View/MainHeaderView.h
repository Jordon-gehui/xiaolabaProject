//
//  MainHeaderView.h
//  xiaolaba
//
//  Created by 戴葛辉 on 2018/4/28.
//  Copyright © 2018年 jackzhang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MainHeaderView : UIScrollView<UIScrollViewDelegate>

- (void) addButtons:(NSArray *) titleArray
            buttonW:(CGFloat)w;
@property (nonatomic ,copy) void (^linkageAction)(NSInteger page);
@property (nonatomic, assign) CGSize intrinsicContentSize;


@property (nonatomic ,assign) NSInteger page;

@end
