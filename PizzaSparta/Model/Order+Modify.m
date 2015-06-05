//
//  Order+Modify.m
//  PizzaSparta
//
//  Created by Petar Kanev on 6/5/15.
//  Copyright (c) 2015 MentorMate Academy. All rights reserved.
//

#import "Order+Modify.h"
#import "Product.h"
#import "SPManager.h"
@implementation Order (Modify)


+ (Order *) orderWithCurrentTimeByCustomer: (Customer *) customer{
    Order *newOrder = nil;
    NSManagedObjectContext *context = [[SPManager sharedManager] privateChildMOContext];
    newOrder = [NSEntityDescription insertNewObjectForEntityForName: @"Order" inManagedObjectContext: context];
    newOrder.id = [Order generateID];
    newOrder.datePlaced = [NSDate date];
    newOrder.whoOrdered = customer;
    [context save: NULL];
    return newOrder;
}

+ (Order *) orderWithDatePlaced: (NSDate *) datePlaced andCustomer: (Customer *) customer{
    Order *newOrder = nil;
    NSManagedObjectContext *context = [[SPManager sharedManager] privateChildMOContext];
    newOrder = [NSEntityDescription insertNewObjectForEntityForName: @"Order" inManagedObjectContext: context];
    newOrder.id = [Order generateID];
    newOrder.datePlaced = datePlaced;
    newOrder.whoOrdered = customer;
    [context save: NULL];
    return newOrder;
}

- (NSInteger) total{
    NSInteger total = 0;
    for (Product *product in self.products) {
        total += (NSInteger)product.price;
    }
    return total;
}

- (void) isDelivered: (BOOL) delivered{
    if (delivered)
        self.isDelivered = @1;
    else self.isDelivered = @0;
    
    if (delivered == YES) {
        NSManagedObjectContext *context = [[SPManager sharedManager] privateChildMOContext];
        for (Product *product in self.products) {
            if ([product.title containsString: @"custom"])
                [context deleteObject: product];
        }
    }
}

// IDGenerator
+ (NSString*) generateID{
    NSString *ID;
    do {
        ID = [[NSUUID UUID] UUIDString];
    } while ([Order orderDoesExist:ID]);
    
    return ID;
}

+ (BOOL) orderDoesExist: (NSString *) id{
    
    NSFetchRequest* request = [NSFetchRequest fetchRequestWithEntityName: @"Order"];
    
    request.predicate = [NSPredicate predicateWithFormat: @"id = %@", id];
    
    NSArray *matches = [[[SPManager sharedManager] privateChildMOContext] executeFetchRequest:request error:NULL];
    
    if (matches == nil){
        NSLog( @"no fetched results(from Ored+Modufy.m)");
        return YES;
    }else{
        if ([matches count] == 0){
            NSLog( @"%lu should be 0 matches (from Customer+Create.m)", (unsigned long)[matches count]);
            return NO;
        } else{
            NSLog( @"%lu order already exist(from Customer+Create.m)", (unsigned long)[matches count]);
            return YES;
        }
    }
}
@end
