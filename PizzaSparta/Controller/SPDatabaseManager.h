//
//  SPDatabaseManager.h
//  PizzaSparta
//
//  Created by Student03 on 6/12/15.
//  Copyright (c) 2015 MentorMate Academy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Product+Modify.h"
#import "SPManager.h"
#import <UIKit/UIKit.h>
#import "User.h"

// Order types for Method allOrdersWithType:completion:
#define ORDER_TYPE_ALL              @"all"
#define ORDER_TYPE_DELIVERED        @"delivered"
#define ORDER_TYPE_NOT_DELIVERED    @"isnotdelivered"
typedef NSString SPGetOrderType;

typedef void (^SPDatabaseManagerSuccessBlock)(User *user);
typedef void (^SPDatabaseManagerSuccessBlockAddress)(NSArray* array);
typedef void (^SPDatabaseManagerSuccessBlockOrders)(NSString *status);
typedef void (^SPDatabaseManagerSuccessBlockReadOrders)(NSArray *array);

@interface SPDatabaseManager : NSObject

+ (instancetype) sharedDatabaseManager;

-(void)getAllProductsFromDataBase;

-(void)logInUserWithUsername:(NSString*)username
                 andPassword:(NSString*)password
                  completion:(SPDatabaseManagerSuccessBlock)completion;

-(void)registerNewUserWithUsername:(NSString*)username
                          password:(NSString*)password
                              name:(NSString*)name
                    andFirstAdress:(NSString*)adress
                        completion:(SPDatabaseManagerSuccessBlock)completionRegistration;

-(void)readAllAddressesForLoggedUserWithCompletion:(SPDatabaseManagerSuccessBlockAddress)completion;

-(void)insertNewAddressForLoggedUserAndNewAddress:(NSString*)address
                             WithInsertCompletion:(SPDatabaseManagerSuccessBlockAddress)completionInsert;

-(void)deleteAddressForLoggedUserAndNewAddress:(UserAdress*)address
                          WithDeleteCompletion:(SPDatabaseManagerSuccessBlockAddress)completionDelete;

-(void)addProductsToOrder:(NSDictionary*)product
           ForOrderWithID:(NSString*)orderId;

-(void)addCustomProductsToOrder:(NSDictionary*)product
                 ForOrderWithID:(NSString*)orderId;

-(void)createNewOrderForAddressWithId:(UserAdress*)address
                         withProducts:(NSArray*)allproducts
                       withCompletion:(SPDatabaseManagerSuccessBlockOrders)completionOrder;

-(void)allOrdersWithType:(SPGetOrderType *)type
              completion:(SPDatabaseManagerSuccessBlockReadOrders)completionOrder;

-(void)getOrderWithId:(NSInteger*)orderId
       WithCompletion:(SPDatabaseManagerSuccessBlockReadOrders)completionOrder;

-(void)deleteOrederWithId:(NSInteger)orderId
           WithCompletion:(SPDatabaseManagerSuccessBlockOrders)completionOrder;
@end
