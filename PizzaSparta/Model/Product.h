//
//  Product.h
//  PizzaSparta
//
//  Created by Student04 on 6/8/15.
//  Copyright (c) 2015 MentorMate Academy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Product : NSManagedObject

@property (nonatomic, retain) NSNumber * isPromo;
@property (nonatomic, retain) NSString * photoURL;
@property (nonatomic, retain) NSNumber * price;
@property (nonatomic, retain) NSString * productDesc;
@property (nonatomic, retain) NSString * size;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * type;
@property (nonatomic, retain) NSNumber * idProduct;
@property (nonatomic, retain) NSManagedObject *order;

@end
