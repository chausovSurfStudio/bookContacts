//
//  BCTDataBaseManager.m
//  BookContacts
//
//  Created by Chausov Alexander on 11/12/16.
//  Copyright © 2016 Chausov Alexander. All rights reserved.
//

#import "BCTDataBaseManager.h"
#import <MagicalRecord/MagicalRecord.h>
#import "AppDelegate.h"

#import "BCTContact.h"

#import "NSString+Extension.h"

@implementation BCTDataBaseManager

+ (instancetype)sharedInstance {
    static id sharedInstance = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[[self class] alloc] init];
    });
    
    return sharedInstance;
}

- (NSArray <BCTContact *> *)findAndSortAllContacts {
    NSArray *allContacts = [BCTContact MR_findAll];
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
    NSArray *sortedContacts = [allContacts sortedArrayUsingDescriptors:@[sortDescriptor]];
    return sortedContacts;
}

- (void)createContactWithName:(NSString *)name
                      surname:(NSString *)surname
              mainPhoneNumber:(NSString *)mainPhoneNumber
             addedPhoneNumber:(NSString *)addedPhoneNumber
                    likedFlag:(BOOL)likedFlag
                   completion:(void(^)(BOOL success))completion {
    if (![name notEmpty] || ![mainPhoneNumber notEmpty]) {
        // сущность контакта не может быть создана без обязательных полей
        return;
    }
    [MagicalRecord saveWithBlock:^(NSManagedObjectContext * _Nonnull localContext) {
        BCTContact *contact = [BCTContact MR_createEntityInContext:localContext];
        contact.name = name;
        contact.surname = surname;
        contact.liked = [NSNumber numberWithBool:likedFlag];
        contact.mainPhoneNumber = mainPhoneNumber;
        contact.addedPhoneNumber = addedPhoneNumber;
        [localContext MR_saveToPersistentStoreAndWait];
    } completion:^(BOOL contextDidSave, NSError * _Nullable error) {
        completion(error ? NO : YES);
    }];
}

- (void)editContact:(BCTContact *)contact
           withName:(NSString *)name
            surname:(NSString *)surname
    mainPhoneNumber:(NSString *)mainPhoneNumber
   addedPhoneNumber:(NSString *)addedPhoneNumber
          likedFlag:(BOOL)likedFlag
         completion:(void(^)(BOOL success))completion {
    if (![name notEmpty] || ![mainPhoneNumber notEmpty]) {
        // сущность контакта не может быть создана без обязательных полей
        return;
    }
    contact.name = name;
    contact.surname = surname;
    contact.liked = [NSNumber numberWithBool:likedFlag];
    contact.mainPhoneNumber = mainPhoneNumber;
    contact.addedPhoneNumber = addedPhoneNumber;
    completion(YES);
}

- (BOOL)checkOnUniquePhoneNumber:(NSString *)phoneNumber {
    if (phoneNumber.length == 0) {
        return YES;
    }
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.mainPhoneNumber == %@ OR SELF.addedPhoneNumber == %@", phoneNumber, phoneNumber];
    NSArray *contacts = [BCTContact MR_findAllWithPredicate:predicate];
    return contacts.count > 0 ? NO : YES;
}

- (BOOL)checkOnUniquePhoneNumber:(NSString *)phoneNumber fromContact:(BCTContact *)contact {
    if (phoneNumber.length == 0) {
        return YES;
    }
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.mainPhoneNumber == %@ OR SELF.addedPhoneNumber == %@", phoneNumber, phoneNumber];
    NSArray *contacts = [BCTContact MR_findAllWithPredicate:predicate];
    if (contacts.count > 2) {
        // если найдено больше 2х контактов - мы ввели не уникальный номер (невозможный в теории случай)
        return NO;
    } else if (contacts.count == 1) {
        // если найден только один контакт - он должен совпадать с переданным contact для уникальности
        if (![[contacts firstObject] isEqual:contacts]) {
            return NO;
        } else {
            return YES;
        }
    }
    return YES;
}

- (void)deleteContactFromDB:(BCTContact *)contact {
    [contact MR_deleteEntity];
    [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
}

@end
