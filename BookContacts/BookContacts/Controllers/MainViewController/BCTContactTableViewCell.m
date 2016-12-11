//
//  BCTContactTableViewCell.m
//  BookContacts
//
//  Created by Chausov Alexander on 11/12/16.
//  Copyright © 2016 Chausov Alexander. All rights reserved.
//

#import "BCTContactTableViewCell.h"

@interface BCTContactTableViewCell()

@property (nonatomic, strong) IBOutlet UILabel *fullNameLabel;
@property (nonatomic, strong) IBOutlet UILabel *phoneNumberLabel;
@property (nonatomic, strong) IBOutlet UIButton *likedButton;
@property (nonatomic, strong) IBOutlet UIView *separatorView;

@end

@implementation BCTContactTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)configureWithFullName:(NSString *)fullName phone:(NSString *)phone likedFlag:(BOOL)likedFlag {
    self.fullNameLabel.text = fullName;
    self.phoneNumberLabel.text = phone;
    self.likedButton.hidden = !likedFlag;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
