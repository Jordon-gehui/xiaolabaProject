//
//  XLBMessageSheetView.h
//  xiaolaba
//
//  Created by 戴葛辉 on 2018/6/6.
//  Copyright © 2018年 jackzhang. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger,GroupListBtnTag) {
    MessageSheetAddFriendBtnTag = 100,
    MessageSheetAddGroupBtnTag,
    MessageSheetGroupListBtnTag,
    MessageSheetScanBtnTag,
    AlertSheetPublishDynamicBtnTag,
};

typedef NS_ENUM(NSUInteger, AlertSheetType) {
    AlertSheetTypeDefault = 200,
    AlertSheetTypeMain,
};

@protocol XLBMessageSheetViewDelegate<NSObject>

- (void)didSeletedMessageSheetViewBtnClick:(UIButton *)sender;

@end


@interface XLBMessageSheetView : UIView

@property (nonatomic, weak) id <XLBMessageSheetViewDelegate>delegate;

- (id)initWithFrame:(CGRect)frame type:(AlertSheetType)type;

- (void)updateTopImgFrame:(CGFloat)top;
@end
