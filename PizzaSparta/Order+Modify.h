//
//  Order+Modify.h
//  PizzaSparta
//
//  Created by Petar Kanev on 6/5/15.
//  Copyright (c) 2015 MentorMate Academy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Order.h"
@class Customer, Product;

@interface Order (Modify)
- (NSInteger) total;
- (void) isDelivered: (BOOL) isDelivered;

+ (Order *) newOrderWithCurrentTimeByCustomer: (Customer *) customer;
+ (Order *) orderWithDatePlaced: (NSDate *) datePlaced andCustomer: (Customer *) customer;

+ (BOOL) orderDoesExist: (NSString *) id;
@end
