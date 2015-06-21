//
//  UserOrders.m
//  PizzaSparta
//
//  Created by Student03 on 6/15/15.
//  Copyright (c) 2015 MentorMate Academy. All rights reserved.
//

#import "UserOrders.h"

@implementation UserOrders
-(id)init{
    self = [super init];
    if(self){
        _products=[[NSMutableArray alloc] init];
    }
    return self;
}
@end
