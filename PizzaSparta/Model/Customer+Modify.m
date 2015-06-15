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
                            andAddress: (NSString *) address{

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

+ (Customer *) customerWithUsername: (NSString *) username
                           password: (NSString *) password
                               name: (NSString *) name
                            address: (NSString *) address
                              andID: (NSNumber *) customerID
                              inMOC: (NSManagedObjectContext *) context{
    
    Customer *newCustomer = nil;
    if (![Customer customerDoesExist: username]) {
        newCustomer = [NSEntityDescription insertNewObjectForEntityForName: @"Customer" inManagedObjectContext: context];
        newCustomer.username = username;
        newCustomer.password = password;
        newCustomer.name = name;
        newCustomer.customerID = customerID;
        newCustomer.address = address;        
    }
    
    return newCustomer;
}

+ (BOOL) customerDoesExist: (NSString *) username{
    
    NSFetchRequest* request = [NSFetchRequest fetchRequestWithEntityName: @"Customer"];
    
    request.predicate = [NSPredicate predicateWithFormat: @"username = %@", username];
    NSManagedObjectContext *context = [[SPManager sharedManager] privateChildMOContext];
    NSArray *matches = [context
                        executeFetchRequest:request error:NULL];
    NSLog(@"%@", matches);
    if (matches == nil){
        NSLog( @"no fetched results(from Customer+Modify.m)");
        return YES;
        
    }else{
        if ([matches count] == 0){
            NSLog( @"%lu should be 0 matches (from Customer+Modify.m)", (unsigned long)[matches count]);
            return NO;
        } else{
            NSLog( @"%lu user already exist(from Customer+Modify.m)", (unsigned long)[matches count]);
            NSLog(@"%@", [matches[0] username]);
            return YES;
        }
    }
}

//+ (Customer *) storedCustomer{
//    NSFetchRequest* request = [NSFetchRequest fetchRequestWithEntityName: @"Customer"];
//        NSManagedObjectContext *context = [[SPManager sharedManager] privateChildMOContext];
//    NSArray *matches = [context executeFetchRequest:request error:NULL];
//    NSLog(@"stored customers in core data: %lud (from Customer+Modify.m)", (unsigned long)[matches count]);
//    return matches[0];
//}

//check if user exist

+ (BOOL) validateCustomersWithUsername:(NSString *)username andPassword:(NSString *)password{
    
    if(![self customerDoesExist:username]){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Login"
                                                        message:[NSString stringWithFormat:@"No user with username: %@", username]
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        return NO;
    }
    else{
        NSFetchRequest* fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Customer"];
    
        fetchRequest.predicate = [NSPredicate predicateWithFormat:@"username = %@ AND password = %@", username, password];
        NSError *error = nil;
        NSArray* results = [[[SPManager sharedManager] privateChildMOContext] executeFetchRequest:fetchRequest    error:&error];
        if(error){
            NSLog(@"validation error - %@", error);
        }
        else if ([results count] > 0){
            
            [[SPManager sharedManager] setLoggedCustomer:results[0]];
            
            NSLog(@"usename - %@", [[[SPManager sharedManager] loggedCustomer] username]);
            return YES;
            
        }
        else{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Login Error"
                                                            message:@"Wrong username/password"
                                                           delegate:self
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
            
            return NO;
        }
    
    }
    return NO;
}
@end
