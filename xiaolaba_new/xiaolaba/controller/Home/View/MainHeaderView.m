//
//  MainHeaderView.m
//  xiaolaba
//
//  Created by 戴葛辉 on 2018/4/28.
//  Copyright © 2018年 jackzhang. All rights reserved.
//

#import "MainHeaderView.h"
#import "LoginView.h"
@implementation MainHeaderView

{
    NSArray *titleArr;
    CGFloat buttonW;
    UIButton *rightBtn;
    UILabel *selectLabel;
}

static NSInteger buttonTag = 999;

-(void)addButtons:(NSArray *)titleArray buttonW:(CGFloat)w{
    
    titleArr = titleArray;
    buttonW = w;
    for (int i = 0; i < titleArray.count; i ++) {
        
        UIButton *button = [[UIButton alloc] init];
        [button setTag:buttonTag+i];
        [button setTitle:titleArray[i] forState:UIControlStateNormal];
        [button setBackgroundColor:[UIColor whiteColor]];
        [button setTitleColor:[UIColor commonTextColor] forState:0];
        button.titleLabel.font = [UIFont systemFontOfSize:21];
        [button addTarget:self action:@selector(titleClicked:) forControlEvents:UIControlEventTouchDown];
        [self  addSubview:button];
        
        if (i == 0) {
            [button setTitleColor:[UIColor commonTextColor] forState:0];
//            button.titleLabel.font = [UIFont systemFontOfSize:21];
            button.transform = CGAffineTransformMakeScale(1, 1);
        }else {
            button.transform = CGAffineTransformMakeScale(0.7, 0.7);
        }
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.equalTo(self).offset(0);
            if (i == 5) {
                make.left.equalTo(self).offset(i*buttonW + 15);
            }else if(i == 4){
                make.left.equalTo(self).offset(i*buttonW + 5);
            }else {
                make.left.equalTo(self).offset(i*buttonW);
            }
            make.height.equalTo(self).offset(0);
            make.width.equalTo([NSNumber numberWithFloat:buttonW]);
            
        }];
        
    }
    
    
    selectLabel = [[UILabel alloc] init];
    [selectLabel setFrame:CGRectMake(buttonW/2-4, 39, 8, 4)];
    [selectLabel setBackgroundColor:[UIColor blackColor]];
    selectLabel.layer.masksToBounds = YES;
    selectLabel.layer.cornerRadius = 2;
    [self addSubview:selectLabel];
    
}

- (void) titleClicked:(UIButton *)sender{
    if ((![XLBUser user].isLogin || !kNotNil([XLBUser user].token)) && sender.tag == 0 + buttonTag) {
        return;
    }
    if ((sender.tag - buttonTag)>0) {
        if (![XLBUser user].isLogin || !kNotNil([XLBUser user].token)) {
            self.linkageAction(0);
//            [LoginView addLoginView];
            return;
        }
    }
    for (UIButton *senderBtn in self.subviews) {
        if (senderBtn.tag == sender.tag) {
            [senderBtn setTitleColor:[UIColor commonTextColor] forState:0];
//            sender.titleLabel.font = [UIFont systemFontOfSize:21];
            [UIView animateWithDuration:0.5 animations:^{
                senderBtn.transform = CGAffineTransformMakeScale(1, 1);
            }];
        }else {
            if ([senderBtn isKindOfClass:[UIButton class]]) {
                [senderBtn setTitleColor:[UIColor minorTextColor] forState:0];
//                senderBtn.titleLabel.font = [UIFont systemFontOfSize:15];
                [UIView animateWithDuration:0.5 animations:^{
                    senderBtn.transform = CGAffineTransformMakeScale(0.7, 0.7);
                }];
            }
        }
    }
    
    _page = sender.tag - buttonTag;
    
    if (self.linkageAction) {
        self.linkageAction(_page);
    }
    if (iPhone5s) {
        if (_page > 0 && _page < titleArr.count - 1) {
            [self setContentOffset:CGPointMake((_page - 1) * buttonW,0) animated:YES];
        }else if(_page == titleArr.count - 1){
            [self setContentOffset:CGPointMake((_page - 2) * buttonW,0) animated:YES];
        }
    }else {
        if (_page > 4) {
            [self setContentOffset:CGPointMake(buttonW,0) animated:YES];
        }else if (_page < 3) {
            [self setContentOffset:CGPointMake(0,0) animated:YES];
        }
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:0.5 animations:^{
            if (_page == 4) {
                [selectLabel setFrame:CGRectMake(_page*buttonW + 5, 43, buttonW, 1)];
            }else if (_page == 5){
                [selectLabel setFrame:CGRectMake(_page*buttonW + 15, 43, buttonW, 1)];
            }else {
                [selectLabel setFrame:CGRectMake(sender.x + (buttonW/2 - 4), 39, 8, 4)];
                selectLabel.centerX = sender.centerX;
            }
        }];
    });
    
    
}

- (void)setPage:(NSInteger)page{
    for (UIButton *senderBtn in self.subviews) {
        if (senderBtn.tag == page + buttonTag) {
            [senderBtn setTitleColor:[UIColor commonTextColor] forState:0];
//            senderBtn.titleLabel.font = [UIFont systemFontOfSize:21];
            [UIView animateWithDuration:0.5 animations:^{
                senderBtn.transform = CGAffineTransformMakeScale(1, 1);
            }];
        }else {
            if ([senderBtn isKindOfClass:[UIButton class]]) {
                [senderBtn setTitleColor:[UIColor minorTextColor] forState:0];
//                senderBtn.titleLabel.font = [UIFont systemFontOfSize:15];
                [UIView animateWithDuration:0.5 animations:^{
                    senderBtn.transform = CGAffineTransformMakeScale(0.7, 0.7);
                }];
            }
        }
    }
    
    _page = page;
    UIButton *but = [self viewWithTag:page + buttonTag];
    if (iPhone5s) {
        if (_page > 1 && _page < titleArr.count - 1) {
            [self setContentOffset:CGPointMake((_page - 1) * buttonW,0) animated:YES];
        }else if(_page == 0){
            [self setContentOffset:CGPointMake(0,0) animated:YES];
        }
    }else {
        if (_page > 4) {
            [self setContentOffset:CGPointMake(buttonW,0) animated:YES];
        }else if (_page < 3) {
            [self setContentOffset:CGPointMake(0,0) animated:YES];
        }
    }

    dispatch_async(dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:0.5 animations:^{
            if (_page == 4) {
                [selectLabel setFrame:CGRectMake(_page*buttonW + 5, 43, buttonW, 1)];
            }else if (_page == 5){
                [selectLabel setFrame:CGRectMake(_page*buttonW + 15, 43, buttonW, 1)];
            }else {
                [selectLabel setFrame:CGRectMake(but.centerX, 39, 8, 4)];
                selectLabel.centerX = but.centerX;
            }
        }];
    });
}

-(void)layoutSubviews{
    [super layoutSubviews];
}
@end
