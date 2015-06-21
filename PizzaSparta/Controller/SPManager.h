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

typedef void (^SPManagerSuccessBlock)(NSString* status);

@interface SPManager : NSObject
@property (readonly, strong, nonatomic) NSManagedObjectContext       *privateParentMOContext;
@property (readonly, strong, nonatomic) NSManagedObjectContext       *mainUIMOContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel         *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@property (strong, nonatomic) NSMutableArray* cart;

@property (strong, nonatomic) User* loggedUser;
@property (nonatomic)          BOOL isUserLogIn;
@property (nonatomic)          BOOL doesUserExist;

@property (atomic, strong) NSOperationQueue *uiOperationQueue;
+ (instancetype) sharedManager;

@property (NS_NONATOMIC_IOSONLY, readonly, strong) NSManagedObjectContext *privateChildMOContext;

//makes an account from user and stores it in CoreData
- (void) saveLoggedUserForAutologin;
@property (NS_NONATOMIC_IOSONLY, readonly) BOOL hasAccountBeenStoredForAutologIn;
- (void) clearLoggedAccounts;
@property (NS_NONATOMIC_IOSONLY, readonly, copy) NSString *storedAccUsername;
@property (NS_NONATOMIC_IOSONLY, readonly, copy) NSString *storedAccPassword;

//cart
- (void) addProductToCart:(NSMutableDictionary *) product;
- (NSInteger) amountForProductInCart:(Product *) product withSize:(NSString *) size;

- (void) saveParentContextToStore;
- (void) updateMenu;
- (void) readUserAddresses;
- (void) logOutUser;

@property (NS_NONATOMIC_IOSONLY, getter=getUserInfoAsArray, readonly, copy) NSArray *userInfoAsArray;

- (void) addForCurrentUserNewAddress:(NSString*)newAddress;
- (void) deleteForCurrentUserAddress:(UserAdress*)address completion:(SPManagerSuccessBlock)completion;
@end