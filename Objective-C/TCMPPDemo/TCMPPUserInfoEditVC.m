//
//  TCMPPUserInfoEditVC.m
//  TCMPPDemo
//
//  Created by Assistant on 2024/12/19.
//  Copyright © 2024 Tencent. All rights reserved.
//

#import "TCMPPUserInfoEditVC.h"
#import "TCMPPDemoLoginManager.h"
#import "ToastView.h"
#import <Photos/Photos.h>
#import <PhotosUI/PhotosUI.h>
#import <AVFoundation/AVFoundation.h>

@interface TCMPPUserInfoEditVC () <UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIImageView *avatarImageView;
@property (nonatomic, strong) UITextField *nicknameTextField;
@property (nonatomic, strong) UITextField *emailTextField;
@property (nonatomic, strong) UITextField *phoneTextField;
@property (nonatomic, strong) NSData *avatarData;
@property (nonatomic, strong) UIBarButtonItem *saveButton;
@property (nonatomic, strong) ToastView *loadingToast;

@property (nonatomic, strong) NSString *userNickname;
@property (nonatomic, strong) NSString *userEmail;
@property (nonatomic, strong) NSString *userPhoneNumber;

@end

@implementation TCMPPUserInfoEditVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = NSLocalizedString(@"Edit User Information", nil);
    if (@available(iOS 13.0, *)) {
        self.view.backgroundColor = [UIColor systemBackgroundColor];
    } else {
        self.view.backgroundColor = [UIColor whiteColor];
    }
    
    [self setupNavigationBar];
    [self loadUserInfo];
    [self setupTableView];
}

- (void)setupNavigationBar {
    self.saveButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Save", nil) 
                                                       style:UIBarButtonItemStyleDone 
                                                      target:self 
                                                      action:@selector(saveUserInfo)];
    self.navigationItem.rightBarButtonItem = self.saveButton;
}

- (void)setupTableView {
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    if (@available(iOS 13.0, *)) {
        self.tableView.backgroundColor = [UIColor systemGroupedBackgroundColor];
    } else {
        self.tableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    }
    [self.view addSubview:self.tableView];
    
    self.tableView.translatesAutoresizingMaskIntoConstraints = NO;
    [NSLayoutConstraint activateConstraints:@[
        [self.tableView.topAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.topAnchor],
        [self.tableView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor],
        [self.tableView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor],
        [self.tableView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor]
    ]];
}

- (void)loadUserInfo {
    TCMPPUserInfo *userInfo = [TCMPPUserInfo sharedInstance];
    
    if (userInfo.avatarUrl && userInfo.avatarUrl.length > 0) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSURL *url = [NSURL URLWithString:userInfo.avatarUrl];
            NSData *imageData = [NSData dataWithContentsOfURL:url];
            if (imageData) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.avatarImageView.image = [UIImage imageWithData:imageData];
                });
            }
        });
    }
    
    TCMPPUserInfo *tcmppUserInfo = [TCMPPUserInfo sharedInstance];
    
    if (self.nicknameTextField) {
        self.nicknameTextField.text = userInfo.nickName ?: @"";
    }
    if (self.emailTextField) {
        self.emailTextField.text = tcmppUserInfo.email ?: @"";
    }
    if (self.phoneTextField) {
        self.phoneTextField.text = tcmppUserInfo.phoneNumber ?: @"";
    }
    
    self.userNickname = tcmppUserInfo.nickName;
    self.userEmail = tcmppUserInfo.email;
    self.userPhoneNumber = tcmppUserInfo.phoneNumber;
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"UserInfoCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    switch (indexPath.row) {
        case 0: {
            cell.textLabel.text = NSLocalizedString(@"Avatar", nil);
            
            if (!self.avatarImageView) {
                self.avatarImageView = [[UIImageView alloc] init];
                self.avatarImageView.contentMode = UIViewContentModeScaleAspectFill;
                self.avatarImageView.clipsToBounds = YES;
                self.avatarImageView.layer.cornerRadius = 25;
                if (@available(iOS 13.0, *)) {
                    self.avatarImageView.backgroundColor = [UIColor systemGray5Color];
                } else {
                    self.avatarImageView.backgroundColor = [UIColor lightGrayColor];
                }
                
                NSString *filePath = [[NSBundle mainBundle] pathForResource:@"avatar" ofType:@"png"];
                if (filePath) {
                    self.avatarImageView.image = [UIImage imageWithContentsOfFile:filePath];
                }
            }
            
            [cell.contentView addSubview:self.avatarImageView];
            self.avatarImageView.translatesAutoresizingMaskIntoConstraints = NO;
            [NSLayoutConstraint activateConstraints:@[
                [self.avatarImageView.centerYAnchor constraintEqualToAnchor:cell.contentView.centerYAnchor],
                [self.avatarImageView.trailingAnchor constraintEqualToAnchor:cell.contentView.trailingAnchor constant:-20],
                [self.avatarImageView.widthAnchor constraintEqualToConstant:50],
                [self.avatarImageView.heightAnchor constraintEqualToConstant:50]
            ]];
            
            UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectAvatar)];
            [self.avatarImageView addGestureRecognizer:tapGesture];
            self.avatarImageView.userInteractionEnabled = YES;
            
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            break;
        }
        case 1: {
            cell.textLabel.text = NSLocalizedString(@"Nickname", nil);
            
            if (!self.nicknameTextField) {
                self.nicknameTextField = [[UITextField alloc] init];
                self.nicknameTextField.placeholder = NSLocalizedString(@"Enter nickname", nil);
                self.nicknameTextField.textAlignment = NSTextAlignmentRight;
                self.nicknameTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
                self.nicknameTextField.text = self.userNickname ?: @"";
            }
            
            [cell.contentView addSubview:self.nicknameTextField];
            self.nicknameTextField.translatesAutoresizingMaskIntoConstraints = NO;
            [NSLayoutConstraint activateConstraints:@[
                [self.nicknameTextField.centerYAnchor constraintEqualToAnchor:cell.contentView.centerYAnchor],
                [self.nicknameTextField.trailingAnchor constraintEqualToAnchor:cell.contentView.trailingAnchor constant:-20],
                [self.nicknameTextField.leadingAnchor constraintEqualToAnchor:cell.contentView.leadingAnchor constant:120],
                [self.nicknameTextField.heightAnchor constraintEqualToConstant:44]
            ]];
            break;
        }
        case 2: {
            cell.textLabel.text = NSLocalizedString(@"Email", nil);
            
            if (!self.emailTextField) {
                self.emailTextField = [[UITextField alloc] init];
                self.emailTextField.placeholder = NSLocalizedString(@"Enter email", nil);
                self.emailTextField.textAlignment = NSTextAlignmentRight;
                self.emailTextField.keyboardType = UIKeyboardTypeEmailAddress;
                self.emailTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
                self.emailTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
                self.emailTextField.text = self.userEmail ?: @"";
            }
            
            [cell.contentView addSubview:self.emailTextField];
            self.emailTextField.translatesAutoresizingMaskIntoConstraints = NO;
            [NSLayoutConstraint activateConstraints:@[
                [self.emailTextField.centerYAnchor constraintEqualToAnchor:cell.contentView.centerYAnchor],
                [self.emailTextField.trailingAnchor constraintEqualToAnchor:cell.contentView.trailingAnchor constant:-20],
                [self.emailTextField.leadingAnchor constraintEqualToAnchor:cell.contentView.leadingAnchor constant:120],
                [self.emailTextField.heightAnchor constraintEqualToConstant:44]
            ]];
            break;
        }
        case 3: {
            cell.textLabel.text = NSLocalizedString(@"Phone Number", nil);
            
            if (!self.phoneTextField) {
                self.phoneTextField = [[UITextField alloc] init];
                self.phoneTextField.placeholder = NSLocalizedString(@"Enter phone number", nil);
                self.phoneTextField.textAlignment = NSTextAlignmentRight;
                self.phoneTextField.keyboardType = UIKeyboardTypePhonePad;
                self.phoneTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
                self.phoneTextField.text = self.userPhoneNumber ?: @"";
            }
            
            [cell.contentView addSubview:self.phoneTextField];
            self.phoneTextField.translatesAutoresizingMaskIntoConstraints = NO;
            [NSLayoutConstraint activateConstraints:@[
                [self.phoneTextField.centerYAnchor constraintEqualToAnchor:cell.contentView.centerYAnchor],
                [self.phoneTextField.trailingAnchor constraintEqualToAnchor:cell.contentView.trailingAnchor constant:-20],
                [self.phoneTextField.leadingAnchor constraintEqualToAnchor:cell.contentView.leadingAnchor constant:120],
                [self.phoneTextField.heightAnchor constraintEqualToConstant:44]
            ]];
            break;
        }
    }
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        [self selectAvatar];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 70.0;
}

#pragma mark - Actions

- (void)selectAvatar {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Select Avatar", nil)
                                                                             message:nil
                                                                      preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *cameraAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Camera", nil)
                                                           style:UIAlertActionStyleDefault
                                                         handler:^(UIAlertAction * _Nonnull action) {
        [self showImagePickerWithSourceType:UIImagePickerControllerSourceTypeCamera];
    }];
    
    UIAlertAction *photoLibraryAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Photo Library", nil)
                                                                 style:UIAlertActionStyleDefault
                                                               handler:^(UIAlertAction * _Nonnull action) {
        [self showImagePickerWithSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Cancel", nil)
                                                           style:UIAlertActionStyleCancel
                                                         handler:nil];
    
    [alertController addAction:cameraAction];
    [alertController addAction:photoLibraryAction];
    [alertController addAction:cancelAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)showImagePickerWithSourceType:(UIImagePickerControllerSourceType)sourceType {
    if (sourceType == UIImagePickerControllerSourceTypeCamera) {
        AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
        if (status == AVAuthorizationStatusDenied || status == AVAuthorizationStatusRestricted) {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Camera Permission", nil)
                                                                           message:NSLocalizedString(@"Please enable camera access in Settings", nil)
                                                                    preferredStyle:UIAlertControllerStyleAlert];
            [alert addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"OK", nil) style:UIAlertActionStyleDefault handler:nil]];
            [self presentViewController:alert animated:YES completion:nil];
            return;
        }
    }
    
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.delegate = self;
    imagePicker.sourceType = sourceType;
    imagePicker.allowsEditing = YES;
    
    [self presentViewController:imagePicker animated:YES completion:nil];
}

- (void)saveUserInfo {
    self.saveButton.enabled = NO;
    [self showLoading:NSLocalizedString(@"Saving...", nil)];
    [[TCMPPDemoLoginManager sharedInstance] updateUserInfoWithEmail:self.emailTextField.text
                                                             avatar:self.avatarData
                                                           nickName:self.nicknameTextField.text
                                                        phoneNumber:self.phoneTextField.text
                                                            success:^(BOOL success, NSString *message) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.saveButton.enabled = YES;
            [self hideLoading];
            
            if (success) {
                TCMPPUserInfo *userInfo = [TCMPPUserInfo sharedInstance];
                userInfo.nickName = self.nicknameTextField.text;
                userInfo.email = self.emailTextField.text;
                userInfo.phoneNumber = self.phoneTextField.text;
                
                [userInfo saveUserInfoToUserDefaults];
                
                [self showToast:NSLocalizedString(@"User information updated successfully", nil)];
                [self.navigationController popViewControllerAnimated:YES];
            } else {
                [self showToast:message ?: NSLocalizedString(@"Update failed", nil)];
            }
        });
    } failure:^(NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.saveButton.enabled = YES;
            [self hideLoading];
            [self showToast:error.localizedDescription ?: NSLocalizedString(@"Update failed", nil)];
        });
    }];
}

#pragma mark - Toast Helper Methods
- (void)showToast:(NSString *)message {
    UIImage *icon = [UIImage imageNamed:@"success"];
    ToastView *toast = [[ToastView alloc] initWithIcon:icon title:message];
    [toast showWithDuration:2.0];
}

- (void)showLoading:(NSString *)message {
    UIImage *icon = [UIImage imageNamed:@"success"];
    self.loadingToast = [[ToastView alloc] initWithIcon:icon title:message];
    [self.loadingToast show];
}

- (void)hideLoading {
    if (self.loadingToast) {
        [self.loadingToast dismiss];
        self.loadingToast = nil;
    }
}

#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<UIImagePickerControllerInfoKey,id> *)info {
    UIImage *selectedImage = info[UIImagePickerControllerEditedImage];
    if (!selectedImage) {
        selectedImage = info[UIImagePickerControllerOriginalImage];
    }
    
    if (selectedImage) {
        CGFloat maxSize = 300.0;
        CGSize newSize = selectedImage.size;
        if (newSize.width > maxSize || newSize.height > maxSize) {
            CGFloat scale = MIN(maxSize / newSize.width, maxSize / newSize.height);
            newSize = CGSizeMake(newSize.width * scale, newSize.height * scale);
            
            UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
            [selectedImage drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
            selectedImage = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
        }
        
        self.avatarImageView.image = selectedImage;
        self.avatarData = UIImageJPEGRepresentation(selectedImage, 0.8);
    }
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}

@end 
