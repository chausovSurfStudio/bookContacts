//
//  BCTSearchTableViewCell.m
//  BookContacts
//
//  Created by Chausov Alexander on 11/12/16.
//  Copyright © 2016 Chausov Alexander. All rights reserved.
//

#import "BCTSearchTableViewCell.h"
#import "BCTThemeConstant.h"
#import "UIImage+Additions.h"

@interface BCTSearchTableViewCell()

@property (nonatomic, strong) IBOutlet UITextField *textField;
@property (nonatomic, strong) IBOutlet UIButton *likedButton;
@property (nonatomic, strong) IBOutlet UIView *separatorView;

@end

@implementation BCTSearchTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.contentView.backgroundColor = mainBackgroundThemeNrmColor;
    self.separatorView.backgroundColor = separatorColor;
    [self configureTextFieldStyle];
}

- (void)configureTextFieldStyle {
    NSString *placeholder = @"Поиск контакта";
    NSAttributedString *attributedPlaceholder = [[NSAttributedString alloc] initWithString:placeholder attributes:@{
                                                                                                                    NSFontAttributeName:[UIFont systemFontOfSize:17],
                                                                                                                    NSForegroundColorAttributeName:mainTextNrmColor
                                                                                                                    }];
    self.textField.attributedPlaceholder = attributedPlaceholder;
    self.textField.textColor = mainTextNrmColor;
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:[[UIImage imageNamed:@"ic_clear.png"] imageByApplyingAlpha:0.8] forState:UIControlStateNormal];
    [button setFrame:CGRectMake(0.0f, 0.0f, 20.0f, 20.0f)];
    [button addTarget:self action:@selector(clearTextField) forControlEvents:UIControlEventTouchUpInside];
    self.textField.rightView = button;
    self.textField.rightViewMode = UITextFieldViewModeWhileEditing;
}

- (void)clearTextField {
    self.textField.text = @"";
}

- (IBAction)likedButtonPressed:(UIButton *)sender {
    if ([self.cellDelegate respondsToSelector:@selector(likedButtonDidPress)]) {
        [self.cellDelegate likedButtonDidPress];
    }
}


@end
