//
//  SPCustomPizza.h
//  PizzaSparta
//
//  Created by Student04 on 6/16/15.
//  Copyright (c) 2015 MentorMate Academy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Ingredient.h"

@interface SPCustomPizza : NSObject

@property Ingredient *pepperoni;
@property Ingredient *bacon;
@property Ingredient *onions;
@property Ingredient *spinach;
@property Ingredient *olives;
@property Ingredient *pineapple;
@property (nonatomic) float price;
@property (strong, nonatomic)NSString* title;
@property (strong, nonatomic)NSString* photoURL;


-(id)initCustomPizzaWithName:(NSString*) tmpTitle WithImage:(NSString*)image;
- (NSInteger) productID;
@end
