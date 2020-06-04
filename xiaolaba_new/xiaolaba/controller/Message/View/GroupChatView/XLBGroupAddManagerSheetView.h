//
//  XLBGroupAddManagerSheetView.h
//  xiaolaba
//
//  Created by 戴葛辉 on 2018/6/2.
//  Copyright © 2018年 jackzhang. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol XLBGroupAddManagerSheetViewDelegate <NSObject>

- (void)didCertainBtnClick;
@end

@interface XLBGroupAddManagerSheetView : UIView

@property (nonatomic, weak) id <XLBGroupAddManagerSheetViewDelegate>delegate;
@property (nonatomic, copy) NSString *nickName;
@property (nonatomic, copy) NSString *userId;
@property (nonatomic, copy) NSString *isAdmin;

@end
