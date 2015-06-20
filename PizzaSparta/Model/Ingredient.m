//
//  Ingredient.m
//  PizzaSparta
//
//  Created by Petar Kanev on 6/15/15.
//  Copyright (c) 2015 MentorMate Academy. All rights reserved.
//

#import "Ingredient.h"

@implementation Ingredient

- (instancetype) initWithName: (NSString *) name andPrice: (float) tmpPrice{
    self = [super init];
    if (self) {
        _name = name;
        _priceIngredient = tmpPrice;
        _isIncluded = 0;
    }
    return self;
}

@end
