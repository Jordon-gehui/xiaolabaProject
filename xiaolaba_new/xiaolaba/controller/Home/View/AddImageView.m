//
//  AddImageView.m
//  xiaolaba
//
//  Created by 斯陈 on 2017/9/13.
//  Copyright © 2017年 jackzhang. All rights reserved.
//

#import "AddImageView.h"

@interface AddImageView()

@property (nonatomic,assign)CGFloat height;
@property (nonatomic,copy)NSArray *array;

@property (nonatomic,assign)NSInteger rowNuber;
@property (nonatomic,assign)NSInteger MaxCount;

#define btnnumber 4 //每行几个
@end
@implementation AddImageView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initViewWithArray:self.array];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initViewWithArray:self.array];
    }
    return self;
}

-(void)initViewWithArray:(NSArray*)viewList {
    if (_MaxCount==0) {
        _MaxCount = 9;
    }
    if (_rowNuber ==0) {
        _rowNuber =btnnumber;
    }
    
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    float kimgWidth = 70; //控件大小
    float kspace = (kSCREEN_WIDTH-20-70*_rowNuber)/(_rowNuber+1);
    float kHspace = 10;
    for (NSInteger i=0; i<viewList.count; i++) {
        NSInteger y = i/_rowNuber;
        NSInteger x = i-y*_rowNuber;
        
        [self addBtnWithframe:CGRectMake((kspace+kimgWidth)*x+kspace, kHspace+y*(kHspace+kimgWidth), kimgWidth, kimgWidth) WithImage:viewList[i] WithTag:i];
        if (i == viewList.count-1) {
            if(viewList.count<_MaxCount){
                y = (i+1)/_rowNuber;
                x = i+1-y*_rowNuber;
                [self addBtnWithframe:CGRectMake((kspace+kimgWidth)*x+kspace, kHspace+y*(kHspace+kimgWidth), kimgWidth, kimgWidth) WithImage:[UIImage imageNamed:@"pic_xj"] WithTag:999];
            }
        }
        
        _height = kHspace+y*(kHspace+kimgWidth) +kimgWidth +10;
    }
    if (viewList.count==0) {
        [self addBtnWithframe:CGRectMake((kspace+kimgWidth)*0+kspace, kHspace+0*(kHspace+kimgWidth), kimgWidth, kimgWidth) WithImage:[UIImage imageNamed:@"pic_xj"] WithTag:999];
    }
    if ([_delegate performSelector:@selector(updateAddimageViewHeight:)]){
        [self.delegate updateAddimageViewHeight:self.height];
    }
}

-(void)setMaxImgCount:(NSInteger)count rowNumber:(NSInteger)number {
    _rowNuber = number;
    _MaxCount = count;
}

-(void)addBtnWithframe:(CGRect)frame WithImage:(UIImage*)img WithTag:(NSInteger)tag{
    UIButton *button = [[UIButton alloc]initWithFrame:frame];
    [button setImage:img forState:UIControlStateNormal];
    button.imageView.contentMode =UIViewContentModeScaleAspectFill;
    button.layer.cornerRadius = 5;
    button.layer.masksToBounds = YES;
    button.tag = tag;
    [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:button];
}

-(void)buttonClick:(UIButton*)button {
    if (button.tag ==999) {
        NSLog(@"添加图片");
        if ([_delegate performSelector:@selector(addImageView:)]){
            [self.delegate addImageView:999];
        }
    }else{
        NSLog(@"预览图片%li",button.tag);
        NSString *indexStr = [NSString stringWithFormat:@"%li",button.tag];
        if ([self.delegate respondsToSelector:@selector(selectBtnImageView:)]) {
            [self.delegate selectBtnImageView:indexStr];
        }
    }
}

-(NSArray *)array {
    if (!_array) {
        _array = [NSArray array];
    }
    return _array;
}
-(void)initViewWith:(NSArray*)array {
    NSMutableArray *list = [NSMutableArray arrayWithArray:array];
    _array = list;
    [self initViewWithArray:_array];
    
}

@end
