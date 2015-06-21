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

+ (Product *) productWithTitle: (NSString *) title
                          size: (NSString *) size
                         price: (NSNumber *) price
                   description: (NSString *) description
                          Type: (NSString *) type
                       isPromo: (NSNumber* ) isPromo
                      poductID: (NSNumber *) productID
                   andPhotoURL: (NSString *) URL{
    
    Product *newProduct = nil;
    
    NSManagedObjectContext *context = [[SPManager sharedManager] privateChildMOContext];
    newProduct = [NSEntityDescription insertNewObjectForEntityForName: @"Product" inManagedObjectContext:context];
    newProduct.title        = title;
    newProduct.size         = size;
    newProduct.price        = price;
    newProduct.productDesc  = description;
    newProduct.type         = type;
    newProduct.idProduct    = productID;
    newProduct.isPromo      = isPromo;
    newProduct.photoURL     = URL;
    
    [context save: NULL];
    
    return newProduct;
}

+ (Product *) productFromDictionarry: (NSDictionary *) element{
    
    NSManagedObjectContext *context = [[SPManager sharedManager] privateChildMOContext];
    Product *newProduct = [NSEntityDescription insertNewObjectForEntityForName: @"Product" inManagedObjectContext:context];
    
    [newProduct setIdProduct:   @([element[@"id"] integerValue])];
    [newProduct setTitle:       element[@"title"]];
    [newProduct setPrice:       @([element[@"price"] integerValue])];
    [newProduct setProductDesc: element[@"productDesc"]];
    [newProduct setType:        element[@"type"]];
    [newProduct setIsPromo:     @([element[@"isPromo"] integerValue])];
    [newProduct setSize:        element[@"size"]];
    [newProduct setPhotoURL:    element[@"photoURL"]];
    
    [context save: NULL];
    
    return newProduct;
}

#pragma mark - property setters and getters
- (NSInteger) productID{
    return [self.idProduct longValue];
}

- (BOOL) promo{
    if ([self.isPromo  isEqual: @1])
        return YES;
    else
        return NO;
}

- (void) setPromo: (BOOL) isPromo{
    if (isPromo)
        self.isPromo = @1;
    else
        self.isPromo = @0;
}

- (NSURL *) urlPhoto{
    return [NSURL URLWithString: self.photoURL];
}

- (void) setPromo: (BOOL) isPromo andNewPrice: (NSNumber *) newPrice{
    
    if (isPromo) {
        self.isPromo = @1;
    }else
        self.isPromo = @0;
    
    self.price = newPrice;
}
@end
