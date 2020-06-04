//
//  XLBFriendDynamicVC.h
//  xiaolaba
//
//  Created by 斯陈 on 2019/3/9.
//  Copyright © 2019年 jackzhang. All rights reserved.
//

#import "BaseTablePage.h"
#import "JXCategoryListContainerView.h"

NS_ASSUME_NONNULL_BEGIN

@interface XLBFriendDynamicVC : BaseViewController<JXCategoryListContentViewDelegate>


@property (nonatomic, copy) void(^didScrollCallback)(UIScrollView *scrollView);

@end

NS_ASSUME_NONNULL_END
