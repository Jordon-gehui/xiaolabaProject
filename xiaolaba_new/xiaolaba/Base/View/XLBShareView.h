//
//  XLBShareView.h
//  xiaolaba
//
//  Created by 戴葛辉 on 2018/6/8.
//  Copyright © 2018年 jackzhang. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger,ShareViewType) {
    ShareViewDefault = 90,
    ShareViewSaveImg,
};

typedef NS_ENUM(NSUInteger,ShareBtnHidden) {
    ShareBtnWeChatHidden = 1000,
    ShareBtnWeiBoHidden,
};


typedef NS_ENUM(NSUInteger, ShareViewBtnTag) {
    ShareViewWeChatBtnTag = 100,
    ShareViewWeChatPyqBtnTag,
    ShareViewWeiBoBtnTag,
};

@protocol XLBShareViewDelegate<NSObject>

- (void)shareViewBtnClickWithTag:(UIButton*)sender;
@end

@interface XLBShareView : UIView
@property (nonatomic, weak) id<XLBShareViewDelegate>delegate;
- (id)initWithFrame:(CGRect)frame type:(NSInteger)type isHidden:(NSInteger)hidden;

@end
