//
//  Product.h
//  
//
//  Created by Petar Kanev on 6/5/15.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Order;

@interface Product : NSManagedObject

@property (nonatomic, retain) NSString * discription;
@property (nonatomic, retain) NSNumber * price;
@property (nonatomic, retain) NSString * type;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) Order *order;

@end
