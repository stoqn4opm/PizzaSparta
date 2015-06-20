//
//  User.h
//  PizzaSparta
//
//  Created by Student03 on 6/10/15.
//  Copyright (c) 2015 MentorMate Academy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserAdress.h"
#import "UserOrders.h"

@interface User : NSObject
    @property(nonatomic)NSInteger userId;
    @property(strong, nonatomic)NSString* username;
    @property(strong, nonatomic)NSString* password;
    @property(strong, nonatomic)NSString* name;
    @property(strong, nonatomic)NSMutableArray* addresses;
    @property(strong, nonatomic)NSMutableArray* orders;
    @property(strong, nonatomic)NSMutableArray* currentOrderDetails;

    -(void)readAllAddresses:(NSArray*)alladdresses;
    -(void)readAllOrders:(NSArray*)allorders;
    -(BOOL)checkIfAddressExist:(NSString*)checkindAddress;
@end
