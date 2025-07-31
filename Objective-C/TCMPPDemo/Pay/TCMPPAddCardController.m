//
//  TCMPPAddCardController.m
//  TUIKitDemo
//
//  Created by xcode on 2024/9/18.
//  Copyright © 2024 Tencent. All rights reserved.
//

#import "TCMPPAddCardController.h"
#import "TCMPPPayMethodCell.h"
@interface TCMPPAddCardController ()
@property (nonatomic, strong) UITextField *cardNumberTextField;
@property (nonatomic, strong) UITextField *cardHolderTextField;
@property (nonatomic, strong) UITextField *expiryDateTextField;
@property (nonatomic, strong) UITextField *cvvTextField;
@property (nonatomic, strong) UIDatePicker *datePicker;
@end

@implementation TCMPPAddCardController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1.0];
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 44)];
    titleLabel.text = @"Provide further information";
    titleLabel.textColor = [UIColor blackColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont boldSystemFontOfSize:17];
    self.navigationItem.titleView = titleLabel;
    
    [self setupUI];
}

- (void)setupUI {
    
    UIView *titleBg = [[UIView alloc]initWithFrame:CGRectMake(10, 100, self.view.frame.size.width - 20, 80)];
    titleBg.backgroundColor = [UIColor whiteColor];
    titleBg.layer.cornerRadius = 15;
    titleBg.layer.masksToBounds = YES;
    [self.view addSubview:titleBg];
    UIImageView *cardImg = [[UIImageView alloc]initWithFrame:CGRectMake(10, 20, 30, 20)];
    cardImg.image = [UIImage imageNamed:@"card"];
    [titleBg addSubview:cardImg];
    UILabel *addCardLbl = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetWidth(cardImg.frame) + 25, 15, 200, 30)];
    addCardLbl.text = @"Add a new card";
    addCardLbl.textColor = [UIColor blackColor];
    [titleBg addSubview:addCardLbl];
    UIImageView *cardtype1 = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"bri"]];
    cardtype1.frame = CGRectMake(10, CGRectGetMaxY(cardImg.frame) + 5, cardtype1.image.size.width * 0.7, cardtype1.image.size.height * 0.7);
    [titleBg addSubview:cardtype1];
    UIImageView *cardtype2 = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"dbs"]];
    cardtype2.frame = CGRectMake(CGRectGetMaxX(cardtype1.frame) + 5, CGRectGetMaxY(cardImg.frame) + 5, cardtype2.image.size.width * 0.7, cardtype2.image.size.height * 0.7);
    [titleBg addSubview:cardtype2];
    
    UIView *textBg = [[UIView alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(titleBg.frame) + 10, self.view.frame.size.width - 20, 240)];
    textBg.backgroundColor = [UIColor whiteColor];
    textBg.layer.cornerRadius = 15;
    textBg.layer.masksToBounds = YES;
    [self.view addSubview:textBg];
    
    CGFloat textFieldWidth = textBg.frame.size.width - 40;
    CGFloat textFieldHeight = 40;
    CGFloat padding = 20;
    self.cardNumberTextField = [self createTextFieldWithPlaceholder:@"card number"];
    self.cardNumberTextField.keyboardType = UIKeyboardTypeNumberPad;
    self.cardHolderTextField = [self createTextFieldWithPlaceholder:@"cardholder Name"];
    self.expiryDateTextField = [self createTextFieldWithPlaceholder:@"MM/YY"];
    self.cvvTextField = [self createTextFieldWithPlaceholder:@"CVV"];
    self.cardNumberTextField.frame = CGRectMake(20, 10, textFieldWidth, textFieldHeight);
    self.cardHolderTextField.frame = CGRectMake(20, CGRectGetMaxY(self.cardNumberTextField.frame) + padding, textFieldWidth, textFieldHeight);
    self.expiryDateTextField.frame = CGRectMake(20, CGRectGetMaxY(self.cardHolderTextField.frame) + padding, textFieldWidth, textFieldHeight);
    self.cvvTextField.frame = CGRectMake(20, CGRectGetMaxY(self.expiryDateTextField.frame) + padding, textFieldWidth, textFieldHeight);
    [textBg addSubview:self.cardNumberTextField];
    [textBg addSubview:self.cardHolderTextField];
    [textBg addSubview:self.expiryDateTextField];
    [textBg addSubview:self.cvvTextField];
    
    UIButton *saveBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [saveBtn setTitle:@"Save&Confirm" forState:UIControlStateNormal];
    saveBtn.backgroundColor = [UIColor redColor];
    [saveBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    saveBtn.layer.cornerRadius = 20;
    saveBtn.layer.masksToBounds = YES;
    [saveBtn addTarget:self action:@selector(saveBtnClick) forControlEvents:UIControlEventTouchUpInside];
    saveBtn.frame = CGRectMake(20, self.view.frame.size.height - 60, self.view.frame.size.width - 40, 40);
    [self.view addSubview:saveBtn];
    
    UIImageView *noticeImg = [[UIImageView alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(textBg.frame) + 12, 15, 15)];
    if (@available(iOS 13.0, *)) {
        noticeImg.image = [UIImage systemImageNamed:@"exclamationmark.circle"];
    } 
    UILabel *noticeLbl = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetWidth(noticeImg.frame) + 15, CGRectGetMaxY(textBg.frame) + 10, 200, 20)];
    noticeLbl.text = @"Money Safety Guarantee";
    noticeLbl.textColor = [UIColor lightGrayColor];
    [self.view addSubview:noticeLbl];
    [self.view addSubview:noticeImg];
    
    [self setupDatePicker];
}

- (UITextField *)createTextFieldWithPlaceholder:(NSString *)placeholder {
    UITextField *textField = [[UITextField alloc] init];
    textField.placeholder = placeholder;
    textField.font = [UIFont systemFontOfSize:16];
    textField.textColor = [UIColor blackColor];
    textField.backgroundColor = [UIColor whiteColor];
    textField.layer.cornerRadius = 8.0;
    textField.layer.borderWidth = 1.0;
    textField.layer.borderColor = [UIColor lightGrayColor].CGColor;
    textField.layer.masksToBounds = YES;
    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, textField.frame.size.height)];
    textField.leftView = paddingView;
    textField.leftViewMode = UITextFieldViewModeAlways;
    UIColor *placeholderColor = [UIColor grayColor];
    textField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:placeholder
                                                                          attributes:@{NSForegroundColorAttributeName: placeholderColor}];
    return textField;
}
- (void)saveBtnClick{
    if (self.cardNumberTextField.text.length <= 8) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Hint" message:@"The card number is too short" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"YES" style:UIAlertActionStyleDefault handler:nil];
        [alertController addAction:okAction];
        [self presentViewController:alertController animated:YES completion:nil];
        return;
    }
    if (self.dismissBlock) {
        TCMPPPayMethodCellModel *model = [[TCMPPPayMethodCellModel alloc]init];
        NSString *cardNumber = self.cardNumberTextField.text;
        NSString *firstFour = [cardNumber substringToIndex:4];
        NSString *lastFour = [cardNumber substringFromIndex:cardNumber.length - 4];
        NSUInteger middleLength = cardNumber.length - 8;
        NSString *middle = [@"" stringByPaddingToLength:middleLength withString:@"*" startingAtIndex:0];
        model.imgName = arc4random_uniform(2) == 0 ? @"bri" : @"dbs";
        model.payName = [NSString stringWithFormat:@"%@%@%@", firstFour, middle, lastFour];
        self.dismissBlock(model);
    }
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)setupDatePicker {

    self.datePicker = [[UIDatePicker alloc] init];
    self.datePicker.datePickerMode = UIDatePickerModeDate;
    self.datePicker.locale = [NSLocale localeWithLocaleIdentifier:@"en_US"];
    self.datePicker.frame = CGRectMake(0, 44, self.view.frame.size.width, 216);

    UIButton *doneButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [doneButton setTitle:@"done" forState:UIControlStateNormal];
    [doneButton addTarget:self action:@selector(doneButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    doneButton.frame = CGRectMake(self.view.frame.size.width - 80, 0, 80, 44);

    UIView *inputView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 260)];
    inputView.backgroundColor = [UIColor whiteColor];
    [inputView addSubview:self.datePicker];
    [inputView addSubview:doneButton];

    self.expiryDateTextField.inputView = inputView;
}


- (void)doneButtonTapped {
    NSDate *selectedDate = self.datePicker.date;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM/yy"];
    NSString *dateString = [dateFormatter stringFromDate:selectedDate];
    self.expiryDateTextField.text = dateString;
    [self.expiryDateTextField resignFirstResponder];
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}
@end
