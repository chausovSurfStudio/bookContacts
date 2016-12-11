//
//  BCTPhoneNumber+CoreDataProperties.h
//  BookContacts
//
//  Created by Chausov Alexander on 11/12/16.
//  Copyright © 2016 Chausov Alexander. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "BCTPhoneNumber.h"

NS_ASSUME_NONNULL_BEGIN

@interface BCTPhoneNumber (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *phoneNumber;
@property (nullable, nonatomic, retain) BCTContact *mainContact;
@property (nullable, nonatomic, retain) BCTContact *contact;

@end

NS_ASSUME_NONNULL_END
