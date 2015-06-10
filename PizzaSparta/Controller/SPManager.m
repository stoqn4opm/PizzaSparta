//
//  SPManager.m
//  PizzaSparta
//
//  Created by Petar Kanev on 6/5/15.
//  Copyright (c) 2015 MentorMate Academy. All rights reserved.
//

#import "SPManager.h"
#import "Customer+Modify.h"
#import "Product+Modify.h"
#import "SPUIHeader.h"

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
        _cart = [[NSMutableDictionary alloc] init];
        NSMutableArray *emptyArr = [[NSMutableArray alloc] init];
        [_cart setValue: emptyArr forKey: @"Product"];
        [_cart setValue: emptyArr forKey: @"Amount"];
    }
    return self;
}

#pragma mark - logged in customers
- (void) logInCustomerWithUsername: (NSString *) username{
    NSFetchRequest* request = [NSFetchRequest fetchRequestWithEntityName: @"Customer"];
    request.predicate = [NSPredicate predicateWithFormat: @"username = %@", username];
    NSManagedObjectContext *context = [[SPManager sharedManager] privateChildMOContext];
    NSArray *matches = [context executeFetchRequest:request error:NULL];
    self.loggedCustomer = matches[0];
}

- (NSArray *) loggedInCustomers{
    NSFetchRequest* request = [NSFetchRequest fetchRequestWithEntityName: @"Customer"];
    NSManagedObjectContext *context = [[SPManager sharedManager] privateChildMOContext];
    return [context executeFetchRequest:request error:NULL];
}

#pragma mark - Core Data stack
@synthesize privateParentMOContext = _privateParentMOContext;
@synthesize mainUIMOContext = _mainUIMOContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

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
        // Replace this with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
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
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate.
            // You should not use this function in a shipping application,
            // although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}



#pragma mark - Set up menu

- (void) updateMenu{
    Product *pr1 = [Product productWithTitle: @"Pizza margherita" size: @"medium" price: @12 description: @"A classic pizza margherita" Type: SPPizza andPhotoURL: @"http://pizzaexpress071.nl/wp-content/uploads/2014/01/Pizza-Margherita.jpg"];
    Product *pr2 = [Product productWithTitle: @"Pizza pepperoni"size: @"medium" price: @15 description: @"A classic pizza pepperoni" Type: SPPizza andPhotoURL: @"http://bluewallpaperhd.com/wp-content/uploads/2014/08/pepperoni-pizza-pizza-hut-slice.jpg"];
    
    Product *pr3 = [Product productWithTitle: @"Pasta bolognese" size: @"400g" price: @7 description: @"A portion of the classic bolognese pasta" Type: SPPasta andPhotoURL: @"http://031b7b3.netsolhost.com/WordPress/wp-content/uploads/2013/12/tofu-bolognese.jpg"];
    Product *pt4 = [Product productWithTitle: @"Four cheese pasta" size: @"400g" price: @8 description: @"A portion of the classic four cheese pasta" Type: SPPasta andPhotoURL: @"http://www.cellocheese.com/wp-content/uploads/2012/02/fourcheesepasta.jpg"];
}
















@end
