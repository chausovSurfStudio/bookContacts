//
//  BCTDataBaseManager.h
//  BookContacts
//
//  Created by Chausov Alexander on 11/12/16.
//  Copyright © 2016 Chausov Alexander. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BCTContact;

@interface BCTDataBaseManager : NSObject

+ (instancetype)sharedInstance;

- (NSArray <BCTContact *> *)findAndSortAllContacts;

- (void)createContactWithName:(NSString *)name
                      surname:(NSString *)surname
              mainPhoneNumber:(NSString *)mainPhoneNumber
             addedPhoneNumber:(NSString *)addedPhoneNumber
                    likedFlag:(BOOL)likedFlag
                   completion:(void(^)(BOOL success))completion;

- (void)editContact:(BCTContact *)contact
           withName:(NSString *)name
            surname:(NSString *)surname
    mainPhoneNumber:(NSString *)mainPhoneNumber
   addedPhoneNumber:(NSString *)addedPhoneNumber
          likedFlag:(BOOL)likedFlag
         completion:(void(^)(BOOL success))completion;

- (BOOL)checkOnUniquePhoneNumber:(NSString *)phoneNumber;

- (BOOL)checkOnUniquePhoneNumber:(NSString *)phoneNumber fromContact:(BCTContact *)contact;

@end
