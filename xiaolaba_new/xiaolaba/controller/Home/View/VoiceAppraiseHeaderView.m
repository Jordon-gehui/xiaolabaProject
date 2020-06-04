//
//  VoiceAppraiseHeaderView.m
//  xiaolaba
//
//  Created by 戴葛辉 on 2018/4/25.
//  Copyright © 2018年 jackzhang. All rights reserved.
//

#import "VoiceAppraiseHeaderView.h"
#import "VoiceProgressView.h"

@interface VoiceAppraiseHeaderView ()

@property (nonatomic, strong) UIView *topView;
@property (nonatomic, strong) UILabel *headerLabel;

@property (nonatomic, strong) UILabel *topLeftLabel;
@property (nonatomic, strong) VoiceProgressView *topProgressView;
@property (nonatomic, strong) UILabel *topRightLabel;

@property (nonatomic, strong) UILabel *centerLeftLabel;
@property (nonatomic, strong) VoiceProgressView *centerPrV;
@property (nonatomic, strong) UILabel *centerRightLabel;

@property (nonatomic, strong) UILabel *centerSecondLabel;
@property (nonatomic, strong) VoiceProgressView *centerSecondPrV;
@property (nonatomic, strong) UILabel *centerSecondRightLabel;

@property (nonatomic, strong) UILabel *centerThreeLabel;
@property (nonatomic, strong) VoiceProgressView *centerThreePrV;
@property (nonatomic, strong) UILabel *centerThreeRightLabel;

@property (nonatomic, strong) UILabel *centerFourLabel;
@property (nonatomic, strong) VoiceProgressView *centerFourPrV;
@property (nonatomic, strong) UILabel *centerFourRightLabel;

@property (nonatomic, strong) UILabel *bottomLeftLabel;
@property (nonatomic, strong) VoiceProgressView *bottomPrV;
@property (nonatomic, strong) UILabel *bottomRightLabel;

@end

@implementation VoiceAppraiseHeaderView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setSubViews];
    }
    return self;
}

- (void)setModel:(VoiceImpressModel *)model {
    _model = model;
    [model.imprss enumerateObjectsUsingBlock:^(VoiceImpressTypeModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {

        if ([obj.type isEqualToString:@"1"]) {
            self.topLeftLabel.text = [NSString stringWithFormat:@"%@",obj.impressionName];;
            self.topRightLabel.text = [NSString stringWithFormat:@"%@票",obj.impressionCount];
            float topProValue = [obj.impressionCount integerValue];
            self.topProgressView.progressValue = [NSString stringWithFormat:@"%02f",topProValue/[_allCount integerValue]];
            NSLog(@"%02f",topProValue/[_allCount integerValue]);
        }else if ([obj.type isEqualToString:@"2"]){
            self.centerLeftLabel.text = [NSString stringWithFormat:@"%@",obj.impressionName];;
            self.centerRightLabel.text = [NSString stringWithFormat:@"%@票",obj.impressionCount];
            float centerProValue = [obj.impressionCount integerValue];
            self.centerPrV.progressValue = [NSString stringWithFormat:@"%02f",centerProValue/[_allCount integerValue]];
        }else if ([obj.type isEqualToString:@"3"]){
            self.centerSecondLabel.text = [NSString stringWithFormat:@"%@",obj.impressionName];;
            self.centerSecondRightLabel.text = [NSString stringWithFormat:@"%@票",obj.impressionCount];
            float centerSecondProValue = [obj.impressionCount integerValue];
            self.centerSecondPrV.progressValue = [NSString stringWithFormat:@"%02f",centerSecondProValue/[_allCount integerValue]];

        }else if ([obj.type isEqualToString:@"4"]){
            self.centerThreeLabel.text = [NSString stringWithFormat:@"%@",obj.impressionName];;
            self.centerThreeRightLabel.text = [NSString stringWithFormat:@"%@票",obj.impressionCount];
            float centerThreeProValue = [obj.impressionCount integerValue];
            self.centerThreePrV.progressValue = [NSString stringWithFormat:@"%02f",centerThreeProValue/[_allCount integerValue]];

        }else if ([obj.type isEqualToString:@"5"]){
            self.centerFourLabel.text = [NSString stringWithFormat:@"%@",obj.impressionName];;
            self.centerFourRightLabel.text = [NSString stringWithFormat:@"%@票",obj.impressionCount];
            float centerFourProValue = [obj.impressionCount integerValue];
            self.centerFourPrV.progressValue = [NSString stringWithFormat:@"%02f",centerFourProValue/[_allCount integerValue]];

        }else if ([obj.type isEqualToString:@"6"]){
            self.bottomLeftLabel.text = [NSString stringWithFormat:@"%@",obj.impressionName];;
            self.bottomRightLabel.text = [NSString stringWithFormat:@"%@票",obj.impressionCount];
            float bottomProValue = [obj.impressionCount integerValue];
            self.bottomPrV.progressValue = [NSString stringWithFormat:@"%02f",bottomProValue/[_allCount integerValue]];
        }
    }];
}

- (void)setSubViews {
    self.headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(16, 30, 100, 20)];
    self.headerLabel.text = @"热门评价";
    self.headerLabel.font = [UIFont systemFontOfSize:17];
    self.headerLabel.textColor = [UIColor assistColor];
    [self addSubview:self.headerLabel];
    
    self.topLeftLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.headerLabel.left, self.headerLabel.bottom + 20, 70, 16)];
    self.topLeftLabel.text = @"声音甜美";
    self.topLeftLabel.font = [UIFont systemFontOfSize:15];
    self.topLeftLabel.textColor = [UIColor minorTextColor];
    [self addSubview:self.topLeftLabel];
    
    self.topProgressView = [[VoiceProgressView alloc] initWithFrame:CGRectMake(self.topLeftLabel.right + 15, self.headerLabel.bottom + 21, 155, 14)];
//    self.topProgressView.progressValue = @"0.8";
    [self addSubview:self.topProgressView];
    self.topProgressView.centerY = self.topLeftLabel.centerY;
    
    self.topRightLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.topProgressView.right + 15, self.headerLabel.bottom + 20, kSCREEN_WIDTH - 265, 16)];
    self.topRightLabel.text = @"188票";
    self.topRightLabel.font = [UIFont systemFontOfSize:12];
    self.topRightLabel.textColor = [UIColor minorTextColor];
    [self addSubview:self.topRightLabel];
    
    self.centerLeftLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.topLeftLabel.left, self.topLeftLabel.bottom + 20, self.topLeftLabel.width, self.topLeftLabel.height)];
    self.centerLeftLabel.text = @"活泼可爱";
    self.centerLeftLabel.font = [UIFont systemFontOfSize:15];
    self.centerLeftLabel.textColor = [UIColor minorTextColor];
    [self addSubview:self.centerLeftLabel];

    self.centerPrV = [[VoiceProgressView alloc] initWithFrame:CGRectMake(self.centerLeftLabel.right + 15, self.centerLeftLabel.top + 1, self.topProgressView.width, self.topProgressView.height)];
//    self.centerPrV.progressValue = @"0.4";
    [self addSubview:self.centerPrV];

    self.centerRightLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.centerPrV.right + 15, self.centerLeftLabel.top, self.topRightLabel.width, self.topRightLabel.height)];
    self.centerRightLabel.text = @"90票";
    self.centerRightLabel.font = [UIFont systemFontOfSize:12];
    self.centerRightLabel.textColor = [UIColor minorTextColor];
    [self addSubview:self.centerRightLabel];

    self.centerSecondLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.topLeftLabel.left, self.centerLeftLabel.bottom + 20, self.topLeftLabel.width, self.topLeftLabel.height)];
    self.centerSecondLabel.text = @"能说会道";
    self.centerSecondLabel.font = [UIFont systemFontOfSize:15];
    self.centerSecondLabel.textColor = [UIColor minorTextColor];
    [self addSubview:self.centerSecondLabel];

    self.centerSecondPrV = [[VoiceProgressView alloc] initWithFrame:CGRectMake(self.centerSecondLabel.right + 15, self.centerSecondLabel.top + 1, self.topProgressView.width, self.topProgressView.height)];
//    self.centerSecondPrV.progressValue = @"0.4";
    [self addSubview:self.centerSecondPrV];

    self.centerSecondRightLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.centerSecondPrV.right + 15, self.centerSecondLabel.top, self.topRightLabel.width, self.topRightLabel.height)];
    self.centerSecondRightLabel.text = @"188票";
    self.centerSecondRightLabel.font = [UIFont systemFontOfSize:12];
    self.centerSecondRightLabel.textColor = [UIColor minorTextColor];
    [self addSubview:self.centerSecondRightLabel];


    self.centerThreeLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.topLeftLabel.left, self.centerSecondLabel.bottom + 20, self.topLeftLabel.width, self.topLeftLabel.height)];
    self.centerThreeLabel.text = @"知识渊博";
    self.centerThreeLabel.font = [UIFont systemFontOfSize:15];
    self.centerThreeLabel.textColor = [UIColor minorTextColor];
    [self addSubview:self.centerThreeLabel];

    self.centerThreePrV = [[VoiceProgressView alloc] initWithFrame:CGRectMake(self.centerThreeLabel.right + 15, self.centerThreeLabel.top + 1, self.topProgressView.width, self.topProgressView.height)];
//    self.centerThreePrV.progressValue = @"0.8";
    [self addSubview:self.centerThreePrV];

    self.centerThreeRightLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.centerSecondPrV.right + 15, self.centerThreeLabel.top, self.topRightLabel.width, self.topRightLabel.height)];
    self.centerThreeRightLabel.text = @"188票";
    self.centerThreeRightLabel.font = [UIFont systemFontOfSize:12];
    self.centerThreeRightLabel.textColor = [UIColor minorTextColor];
    [self addSubview:self.centerThreeRightLabel];


    self.centerFourLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.topLeftLabel.left, self.centerThreeLabel.bottom + 20, self.topLeftLabel.width, self.topLeftLabel.height)];
    self.centerFourLabel.text = @"热情开朗";
    self.centerFourLabel.font = [UIFont systemFontOfSize:15];
    self.centerFourLabel.textColor = [UIColor minorTextColor];
    [self addSubview:self.centerFourLabel];

    self.centerFourPrV = [[VoiceProgressView alloc] initWithFrame:CGRectMake(self.centerFourLabel.right + 15, self.centerFourLabel.top + 1, self.topProgressView.width, self.topProgressView.height)];
//    self.centerFourPrV.progressValue = @"0.8";
    [self addSubview:self.centerFourPrV];

    self.centerFourRightLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.centerFourPrV.right + 15, self.centerFourLabel.top, self.topRightLabel.width, self.topRightLabel.height)];
    self.centerFourRightLabel.text = @"188票";
    self.centerFourRightLabel.font = [UIFont systemFontOfSize:12];
    self.centerFourRightLabel.textColor = [UIColor minorTextColor];
    [self addSubview:self.centerFourRightLabel];

    self.bottomLeftLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.topLeftLabel.left, self.centerFourLabel.bottom + 20, self.topLeftLabel.width, self.topLeftLabel.height)];
    self.bottomLeftLabel.text = @"成熟声音";
    self.bottomLeftLabel.font = [UIFont systemFontOfSize:15];
    self.bottomLeftLabel.textColor = [UIColor minorTextColor];
    [self addSubview:self.bottomLeftLabel];

    self.bottomPrV = [[VoiceProgressView alloc] initWithFrame:CGRectMake(self.bottomLeftLabel.right + 15, self.bottomLeftLabel.top + 1, self.topProgressView.width, self.topProgressView.height)];
//    self.bottomPrV.progressValue = @"0.7";
    [self addSubview:self.bottomPrV];

    self.bottomRightLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.bottomPrV.right + 15, self.bottomLeftLabel.top, self.topRightLabel.width, self.topRightLabel.height)];
    self.bottomRightLabel.text = @"188票";
    self.bottomRightLabel.font = [UIFont systemFontOfSize:12];
    self.bottomRightLabel.textColor = [UIColor minorTextColor];
    [self addSubview:self.bottomRightLabel];
}


@end
