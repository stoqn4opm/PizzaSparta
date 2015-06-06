//
//  Product+Modify.m
//  PizzaSparta
//
//  Created by Petar Kanev on 6/5/15.
//  Copyright (c) 2015 MentorMate Academy. All rights reserved.
//

#import "Product+Modify.h"
#import "SPManager.h"

@implementation Product (Modify)

+(Product *) productWithTitle: (NSString *) title
                  description: (NSString *) description
                      andType: (NSString *) type{

    Product *newProduct = nil;
    
    NSManagedObjectContext *context = [[SPManager sharedManager] privateChildMOContext];
    newProduct = [NSEntityDescription insertNewObjectForEntityForName: @"Product" inManagedObjectContext:context];
    newProduct.title = title;
    newProduct.productDesc = description;
    newProduct.type = type;
    [context save: NULL];
    return newProduct;
}

@end
