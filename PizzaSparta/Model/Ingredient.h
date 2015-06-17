//
//  Ingredient.h
//  PizzaSparta
//
//  Created by Petar Kanev on 6/15/15.
//  Copyright (c) 2015 MentorMate Academy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Ingredient : NSObject

@property (strong, nonatomic) NSString *name;
@property (nonatomic) float price;
@property (nonatomic) NSInteger isIncluded;

- (instancetype) initWithName: (NSString *) name andPrice: (float) price;

@end
