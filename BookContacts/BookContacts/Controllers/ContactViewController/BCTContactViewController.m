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

#import "BCTDataBaseManager.h"
#import "BCTContact.h"
#import "BCTPhoneNumber.h"

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
    [self fillTextField];
    self.scrollView.contentSize = CGSizeMake(self.scrollView.width, self.scrollView.height + 30.0);
    
}

- (void)fillTextField {
    if (self.contact) {
        self.nameTextField.text = self.contact.name;
        self.surnameTextField.text = self.contact.surname;
        self.phoneTextField.text = self.contact.mainPhoneNumber.phoneNumber;
        self.extraPhoneTextField.text = @"Заглушка, не нажимать";
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

@end
