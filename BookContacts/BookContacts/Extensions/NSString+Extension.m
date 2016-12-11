//
//  NSString+Extension.m
//  BookContacts
//
//  Created by Chausov Alexander on 11/12/16.
//  Copyright © 2016 Chausov Alexander. All rights reserved.
//

#import "NSString+Extension.h"

@implementation NSString (Extension)

- (BOOL)notEmpty {
    return self && self.length > 0;
}

@end
