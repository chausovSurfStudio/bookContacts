//
//  BCTContactTableViewCell.h
//  BookContacts
//
//  Created by Chausov Alexander on 11/12/16.
//  Copyright © 2016 Chausov Alexander. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MGSwipeTableCell/MGSwipeTableCell.h>

@interface BCTContactTableViewCell : MGSwipeTableCell

- (void)configureWithFullName:(NSString *)fullName phone:(NSString *)phone likedFlag:(BOOL)likedFlag;

@end
