//
//  XLBMainDynamicViewController.h
//  xiaolaba
//
//  Created by 斯陈 on 2019/3/21.
//  Copyright © 2019年 jackzhang. All rights reserved.
//

#import "BaseViewController.h"
#import "JXCategoryListContainerView.h"


@interface XLBMainDynamicViewController : BaseViewController<JXCategoryListContentViewDelegate>
@property (nonatomic, copy) void(^didScrollCallback)(UIScrollView *scrollView);

@end

