//
//  BCTContactViewController.m
//  BookContacts
//
//  Created by Chausov Alexander on 20/12/16.
//  Copyright © 2016 Chausov Alexander. All rights reserved.
//

#import "BCTContactViewController.h"
#import "RPFloatingPlaceholderTextField.h"
#import "BCTThemeConstant.h"
#import "FrameAccessor.h"
#import "AlertViewController.h"
#import "BCTValidator.h"

#import "BCTDataBaseManager.h"
#import "BCTContact.h"

#import "UIButton+CustomStyle.h"

@interface BCTContactViewController ()

@property (nonatomic, strong) IBOutlet RPFloatingPlaceholderTextField *nameTextField;
@property (nonatomic, strong) IBOutlet RPFloatingPlaceholderTextField *surnameTextField;
@property (nonatomic, strong) IBOutlet RPFloatingPlaceholderTextField *phoneTextField;
@property (nonatomic, strong) IBOutlet RPFloatingPlaceholderTextField *extraPhoneTextField;
@property (nonatomic, strong) IBOutlet UIScrollView *scrollView;
@property (nonatomic, strong) IBOutlet UILabel *likedLabel;
@property (nonatomic, strong) IBOutlet UISwitch *likedSwitch;
@property (nonatomic, strong) IBOutlet UIButton *saveButon;

@property (nonatomic, strong) BCTContact *contact;

@end

@implementation BCTContactViewController

- (instancetype)initWithContact:(BCTContact *)contact {
    self = [super init];
    if (self) {
        self.contact = contact;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setStyle];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self fillTextFieldAndSwitcher];
    self.scrollView.contentSize = CGSizeMake(self.scrollView.width, self.scrollView.height + 30.0);
    
}

- (void)fillTextFieldAndSwitcher {
    if (self.contact) {
        self.nameTextField.text = self.contact.name;
        self.surnameTextField.text = self.contact.surname;
        self.phoneTextField.text = self.contact.mainPhoneNumber;
        self.extraPhoneTextField.text = self.contact.addedPhoneNumber;
        self.likedSwitch.on = self.contact.liked.boolValue;
    }
}

- (void)setStyle {
    self.scrollView.backgroundColor = mainBackgroundThemeNrmColor;
    
    NSArray <RPFloatingPlaceholderTextField *> *textFields = @[self.nameTextField, self.surnameTextField, self.phoneTextField, self.extraPhoneTextField];
    for (RPFloatingPlaceholderTextField *textField in textFields) {
        textField.textColor = mainTextNrmColor;
        textField.tintColor = extraTextNrmColor;
        textField.floatingLabelActiveTextColor = extraTextNrmColor;
    }
    self.likedLabel.textColor = mainTextNrmColor;
    
    [self.saveButon setSaveButtonStyle];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self.view endEditing:YES];
}

#pragma mark - Action
- (IBAction)saveButtonPress:(UIButton *)sender {
    if (self.contact) {
        [self editAction];
    } else {
        [self saveAction];
    }
}

- (void)editAction {
    BOOL validField = [self validateFieldAndShowError];
    if (validField) {
        NSString *name = [[BCTValidator sharedInstance] validateContactName:self.nameTextField.text];
        NSString *surname = [[BCTValidator sharedInstance] validateContactName:self.surnameTextField.text];
        NSString *mainPhone = self.phoneTextField.text;
        NSString *extraPhone = self.extraPhoneTextField.text;
        [[BCTDataBaseManager sharedInstance] editContact:self.contact
                                                withName:name
                                                 surname:surname
                                         mainPhoneNumber:mainPhone
                                        addedPhoneNumber:extraPhone
                                               likedFlag:self.likedSwitch.on
                                              completion:^(BOOL success) {
                                                  if (success) {
                                                      [self.navigationController popViewControllerAnimated:YES];
                                                  } else {
                                                      [[AlertViewController sharedInstance] showErrorAlert:@"Произошла ошибка, попробуйте еще раз!" animation:YES autoHide:YES];
                                                  };
                                              }];
    }
}

- (void)saveAction {
    BOOL validField = [self validateFieldAndShowError];
    if (validField) {
        NSString *name = [[BCTValidator sharedInstance] validateContactName:self.nameTextField.text];
        NSString *surname = [[BCTValidator sharedInstance] validateContactName:self.surnameTextField.text];
        NSString *mainPhone = self.phoneTextField.text;
        NSString *extraPhone = self.extraPhoneTextField.text;
        [[BCTDataBaseManager sharedInstance] createContactWithName:name
                                                           surname:surname
                                                   mainPhoneNumber:mainPhone
                                                  addedPhoneNumber:extraPhone
                                                         likedFlag:self.likedSwitch.on
                                                        completion:^(BOOL success) {
                                                            if (success) {
                                                                [self.navigationController popViewControllerAnimated:YES];
                                                            } else {
                                                                [[AlertViewController sharedInstance] showErrorAlert:@"Произошла ошибка, попробуйте еще раз!" animation:YES autoHide:YES];
                                                            }
                                                        }];
    }
}

- (BOOL)validateFieldAndShowError {
    NSString *error = @"";
    if (self.nameTextField.text.length > 0) {
        if (![[BCTValidator sharedInstance] validateContactName:self.nameTextField.text]) {
            error = [error stringByAppendingString:@"Проверьте имя (от 1 до 15 символов)\n"];
        }
    } else {
        error = [error stringByAppendingString:@"Имя должно быть обязательно указано!\n"];
    }
    
    if (self.phoneTextField.text.length > 0) {
        if (![[BCTValidator sharedInstance] validatePhoneNumber:self.phoneTextField.text]) {
            error = [error stringByAppendingString:@"Неверный номер телефона\n"];
        }
    } else {
        error = [error stringByAppendingString:@"Номер телефона должен быть обязательно указан!\n"];
    }
    
    if (self.surnameTextField.text.length > 0 && ![[BCTValidator sharedInstance] validateContactSurname:self.surnameTextField.text]) {
        error = [error stringByAppendingString:@"Проверьте фамилию (от 3 до 20 символов)\n"];
    }
    
    if (self.extraPhoneTextField.text.length > 0 && ![[BCTValidator sharedInstance] validatePhoneNumber:self.extraPhoneTextField.text]) {
        error = [error stringByAppendingString:@"Неверный дополнительный номер телефона"];
    }
    
    if (!self.contact) {
        // Случай создания нового контакта
        if (![[BCTDataBaseManager sharedInstance] checkOnUniquePhoneNumber:self.phoneTextField.text]) {
            error = [error stringByAppendingString:@"\nОсновной номер телефона уже существует"];
        }
        if (![[BCTDataBaseManager sharedInstance] checkOnUniquePhoneNumber:self.extraPhoneTextField.text]) {
            error = [error stringByAppendingString:@"\nДополнительный номер телефона уже существует"];
        }
    } else {
        // случай редактирования профиля
        if (![self.contact.mainPhoneNumber isEqualToString:self.phoneTextField.text] &&
            ![[BCTDataBaseManager sharedInstance] checkOnUniquePhoneNumber:self.phoneTextField.text fromContact:self.contact]) {
            error = [error stringByAppendingString:@"\nОсновной номер телефона уже существует"];
        }
        if (![self.contact.addedPhoneNumber isEqualToString:self.extraPhoneTextField.text] &&
            ![[BCTDataBaseManager sharedInstance] checkOnUniquePhoneNumber:self.extraPhoneTextField.text fromContact:self.contact]) {
            error = [error stringByAppendingString:@"\nДополнительный номер телефона уже существует"];
        }
    }
    
    if (error.length > 0) {
        [[AlertViewController sharedInstance] showErrorAlert:error animation:YES autoHide:YES];
    }
    return error.length > 0 ? NO : YES;
}

@end
