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

/** Проверяет имя контакта на корректность, возвращает корректное имя контакта или nil, если входная строка невалидна */
- (NSString *)validateContactName:(NSString *)name;

/** Проверяет фамилию контакта на корректность, возвращает корректную фамилию контакта или nil, если входная строка невалидна */
- (NSString *)validateContactSurname:(NSString *)surname;

/** Проверяет номер контакта на корректность, возвращает корректный номер или nil, если входная строка невалидна */
- (NSString *)validatePhoneNumber:(NSString *)phoneNumber;

@end
