//
//  User.h
//  PizzaSparta
//
//  Created by Student03 on 6/10/15.
//  Copyright (c) 2015 MentorMate Academy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserAdress.h"

@interface User : NSObject
    @property(nonatomic)NSInteger userId;
    @property(strong, nonatomic)NSString* username;
    @property(strong, nonatomic)NSString* password;
    @property(strong, nonatomic)NSString* name;
    @property(strong, nonatomic)NSMutableArray* addresses;

-(void)ReadAllAddresses:(NSArray*)alladdresses;

@end
