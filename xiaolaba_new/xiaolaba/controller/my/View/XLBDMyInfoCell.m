//
//  XLBDMyInfoCell.m
//  xiaolaba
//
//  Created by 戴葛辉 on 2017/9/6.
//  Copyright © 2017年 jxcode. All rights reserved.
//

#import "XLBDMyInfoCell.h"

@implementation XLBDMyInfoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.contentView.autoresizingMask =
    //UIViewAutoresizingFlexibleLeftMargin |
    UIViewAutoresizingFlexibleWidth |
    //UIViewAutoresizingFlexibleRightMargin |
    //UIViewAutoresizingFlexibleTopMargin |
    UIViewAutoresizingFlexibleHeight
    //UIViewAutoresizingFlexibleBottomMargin
    ;
    self.contentView.translatesAutoresizingMaskIntoConstraints = YES;
}

- (void)setUser:(XLBUser *)user {
    self.XLBAllTitle.hidden = YES;
    switch (self.section) {
        case 0: {
            switch (self.row) {
                case 0: {
                    self.XLBTitle.text = @"昵称";
                    self.XLBSubTitle.text = user.userModel.nickname;
                }
                    break;
                case 1: {
                    self.XLBTitle.text = @"性别";
                    NSString *sex = [user.userModel.sex boolValue] ? @"男":@"女";
                    self.XLBSubTitle.text = sex;
                }
                    break;
                case 2: {
                    if (!kNotNil(user.userModel.birthdate)) {
                        self.XLBSubTitle.text = @"未填写";
                    }else {
                        self.XLBSubTitle.text = [ZZCHelper dateStringFromNumberTimer:user.userModel.birthdate type:1];
                    }
                    self.XLBTitle.text = @"生日";

                }
                    break;
                case 3: {
                    if (!kNotNil(user.userModel.domicile)) {
                        self.XLBSubTitle.text = @"";
                    }else {
                        if (kNotNil(user.userModel.domicile)) {
                            if ([user.userModel.domicile containsString:@","]) {
                                NSArray *strArr = [user.userModel.domicile componentsSeparatedByString:@","];
                                self.XLBSubTitle.text = [NSString stringWithFormat:@"%@%@",strArr[1],strArr[2]];
                            }else {
                                self.XLBSubTitle.text = user.userModel.domicile;
                            }
                        }
                    }
                    self.XLBTitle.text = @"居住地";
                    
                }
                    break;
                default:
                    break;
            }
        }
            break;
        case 1: {
            self.XLBSubTitle.text = user.userModel.signature;
            self.XLBTitle.text = @"个性签名";
            if (user.userModel.signature.length > 16) {
                self.XLBSubTitle.textAlignment = NSTextAlignmentLeft;
            }else {
                self.XLBSubTitle.textAlignment = NSTextAlignmentRight;
            }
        }
            break;
        case 2: {
            self.XLBTitle.text = @"";
            self.XLBSubTitle.text = @"";
            self.XLBAllTitle.hidden = NO;
            self.XLBAllTitle.text = @"查看我的全部动态";

        }
            break;

            
        default:
            break;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
