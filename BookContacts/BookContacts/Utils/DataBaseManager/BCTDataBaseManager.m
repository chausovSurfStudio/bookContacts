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
        
        if ([addedPhoneNumber notEmpty]) {
            contact.addedPhoneNumber = addedPhoneNumber;
        }
        [localContext MR_saveToPersistentStoreAndWait];
    } completion:^(BOOL contextDidSave, NSError * _Nullable error) {
        completion(error ? NO : YES);
    }];
}

- (BOOL)checkOnUniquePhoneNumber:(NSString *)phoneNumber {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.mainPhoneNumber == %@ AND SELF.addedPhoneNumber == %@", phoneNumber, phoneNumber];
    NSArray *phones = [BCTContact MR_findAllWithPredicate:predicate];
    return phones.count > 0 ? NO : YES;
}

@end
