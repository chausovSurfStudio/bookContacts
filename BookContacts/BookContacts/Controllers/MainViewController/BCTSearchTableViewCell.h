//
//  BCTSearchTableViewCell.h
//  BookContacts
//
//  Created by Chausov Alexander on 11/12/16.
//  Copyright © 2016 Chausov Alexander. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BCTSearchTableViewCellDelegate <NSObject>

- (void)likedButtonDidPress;

@end

@interface BCTSearchTableViewCell : UITableViewCell

@property (nonatomic, weak) id<BCTSearchTableViewCellDelegate> cellDelegate;

@end
