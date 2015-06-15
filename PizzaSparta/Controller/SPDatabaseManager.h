//
//  SPDatabaseManager.h
//  PizzaSparta
//
//  Created by Student03 on 6/12/15.
//  Copyright (c) 2015 MentorMate Academy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Product+Modify.h"
#import "Customer+Modify.h"
#import "SPManager.h"
#import <UIKit/UIKit.h>
#import "User.h"

typedef void (^SPDatabaseManagerSuccessBlock)(User *user);
typedef void (^SPDatabaseManagerSuccessBlockAddress)(NSArray* array);
typedef void (^SPDatabaseManagerSuccessBlockOrders)(NSString *status);
typedef void (^SPDatabaseManagerSuccessBlockReadOrders)(NSArray *array);

@interface SPDatabaseManager : NSObject

    + (instancetype) sharedDatabaseManager;

    -(void)getAllProductsFromDataBase;
    -(void)loggInUserWithUsername:(NSString*)username AndPassword:(NSString*)password completion:(SPDatabaseManagerSuccessBlock)completion;
    -(void)registerNewUserWithUsername:(NSString*)username Password:(NSString*)password Name:(NSString*)name AndFirstAdress:(NSString*)adress completion:(SPDatabaseManagerSuccessBlock)completionRegistration;
    -(void)readAllAddressesForLoggedUserWithCompletion:(SPDatabaseManagerSuccessBlockAddress)completion;
    -(void)insertNewAddressForLoggedUserAndNewAddress:(NSString*)address WithInsertCompletion:(SPDatabaseManagerSuccessBlockAddress)completionInsert;
    -(void)deleteAddressForLoggedUserAndNewAddress:(UserAdress*)address WithDeleteCompletion:(SPDatabaseManagerSuccessBlockAddress)completionDelete;

    -(void)addProductsToOrder:(NSDictionary*)product ForOrderWithID:(NSString*)orderId;
    -(void)createNewOrderForAddressWithId:(UserAdress*)address withProducts:(NSArray*)allproducts AndCustomProducts:(NSArray*)allcustomproducts WithCompletion:(SPDatabaseManagerSuccessBlockOrders)completionOrder;
-(void)getAllOrderstoGet:(NSString*) type WithCompletion:(SPDatabaseManagerSuccessBlockReadOrders)completionOrder;
-(void)getOrderWithId:(NSInteger*)orderId WithCompletion:(SPDatabaseManagerSuccessBlockReadOrders)completionOrder;
-(void)deleteOrederWithId:(NSInteger)orderId WithCompletion:(SPDatabaseManagerSuccessBlockOrders)completionOrder;
@end
