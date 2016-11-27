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

/** Проверяет имя контакта на корректность, возвращает корректное имя контакта или nil, если входная строка невалидна */
- (NSString *)validateContactName:(NSString *)name {
    return nil;
}

/** Проверяет фамилию контакта на корректность, возвращает корректную фамилию контакта или nil, если входная строка невалидна */
- (NSString *)validateContactSurname:(NSString *)surname {
    return nil;
}

/** Проверяет номер контакта на корректность, возвращает корректный номер или nil, если входная строка невалидна */
- (NSString *)validatePhoneNumber:(NSString *)phoneNumber {
    return nil;
}

/** Обрезает символы переноса строки и пробелы с обоих концов строки */
- (NSString *)trimmingWhitespaceAndNewlineCharecters:(NSString *)string {
    return string;
}

@end
