//
//  XLBScreenViewController.h
//  xiaolaba
//
//  Created by 戴葛辉 on 2017/9/18.
//  Copyright © 2017年 jackzhang. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^screenRetrunBlock)(id dic,NSInteger isClear);
@interface XLBScreenViewController : BaseTablePage

@property (nonatomic,copy)screenRetrunBlock block;

@end
