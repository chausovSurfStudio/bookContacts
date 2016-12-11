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
    NSManagedObjectContext *context = [AppDelegate appDelegate].managedObjectContext;
    NSFetchRequest *fetch = [[NSFetchRequest alloc] init];
    [fetch setEntity:[NSEntityDescription entityForName:@"BCTContact" inManagedObjectContext:context]];
    NSArray <BCTContact *> *result = [context executeFetchRequest:fetch error:nil];
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
    NSArray *sortedResult = [result sortedArrayUsingDescriptors:@[sortDescriptor]];
    return sortedResult;
}

@end
