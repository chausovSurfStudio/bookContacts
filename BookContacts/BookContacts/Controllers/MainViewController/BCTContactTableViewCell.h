//
//  BCTContactTableViewCell.h
//  BookContacts
//
//  Created by Chausov Alexander on 11/12/16.
//  Copyright © 2016 Chausov Alexander. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BCTContactTableViewCell : UITableViewCell

- (void)configureWithFullName:(NSString *)fullName phone:(NSString *)phone likedFlag:(BOOL)likedFlag;

@end
