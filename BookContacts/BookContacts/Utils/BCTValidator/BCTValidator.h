//
//  BCTValidator.h
//  BookContacts
//
//  Created by Chausov Alexander on 27/11/16.
//  Copyright © 2016 Chausov Alexander. All rights reserved.
//
//  Класс-синглтон, который принимает на вход данные и выносит решение о том, корректные они или нет

#import <Foundation/Foundation.h>

@interface BCTValidator : NSObject

+ (instancetype)sharedInstance;

/** Проверяет на вход строку с именем контакта, возвращает YES, если она корректная, NO в противном случае */
- (BOOL)validateContactName:(NSString *)name;

/** Проверяет на вход строку с фамилией контакта, возвращает YES, если она корректная, NO в противном случае */
- (BOOL)validateContactSurname:(NSString *)surname;

/** Проверяет на вход строку с номером телефона контакта, возвращает YES, если она корректная, NO в противном случае */
- (BOOL)validatePhoneNumber:(NSString *)phoneNumber;

/** Обрезает символы переноса строки и пробелы с обоих концов строки */
- (NSString *)trimmingWhitespaceAndNewlineCharecters:(NSString *)string;

@end
