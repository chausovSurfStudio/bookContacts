//
//  BCTContact+CoreDataProperties.h
//  BookContacts
//
//  Created by Chausov Alexander on 11/12/16.
//  Copyright © 2016 Chausov Alexander. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "BCTContact.h"

NS_ASSUME_NONNULL_BEGIN

@interface BCTContact (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *name;
@property (nullable, nonatomic, retain) NSString *surname;
@property (nullable, nonatomic, retain) NSNumber *liked;
@property (nullable, nonatomic, retain) NSManagedObject *mainPhoneNumber;
@property (nullable, nonatomic, retain) NSSet<NSManagedObject *> *addedPhoneNumbers;

@end

@interface BCTContact (CoreDataGeneratedAccessors)

- (void)addAddedPhoneNumbersObject:(NSManagedObject *)value;
- (void)removeAddedPhoneNumbersObject:(NSManagedObject *)value;
- (void)addAddedPhoneNumbers:(NSSet<NSManagedObject *> *)values;
- (void)removeAddedPhoneNumbers:(NSSet<NSManagedObject *> *)values;

@end

NS_ASSUME_NONNULL_END
