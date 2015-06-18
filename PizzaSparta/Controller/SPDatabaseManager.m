//
//  SPDatabaseManager.m
//  PizzaSparta
//
//  Created by Student03 on 6/12/15.
//  Copyright (c) 2015 MentorMate Academy. All rights reserved.
//

#import "SPDatabaseManager.h"

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
    NSURLSession *session = [NSURLSession sessionWithConfiguration:sessionConfig delegate:nil delegateQueue:nil];
    
    NSURLSessionDataTask *test = [session dataTaskWithURL:[NSURL URLWithString:@"http://geit-dev.info/public/ios/product.php"]
                                        completionHandler:^(NSData* data, NSURLResponse *response, NSError *error) {
                                            NSError *parseError;
                                            NSDictionary * result =[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&parseError];
                                            if(parseError){
                                                NSLog(@"parse Error-%@", parseError);
                                            }
                                            dispatch_async(dispatch_get_main_queue(), ^{
                                                for(id element in result){
                                                    
                                                    NSManagedObjectContext *context = [[SPManager sharedManager] privateChildMOContext];
                                                    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Product"];
                                                    fetchRequest.predicate = [NSPredicate predicateWithFormat:@"idProduct  == %@ ", [element valueForKey:@"id"]];
                                                    NSError *error = nil;
                                                    NSInteger cn= [context countForFetchRequest:fetchRequest error:&error];
                                                    if(cn < 1){
                                                        Product *newProduct = [NSEntityDescription insertNewObjectForEntityForName: @"Product" inManagedObjectContext:context];
                                                        [newProduct setIdProduct: [NSNumber numberWithInteger:[[element objectForKey:@"id"] integerValue]]];
                                                        [newProduct setTitle:[element objectForKey:@"title"]];
                                                        [newProduct setPrice: [NSNumber numberWithInteger:[[element objectForKey:@"price"] integerValue]]];
                                                        [newProduct setProductDesc:[element objectForKey:@"productDesc"]];
                                                        [newProduct setType:[element objectForKey:@"type"]];
                                                        [newProduct setIsPromo: [NSNumber numberWithInteger:[[element objectForKey:@"isPromo"] integerValue]]];
                                                        [newProduct setSize:[element objectForKey:@"size"]];
                                                        
                                                        
                                                        __block BOOL success = YES;
                                                        while (context && success) {
                                                            [context performBlockAndWait:^{
                                                                NSError * error_context=nil;
                                                                
                                                                success = [context save:&error_context];
                                                                if(success == false){
                                                                    NSLog(@"Save did not complete successfully, Error: %@", [error_context localizedDescription]);
                                                                }
                                                            }];
                                                            context = context.parentContext;
                                                        }
                                                    }
                                                    
                                                }
                                            });
                                        }];
    [test resume];
}


- (BOOL) productIsSame: (Product *) product coparedTo: (NSDictionary *) dict{
    BOOL result = YES;
    
    result = (result && [product.title isEqualToString: [dict valueForKey: @"title"]]);
    result = (result && [product.price isEqual: [NSNumber numberWithInteger:[[dict objectForKey:@"price"] integerValue]]]);
    result = (result && [product.productDesc isEqualToString: [dict valueForKey: @"productDesc"]]);
    result = (result && [product.isPromo isEqual: [NSNumber numberWithInteger:[[dict objectForKey:@"isPromo"] integerValue]]]);
   
    return result;
}

-(void)logInUserWithUsername:(NSString*)username andPassword:(NSString*)password completion:(SPDatabaseManagerSuccessBlock)completion{
    
    NSURL* url = [[NSURL alloc] initWithString:[NSString stringWithFormat:@"http://geit-dev.info/public/ios/userController.php?action=readData&username=%@&password=%@",username, password ]];
    NSURLSessionConfiguration *sessionConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:sessionConfig delegate:nil delegateQueue:nil];
    
    NSURLSessionDataTask *loginSession = [session dataTaskWithURL:url
                                                completionHandler:^(NSData* data, NSURLResponse *response, NSError *error) {
                                                    NSError *parseError;
                                                    NSDictionary * result =[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&parseError];
                                                    if(parseError){
                                                        NSLog(@"parse Error-%@", parseError);
                                                    }
                                                    dispatch_async(dispatch_get_main_queue(), ^{
                                                        if(![[result valueForKey:@"username"] isEqualToString:@"none"]){
                                                            
                                                            User *newUser=[[User alloc] init];
                                                            [newUser setUserId:[[result objectForKey:@"id"] integerValue]];
                                                            [newUser setUsername:[result objectForKey:@"username"]];
                                                            [newUser setPassword:[result objectForKey:@"password"]];
                                                            [newUser setName:[result objectForKey:@"realName"]];
                                                            [newUser readAllAddresses:[result objectForKey:@"addresses"]];
                                                            
                                                            completion(newUser);
                                                        }
                                                        else{
                                                            completion(nil);
                                                        }
                                                    });
                                                }];
    [loginSession resume];
}


-(void)registerNewUserWithUsername:(NSString *)username password:(NSString *)password name:(NSString *)name andFirstAdress:(NSString *)adress completion:(SPDatabaseManagerSuccessBlock)completionRegistration{
    NSURL* url = [[NSURL alloc] initWithString:[NSString stringWithFormat:@"http://geit-dev.info/public/ios/userController.php?action=insert&username=%@&password=%@&realName=%@&adress=%@",[username stringByReplacingOccurrencesOfString:@" " withString:@"+"], [password stringByReplacingOccurrencesOfString:@" " withString:@"+"], [name stringByReplacingOccurrencesOfString:@" " withString:@"+"], [adress stringByReplacingOccurrencesOfString:@" " withString:@"+"]]];
    NSURLSessionConfiguration *sessionConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:sessionConfig delegate:nil delegateQueue:nil];
    
    NSURLSessionDataTask *registrationSession = [session dataTaskWithURL:url
                                                       completionHandler:^(NSData* data, NSURLResponse *response, NSError *error) {
                                                           NSError *parseError;
                                                           NSDictionary * result =[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&parseError];
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
    if(([[SPManager sharedManager] isUserLogIn] == YES)&&([[SPManager sharedManager] loggedUser] != nil)){
        [[[[SPManager sharedManager] loggedUser] addresses] removeAllObjects];
        NSURL* url = [[NSURL alloc] initWithString:[NSString stringWithFormat:@"http://geit-dev.info/public/ios/adressController.php?action=readData&userId=%ld",(long)[[[SPManager sharedManager] loggedUser] userId] ]];
        NSURLSessionConfiguration *sessionConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
        NSURLSession *session = [NSURLSession sessionWithConfiguration:sessionConfig delegate:nil delegateQueue:nil];
        
        NSURLSessionDataTask *loginSession = [session dataTaskWithURL:url
                                                    completionHandler:^(NSData* data, NSURLResponse *response, NSError *error) {
                                                        NSError *parseError;

                                                        NSArray* result =[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&parseError];
                                                        if(parseError){
                                                            NSLog(@"parse Error-%@", parseError);
                                                            completion(nil);
                                                        }
                                                        else{
                                                            dispatch_async(dispatch_get_main_queue(), ^{
                                                                //NSLog(@"%@", result);
                                                                completion(result);
                                                            });
                                                        }
                                                        
                                                    }];
        [loginSession resume];
    }
    
}

-(void)insertNewAddressForLoggedUserAndNewAddress:(NSString*)address WithInsertCompletion:(SPDatabaseManagerSuccessBlockAddress)completionInsert{
     if(([[SPManager sharedManager] isUserLogIn] == YES)&&([[SPManager sharedManager] loggedUser] != nil)){
          NSURL* url = [[NSURL alloc] initWithString:[NSString stringWithFormat:@"http://geit-dev.info/public/ios/adressController.php?action=insert&userId=%ld&newadress=%@",(long)[[[SPManager sharedManager] loggedUser] userId],[address stringByReplacingOccurrencesOfString:@" " withString:@"+"]]];
         NSURLSessionConfiguration *sessionConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
         NSURLSession *session = [NSURLSession sessionWithConfiguration:sessionConfig delegate:nil delegateQueue:nil];
         
         NSURLSessionDataTask *registrationSession = [session dataTaskWithURL:url
                                                            completionHandler:^(NSData* data, NSURLResponse *response, NSError *error) {
                                                                NSError *parseError;
                                                                NSDictionary * result =[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&parseError];
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


-(void)deleteAddressForLoggedUserAndNewAddress:(UserAdress*)address WithDeleteCompletion:(SPDatabaseManagerSuccessBlockAddress)completionDelete{
    if(([[SPManager sharedManager] isUserLogIn] == YES)&&([[SPManager sharedManager] loggedUser] != nil)){
        NSURL* url = [[NSURL alloc] initWithString:[NSString stringWithFormat:@"http://geit-dev.info/public/ios/adressController.php?action=delete&userId=%ld&adressId=%ld",(long)[[[SPManager sharedManager]loggedUser] userId],(long)[address addressID]]];
        NSURLSessionConfiguration *sessionConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
        NSURLSession *session = [NSURLSession sessionWithConfiguration:sessionConfig delegate:nil delegateQueue:nil];
        
        NSURLSessionDataTask *registrationSession = [session dataTaskWithURL:url
                                                           completionHandler:^(NSData* data, NSURLResponse *response, NSError *error) {
                                                               NSError *parseError;
                                                               NSDictionary * result =[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&parseError];
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

-(void)addProductsToOrder:(NSDictionary*)product ForOrderWithID:(NSString*)orderId{
    if(([[SPManager sharedManager] isUserLogIn] == YES)&&([[SPManager sharedManager] loggedUser] != nil)){
        NSURL* url = [[NSURL alloc] initWithString:[NSString stringWithFormat:@"http://geit-dev.info/public/ios/ordersController.php?actionOrder=addProduct&productType=normal&orderId=%@&productId=%@&numberOfProduct=%@&size=%@",orderId,[product objectForKey:@"prodictId"],[product objectForKey:@"numberOfProduct"], [product objectForKey:@"size"]]];
        NSURLSessionConfiguration *sessionConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
        NSURLSession *session = [NSURLSession sessionWithConfiguration:sessionConfig delegate:nil delegateQueue:nil];
        
        NSURLSessionDataTask *registrationSession = [session dataTaskWithURL:url
                                                           completionHandler:^(NSData* data, NSURLResponse *response, NSError *error) {
                                                               NSError *parseError;
                                                               NSDictionary * result =[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&parseError];
                                                               if(parseError){
                                                                   NSLog(@"parse Error-%@", parseError);
                                                               }
                                                               dispatch_async(dispatch_get_main_queue(), ^{
                                                                   
                                                                   NSLog(@"%@", [result objectForKey:@"product"]);
                                                                   
                                                               });
                                                           }];
        [registrationSession resume];

    }
}

-(void)createNewOrderForAddressWithId:(UserAdress*)address withProducts:(NSArray*)allproducts AndCustomProducts:(NSArray*)allcustomproducts WithCompletion:(SPDatabaseManagerSuccessBlockOrders)completionOrder{
    if(([[SPManager sharedManager] isUserLogIn] == YES)&&([[SPManager sharedManager] loggedUser] != nil)){
     NSURL* url = [[NSURL alloc] initWithString:[NSString stringWithFormat:@"http://geit-dev.info/public/ios/ordersController.php?actionOrder=create&userId=%ld&addressId=%ld",(long)[[[SPManager sharedManager]loggedUser] userId],(long)[address addressID]]];
        NSURLSessionConfiguration *sessionConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
        NSURLSession *session = [NSURLSession sessionWithConfiguration:sessionConfig delegate:nil delegateQueue:nil];
        
        NSURLSessionDataTask *registrationSession = [session dataTaskWithURL:url
                                                           completionHandler:^(NSData* data, NSURLResponse *response, NSError *error) {
                                                               NSError *parseError;
                                                               NSDictionary * result =[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&parseError];
                                                               if(parseError){
                                                                   NSLog(@"parse Error-%@", parseError);
                                                               }
                                                               dispatch_async(dispatch_get_main_queue(), ^{
                                                                   
                                                                   if(![[result valueForKey:@"order"] isEqualToString:@"fail"]){
                                                                       NSLog(@"%@", result);
                                                                       for(id element in allproducts){
                                                                           [self addProductsToOrder:element ForOrderWithID:[result objectForKey:@"order"]];
                                                                       }
                                                                       NSLog(@"here");
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
//type = all
//type = delivered
//type = isnotdelivered
-(void)getAllOrderstoGet:(NSString*) type WithCompletion:(SPDatabaseManagerSuccessBlockReadOrders)completionOrder{
    if(([[SPManager sharedManager] isUserLogIn] == YES)&&([[SPManager sharedManager] loggedUser] != nil)){
        NSURL* url = [[NSURL alloc] initWithString:[NSString stringWithFormat:@"http://geit-dev.info/public/ios/ordersController.php?actionOrder=getAllOrders&userId=%ld&get=%@",(long)[[[SPManager sharedManager] loggedUser] userId],type]];
        NSURLSessionConfiguration *sessionConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
        NSURLSession *session = [NSURLSession sessionWithConfiguration:sessionConfig delegate:nil delegateQueue:nil];
        
        NSURLSessionDataTask *registrationSession = [session dataTaskWithURL:url
                                                           completionHandler:^(NSData* data, NSURLResponse *response, NSError *error) {
                                                               NSError *parseError;
                                                               NSArray * result =[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&parseError];
                                                               if(parseError){
                                                                   NSLog(@"parse Error-%@", parseError);
                                                               }
                                                               dispatch_async(dispatch_get_main_queue(), ^{
                                                                   
                                                                   if(![[[result objectAtIndex:0] valueForKey:@"id"] isEqualToString:@"none"]){
                                                                       
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
-(void)getOrderWithId:(NSInteger*)orderId WithCompletion:(SPDatabaseManagerSuccessBlockReadOrders)completionOrder{
    if(([[SPManager sharedManager] isUserLogIn] == YES)&&([[SPManager sharedManager] loggedUser] != nil)){
        NSURL* url = [[NSURL alloc] initWithString:[NSString stringWithFormat:@"http://geit-dev.info/public/ios/ordersController.php?actionOrder=getOrder&orderId=%ld",(long)orderId]];
        NSURLSessionConfiguration *sessionConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
        NSURLSession *session = [NSURLSession sessionWithConfiguration:sessionConfig delegate:nil delegateQueue:nil];
        
        NSURLSessionDataTask *registrationSession = [session dataTaskWithURL:url
                                                           completionHandler:^(NSData* data, NSURLResponse *response, NSError *error) {
                                                               NSError *parseError;
                                                               NSArray * result =[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&parseError];
                                                               if(parseError){
                                                                   NSLog(@"parse Error-%@", parseError);
                                                               }
                                                               dispatch_async(dispatch_get_main_queue(), ^{
                                                                   
                                                                   if(![[[result objectAtIndex:0] valueForKey:@"id"] isEqualToString:@"none"]){
                                                                       
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
-(void)deleteOrederWithId:(NSInteger)orderId WithCompletion:(SPDatabaseManagerSuccessBlockOrders)completionOrder{
    if(([[SPManager sharedManager] isUserLogIn] == YES)&&([[SPManager sharedManager] loggedUser] != nil)){
        NSURL* url = [[NSURL alloc] initWithString:[NSString stringWithFormat:@"http://geit-dev.info/public/ios/ordersController.php?actionOrder=deleteOrder&orderId=%ld",(long)orderId]];
        NSURLSessionConfiguration *sessionConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
        NSURLSession *session = [NSURLSession sessionWithConfiguration:sessionConfig delegate:nil delegateQueue:nil];
        
        NSURLSessionDataTask *registrationSession = [session dataTaskWithURL:url
                                                           completionHandler:^(NSData* data, NSURLResponse *response, NSError *error) {
                                                               NSError *parseError;
                                                               NSDictionary * result =[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&parseError];
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
@end
