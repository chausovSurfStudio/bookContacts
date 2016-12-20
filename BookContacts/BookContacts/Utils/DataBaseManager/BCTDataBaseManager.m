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
#import "BCTPhoneNumber.h"

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
                            likedFlag:(BOOL)likedFlag {
    if (![name notEmpty] || ![mainPhoneNumber notEmpty]) {
        // сущность контакта не может быть создана без обязательных полей
        return;
    }
    [MagicalRecord saveWithBlock:^(NSManagedObjectContext * _Nonnull localContext) {
        BCTContact *contact = [BCTContact MR_createEntityInContext:localContext];
        contact.name = name;
        contact.surname = surname;
        contact.liked = [NSNumber numberWithBool:likedFlag];
        
        BCTPhoneNumber *mainPhoneNumberEntity = [BCTPhoneNumber MR_createEntityInContext:localContext];
        mainPhoneNumberEntity.phoneNumber = mainPhoneNumber;
        contact.mainPhoneNumber = mainPhoneNumberEntity;
        
        if ([addedPhoneNumber notEmpty]) {
            BCTPhoneNumber *addedPhoneNumberEntity = [BCTPhoneNumber MR_createEntityInContext:localContext];
            addedPhoneNumberEntity.phoneNumber = addedPhoneNumber;
            [contact addAddedPhoneNumbersObject:addedPhoneNumberEntity];
        }
        [localContext MR_saveToPersistentStoreAndWait];
    } completion:^(BOOL contextDidSave, NSError * _Nullable error) {
        
    }];
}

- (BOOL)checkOnUniquePhoneNumber:(NSString *)phoneNumber {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"phoneNumber == %@", phoneNumber];
    NSArray *phones = [BCTPhoneNumber MR_findAllWithPredicate:predicate];
    return phones.count > 0 ? NO : YES;
}

@end
