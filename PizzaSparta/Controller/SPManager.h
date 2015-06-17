//
//  SPManager.h
//  PizzaSparta
//
//  Created by Petar Kanev on 6/5/15.
//  Copyright (c) 2015 MentorMate Academy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "User.h"
#import "Product.h"


@interface SPManager : NSObject
@property (readonly, strong, nonatomic) NSManagedObjectContext *privateParentMOContext;
@property (readonly, strong, nonatomic) NSManagedObjectContext *mainUIMOContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

<<<<<<< HEAD
@property (strong, nonatomic) NSMutableArray* cart;
=======
//@property (strong, nonatomic) NSMutableDictionary* cart;
@property (strong, nonatomic) NSMutableArray *cart;

>>>>>>> 0e06416e54224da1778222462514e1cc2307a363
@property (strong, nonatomic) User* loggedUser;
@property(nonatomic)BOOL isUserLogIn;
@property(nonatomic)BOOL doesUserExist;
@property(nonatomic)BOOL autoLoginEnabled;

+ (instancetype) sharedManager;

- (NSManagedObjectContext *) privateChildMOContext;

//makes an account from user and stores it in CoreData
- (void) saveUserAccount: (User *) user;
- (BOOL) hasAccountBeenLoggedIn;
- (void) clearLoggedAccounts;
- (NSString *) storedAccUsername;
- (NSString *) storedAccPassword;

//cart
- (void) addProductToCart:(NSMutableDictionary *) product;

- (void) saveParentContextToStore;

- (void) updateMenu;

@end