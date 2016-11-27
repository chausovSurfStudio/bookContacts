//
//  BCTValidator.m
//  BookContacts
//
//  Created by Chausov Alexander on 27/11/16.
//  Copyright © 2016 Chausov Alexander. All rights reserved.
//

#import "BCTValidator.h"

@implementation BCTValidator

+ (instancetype)sharedInstance {
    static id sharedInstance = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[[self class] alloc] init];
    });
    
    return sharedInstance;
}

/** Проверяет на вход строку с именем контакта, возвращает YES, если она корректная, NO в противном случае */
- (BOOL)validateContactName:(NSString *)name {
    return NO;
}

/** Проверяет на вход строку с фамилией контакта, возвращает YES, если она корректная, NO в противном случае */
- (BOOL)validateContactSurname:(NSString *)surname {
    return NO;
}

/** Проверяет на вход строку с номером телефона контакта, возвращает YES, если она корректная, NO в противном случае */
- (BOOL)validatePhoneNumber:(NSString *)phoneNumber {
    return NO;
}

/** Обрезает символы переноса строки и пробелы с обоих концов строки */
- (NSString *)trimmingWhitespaceAndNewlineCharecters:(NSString *)string {
    return string;
}

@end
