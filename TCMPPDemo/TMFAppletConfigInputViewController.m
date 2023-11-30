//
//  TMFAppletConfigInputViewController.m
//  TMFDemo
//
//  Created by StoneShi on 2022/4/18.
//  Copyright © 2022 Tencent. All rights reserved.
//

#import "TMFAppletConfigInputViewController.h"
#import "TMFAppletConfigManager.h"


@interface TMFAppletConfigInputViewController () <UITextViewDelegate>
@property (nonatomic, strong) UITextView *textView;
@property (nonatomic, assign) CGFloat textViewMinimumHeight;
@property (nonatomic, strong) UIToolbar *toolBar;
@property (nonatomic, strong) UILabel *tipsLabel;
@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) UILabel *placeholderLabel;
@end

@implementation TMFAppletConfigInputViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.toolBar = [[UIToolbar alloc] init];
    [self.view addSubview:self.toolBar];
    UIBarButtonItem *cancel = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Cancel",nil) style:UIBarButtonItemStylePlain target:self action:@selector(clickCancel:)];
    UIBarButtonItem *fix = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem *confirm = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Save",nil) style:UIBarButtonItemStylePlain target:self action:@selector(clickConfirm:)];
    [self.toolBar setItems:@[cancel, fix, confirm]];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.tipsLabel = [[UILabel alloc] init];
    
    self.tipsLabel.attributedText = [[NSAttributedString alloc]
        initWithString:NSLocalizedString(@"Please enter a profile name:",nil)
            attributes:@{
                NSFontAttributeName: [UIFont systemFontOfSize:12],
                NSForegroundColorAttributeName: [UIColor colorWithRed:153/255.0 green:160/255.0 blue:170/255.0 alpha:1],
                NSParagraphStyleAttributeName: [NSMutableParagraphStyle defaultParagraphStyle]
            }];
    
    self.tipsLabel.numberOfLines = 0;
    [self.view addSubview:self.tipsLabel];
    
    self.textField = [[UITextField alloc] init];
    self.textField.font = [UIFont systemFontOfSize:16];
    self.textField.layer.cornerRadius = 2;
    self.textField.layer.borderColor = [UIColor colorWithRed:222/255.0 green:224/255.0 blue:226/255.0 alpha:1].CGColor;
    self.textField.layer.borderWidth = 1;

    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.firstLineHeadIndent = 10.0;

    NSAttributedString *placeholder = [[NSAttributedString alloc] initWithString:NSLocalizedString(@"Configuration information name",nil) attributes:@{NSForegroundColorAttributeName:[UIColor lightGrayColor], NSParagraphStyleAttributeName:paragraphStyle}];
    self.textField.attributedPlaceholder = placeholder;
    
    self.textField.clearButtonMode = UITextFieldViewModeAlways;
    [self.view addSubview:self.textField];
    
    self.textView = [[UITextView alloc] init];
    self.textView.delegate = self;
    self.textView.textContainerInset = UIEdgeInsetsMake(10, 7, 10, 7);
    self.textView.returnKeyType = UIReturnKeySend;

    self.placeholderLabel = [[UILabel alloc] init];
    self.placeholderLabel.text = NSLocalizedString(@"Configuration information content can be pasted here by long pressing",nil);
    self.placeholderLabel.textColor = [UIColor lightGrayColor];
    self.placeholderLabel.font = self.textView.font;
    self.placeholderLabel.numberOfLines = 3;
    [self.placeholderLabel sizeToFit];
    [self.textView addSubview:self.placeholderLabel];
    
    self.textView.delegate = self;
    
    self.textView.layer.borderWidth = 1;
    self.textView.layer.borderColor = [UIColor colorWithRed:222/255.0 green:224/255.0 blue:226/255.0 alpha:1].CGColor;
    self.textView.layer.cornerRadius = 4;
    [self.view addSubview:self.textView];
}

- (void)textViewDidChange:(UITextView *)textView {
    if (self.textView.text.length > 0) {
        self.placeholderLabel.hidden = YES;
    } else {
        self.placeholderLabel.hidden = NO;
    }
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    CGFloat height = CGRectGetHeight(self.view.bounds);
    CGFloat y = 0;
    
    self.toolBar.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), 44);
    y += 40;
    
    CGFloat contentWidth = CGRectGetWidth(self.view.bounds) - 32;
    
    CGFloat tipsLabelHeight = 40;
    self.tipsLabel.frame = CGRectMake(16, y, contentWidth, tipsLabelHeight);
    y += tipsLabelHeight;
    y += 5;
    self.textField.frame = CGRectMake(16, y, contentWidth,40);
    y += 45;
    self.textView.frame = CGRectMake(16, y, contentWidth, height-y-50);
    
    self.placeholderLabel.frame = CGRectMake(16, y, contentWidth, 60);
}

- (BOOL)shouldHideKeyboardWhenTouchInView:(UIView *)view {
    // 表示点击空白区域都会降下键盘
    return YES;
}

#pragma mark - Slider function
- (void)clickCancel:(id)slider{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)clickConfirm:(id)slider{
    NSString *title = self.textField.text;
    NSString *content = self.textView.text;
    
    if (title.length<=0 || content.length<=0) {
        [self showError:NSLocalizedString(@"The input content is empty, unable to add!",nil)];
    } else if(title.length<2 || title.length>10){
        [self showError:NSLocalizedString(@"Please enter 2~10 characters for the server name!",nil)];
    } else if([[TMFAppletConfigManager sharedInstance] checkAppletConfigTitle:title]){
        [self showError:NSLocalizedString(@"Server name already exists!",nil)];
    } else {
        //新增配置文件
        if([[TMFAppletConfigManager sharedInstance] addAppletConfig:title andContent:content]) {
            if(self.addHandler) {
                self.addHandler(nil);
            }
            [self dismissViewControllerAnimated:YES completion:nil];
        } else {
            [self showError:NSLocalizedString(@"Configuration file information error!",nil)];
        }
    }
}


- (void)showError:(NSString *)err {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error" message:err preferredStyle:UIAlertControllerStyleAlert];
    [self presentViewController:alert animated:YES completion:nil];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [alert dismissViewControllerAnimated:YES completion:nil];
    });
}

@end
