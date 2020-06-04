//
//  XLBAreaSelectView.h
//  xiaolaba
//
//  Created by lin on 2017/7/25.
//  Copyright © 2017年 jxcode. All rights reserved.
//

@class XLBAreaSelectView;
@protocol XLBAreaSelectViewDelegate <NSObject>

- (void)areaSelectView:(XLBAreaSelectView *)view
         didSelectArea:(NSString *)area
              province:(NSString *)province
                  city:(NSString *)city
              district:(NSString *)district;

@end

@interface XLBAreaSelectView : UIView

@property (nonatomic, weak) id<XLBAreaSelectViewDelegate>delegate;
- (void)show:(UIView *)container;

@end
