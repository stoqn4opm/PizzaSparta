//
//  UserOrders.h
//  PizzaSparta
//
//  Created by Student03 on 6/15/15.
//  Copyright (c) 2015 MentorMate Academy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserOrders : NSObject
    @property(nonatomic)NSInteger orderId;
    @property(nonatomic)NSInteger userId;
    @property(nonatomic)NSInteger addressID;
    @property(nonatomic)NSInteger isDelivered;
    @property(strong, nonatomic)NSString* dateOrder;
    @property(strong, nonatomic)NSMutableArray* products;
    @property(strong, nonatomic)NSMutableArray* customProduct;
@end
