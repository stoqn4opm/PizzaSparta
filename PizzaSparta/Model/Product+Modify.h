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

// creates a new product and returns it and sets it's isPromo property to NO (0)
+ (Product *) productWithTitle: (NSString *) title
                          size: (NSString *) size
                         price: (NSNumber *) price
                   description: (NSString *) description
                          Type: (NSString *) type
                       isPromo: (NSNumber* ) isPromo
                      poductID: (NSNumber *) productID
                   andPhotoURL: (NSString *) URL;

+ (Product *) productFromDictionarry: (NSDictionary *) element;

//isPromo setters and getters
@property (NS_NONATOMIC_IOSONLY) BOOL promo;
@property (NS_NONATOMIC_IOSONLY, readonly) NSInteger productID;

@property (NS_NONATOMIC_IOSONLY, readonly, copy) NSURL *urlPhoto;

- (void) setPromo: (BOOL) isPromo andNewPrice: (NSNumber *) newPrice;


@end
