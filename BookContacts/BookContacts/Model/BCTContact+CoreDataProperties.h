//
//  BCTContact+CoreDataProperties.h
//  BookContacts
//
//  Created by Chausov Alexander on 26/12/16.
//  Copyright © 2016 Chausov Alexander. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "BCTContact.h"

NS_ASSUME_NONNULL_BEGIN

@interface BCTContact (CoreDataProperties)

@property (nullable, nonatomic, retain) NSNumber *liked;
@property (nullable, nonatomic, retain) NSString *name;
@property (nullable, nonatomic, retain) NSString *surname;
@property (nullable, nonatomic, retain) NSString *mainPhoneNumber;
@property (nullable, nonatomic, retain) NSString *addedPhoneNumber;

@end

NS_ASSUME_NONNULL_END
