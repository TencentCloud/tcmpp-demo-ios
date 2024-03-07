//
//  TCMPPPayView.m
//  TCMPPDemo
//
//  Created by stonelshi on 2023/4/24.
//  Copyright (c) 2023 Tencent. All rights reserved.
//

#import "TCMPPPayView.h"

#define TITLE_HEIGHT 46
#define PAYMENT_WIDTH [UIScreen mainScreen].bounds.size.width - 80
#define PWD_COUNT 6
#define DOT_WIDTH 10
#define KEYBOARD_HEIGHT 216
#define KEY_VIEW_DISTANCE 100
#define ALERT_HEIGHT 230

@interface TCMPPPayView () <UITextFieldDelegate> {
    NSMutableArray *pwdIndicatorArr;
}
@property (nonatomic, strong) UIView *paymentAlert, *inputView;
@property (nonatomic, strong) UIButton *closeBtn;
@property (nonatomic, strong) UILabel *titleLabel, *line, *detailLabel, *moneyLabel;
@property (nonatomic, strong) UITextField *pwdTextField;
@property (nonatomic, strong) UILabel *defaultPassLabel;
@end
@implementation TCMPPPayView
- (instancetype)init {
    self = [super init];
    if (self) {
        self.frame = [UIScreen mainScreen].bounds;
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3f];
        [self drawView];
    }
    return self;
}

- (void)drawView {
    if (!_paymentAlert) {
        _paymentAlert = [[UIView alloc]
            initWithFrame:CGRectMake(40, [UIScreen mainScreen].bounds.size.height - KEYBOARD_HEIGHT - KEY_VIEW_DISTANCE - ALERT_HEIGHT, PAYMENT_WIDTH,
                              ALERT_HEIGHT)];
        _paymentAlert.layer.cornerRadius = 5.0f;
        _paymentAlert.layer.masksToBounds = YES;
        _paymentAlert.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.95];
        [self addSubview:_paymentAlert];

        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, PAYMENT_WIDTH, TITLE_HEIGHT)];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.textColor = [UIColor blackColor];
        _titleLabel.font = [UIFont systemFontOfSize:17];
        [_paymentAlert addSubview:_titleLabel];

        _closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _closeBtn.frame = CGRectMake(0, 0, TITLE_HEIGHT, TITLE_HEIGHT);
        [_closeBtn setTitle:@"╳" forState:UIControlStateNormal];
        [_closeBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [_closeBtn addTarget:self action:@selector(cancel) forControlEvents:UIControlEventTouchUpInside];
        _closeBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [_paymentAlert addSubview:_closeBtn];

        _line = [[UILabel alloc] initWithFrame:CGRectMake(0, TITLE_HEIGHT, PAYMENT_WIDTH, 0.5f)];
        _line.backgroundColor = [UIColor lightGrayColor];
        [_paymentAlert addSubview:_line];

        _detailLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, TITLE_HEIGHT + 15, PAYMENT_WIDTH, 20)];
        _detailLabel.textAlignment = NSTextAlignmentCenter;
        _detailLabel.textColor = [UIColor blackColor];
        _detailLabel.font = [UIFont systemFontOfSize:16];
        [_paymentAlert addSubview:_detailLabel];

        _moneyLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, TITLE_HEIGHT * 2, PAYMENT_WIDTH, 30)];
        _moneyLabel.textAlignment = NSTextAlignmentCenter;
        _moneyLabel.textColor = [UIColor blackColor];
        _moneyLabel.font = [UIFont systemFontOfSize:33];
        [_paymentAlert addSubview:_moneyLabel];

        _inputView = [[UIView alloc] initWithFrame:CGRectMake(15, _paymentAlert.frame.size.height - (PAYMENT_WIDTH - 30) / 6 - 35, PAYMENT_WIDTH - 30,
                                                       (PAYMENT_WIDTH - 30) / 6)];
        _inputView.backgroundColor = [UIColor whiteColor];
        _inputView.layer.borderColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1.0].CGColor;
        _inputView.layer.borderWidth = 1;
        [_paymentAlert addSubview:_inputView];

        pwdIndicatorArr = [[NSMutableArray alloc] init];
        _pwdTextField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        _pwdTextField.hidden = YES;
        _pwdTextField.delegate = self;
        _pwdTextField.keyboardType = UIKeyboardTypeNumberPad;
        [_inputView addSubview:_pwdTextField];

        _defaultPassLabel =
            [[UILabel alloc] initWithFrame:CGRectMake(15, _paymentAlert.frame.size.height - (PAYMENT_WIDTH - 30) / 6 - 30 + (PAYMENT_WIDTH - 30) / 6,
                                               PAYMENT_WIDTH, 20)];
        _defaultPassLabel.textAlignment = NSTextAlignmentLeft;
        _defaultPassLabel.textColor = [UIColor grayColor];
        _defaultPassLabel.font = [UIFont systemFontOfSize:12];
        [_paymentAlert addSubview:_defaultPassLabel];

        CGFloat width = _inputView.bounds.size.width / PWD_COUNT;
        for (int i = 0; i < PWD_COUNT; i++) {
            UILabel *dot = [[UILabel alloc] initWithFrame:CGRectMake((width - DOT_WIDTH) / 2.0f + i * width,
                                                              (_inputView.bounds.size.height - DOT_WIDTH) / 2.0f, DOT_WIDTH, DOT_WIDTH)];
            dot.backgroundColor = [UIColor blackColor];
            dot.layer.cornerRadius = DOT_WIDTH / 2.0;
            dot.clipsToBounds = YES;
            dot.hidden = YES;
            [_inputView addSubview:dot];
            [pwdIndicatorArr addObject:dot];

            if (i == PWD_COUNT - 1) {
                continue;
            }
            UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake((i + 1) * width, 0, .5f, _inputView.bounds.size.height)];
            line.backgroundColor = [UIColor colorWithRed:.9 green:.9 blue:.9 alpha:1.];
            [_inputView addSubview:line];
        }
    }
}

- (void)show {
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    [keyWindow addSubview:self];

    _paymentAlert.transform = CGAffineTransformMakeScale(0.5f, 0.5f);
    _paymentAlert.alpha = 0;
    [UIView animateWithDuration:0.7f delay:0.0f usingSpringWithDamping:0.7f initialSpringVelocity:1 options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         [self->_pwdTextField becomeFirstResponder];
                         self->_paymentAlert.transform = CGAffineTransformMakeScale(1.0f, 1.0f);
                         self->_paymentAlert.alpha = 1.0;
                     }
                     completion:nil];
}

- (void)cancel {
    [self performSelector:@selector(dismiss) withObject:nil afterDelay:0];
    if (_cancelHandle) {
        _cancelHandle();
    }
}

- (void)dismiss {
    [_pwdTextField resignFirstResponder];
    [UIView animateWithDuration:0 animations:^{
        self->_paymentAlert.transform = CGAffineTransformMakeScale(0.5f, 0.5f);
        self->_paymentAlert.alpha = 0;
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (textField.text.length >= PWD_COUNT && string.length) {
        // 输入的字符个数大于6，则无法继续输入，返回NO表示禁止输入
        return NO;
    }

    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", @"^[0-9]*$"];
    if (![predicate evaluateWithObject:string]) {
        return NO;
    }
    NSString *totalString;
    if (string.length <= 0) {
        totalString = [textField.text substringToIndex:textField.text.length - 1];
    } else {
        totalString = [NSString stringWithFormat:@"%@%@", textField.text, string];
    }
    [self setLabWithCount:totalString.length];

    if (totalString.length == 6) {
        if (_completeHandle) {
            [self performSelector:@selector(dismiss) withObject:nil afterDelay:0];
            _completeHandle(totalString);
        }
    }

    return YES;
}

- (void)setLabWithCount:(NSInteger)count {
    for (UILabel *dot in pwdIndicatorArr) {
        dot.hidden = YES;
    }

    for (int i = 0; i < count; i++) {
        ((UILabel *)[pwdIndicatorArr objectAtIndex:i]).hidden = NO;
    }
}

#pragma mark -
- (void)setTitle:(NSString *)title {
    if (_title != title) {
        _title = title;
        _titleLabel.text = _title;
    }
}

- (void)setDetail:(NSString *)detail {
    if (_detail != detail) {
        _detail = detail;
        _detailLabel.text = _detail;
    }
}

- (void)setMoney:(CGFloat)money {
    if (_money != money) {
        _money = money;
        _moneyLabel.text = [NSString stringWithFormat:@"￥%.2f元", money];
    }
}

- (void)setDefaultPass:(NSString *)defaultPass {
    if (_defaultPass != defaultPass) {
        _defaultPass = defaultPass;
        _defaultPassLabel.text = _defaultPass;
    }
}

@end
