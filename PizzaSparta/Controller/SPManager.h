//
//  SPManager.h
//  PizzaSparta
//
//  Created by Petar Kanev on 6/5/15.
//  Copyright (c) 2015 MentorMate Academy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "Customer.h"


@interface SPManager : NSObject
@property (readonly, strong, nonatomic) NSManagedObjectContext *privateParentMOContext;
@property (readonly, strong, nonatomic) NSManagedObjectContext *mainUIMOContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (strong, nonatomic) Customer* loggedCustomer;
@property (strong, nonatomic) NSMutableDictionary* cart;

+ (instancetype) sharedManager;
- (NSManagedObjectContext *) privateChildMOContext;

// returns all of the logged in customers
- (NSArray *) loggedInCustomers;

// use this method to log in an already stored customer
- (void) logInCustomerWithUsername: (NSString *) username;

- (void) saveParentContextToStore;

- (void) updateMenu;

@end