//
//  Product+Modify.h
//  PizzaSparta
//
//  Created by Petar Kanev on 6/5/15.
//  Copyright (c) 2015 MentorMate Academy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Product.h"
//@property (nonatomic, retain) NSString * discription;
//@property (nonatomic, retain) NSNumber * price;
//@property (nonatomic, retain) NSString * type;
//@property (nonatomic, retain) NSString * title;
//@property (nonatomic, retain) Order *order;

@interface Product (Modify)

+(Product *) productWithTitle: (NSString *) title
                  discription: (NSString *) discription
                      andType: (NSString *) type;

@end
