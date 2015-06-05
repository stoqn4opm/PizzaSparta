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

//goes throuth the products set and sums their prices
- (NSInteger) total;

//order's isDelivered setter - deletes custom products in the order
- (void) isDelivered: (BOOL) isDelivered;

//creates a new order with current time and set time and generats an unique ID for them
+ (Order *) orderWithCurrentTimeByCustomer: (Customer *) customer;
+ (Order *) orderWithDatePlaced: (NSDate *) datePlaced andCustomer: (Customer *) customer;

+ (BOOL) orderDoesExist: (NSString *) id;
@end
