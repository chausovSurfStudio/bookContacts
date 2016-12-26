//
//  BCTValidator.m
//  BookContacts
//
//  Created by Chausov Alexander on 27/11/16.
//  Copyright © 2016 Chausov Alexander. All rights reserved.
//

#import "BCTValidator.h"

static NSUInteger const nameMinLength = 1;
static NSUInteger const nameMaxLength = 15;
static NSUInteger const surnameMinLength = 3;
static NSUInteger const surnameMaxLength = 20;
static NSUInteger const phoneMinLength = 5;
static NSUInteger const phoneMaxLength = 12;

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
    NSString *trimmingName = [BCTValidator trimmingWhitespaceAndNewlineCharecters:name];
    if (trimmingName.length < nameMinLength || trimmingName.length > nameMaxLength) {
        return nil;
    }
    return trimmingName;
}

/** Проверяет фамилию контакта на корректность, возвращает корректную фамилию контакта или nil, если входная строка невалидна */
- (NSString *)validateContactSurname:(NSString *)surname {
    NSString *trimmingSurname = [BCTValidator trimmingWhitespaceAndNewlineCharecters:surname];
    if (trimmingSurname.length < surnameMinLength || trimmingSurname.length > surnameMaxLength) {
        return nil;
    }
    return trimmingSurname;
}

/** Проверяет номер контакта на корректность, возвращает корректный номер или nil, если входная строка невалидна */
- (NSString *)validatePhoneNumber:(NSString *)phoneNumber {
    NSString *tempString = [phoneNumber copy];
    if (tempString.length < phoneMinLength || tempString.length > phoneMaxLength) {
        // не прошел на проверку по длинне
        return nil;
    }
    NSInteger plusCount = [[tempString componentsSeparatedByString:@"+"] count] - 1;
    if (plusCount > 1) {
        // слишком много символов "+"
        return nil;
    }
    if ([tempString rangeOfString:@"+"].location != 0 && [tempString rangeOfString:@"+"].location != NSNotFound) {
        // "+" не на первом месте в строке
        return nil;
    }
    tempString = [tempString stringByReplacingOccurrencesOfString:@"+" withString:@""];
    tempString = [[tempString componentsSeparatedByCharactersInSet:[NSCharacterSet decimalDigitCharacterSet]] componentsJoinedByString:@""];
    if (tempString.length > 0) {
        // есть что-то, кроме цифр и "+"
        return nil;
    }
    return phoneNumber;
}

/** Обрезает символы переноса строки и пробелы с обоих концов строки */
+ (NSString *)trimmingWhitespaceAndNewlineCharecters:(NSString *)string {
    return [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

@end
