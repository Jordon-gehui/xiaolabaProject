//
//  DetailImageView.m
//  xiaolaba
//
//  Created by jackzhang on 2017/9/18.
//  Copyright © 2017年 jackzhang. All rights reserved.
//

#import "DetailImageView.h"

@implementation DetailImageView

@synthesize topLabel,bottomLable,imageView,likeBu,likeLable,countLable,countImageView,nilTagsLabel,ownerImgBtn,praiseBtn;

-(instancetype)init{
    
    self.backgroundColor = [UIColor whiteColor];
    
    self = [super initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, 75 + 50)];
    if (self) {
        
        
        UIView * view = [UIView new];
        view.backgroundColor = [UIColor colorWithR:247 g:248 b:250];
        view.frame = CGRectMake(0, 0, kSCREEN_WIDTH, 75 + 50);
        [self addSubview:view];
        
        
        
        UIView *Imageback = [UIView new];
        Imageback.frame = CGRectMake(0, 10, kSCREEN_WIDTH, 55);
        Imageback.backgroundColor = [UIColor whiteColor];
        [view addSubview:Imageback];
        
        praiseBtn = [UIButton new];
        praiseBtn.frame = CGRectMake(0, 0, kSCREEN_WIDTH, view.size.height);
        [view addSubview:praiseBtn];
        for (NSInteger i = 0; i < 5; i ++) {
            imageView = [UIImageView new];
            imageView.tag = 100 +i;
            [imageView.layer setMasksToBounds:YES];
            [imageView.layer setCornerRadius:20];
            [view addSubview:imageView];
            
            ownerImgBtn = [UIButton new];
            ownerImgBtn.tag = 200 + i;
            [view addSubview:ownerImgBtn];
        }
        

        
        likeBu = [UIButton new];
        [likeBu setEnlargeEdge:10];
//        likeBu.textColor = [UIColor colorWithR:153 g:153 b:153];
        [likeBu setBackgroundImage:[UIImage imageNamed:@"icon_fx_dz_n"] forState:UIControlStateNormal];
        [likeBu addTarget:self action:@selector(clickLikeBu) forControlEvents:UIControlEventTouchUpInside];
        likeBu.frame = CGRectMake(self.width - 100, 27, 22, 20);
        likeBu.centerY = Imageback.centerY;
        [view addSubview:likeBu];
        
        
        
        likeLable = [UILabel new];
        likeLable.textColor = [UIColor colorWithR:153 g:153 b:153];
        likeLable.font = [UIFont systemFontOfSize:14];;
        likeLable.frame = CGRectMake(self.width - 80, 27, 70, 20);
        likeLable.text = [NSString stringWithFormat:@"0人点赞"];
        likeLable.textAlignment = 2;
        likeLable.centerY = Imageback.centerY;
        [view addSubview:likeLable];
        
        
        nilTagsLabel = [UILabel new];
        nilTagsLabel.textColor = [UIColor lightGrayColor];
        nilTagsLabel.font = [UIFont systemFontOfSize:14];;
        nilTagsLabel.frame = CGRectMake(0, 0, 200, 20);
        nilTagsLabel.centerY = Imageback.centerY;
        nilTagsLabel.textAlignment = 1;
        nilTagsLabel.text = [NSString stringWithFormat:@"举手之劳，赞有余香！"];
        [view addSubview:nilTagsLabel];
        
        
        UIView *countBack = [UIView new];
        countBack.frame = CGRectMake(0, Imageback.bottom + 10, kSCREEN_WIDTH, 49);
        countBack.backgroundColor = [UIColor whiteColor];
        [view addSubview:countBack];
        
        countImageView = [UIImageView new];
        countImageView.frame = CGRectMake(20, 15, 27, 27);
        countImageView.image = [UIImage imageNamed:@"icon_pl"];
        [countBack addSubview:countImageView];

        
        countLable = [UILabel new];
        countLable.textColor = [UIColor colorWithR:153 g:153 b:153];
        countLable.font = [UIFont systemFontOfSize:14];;
        countLable.frame = CGRectMake(countImageView.right + 7, 17, 70, 20);
        countLable.text = [NSString stringWithFormat:@"0"];
        countLable.textAlignment = 0;
        [countBack addSubview:countLable];
        
        

        
        
    }
    
    
    return self;
    
}

- (void)setImageModelArr:(NSMutableArray *)imageModelArr{

    self.twoArr = [NSMutableArray new];
    self.ownerArr = [NSMutableArray new];
    
    if (imageModelArr.count > 0) {
        
        for (NSDictionary * dict in imageModelArr) {
            
            self.imageModel = [DetailImageModel mj_objectWithKeyValues:dict];
            
            if ([self.imageModel.avatar containsString:@"http"]) {

                [self.twoArr addObject:self.imageModel.avatar];

                //头像
            } else {
                //头像

                [self.twoArr addObject:[NSString stringWithFormat:@"%@%@",kImagePrefix,self.imageModel.avatar]];


            }
            [self.ownerArr addObject:self.imageModel];
        }
        
        for (NSInteger i = 0; i < self.twoArr.count; i++ ) {
            
            imageView = [self viewWithTag:100 + i];
            
            ownerImgBtn = [self viewWithTag:200 + i];
            
            [ownerImgBtn addTarget:self action:@selector(ownerImgBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            //头像
            [imageView sd_setImageWithURL:[NSURL URLWithString:[JXutils judgeImageheader:self.twoArr[i] Withtype:IMGAvatar]] placeholderImage:[UIImage imageNamed:@"weitouxiang"]];

            imageView.frame = CGRectMake(20 + 50 * i, 15, 40, 40);
            ownerImgBtn.frame = imageView.frame;
        }
        
        likeBu.frame = CGRectMake(self.width - 100, 27, 22, 20);
        likeLable.frame = CGRectMake(self.width - 80, 25, 70, 20);
        likeLable.textAlignment = 2;
        likeBu.centerY = imageView.centerY + 3;
        likeLable.centerY = imageView.centerY + 3;
        likeLable.text = [NSString stringWithFormat:@"%ld人点赞",imageModelArr.count];
//        

    }
    
}

- (void)ownerImgBtnClick:(UIButton *)sender {
    if (!kNotNil(self.ownerArr)) return;
    if ([self.delegate respondsToSelector:@selector(ownerImgBtnClickWithId:)]) {
        DetailImageModel *model = [self.ownerArr objectAtIndex:sender.tag - 200];
        [self.delegate ownerImgBtnClickWithId:model.userId];
    }
}

- (void)clickLikeBu{

    [self.delegate likeBu:self];
}

@end
