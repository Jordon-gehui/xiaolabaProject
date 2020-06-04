//
//  XLBDEvaluateView.m
//  xiaolaba
//
//  Created by 戴葛辉 on 2017/9/7.
//  Copyright © 2017年 jxcode. All rights reserved.
//

#import "XLBDEvaluateView.h"
#import "XLBFindUserModel.h"
@interface XLBDEvaluateView ()
{
    CGFloat font;
    CGFloat Lheight;
    CGFloat Lwidht;
    CGFloat Radius;
}
@end
@implementation XLBDEvaluateView

- (void)insertSign:(NSArray <UserTagsModel *>*)signs {
    if(signs.count == 0) return;
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    CGFloat height = Lheight == 0 ? 20:Lheight;
    __block UIView *lastView = nil;
    [signs enumerateObjectsUsingBlock:^(UserTagsModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UILabel *label = [[UILabel alloc] init];
        NSLog(@"%@",obj);
        
//        NSString *colorString = [NSString stringWithFormat:@"0x%@",obj.color];
//        label.backgroundColor = [UIColor colorWithHexString:colorString];;//[UIColor colorWithHexString:colorString];
        [label.layer setMasksToBounds:YES];
        [label.layer setCornerRadius:Radius];
//        [label.layer setCornerRadius:height/2];
//        [label.layer setBorderWidth:1.0];
//        label.layer.borderColor=[UIColor colorWithR:225 g:230 b:240].CGColor;
        label.highlightedTextColor = [UIColor whiteColor];
        label.textAlignment = NSTextAlignmentCenter;
        label.highlighted = YES;
        
        label.backgroundColor = [UIColor colorWithHexString:[NSString stringWithFormat:@"#%@",obj.color]];
        NSLog(@"%@",obj.color);
        label.font = [UIFont systemFontOfSize:font>1?font:12];
        label.text = obj.label;
        CGFloat width = [self widthWithSize:CGSizeMake(0, height) text:obj.label font:[UIFont systemFontOfSize:font>1?font:12]];
        [self addSubview:label];
        if(lastView) {
            [label mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(lastView.mas_right).with.offset(6);
                make.centerY.mas_equalTo(self);
                if (Lwidht) {
                    make.width.mas_equalTo(width + height/2);
                }else {
                    make.width.mas_equalTo(width + 10 + height/2);
                }
                make.height.mas_equalTo(height);
            }];
        }
        else {
            [label mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(0);
                make.centerY.mas_equalTo(self);
                if (Lwidht) {
                    make.width.mas_equalTo(width + height/2);
                }else {
                    make.width.mas_equalTo(width + 10 + height/2);
                }
                make.height.mas_equalTo(height);


            }];
        }
        lastView = label;
    }];
}
-(void)setFont:(CGFloat)lffont {
    font = lffont;
}
- (void)setlHeight:(CGFloat)lheight {
    Lheight = lheight;
}
- (void)setLwidth:(CGFloat)lwidth {
    Lwidht = lwidth;
}
- (void)setRadius:(CGFloat)radius {
    Radius = radius;
}
- (CGFloat )widthWithSize:(CGSize)size text:(NSString *)text font:(UIFont *)font{
    
    CGRect rect=[text boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObjectsAndKeys:font,NSFontAttributeName, nil] context:nil];
    return rect.size.width;
}



@end

