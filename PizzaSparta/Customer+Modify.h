//
//  Customer+Modify.h
//  PizzaSparta
//
//  Created by Petar Kanev on 6/5/15.
//  Copyright (c) 2015 MentorMate Academy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Customer.h"

@interface Customer (Modify)

+ (Customer *) customerWithUsername: (NSString *) username
                           password: (NSString *) password
                               name: (NSString *) name
                            address: (NSString *) address;

+ (BOOL) customerDoesExist: (NSString *) username;
@end
