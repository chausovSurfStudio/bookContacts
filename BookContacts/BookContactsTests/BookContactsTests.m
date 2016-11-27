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
    XCTAssertNotNil([[BCTValidator sharedInstance] validateContactName:name]);
}

- (void)testName02 {
    // Имя контакта состоит полностью из пробелов
    NSString *name = @"     ";
    XCTAssertNil([[BCTValidator sharedInstance] validateContactName:name]);
}

- (void)testName03 {
    // Имя контакта содержит пробелы на концах, должны обрезаться
    NSString *name = @"   Qwerty   ";
    XCTAssertEqual([[BCTValidator sharedInstance] validateContactName:name], @"Qwerty");
}

- (void)testName04 {
    // Некорректное пустое имя контакта
    NSString *name = @"";
    XCTAssertNil([[BCTValidator sharedInstance] validateContactName:name]);
}

- (void)testName05 {
    // Слишком длинное имя для контакта
    NSString *name = @"Qwertyuiopasdfghjkl";
    XCTAssertNil([[BCTValidator sharedInstance] validateContactName:name]);
}

#pragma mark - Contact surname
- (void)testSurname01 {
    // Тест с корректной фамилией контакта
    NSString *surname = @"Qwerty";
    XCTAssertNotNil([[BCTValidator sharedInstance] validateContactSurname:surname]);
}

- (void)testSurname02 {
    // Фамилия контакта состоит полностью из пробелов
    NSString *surname = @"     ";
    XCTAssertNil([[BCTValidator sharedInstance] validateContactSurname:surname]);
}

- (void)testSurname03 {
    // Фамилия контакта содержит пробелы на концах, должны обрезаться
    NSString *surname = @"   Qwerty   ";
    XCTAssertEqual([[BCTValidator sharedInstance] validateContactSurname:surname], @"Qwerty");
}

- (void)testSurname04 {
    // Некорректная пустая фамилия контакта
    NSString *surname = @"";
    XCTAssertNil([[BCTValidator sharedInstance] validateContactSurname:surname]);
}

- (void)testSurname05 {
    // Слишком длинная фамилия для контакта
    NSString *surname = @"Qwertyuiopasdfghjkl";
    XCTAssertNil([[BCTValidator sharedInstance] validateContactSurname:surname]);
}

#pragma mark - Phone number
- (void)testPhone01 {
    // Чистый тест, корректный номер телефона
    NSString *phoneNumber = @"+79999999999";
    XCTAssertNotNil([[BCTValidator sharedInstance] validatePhoneNumber:phoneNumber]);
}

- (void)testPhone02 {
    // Короткий номер телефона
    NSString *phoneNumber = @"+79";
    XCTAssertNil([[BCTValidator sharedInstance] validatePhoneNumber:phoneNumber]);
}

- (void)testPhone03 {
    // Длинный номер телефона
    NSString *phoneNumber = @"+799845769834576938457693845";
    XCTAssertNil([[BCTValidator sharedInstance] validatePhoneNumber:phoneNumber]);
}

- (void)testPhone04 {
    // В номере присутствуют символы, не являющиеся цифрами или знаком "+"
    NSString *phoneNumber = @"+-987654йцуqwe.,";
    XCTAssertNil([[BCTValidator sharedInstance] validatePhoneNumber:phoneNumber]);
}

@end
