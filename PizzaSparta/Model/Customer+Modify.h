//
//  Customer+Modify.h
//  PizzaSparta
//
//  Created by Petar Kanev on 6/5/15.
//  Copyright (c) 2015 MentorMate Academy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Customer.h"
#import "NSString+Check.h"
#import <UIKit/UIKit.h>
@interface Customer (Modify)


// creates a new customer in CD if the username is available with log and returns it (nil if username taken)
+ (Customer *) customerWithUsername: (NSString *) username
                           password: (NSString *) password
                               name: (NSString *) name
                            andAddress: (NSString *) address;

+ (Customer *) customerWithUsername: (NSString *) username
                           password: (NSString *) password
                               name: (NSString *) name
                            address: (NSString *) address
                              andID: (NSNumber *) customerID
                              inMOC: (NSManagedObjectContext *) context;

//chechs if a customer with that username exists - done in the cusomerWithUsername: password: name: adress: method
+ (BOOL) customerDoesExist: (NSString *) username;

+ (BOOL) validateCustomersWithUsername:(NSString*) username andPassword:(NSString*)password;

//+ (Customer *) storedCustomer;
@end
