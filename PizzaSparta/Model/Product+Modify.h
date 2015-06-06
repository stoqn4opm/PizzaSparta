//
//  Product+Modify.h
//  PizzaSparta
//
//  Created by Petar Kanev on 6/5/15.
//  Copyright (c) 2015 MentorMate Academy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Product.h"

@interface Product (Modify)

+(Product *) productWithTitle: (NSString *) title
                  description: (NSString *) description
                      andType: (NSString *) type;

@end
