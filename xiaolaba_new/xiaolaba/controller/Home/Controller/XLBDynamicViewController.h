//
//  XLBDynamicViewController.h
//  xiaolaba
//
//  Created by 戴葛辉 on 2018/4/17.
//  Copyright © 2018年 jackzhang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JXCategoryListContainerView.h"
@interface XLBDynamicViewController : BaseTablePage<JXCategoryListContentViewDelegate>


@property (nonatomic, copy) void(^didScrollCallback)(UIScrollView *scrollView);

@end
