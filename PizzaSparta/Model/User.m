//
//  User.m
//  PizzaSparta
//
//  Created by Student03 on 6/10/15.
//  Copyright (c) 2015 MentorMate Academy. All rights reserved.
//

#import "User.h"

@implementation User
-(id)init{
    self=[super init];
    if(self)
    {
        _userId=0;
        _username=@"";
        _password=@"";
        _name=@"";
        _addresses=[[NSMutableArray alloc] init];
        _orders=[[NSMutableArray alloc] init];
    }
    return self;
}
-(void)readAllAddresses:(NSArray*)alladdresses{
    [self.addresses removeAllObjects];
    for(NSDictionary* element in alladdresses){
        UserAdress* newAddress=[[UserAdress alloc] init];
        [newAddress setAddressID:[[element valueForKey:@"id"] integerValue]];
        [newAddress setAddress:[element valueForKey:@"adress"]];
        [self.addresses addObject:newAddress];
    }
}


-(BOOL)checkIfAddressExist:(NSString*)checkindAddress{
    NSString* tmpAddress = [checkindAddress stringByReplacingOccurrencesOfString:@" " withString:@""];
    for(UserAdress* element in self.addresses){
        NSString* addressFromArray = [[element address] stringByReplacingOccurrencesOfString:@" " withString:@""];
        if([addressFromArray isEqualToString:tmpAddress]){
            return YES;
        }
    }
    return NO;
}
-(void)readAllOrders:(NSArray *)allorders{
    [self.orders removeAllObjects];
    for(NSDictionary* element in allorders){
        UserOrders* ord=[[UserOrders alloc]init];
        [ord setOrderId:[[element valueForKey:@"id"] integerValue]];
        [ord setUserId:[[element valueForKey:@"userId"] integerValue]];
        [ord setAddressID:[[element valueForKey:@"adressId"] integerValue]];
        [ord setIsDelivered:[[element valueForKey:@"isDelivered"] integerValue]];
        [ord setDateOrder:[element valueForKey:@"dateOrder"]];
        /*if(![[element valueForKey:@"products"] isEqualToString:@"none"]){
            [ord setProducts:[element valueForKey:@"products"]];
        }*/
        [self.orders addObject:ord];
    }
}
@end
