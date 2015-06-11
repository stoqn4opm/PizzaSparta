//
//  SPJSONParser.h
//  PizzaSparta
//
//  Created by Student03 on 6/8/15.
//  Copyright (c) 2015 MentorMate Academy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Product+Modify.h"
#import "Customer+Modify.h"
#import "SPManager.h"
#import <UIKit/UIKit.h>

#import "User.h"


typedef void (^SPJSONParserSuccessBlock)(User *user);
typedef void (^SPJSONParserSuccessBlockAddress)(NSArray* dictionary);

@interface SPJSONParser : NSObject
+ (instancetype) sharedJSONParser;
-(void)getAllProductsFromDataBase;
-(void)LoggInUserWithUsername:(NSString*)username AndPassword:(NSString*)password completion:(SPJSONParserSuccessBlock)completion;
-(void)RegisterNewUserWithUsername:(NSString*)username Password:(NSString*)password Name:(NSString*)name AndFirstAdress:(NSString*)adress completion:(SPJSONParserSuccessBlock)completionRegistration;
-(void)ReadAllAddressesForLoggedUser:(User*) user WithCompletion:(SPJSONParserSuccessBlockAddress)completion;
@end
