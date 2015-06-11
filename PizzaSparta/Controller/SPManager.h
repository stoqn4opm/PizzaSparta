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
#import "User.h"


@interface SPManager : NSObject
@property (readonly, strong, nonatomic) NSManagedObjectContext *privateParentMOContext;
@property (readonly, strong, nonatomic) NSManagedObjectContext *mainUIMOContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (strong, nonatomic) Customer* loggedCustomer;
@property (strong, nonatomic) NSMutableDictionary* cart;
@property (strong, nonatomic) User* loggedUser;
@property(nonatomic)BOOL isUserLogIn;
@property(nonatomic)BOOL doesUserExist;

+ (instancetype) sharedManager;
- (NSManagedObjectContext *) privateChildMOContext;
- (void) saveParentContextToStore;

- (void) storeLoggedInCustomerWithName: (NSString *) name andPassword: (NSString *) password;

- (void) setUpMenu;

@end

//#import <Foundation/foundation.h>
//
//@interface SPServerAPI : NSObject
//
//
//// this method will return Menu updates when invoked
//// formed as dictionary from the incoming server JSON
//+ (NSDictionary *)menuUpdate;
//
//// method for placing orders to user
//// returns YES if order is placed successfully
//// returns NO in case of error
//+ (BOOL)placeOrderForUser:(NSString *)user
//             withProducts:(NSArray *)products
//           customProducts:(NSArray *)customProducts
//                   adress:(NSString *)address;
//
//
//// method that checks if such a user with that password exist in the database
//+ (BOOL)checkIfSuchUserExistInDataBase:(NSString *)userName
//                          withPassword:(NSString *)password;
//
//// method returns dictionary with user details formed like this
////{
////    @"userName": @"username1"
////    @"password": @"password123"
////    @"previousOrders": [@"order1", @"order2",...]
////    @"adresses":[@"address1", @"address2",...]
////}
//// returns nil if user not logged in
//+ (NSDictionary *)loggedUserDetails;
//
//// this method register user and automatically log him in
//// so that loggedUserDetails gives corresponding info when invoked
//+ (BOOL)registerUserWithUserName:(NSString *)userName
//                        password:(NSString *)password
//                            name:(NSString *)name
//                        adresses:(NSArray *) addresses;
//
//// method for adding/removing address to user ********
//+ (BOOL)addAdress:(NSString) address
//           toUser:(NSString *)userName;
//
//+ (BOOL)removeAddress:(NSString *)address
//             fromUser:(NSString *)userName;
//// end methods for adding/removing address to user ***
//@end