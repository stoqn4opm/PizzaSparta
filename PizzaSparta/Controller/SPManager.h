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
/* property cart is a dictionary of following type:
 {
    Product:[Product1, Product2...]
    Amount :[ number_representing_amount_for_product1,number_representing_amount_for_product2...]
 }
 both keys are arrays so when you want the i-th product and its ammount you get it like this:
    
    [cart ObjectForKey:@"Product"][i] - thats the i-th product of type Product in cart
    [cart ObjectForKey:@"Amount"][i]  - thats the ammount in cart for i-th product
 */
@property (readonly, strong, nonatomic) NSMutableDictionary* cart;
- (void) addProductToCart:(Product *) product amount:(NSInteger) count;

- (void) saveParentContextToStore;

- (void) updateMenu;

@end