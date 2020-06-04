//
//  XLBRecommendViewController.h
//  xiaolaba
//
//  Created by 戴葛辉 on 2018/4/17.
//  Copyright © 2018年 jackzhang. All rights reserved.
//

#import "BaseTablePage.h"

@protocol RecommendViewControllerDelegate <NSObject>
- (void)didSeleted:(NSInteger)page;
@end
@interface XLBRecommendViewController : BaseTablePage

@property (nonatomic, weak) id<RecommendViewControllerDelegate>delegate;
@end
