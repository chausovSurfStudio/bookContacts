//
//  BCTContactTableViewCell.m
//  BookContacts
//
//  Created by Chausov Alexander on 11/12/16.
//  Copyright © 2016 Chausov Alexander. All rights reserved.
//

#import "BCTContactTableViewCell.h"
#import "BCTThemeConstant.h"

@interface BCTContactTableViewCell()

@property (nonatomic, strong) IBOutlet UILabel *fullNameLabel;
@property (nonatomic, strong) IBOutlet UILabel *phoneNumberLabel;
@property (nonatomic, strong) IBOutlet UIButton *likedButton;
@property (nonatomic, strong) IBOutlet UIView *separatorView;

@end

@implementation BCTContactTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.contentView.backgroundColor = mainBackgroundThemeNrmColor;
    self.fullNameLabel.textColor = extraTextNrmColor;
    self.phoneNumberLabel.textColor = mainTextNrmColor;
    self.separatorView.backgroundColor = separatorColor;
}

- (void)configureWithFullName:(NSString *)fullName phone:(NSString *)phone likedFlag:(BOOL)likedFlag {
    self.fullNameLabel.text = fullName;
    self.phoneNumberLabel.text = phone;
    self.likedButton.hidden = !likedFlag;
    
    self.leftButtons = @[[MGSwipeButton buttonWithTitle:@"Удалить" icon:nil backgroundColor:[UIColor redColor]]];
    self.leftSwipeSettings.transition = MGSwipeTransition3D;
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
    self.contentView.backgroundColor = highlighted ? mainBackgroundThemePrsColor : mainBackgroundThemeNrmColor;
    self.fullNameLabel.textColor = highlighted ? extraTextPrsColor : extraTextNrmColor;
    self.phoneNumberLabel.textColor = highlighted ? mainTextPrsColor : mainTextNrmColor;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    self.contentView.backgroundColor = selected ? mainBackgroundThemePrsColor : mainBackgroundThemeNrmColor;
    self.fullNameLabel.textColor = selected ? extraTextPrsColor : extraTextNrmColor;
    self.phoneNumberLabel.textColor = selected ? mainTextPrsColor : mainTextNrmColor;
}

@end
