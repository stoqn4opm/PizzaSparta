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

typedef void (^SPDatabaseManagerSuccessBlock)(User *user);
typedef void (^SPDatabaseManagerSuccessBlockAddress)(NSArray* array);

@interface SPDatabaseManager : NSObject

    + (instancetype) sharedDatabaseManager;

    -(void)getAllProductsFromDataBase;

    -(void)loginUserWithUsername:(NSString*)username andPassword:(NSString*)password completion:(SPDatabaseManagerSuccessBlock)completion;
    -(void)registerNewUserWithUsername:(NSString*)username password:(NSString*)password name:(NSString*)name andFirstAdress:(NSString*)adress completion:(SPDatabaseManagerSuccessBlock)completionRegistration;
    -(void)readAllAddressesForLoggedUser:(User*) user WithCompletion:(SPDatabaseManagerSuccessBlockAddress)completion;
    -(void)insertNewAddressForLoggedUser:(User*)user AndNewAddress:(NSString*)address WithInsertCompletion:(SPDatabaseManagerSuccessBlockAddress)completionInsert;
    -(void)deleteAddressForLoggedUser:(User*)user AndNewAddress:(UserAdress*)address WithDeleteCompletion:(SPDatabaseManagerSuccessBlockAddress)completionDelete;

@end
