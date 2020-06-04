//
//  XLBVerificationCodeView.m
//  xiaolaba
//
//  Created by 戴葛辉 on 2017/12/8.
//  Copyright © 2017年 jackzhang. All rights reserved.
//

#import "XLBVerificationCodeView.h"

#define kDotCount 6  //密码个数
#define K_Field_Height self.frame.size.height  //每一个输入框的高度等于当前view的高度
@interface XLBVerificationCodeView ()

@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) NSMutableArray *textArray;
@property (nonatomic, assign) NSInteger passwordLength;
@end

@implementation XLBVerificationCodeView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self initPwdTextField];
        _passwordLength = 0;
    }
    return self;
}

- (void)initPwdTextField {
    //每个密码输入框的宽度
    CGFloat width = self.frame.size.width / kDotCount;
    for (int i = 0; i < kDotCount - 1; i++) {
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.textField.frame) + (i + 1) * width, 0, 1, K_Field_Height)];
        lineView.layer.backgroundColor = [RGB(204, 204, 204) CGColor];
        [self addSubview:lineView];
    }
    self.textArray = [[NSMutableArray alloc] init];
    for (int i = 0; i < kDotCount; i++) {
        UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake(i * width, CGRectGetMinY(self.textField.frame), width, K_Field_Height)];
        lable.textColor = [UIColor textBlackColor];
        lable.font = [UIFont fontWithName:@"Arial" size:30];;
        lable.textAlignment = NSTextAlignmentCenter;
        [self addSubview:lable];
        [self.textArray addObject:lable];
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSLog(@"变化%@", string);
    if (textField == _textField) {
        NSUInteger lengthOfString = string.length;
        if([string isEqualToString:@"\n"]) {
            [textField resignFirstResponder];
            return NO;
        }
        for (NSInteger loopIndex = 0; loopIndex < lengthOfString; loopIndex++) {
            unichar character = [string characterAtIndex:loopIndex];
            // 48-57;{0,9};65-90;{A..Z};97-122:{a..z}
            if (character < 48) return NO;
            if (character > 57 && character < 65) return NO;
            if (character > 90 && character < 97) return NO;
            if (character > 122) return NO;
        }
        NSUInteger proposedNewLength = textField.text.length - range.length + string.length;
        if (proposedNewLength > kDotCount) {
            return NO;
        }else if(string.length == 0) {
            return YES;
        }
        return YES;

    }
    return YES;
    
//    if([string isEqualToString:@"\n"]) {
//        //按回车关闭键盘
//        [textField resignFirstResponder];
//        return NO;
//    } else if(string.length == 0) {
//        //判断是不是删除键
//        return YES;
//    }
//    else if(textField.text.length >= kDotCount) {
//        //输入的字符个数大于6，则无法继续输入，返回NO表示禁止输入
//        NSLog(@"输入的字符个数大于6，忽略输入");
//        return NO;
//    }else {
//        return YES;
//    }
    
}

/**
 *  清除密码
 */
- (void)clearUpPassword {
    self.textField.text = @"";
    [self textFieldDidChange:self.textField];
}
- (void)textFieldDidChange:(UITextField *)textField {
    NSLog(@"%@", textField.text);
    if (textField.text.length == kDotCount) {
        NSLog(@"输入完毕");
    }
//    NSString *regex = @"[~`!@#$%^&*()_+-=[]|{};':\",./<>?]{,}/•€£¥ ";
//    for (int i = 0; i < textField.text.length; i++) {
//        NSString *textf = [textField.text substringWithRange:NSMakeRange(i, 1)];
//        if ([regex containsString:textf] == YES) {
//            textField.text = [textField.text stringByReplacingOccurrencesOfString:textf withString:@""];
//        };
//    }
    self.passwordBlock(textField.text);
    self.passwordLength = textField.text.length;
}

- (void)setPasswordLength:(NSInteger)passwordLength {
    passwordLength = (passwordLength > kDotCount) ? kDotCount : passwordLength;
    _passwordLength = passwordLength;
    for (int i = 0; i < _textField.text.length; i++) {
        ((UILabel *)[self.textArray objectAtIndex:i]).text = [_textField.text substringWithRange:NSMakeRange(i, 1)];
    }
    for (NSInteger i = passwordLength; i < self.textArray.count; i ++) {
        UILabel *label = self.textArray[i];
        label.text = nil;
    }
    
}
#pragma mark - init

- (UITextField *)textField
{
    if (!_textField) {
        _textField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        _textField.backgroundColor = [UIColor whiteColor];
        //输入的文字颜色为白色
        _textField.textColor = [UIColor whiteColor];
        //输入框光标的颜色为白色
        _textField.tintColor = [UIColor whiteColor];
        _textField.delegate = self;
        _textField.autocorrectionType = UITextAutocorrectionTypeNo;
        _textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
        _textField.keyboardType = UIKeyboardTypeASCIICapable;
        _textField.layer.borderColor = [RGB(204, 204, 204) CGColor];
        _textField.layer.borderWidth = 1.0;
        _textField.layer.masksToBounds = YES;
        _textField.layer.cornerRadius = 5.0;
        [_textField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
        [self addSubview:_textField];
    }
    return _textField;
}

@end

