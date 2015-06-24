//
//  SPDatabaseManager.m
//  PizzaSparta
//
//  Created by Student03 on 6/12/15.
//  Copyright (c) 2015 MentorMate Academy. All rights reserved.
//

#import "SPDatabaseManager.h"
#import "Product.h"
#import "SPCustomPizza.h"

@implementation SPDatabaseManager

+ (instancetype) sharedDatabaseManager{
    static SPDatabaseManager *sharedDatabaseManagerObject = nil;
    @synchronized(self){
        if (sharedDatabaseManagerObject == nil) {
            sharedDatabaseManagerObject = [[self alloc] init];
        }
    }
    return sharedDatabaseManagerObject;
}

- (instancetype) init {
    self = [super init];
    if (self) {
        // init properties
        
    }
    return self;
}

-(void)getAllProductsFromDataBase{
    NSURLSessionConfiguration *sessionConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:sessionConfig
                                                          delegate:nil delegateQueue:nil];
    
    NSURLSessionDataTask *test =
    [session dataTaskWithURL:[NSURL URLWithString:@"http://geit-dev.info/public/ios/product.php"]
           completionHandler:^(NSData* data, NSURLResponse *response, NSError *error) {
               
               NSError *parseError;
               NSDictionary * result =[NSJSONSerialization
                                       JSONObjectWithData:data
                                       options:NSJSONReadingMutableContainers
                                       error:&parseError];
               if(parseError){
                   NSLog(@"parse Error-%@", parseError);
               }
               dispatch_async(dispatch_get_main_queue(), ^{
                   for(id element in result){
                       NSManagedObjectContext *context = [[SPManager sharedManager] privateChildMOContext];
                       NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Product"];
                       fetchRequest.predicate = [NSPredicate predicateWithFormat:@"idProduct  == %@ ", [element valueForKey:@"id"]];
                       NSError *error = nil;
                       NSArray *matches = [context executeFetchRequest: fetchRequest error: &error];
                       
                       if([matches count] < 1){
                           [Product productFromDictionarry: element];
                           [[SPManager sharedManager] saveParentContextToStore];
                           
                       }
                       else if (![self productIsSame: matches[0] coparedTo:element]){
                           [context deleteObject: matches[0]];
                           [Product productFromDictionarry: element];
                           [[SPManager sharedManager] saveParentContextToStore];
                       }
                   }
               });
           }];
    [test resume];
}


- (BOOL) productIsSame:(Product *)product coparedTo:(NSDictionary *)dict{
    BOOL result = YES;
    
    result = (result && [product.title       isEqualToString: [dict valueForKey: @"title"]]);
    result = (result && [product.productDesc isEqualToString: [dict valueForKey: @"productDesc"]]);
    result = (result && [product.price       isEqual: @([dict[@"price"] floatValue])]);
    result = (result && [product.isPromo     isEqual: @([dict[@"isPromo"] integerValue])]);
   
    return result;
}

-(void)logInUserWithUsername:(NSString*)username
                 andPassword:(NSString*)password
                  completion:(SPDatabaseManagerSuccessBlock)completion{
    
    NSURL* url = [[NSURL alloc] initWithString:[NSString stringWithFormat:@"http://geit-dev.info/public/ios/userController.php?action=readData&username=%@&password=%@",username, password ]];
    NSURLSessionConfiguration *sessionConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:sessionConfig
                                                          delegate:nil delegateQueue:nil];
    
    NSURLSessionDataTask *loginSession =
    [session dataTaskWithURL:url
           completionHandler:^(NSData* data, NSURLResponse *response, NSError *error) {
    
               NSError *parseError;
               NSDictionary * result =[NSJSONSerialization
                                       JSONObjectWithData:data
                                       options:NSJSONReadingMutableContainers
                                       error:&parseError];
               if(parseError){
                   NSLog(@"parse Error-%@", parseError);
               }
               dispatch_async(dispatch_get_main_queue(), ^{
                   if(![[result valueForKey:@"username"] isEqualToString:@"none"]){
                       
                       User *newUser = [[User alloc] init];
                       
                       [newUser setUserId:          [result[@"id"] integerValue]];
                       [newUser setUsername:        result[@"username"]];
                       [newUser setPassword:        result[@"password"]];
                       [newUser setName:            result[@"realName"]];
                       [newUser readAllAddresses:   result[@"addresses"]];
                       
                       completion(newUser);
                   }
                   else{
                       completion(nil);
                   }
               });
           }];
    [loginSession resume];
}

-(void)registerNewUserWithUsername:(NSString *)username
                          password:(NSString *)password
                              name:(NSString *)name
                    andFirstAdress:(NSString *)adress
                        completion:(SPDatabaseManagerSuccessBlock)completionRegistration{
    
    NSURL* url = [[NSURL alloc] initWithString:[NSString stringWithFormat:@"http://geit-dev.info/public/ios/userController.php?action=insert&username=%@&password=%@&realName=%@&adress=%@",
                                                [username stringByReplacingOccurrencesOfString:@" " withString:@"+"],
                                                [password stringByReplacingOccurrencesOfString:@" " withString:@"+"],
                                                [name stringByReplacingOccurrencesOfString:@" " withString:@"+"],
                                                [adress stringByReplacingOccurrencesOfString:@" " withString:@"+"]]];
    
    NSURLSessionConfiguration *sessionConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:sessionConfig
                                                          delegate:nil delegateQueue:nil];
    
    NSURLSessionDataTask *registrationSession =
    [session dataTaskWithURL:url
           completionHandler:^(NSData* data, NSURLResponse *response, NSError *error) {
    
               NSError *parseError;
               NSDictionary * result =[NSJSONSerialization
                                       JSONObjectWithData:data
                                       options:NSJSONReadingMutableContainers
                                       error:&parseError];
               if(parseError){
                   NSLog(@"parse Error-%@", parseError);
               }
               dispatch_async(dispatch_get_main_queue(), ^{
                   
                   if([[result valueForKey:@"username"] isEqualToString:@"successful"]){
                       
                       [self logInUserWithUsername:username andPassword:password completion:^(User *user){
                           if ( user ) {
                               completionRegistration(user);
                           } else {
                               completionRegistration(nil);
                               
                           }
                       }];
                   }
                   else if([[result valueForKey:@"username"] isEqualToString:@"exist"]){
                       [[SPManager sharedManager] setDoesUserExist:YES];
                       completionRegistration(nil);
                   }
                   else{
                       completionRegistration(nil);
                   }
                   
               });
           }];
    [registrationSession resume];
}

//returns array with dictionaries. Every dictionary has information for one address.
-(void)readAllAddressesForLoggedUserWithCompletion:(SPDatabaseManagerSuccessBlockAddress)completion{
    
    if( ([[SPManager sharedManager] isUserLogIn] == YES) &&
       ([[SPManager sharedManager] loggedUser] != nil)){
        
        [[[[SPManager sharedManager] loggedUser] addresses] removeAllObjects];
        NSURL* url = [[NSURL alloc] initWithString:[NSString stringWithFormat:@"http://geit-dev.info/public/ios/adressController.php?action=readData&userId=%ld",
                                                    (long)[[[SPManager sharedManager] loggedUser] userId]]];
        
        NSURLSessionConfiguration *sessionConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
        NSURLSession *session = [NSURLSession sessionWithConfiguration:sessionConfig
                                                              delegate:nil
                                                         delegateQueue:nil];
        
        NSURLSessionDataTask *loginSession =
        [session dataTaskWithURL:url
               completionHandler:^(NSData* data, NSURLResponse *response, NSError *error) {
                   
                   NSError *parseError;
                   NSArray* result =[NSJSONSerialization
                                     JSONObjectWithData:data
                                     options:NSJSONReadingMutableContainers
                                     error:&parseError];
                   if(parseError){
                       NSLog(@"parse Error-%@", parseError);
                       completion(nil);
                   }
                   else{
                       dispatch_async(dispatch_get_main_queue(), ^{
                           completion(result);
                       });
                   }
               }];
        [loginSession resume];
    }
}

-(void)insertNewAddressForLoggedUserAndNewAddress:(NSString*)address
                             WithInsertCompletion:(SPDatabaseManagerSuccessBlockAddress)completionInsert{
    
     if( ([[SPManager sharedManager] isUserLogIn] == YES) &&
         ([[SPManager sharedManager] loggedUser] != nil)){
         
          NSURL* url = [[NSURL alloc] initWithString:[NSString stringWithFormat:@"http://geit-dev.info/public/ios/adressController.php?action=insert&userId=%ld&newadress=%@",
                                                      (long)[[[SPManager sharedManager] loggedUser] userId],
                                                      [address stringByReplacingOccurrencesOfString:@" " withString:@"+"]]];
         
         NSURLSessionConfiguration *sessionConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
         NSURLSession *session = [NSURLSession sessionWithConfiguration:sessionConfig
                                                               delegate:nil
                                                          delegateQueue:nil];
         
         NSURLSessionDataTask *registrationSession =
         [session dataTaskWithURL:url
                completionHandler:^(NSData* data, NSURLResponse *response, NSError *error) {
         
                    NSError *parseError;
                    NSDictionary * result =[NSJSONSerialization JSONObjectWithData:data
                                                                           options:NSJSONReadingMutableContainers
                                                                             error:&parseError];
                    if(parseError){
                        NSLog(@"parse Error-%@", parseError);
                    }
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        if([[result valueForKey:@"address"] isEqualToString:@"successful"]){
                            [self readAllAddressesForLoggedUserWithCompletion:^(NSArray* array){
                                if ( array ) {
                                    completionInsert(array);
                                } else {
                                    completionInsert(nil);
                                }
                            }];
                        }
                        else{
                            completionInsert(nil);
                        }
                    });
                }];
         [registrationSession resume];
     }
}

-(void)deleteAddressForLoggedUserAndNewAddress:(UserAdress*)address
                          WithDeleteCompletion:(SPDatabaseManagerSuccessBlockAddress)completionDelete{
    
    if( ([[SPManager sharedManager] isUserLogIn] == YES) &&
        ([[SPManager sharedManager] loggedUser] != nil)){
        
        NSURL* url = [[NSURL alloc] initWithString:[NSString stringWithFormat:@"http://geit-dev.info/public/ios/adressController.php?action=delete&userId=%ld&adressId=%ld",
                                                    (long)[[[SPManager sharedManager]loggedUser] userId],
                                                    (long)[address addressID]]];
        
        NSURLSessionConfiguration *sessionConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
        NSURLSession *session = [NSURLSession sessionWithConfiguration:sessionConfig
                                                              delegate:nil
                                                         delegateQueue:nil];
        
        NSURLSessionDataTask *registrationSession =
        [session dataTaskWithURL:url
               completionHandler:^(NSData* data, NSURLResponse *response, NSError *error) {
        
                   NSError *parseError;
                   NSDictionary * result =[NSJSONSerialization JSONObjectWithData:data
                                                                          options:NSJSONReadingMutableContainers
                                                                            error:&parseError];
                   if(parseError){
                       NSLog(@"parse Error-%@", parseError);
                   }
                   dispatch_async(dispatch_get_main_queue(), ^{
                       
                       if([[result valueForKey:@"address"] isEqualToString:@"successful"]){
                           [self readAllAddressesForLoggedUserWithCompletion:^(NSArray* array){
                               if ( array ) {
                                   completionDelete(array);
                               } else {
                                   completionDelete(nil);
                                   
                               }
                           }];
                       }
                       else{
                           completionDelete(nil);
                       }
                   });
               }];
        [registrationSession resume];
    }
}

-(void)addProductsToOrder:(NSDictionary*)product
           ForOrderWithID:(NSString*)orderId{
    
    if( ([[SPManager sharedManager] isUserLogIn] == YES) &&
        ([[SPManager sharedManager] loggedUser] != nil)){
        
        NSURL* url = [[NSURL alloc] initWithString:[NSString stringWithFormat:@"http://geit-dev.info/public/ios/ordersController.php?actionOrder=addProduct&productType=normal&orderId=%@&productId=%@&numberOfProduct=%@&size=%@",
                                                    orderId,[self returnProductID:product[@"Product"]],
                                                    product[@"Amount"],
                                                    product[@"Size"]]];
        
        NSURLSessionConfiguration *sessionConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
        NSURLSession *session = [NSURLSession sessionWithConfiguration:sessionConfig
                                                              delegate:nil
                                                         delegateQueue:nil];
        
        NSURLSessionDataTask *registrationSession =
        [session dataTaskWithURL:url
               completionHandler:^(NSData* data, NSURLResponse *response, NSError *error) {
        
                   NSError *parseError;
                   NSDictionary * result =[NSJSONSerialization JSONObjectWithData:data
                                                                          options:NSJSONReadingMutableContainers
                                                                            error:&parseError];
                   if(parseError){
                       NSLog(@"parse Error-%@", parseError);
                   }
                   dispatch_async(dispatch_get_main_queue(), ^{
                       
                       NSLog(@"%@", result[@"product"]);
                   });
               }];
        [registrationSession resume];
    }
}

-(void)addCustomProductsToOrder:(NSDictionary*)product
                 ForOrderWithID:(NSString*)orderId{
    
    if( ([[SPManager sharedManager] isUserLogIn] == YES) &&
        ([[SPManager sharedManager] loggedUser] != nil)){
        
        NSString* urlString =[NSString stringWithFormat:@"http://geit-dev.info/public/ios/ordersController.php?actionOrder=addProduct&productType=custom&orderId=%@&bacon=%@&pepperoni=%@&olives=%@&onions=%@&spinach=%@&pineapple=%@&title=%@&numberOfProduct=%@&productSize=%@",
                              orderId,
                              [self returnIfIngInclude:[product[@"Product"] bacon]],
                              [self returnIfIngInclude:[product[@"Product"] pepperoni]],
                              [self returnIfIngInclude:[product[@"Product"] olives]],
                              [self returnIfIngInclude:[product[@"Product"] onions]],
                              [self returnIfIngInclude:[product[@"Product"] spinach]],
                              [self returnIfIngInclude:[product[@"Product"] pineapple]],
                              [product[@"Product"] title],
                              product[@"Amount"],
                              product[@"Size"]];
        
        NSURL* url = [[NSURL alloc] initWithString:[urlString stringByReplacingOccurrencesOfString:@" " withString:@"+"]];
        NSLog(@"%@", [product[@"Product"] title]);
        NSURLSessionConfiguration *sessionConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
        NSURLSession *session = [NSURLSession sessionWithConfiguration:sessionConfig
                                                              delegate:nil
                                                         delegateQueue:nil];
        
        NSURLSessionDataTask *registrationSession =
        [session dataTaskWithURL:url
               completionHandler:^(NSData* data, NSURLResponse *response, NSError *error) {
        
                   NSError *parseError;
                   NSDictionary * result =[NSJSONSerialization
                                           JSONObjectWithData:data
                                           options:NSJSONReadingMutableContainers
                                           error:&parseError];
                   if(parseError){
                       NSLog(@"parse Error-%@", parseError);
                   }
                   dispatch_async(dispatch_get_main_queue(), ^{
                       
                       NSLog(@"%@", result[@"product"]);
                   });
               }];
        [registrationSession resume];
    }
}

-(void)createNewOrderForAddressWithId:(UserAdress*)address
                         withProducts:(NSArray*)allproducts
                       withCompletion:(SPDatabaseManagerSuccessBlockOrders)completionOrder{
    
    if( ([[SPManager sharedManager] isUserLogIn] == YES) &&
        ([[SPManager sharedManager] loggedUser] != nil)){
        
        NSURL* url = [[NSURL alloc] initWithString:[NSString stringWithFormat:@"http://geit-dev.info/public/ios/ordersController.php?actionOrder=create&userId=%ld&addressId=%ld",
                                                    (long)[[[SPManager sharedManager]loggedUser] userId],
                                                    (long)[address addressID]]];
        
        NSURLSessionConfiguration *sessionConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
        NSURLSession *session = [NSURLSession sessionWithConfiguration:sessionConfig
                                                              delegate:nil
                                                         delegateQueue:nil];
        
        NSURLSessionDataTask *registrationSession =
        [session dataTaskWithURL:url
               completionHandler:^(NSData* data, NSURLResponse *response, NSError *error) {
        
                   NSError *parseError;
                   NSDictionary * result =[NSJSONSerialization JSONObjectWithData:data
                                                                          options:NSJSONReadingMutableContainers
                                                                            error:&parseError];
                   if(parseError){
                       NSLog(@"parse Error-%@", parseError);
                   }
                   dispatch_async(dispatch_get_main_queue(), ^{
                       
                       if(![[result valueForKey:@"order"] isEqualToString:@"fail"]){
                           NSLog(@"%@", result);
                           for(id element in allproducts){
                               if([element[@"Product"] isKindOfClass:[Product class]]){
                                   [self addProductsToOrder:element ForOrderWithID:result[@"order"]];
                               }
                               else if([element[@"Product"] isKindOfClass:[SPCustomPizza class]]) {
                                   [self addCustomProductsToOrder:element ForOrderWithID:result[@"order"]];
                               }
                           }
                           completionOrder(@"success");
                       }
                       else{
                           completionOrder(nil);
                       }
                   });
               }];
        [registrationSession resume];
    }
}

//get all orders or by entring type choose to show delivered or not delivered orders
-(void)allOrdersWithType:(SPGetOrderType *) type
              completion:(SPDatabaseManagerSuccessBlockReadOrders)completionOrder{
    
    if( ([[SPManager sharedManager] isUserLogIn] == YES) &&
        ([[SPManager sharedManager] loggedUser] != nil)){
        
        NSURL* url = [[NSURL alloc] initWithString:[NSString stringWithFormat:@"http://geit-dev.info/public/ios/ordersController.php?actionOrder=getAllOrders&userId=%ld&get=%@",
                                                    (long)[[[SPManager sharedManager] loggedUser] userId],
                                                    type]];
        
        NSURLSessionConfiguration *sessionConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
        NSURLSession *session = [NSURLSession sessionWithConfiguration:sessionConfig
                                                              delegate:nil
                                                         delegateQueue:nil];
        
        NSURLSessionDataTask *registrationSession =
        [session dataTaskWithURL:url
               completionHandler:^(NSData* data, NSURLResponse *response, NSError *error) {
                   
                   NSError *parseError;
                   NSArray * result =[NSJSONSerialization JSONObjectWithData:data
                                                                     options:NSJSONReadingMutableContainers
                                                                       error:&parseError];
                   if(parseError){
                       NSLog(@"parse Error-%@", parseError);
                   }
                   dispatch_async(dispatch_get_main_queue(), ^{
                       
                       if(![[result[0] valueForKey:@"id"] isEqualToString:@"none"]){
                           
                           completionOrder(result);
                       }
                       else{
                           completionOrder(nil);
                       }
                   });
               }];
        [registrationSession resume];
    }
}

-(void)getOrderWithId:(NSInteger*)orderId
       WithCompletion:(SPDatabaseManagerSuccessBlockReadOrders)completionOrder{
    
    if( ([[SPManager sharedManager] isUserLogIn] == YES) &&
        ([[SPManager sharedManager] loggedUser] != nil)){
        
        NSURL* url = [[NSURL alloc] initWithString:[NSString stringWithFormat:@"http://geit-dev.info/public/ios/ordersController.php?actionOrder=getOrder&orderId=%ld",
                                                    (long)orderId]];
        
        NSURLSessionConfiguration *sessionConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
        NSURLSession *session = [NSURLSession sessionWithConfiguration:sessionConfig
                                                              delegate:nil
                                                         delegateQueue:nil];
        
        NSURLSessionDataTask *registrationSession =
        [session dataTaskWithURL:url
               completionHandler:^(NSData* data, NSURLResponse *response, NSError *error) {
        
                   NSError *parseError;
                   NSArray * result =[NSJSONSerialization JSONObjectWithData:data
                                                                     options:NSJSONReadingMutableContainers
                                                                       error:&parseError];
                   if(parseError){
                       NSLog(@"parse Error-%@", parseError);
                   }
                   dispatch_async(dispatch_get_main_queue(), ^{
                       
                       if(![[result[0] valueForKey:@"id"] isEqualToString:@"none"]){
                           
                           completionOrder(result);
                       }
                       else{
                           completionOrder(nil);
                       }
                   });
               }];
        [registrationSession resume];
    }
}

-(void)deleteOrederWithId:(NSInteger)orderId
           WithCompletion:(SPDatabaseManagerSuccessBlockOrders)completionOrder{
    
    if( ([[SPManager sharedManager] isUserLogIn] == YES) &&
        ([[SPManager sharedManager] loggedUser] != nil)){
        
        NSURL* url = [[NSURL alloc] initWithString:[NSString stringWithFormat:@"http://geit-dev.info/public/ios/ordersController.php?actionOrder=deleteOrder&orderId=%ld",
                                                    (long)orderId]];
        NSURLSessionConfiguration *sessionConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
        NSURLSession *session = [NSURLSession sessionWithConfiguration:sessionConfig
                                                              delegate:nil
                                                         delegateQueue:nil];
        
        NSURLSessionDataTask *registrationSession =
        [session dataTaskWithURL:url
               completionHandler:^(NSData* data, NSURLResponse *response, NSError *error) {
        
                   NSError *parseError;
                   NSDictionary * result =[NSJSONSerialization JSONObjectWithData:data
                                                                          options:NSJSONReadingMutableContainers
                                                                            error:&parseError];
                   if(parseError){
                       NSLog(@"parse Error-%@", parseError);
                   }
                   dispatch_async(dispatch_get_main_queue(), ^{
                       
                       if([[result valueForKey:@"order"] isEqualToString:@"successful"]){
                           NSLog(@"%@", result);
                           
                           completionOrder(@"successful");
                       }
                       else{
                           completionOrder(nil);
                       }
                   });
               }];
        [registrationSession resume];
    }
}

-(NSString*)returnProductID:(Product*) element{
    
    NSInteger productId = [[element idProduct] integerValue];
    return [NSString stringWithFormat:@"%ld", (long)productId];
}

-(NSString*)returnIfIngInclude:(Ingredient*)element{
    
    NSLog(@"%@", [NSString stringWithFormat:@"%ld", (long)[element isIncluded]]);
    return [NSString stringWithFormat:@"%ld", (long)[element isIncluded]];
}
@end
