//
//  SPManager.m
//  PizzaSparta
//
//  Created by Petar Kanev on 6/5/15.
//  Copyright (c) 2015 MentorMate Academy. All rights reserved.
//

#import "SPManager.h"
#import "Product+Modify.h"
#import "SPUIHeader.h"
#import "Account.h"
#import "Product+Modify.h"
#import "SPDatabaseManager.h"
#import "SPCustomPizza.h"
#import "SPAppDelegate.h"

@implementation SPManager

+ (instancetype) sharedManager{
    static SPManager *sharedManager = nil;
    @synchronized(self){
        if (sharedManager == nil) {
            sharedManager = [[self alloc] init];
            
        }
    }
    return sharedManager;
}

- (instancetype) init {
    self = [super init];
    if (self) {
        _cart = [[NSMutableArray alloc] init];
        _loggedUser=[[User alloc] init];
        _isUserLogIn = NO;
        _doesUserExist= NO;
        _uiOperationQueue = [NSOperationQueue new];
    }
    return self;
}

#pragma mark - logged in accounts
- (void) saveLoggedUserForAutologin{
    [self clearLoggedAccounts];
    NSManagedObjectContext *context = [self privateChildMOContext];
    Account *acc = [NSEntityDescription insertNewObjectForEntityForName: @"Account" inManagedObjectContext: context];
    [acc setUsername: self.loggedUser.username];
    [acc setPassword: self.loggedUser.password];
    [context save: NULL];
    [self saveParentContextToStore];
}

- (BOOL) hasAccountBeenStoredForAutologIn{
    NSFetchRequest* request = [NSFetchRequest fetchRequestWithEntityName: @"Account"];
    NSManagedObjectContext *context = [[SPManager sharedManager] privateChildMOContext];
    NSArray *matches = [context executeFetchRequest: request error: NULL];
    if ([matches count] == 0) {
        return NO;
    }else
        return YES;
}

- (void) clearLoggedAccounts{
    NSFetchRequest* request = [NSFetchRequest fetchRequestWithEntityName: @"Account"];
    NSManagedObjectContext *context = [[SPManager sharedManager] privateChildMOContext];
    NSArray *matches = [context executeFetchRequest: request error: NULL];
    
    for (Account *acc in matches)
        [context deleteObject: acc];
    
    [context save: NULL];
    [self saveParentContextToStore];
}

- (NSString *) storedAccUsername{
    if ([self hasAccountBeenStoredForAutologIn]) {
        NSFetchRequest* request = [NSFetchRequest fetchRequestWithEntityName: @"Account"];
        NSManagedObjectContext *context = [[SPManager sharedManager] privateChildMOContext];
        NSArray *matches = [context executeFetchRequest: request error: NULL];
        
        return [matches[0] username];
    }
    return NULL;
}

- (NSString *) storedAccPassword{
    if ([self hasAccountBeenStoredForAutologIn]) {
        NSFetchRequest* request = [NSFetchRequest fetchRequestWithEntityName: @"Account"];
        NSManagedObjectContext *context = [[SPManager sharedManager] privateChildMOContext];
        NSArray *matches = [context executeFetchRequest: request error: NULL];
        return [matches[0] password];
    }
    return NULL;
}


#pragma mark - cart
- (void) addProductToCart:(NSMutableDictionary *) product{
    
    for (int i = 0; i < [self.cart count]; i++){
        
        NSMutableDictionary *dict = self.cart[i];
        if ( [[dict valueForKey: @"Product"] productID] == [[product valueForKey: @"Product"] productID] ) {
            
            if ( [[dict valueForKey: @"Size"] isEqualToString: [product valueForKey: @"Size"]] ) {
                
                NSInteger amount =
                [[dict valueForKey: @"Amount"] longValue] + [[product valueForKey: @"Amount"] longValue];
                
                if (amount < 1) {
                    [self.cart removeObjectAtIndex: i];
                }else
                    [dict setValue: @(amount) forKey: @"Amount"];
                return;
            }
            return;
        }
    }
    [self.cart addObject: product];
}

- (NSInteger) amountForProductInCart:(Product *) product withSize:(NSString *) size{
    for (NSMutableDictionary *dict in self.cart) {
        
        if ([[dict valueForKey: @"Product"] productID] == [product productID] &&
            [[dict valueForKey: @"Size"] isEqualToString: size]) {
            
            return [[dict valueForKey: @"Amount"] longValue];
        }
    }
    return 0;
}

#pragma mark - Core Data stack
@synthesize privateParentMOContext      = _privateParentMOContext;
@synthesize mainUIMOContext             = _mainUIMOContext;
@synthesize managedObjectModel          = _managedObjectModel;
@synthesize persistentStoreCoordinator  = _persistentStoreCoordinator;

- (NSURL *)applicationDocumentsDirectory {
    // The directory the application uses to store the Core Data store file. This code uses a directory named "MentorMateAcademy.PizzaSparta" in the application's documents directory.
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectModel *)managedObjectModel {
    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"PizzaSparta" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    // The persistent store coordinator for the application. This implementation creates and return a coordinator, having added the store for the application to it.
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    // Create the coordinator and store
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"PizzaSparta.sqlite"];
    NSError *error = nil;
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        // Report any error we got.
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
    }
    return _persistentStoreCoordinator;
}

#pragma mark - ManagedObjectContexts getters
- (NSManagedObjectContext *)privateParentMOContext {
    if (_privateParentMOContext != nil) {
        return _privateParentMOContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        return nil;
    }
    
    _privateParentMOContext = [[NSManagedObjectContext alloc]
                               initWithConcurrencyType:NSPrivateQueueConcurrencyType];
    
    [_privateParentMOContext setPersistentStoreCoordinator:coordinator];
    return _privateParentMOContext;
}

-(NSManagedObjectContext *)mainUIMOContext{
    if (_mainUIMOContext) {
        return _mainUIMOContext;
    }
    _mainUIMOContext = [[NSManagedObjectContext alloc]
                        initWithConcurrencyType:NSMainQueueConcurrencyType];
    
    [_mainUIMOContext setParentContext:[self privateParentMOContext]];
    return _mainUIMOContext;
}

-(NSManagedObjectContext *)privateChildMOContext{
      NSManagedObjectContext  *privateChildMOContext = [[NSManagedObjectContext alloc]
                              initWithConcurrencyType:NSPrivateQueueConcurrencyType];
    
    [privateChildMOContext setParentContext:[self mainUIMOContext]];
    return privateChildMOContext;
}

#pragma mark - Core Data Saving support
- (void)saveParentContextToStore {
    
    NSManagedObjectContext *managedObjectContext = self.privateParentMOContext;
    if (managedObjectContext != nil) {
        NSError *error = nil;
        [self.privateChildMOContext save:&error];
        [self.mainUIMOContext save:&error];
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        }
    }
}

#pragma mark - Set up menu
- (void) updateMenu{
    [[SPDatabaseManager sharedDatabaseManager] getAllProductsFromDataBase];
}

-(void)readUserAddresses{
    if((self.loggedUser != nil) && (self.isUserLogIn == YES)){
        [[SPDatabaseManager sharedDatabaseManager] readAllAddressesForLoggedUserWithCompletion:^(NSArray* array){
            if(array){
                [self.loggedUser readAllAddresses:array];
            }
            else{
                NSLog(@"error reading addresses");
            }
        }];
    }
}

-(void)logOutUser{
    if(self.isUserLogIn) {
        [self clearLoggedAccounts];
        [self setLoggedUser:nil];
        [self setIsUserLogIn:NO];
        [self.cart removeAllObjects];
    }
}

-(NSArray*)getUserInfoAsArray{
    return @[[self.loggedUser username], [self.loggedUser name],@"Addresses"];
}

-(void)addForCurrentUserNewAddress:(NSString*)newAddress{
    if((self.loggedUser != nil) && (self.isUserLogIn == YES)){
        [[SPDatabaseManager sharedDatabaseManager] insertNewAddressForLoggedUserAndNewAddress:newAddress WithInsertCompletion:^(NSArray* array){
            if(array){
                [self.loggedUser readAllAddresses:array];
            }
            else{
                NSLog(@"error reading new address");
            }
        }];
    }
}

-(void)deleteForCurrentUserAddress:(UserAdress*)address completion:(SPManagerSuccessBlock)completion{
    if((self.loggedUser != nil) && (self.isUserLogIn == YES)){
        [[SPDatabaseManager sharedDatabaseManager] deleteAddressForLoggedUserAndNewAddress:address WithDeleteCompletion:^(NSArray* array){
            if(array){
                [self.loggedUser readAllAddresses:array];
                completion(@"success");
            }
            else{
                completion(@"error");
            }
        }];
    }
}

- (float) cartTotal{
    CGFloat total = 0;
    
    for (NSMutableDictionary *dict in self.cart) {
        if([[dict valueForKey: @"Product"] isKindOfClass:[Product class]]){
            Product *currentProduct = [dict valueForKey: @"Product"];
            total = total + [currentProduct.price floatValue];
            if ([[dict valueForKey: @"Size"] isEqualToString: @"Medium"]) {
                total -= 3.0f;
            }
        }
        else{
            SPCustomPizza *currentProduct = [dict valueForKey: @"Product"];
            total = total + currentProduct.price ;
            if ([[dict valueForKey: @"Size"] isEqualToString: @"Medium"]) {
                total -= 3.0f;
            }

        }
    }
    return total;
}
-(void)checkOrderStatusDoesChange{
    [self getAllOrdersForUser];
    [NSTimer scheduledTimerWithTimeInterval:5.0f
                                     target:self selector:@selector(checkOrderStatus) userInfo:nil repeats:YES];
}

-(void)checkOrderStatus{
    if([[self.loggedUser orders] count] > 0){
        for(UserOrders * element in [self.loggedUser orders]){
            if(element.isDelivered == 0){
                [[SPDatabaseManager sharedDatabaseManager] getOrderWithId:[element orderId] WithCompletion:^(NSDictionary* dict){
                    if(dict){
                        if([[dict  valueForKey:@"isDelivered"] isEqualToString:@"2"]){
                            [element setIsDelivered:2];
                            NSLog(@"%@ element - %ld",[dict  valueForKey:@"isDelivered"], [element isDelivered]);
                            
                            [self addNotification:[NSString stringWithFormat:@"%@ - out for delivery", [element dateOrder]]];
                        }
                        else if([[dict  valueForKey:@"isDelivered"] isEqualToString:@"1"]){
                            [element setIsDelivered:1];
                             NSLog(@"%@ element - %ld",[dict  valueForKey:@"isDelivered"], [element isDelivered]);
                            [self addNotification:[NSString stringWithFormat:@"%@ - delivered", [element dateOrder]]];
                        }
                    }
                    else{
                        NSLog(@"error notification no to go");
                    }
                }];
            }
            else if(element.isDelivered == 2){
                [[SPDatabaseManager sharedDatabaseManager] getOrderWithId:[element orderId] WithCompletion:^(NSDictionary* dict){
                    if(dict){
                        if([[dict valueForKey:@"isDelivered"] isEqualToString:@"1"]){
                            [element setIsDelivered:1];
                            [self addNotification:[NSString stringWithFormat:@"%@ - delivered", [element dateOrder]]];
                            
                             NSLog(@"%@ element - %ld",[dict  valueForKey:@"isDelivered"], [element isDelivered]);
                        }
                    }
                    else{
                        NSLog(@"error notification not delivered");
                    }
                }];
            }
        }
        
    }
}

-(void)addNotification:(NSString*)text{
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    
    UILocalNotification *localNotification = [[UILocalNotification alloc] init];
    
    NSDate *now = [NSDate date];
    
    
    localNotification.fireDate = now;
    localNotification.alertBody = text;
    localNotification.soundName = UILocalNotificationDefaultSoundName;
    localNotification.applicationIconBadgeNumber = 1;
    
    
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
    
}

-(void)getAllOrdersForUser{
    
    [[SPDatabaseManager sharedDatabaseManager]
     allOrdersWithType:ORDER_TYPE_ALL
     completion:^(NSArray* array){
         
         if(array){
             [[[SPManager sharedManager] loggedUser] readAllOrders:array];
         }else{
             NSLog(@"not found");
         }
     }];
}

@end
