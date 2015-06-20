//
//  SPCustomPizza.m
//  PizzaSparta
//
//  Created by Student04 on 6/16/15.
//  Copyright (c) 2015 MentorMate Academy. All rights reserved.
//

#import "SPCustomPizza.h"

@implementation SPCustomPizza
-(id)initCustomPizzaWithName:(NSString*) tmpTitle WithImage:(NSString*)image{
    self =[super init];
    if(self){
        _title=[[NSString alloc] initWithString:tmpTitle];
        _photoURL=[[NSString alloc] initWithString:image];
    }
    return self;
}

- (NSInteger) productID{
    NSInteger pizzaid = 1000000;
    
    if (self.pepperoni.isIncluded == 1) {
        pizzaid += 100000;
    }
    if (self.bacon.isIncluded == 1) {
        pizzaid += 10000;
    }
    if (self.onions.isIncluded == 1) {
        pizzaid += 1000;
    }
    if (self.spinach.isIncluded == 1) {
        pizzaid += 100;
    }
    if (self.olives.isIncluded == 1) {
        pizzaid += 10;
    }
    if (self.pineapple.isIncluded == 1) {
        pizzaid += 1;
    }
    return pizzaid;
}


@end
