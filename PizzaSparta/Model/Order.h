//
//  Order.h
//  PizzaSparta
//
//  Created by Petar Kanev on 6/5/15.
//  Copyright (c) 2015 MentorMate Academy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Customer, Product;

@interface Order : NSManagedObject

@property (nonatomic, retain) NSDate * datePlaced;
@property (nonatomic, retain) NSString * id;
@property (nonatomic, retain) NSNumber * isDelivered; //setter has to delete the custom Products* from CoreData!!!
@property (nonatomic, retain) NSSet *products;
@property (nonatomic, retain) Customer *whoOrdered;
@end

@interface Order (CoreDataGeneratedAccessors)

- (void)addProductsObject:(Product *)value;
- (void)removeProductsObject:(Product *)value;
- (void)addProducts:(NSSet *)values;
- (void)removeProducts:(NSSet *)values;

@end
