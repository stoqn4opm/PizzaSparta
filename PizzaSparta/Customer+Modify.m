//
//  Customer+Modify.m
//  PizzaSparta
//
//  Created by Petar Kanev on 6/5/15.
//  Copyright (c) 2015 MentorMate Academy. All rights reserved.
//

#import "Customer+Modify.h"
#import "SPManager.h"

@implementation Customer (Modify)

+ (Customer *) customerWithUsername: (NSString *) username
                           password: (NSString *) password
                               name: (NSString *) name
                            address: (NSString *) address{

    Customer *newCustomer = nil;
    if (![Customer customerDoesExist: username]) {
        NSManagedObjectContext *context = [[SPManager sharedManager] privateChildMOContext];
        newCustomer = [NSEntityDescription insertNewObjectForEntityForName: @"Customer" inManagedObjectContext: context];
        newCustomer.username = username;
        newCustomer.password = password;
        newCustomer.name = name;
        newCustomer.address = address;
        [context save: NULL];
        
    }
    
    return newCustomer;
}

+ (BOOL) customerDoesExist: (NSString *) username{
    
    NSFetchRequest* request = [NSFetchRequest fetchRequestWithEntityName: @"Customer"];
    
    request.predicate = [NSPredicate predicateWithFormat: @"username = %@", username];
    
    NSArray *matches = [[[SPManager sharedManager] privateChildMOContext] executeFetchRequest:request error:NULL];
    
    if (matches == nil){
        NSLog( @"no fetched results(from Customer+Create.m)");
        return YES;
    }else{
        if ([matches count] == 0){
            NSLog( @"%lu should be 0 matches (from Customer+Create.m)", [matches count]);
            return NO;
        } else{
            NSLog( @"%lu user already exist(from Customer+Create.m)", [matches count]);
            return YES;
        }
    }
}

@end
