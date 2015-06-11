//
//  SPJSONParser.m
//  PizzaSparta
//
//  Created by Student03 on 6/8/15.
//  Copyright (c) 2015 MentorMate Academy. All rights reserved.
//

#import "SPJSONParser.h"

@implementation SPJSONParser

+ (instancetype) sharedJSONParser{
    static SPJSONParser *sharedJSONParser = nil;
    @synchronized(self){
        if (sharedJSONParser == nil) {
            sharedJSONParser = [[self alloc] init];
        }
    }
    return sharedJSONParser;
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
    
    NSURLSessionDataTask *test = [session dataTaskWithURL:[NSURL URLWithString:@"http://80.72.68.36:8081/ios/product.php"]
                                        completionHandler:^(NSData* data, NSURLResponse *response, NSError *error) {
                                            NSError *parseError;
                                            NSDictionary * response2 =[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&parseError];
                                            if(parseError){
                                                NSLog(@"parse Error-%@", parseError);
                                            }
                                            dispatch_async(dispatch_get_main_queue(), ^{
                                            for(id element in response2){
                                                //for(id key in element){
                                                  //  NSLog(@"%@, %@", key ,[element objectForKey:key]);
                                                //}
                                                //[Product productWithTitle:[element objectForKey:@"title"] size:[element objectForKey:@"size"] price:[element objectForKey:@"price"] description:[element objectForKey:@"productDesc"] Type:[element objectForKey:@"type"] andPhotoURL:[element objectForKey:@"photoURL"]];
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
                                                   // NSLog(@"%@", [element objectForKey:@"id"]);
                                               // NSLog(@"%@", [element objectForKey:@"title"]);
                                                    
                                                    //[newProduct setPhotoURL:[element objectForKey:@"photoURL"]];
                                                    //[newProduct setValuesForKeysWithDictionary:element];
                                                  //  [context save:NULL];
                                                   [[SPManager sharedManager] saveParentContextToStore];
                                                }
                                                
                                            }
                                            });
                                        }];
    [test resume];
}
-(void)LoggInUserWithUsername:(NSString *)username AndPassword:(NSString *)password completion:(SPJSONParserSuccessBlock)completion{
    
    NSURL* url = [[NSURL alloc] initWithString:[NSString stringWithFormat:@"http://80.72.68.36:8081/ios/userController.php?action=readData&username=%@&password=%@",username, password ]];
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
                                                [newUser ReadAllAddresses:[result objectForKey:@"addresses"]];
                                
                                                completion(newUser);
                                            }
                                            else{
                                                completion(nil);
                                            }
                                            });
                                        }];
    [loginSession resume];
}


-(void)RegisterNewUserWithUsername:(NSString *)username Password:(NSString *)password Name:(NSString *)name AndFirstAdress:(NSString *)adress completion:(SPJSONParserSuccessBlock)completionRegistration{
    NSURL* url = [[NSURL alloc] initWithString:[NSString stringWithFormat:@"http://80.72.68.36:8081/ios/userController.php?action=insert&username=%@&password=%@&realName=%@&adress=%@",[username stringByReplacingOccurrencesOfString:@" " withString:@"+"], [password stringByReplacingOccurrencesOfString:@" " withString:@"+"], [name stringByReplacingOccurrencesOfString:@" " withString:@"+"], [adress stringByReplacingOccurrencesOfString:@" " withString:@"+"]]];
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
                                                        [self LoggInUserWithUsername:username AndPassword:password completion:^(User *user){
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
-(void)ReadAllAddressesForLoggedUser:(User*) user WithCompletion:(SPJSONParserSuccessBlockAddress)completion{
    if(([[SPManager sharedManager] isUserLogIn] == YES)&&(user != nil)){
        [[[[SPManager sharedManager] loggedUser] addresses] removeAllObjects];
        NSURL* url = [[NSURL alloc] initWithString:[NSString stringWithFormat:@"http://80.72.68.36:8081/ios/adressController.php?action=readData&userId=%ld",(long)[user userId] ]];
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
                                                            NSLog(@"%@", result);
                                                            completion(result);
                                                        });
                                                        }
  
                                                    }];
        [loginSession resume];
    }
    
}
@end
