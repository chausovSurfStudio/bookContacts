//
//  BookContactsTests.m
//  BookContactsTests
//
//  Created by Chausov Alexander on 27/11/16.
//  Copyright © 2016 Chausov Alexander. All rights reserved.
//
//  Тесты на валидатор

#import <XCTest/XCTest.h>
#import "BCTValidator.h"

@interface BookContactsTests : XCTestCase

@end

@implementation BookContactsTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

#pragma mark - Contact name
- (void)testName01 {
    // Тест с корректным именем контакта
    NSString *name = @"Qwerty";
    XCTAssertTrue([[BCTValidator sharedInstance] validateContactName:name]);
}

- (void)testName02 {
    // Имя контакта состоит полностью из пробелов
    NSString *name = @"     ";
    XCTAssertFalse([[BCTValidator sharedInstance] validateContactName:name]);
}

- (void)testName03 {
    // Имя контакта содержит пробелы на концах, должны обрезаться
    NSString *name = @"   Qwerty   ";
    XCTAssertEqual([[BCTValidator sharedInstance] trimmingWhitespaceAndNewlineCharecters:name], @"Qwerty");
}

- (void)testName04 {
    // Некорректное пустое имя контакта
    NSString *name = @"";
    XCTAssertFalse([[BCTValidator sharedInstance] validateContactName:name]);
}

- (void)testName05 {
    // Слишком длинное имя для контакта
    NSString *name = @"Qwertyuiopasdfghjkl";
    XCTAssertFalse([[BCTValidator sharedInstance] validateContactName:name]);
}

#pragma mark - Contact surname
- (void)testSurname01 {
    // Тест с корректной фамилией контакта
    NSString *surname = @"Qwerty";
    XCTAssertTrue([[BCTValidator sharedInstance] validateContactSurname:surname]);
}

- (void)testSurname02 {
    // Фамилия контакта состоит полностью из пробелов
    NSString *surname = @"     ";
    XCTAssertFalse([[BCTValidator sharedInstance] validateContactSurname:surname]);
}

- (void)testSurname03 {
    // Фамилия контакта содержит пробелы на концах, должны обрезаться
    NSString *surname = @"   Qwerty   ";
    XCTAssertEqual([[BCTValidator sharedInstance] trimmingWhitespaceAndNewlineCharecters:surname], @"Qwerty");
}

- (void)testSurname04 {
    // Некорректная пустая фамилия контакта
    NSString *surname = @"";
    XCTAssertFalse([[BCTValidator sharedInstance] validateContactSurname:surname]);
}

- (void)testSurname05 {
    // Слишком длинная фамилия для контакта
    NSString *surname = @"Qwertyuiopasdfghjkl";
    XCTAssertFalse([[BCTValidator sharedInstance] validateContactSurname:surname]);
}

#pragma mark - Phone number
- (void)testPhone01 {
    // Чистый тест, корректный номер телефона
    NSString *phoneNumber = @"+79999999999";
    XCTAssertTrue([[BCTValidator sharedInstance] validatePhoneNumber:phoneNumber]);
}

- (void)testPhone02 {
    // Короткий номер телефона
    NSString *phoneNumber = @"+79";
    XCTAssertFalse([[BCTValidator sharedInstance] validatePhoneNumber:phoneNumber]);
}

- (void)testPhone03 {
    // Длинный номер телефона
    NSString *phoneNumber = @"+799845769834576938457693845";
    XCTAssertFalse([[BCTValidator sharedInstance] validatePhoneNumber:phoneNumber]);
}

- (void)testPhone04 {
    // В номере присутствуют символы, не являющиеся цифрами или знаком "+"
    NSString *phoneNumber = @"+-987654йцуqwe.,";
    XCTAssertFalse([[BCTValidator sharedInstance] validatePhoneNumber:phoneNumber]);
}

@end
