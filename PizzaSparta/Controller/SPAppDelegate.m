//
//  AppDelegate.m
//  PizzaSparta
//
//  Created by Stoqn Stoqnov on 6/3/15.
//  Copyright (c) 2015 MentorMate Academy. All rights reserved.
//

#import "SPAppDelegate.h"
#import "SPUIHeader.h"
#import "SPManager.h"
#import "Product+Modify.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>

@interface SPAppDelegate ()

@end

@implementation SPAppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [self.window setTintColor:SPCOLOR_RED];
    [[SPManager sharedManager] updateMenu];
//    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName: @"Product"];
//    NSManagedObjectContext *context = [[SPManager sharedManager] privateChildMOContext];
//    NSArray *matches = [context executeFetchRequest: request error: NULL];
//    NSLog(@"%@", matches);

//    Uncomment these to test population of data across views and core data
//    Product *pr1 = [Product productWithTitle:@"Pizza 1" description:@"Short desc" andType:SPPizza];
    /*Product *pr1 = [Product productWithTitle: @"Pizza margherita" size: @"medium" price: @12 description: @"A classic pizza margherita" Type: SPPizza andPhotoURL: @"http://pizzaexpress071.nl/wp-content/uploads/2014/01/Pizza-Margherita.jpg"];
    Product *pr2 = [Product productWithTitle: @"Pizza pepperoni"size: @"medium" price: @15 description: @"A classic pizza pepperoni" Type: SPPizza andPhotoURL: @"http://bluewallpaperhd.com/wp-content/uploads/2014/08/pepperoni-pizza-pizza-hut-slice.jpg"];
    
    Product *pr3 = [Product productWithTitle: @"Pasta bolognese" size: @"400g" price: @7 description: @"A portion of the classic bolognese pasta" Type: SPPasta andPhotoURL: @"http://031b7b3.netsolhost.com/WordPress/wp-content/uploads/2013/12/tofu-bolognese.jpg"];
    Product *pt4 = [Product productWithTitle: @"Four cheese pasta" size: @"400g" price: @8 description: @"A portion of the classic four cheese pasta" Type: SPPasta andPhotoURL: @"http://www.cellocheese.com/wp-content/uploads/2012/02/fourcheesepasta.jpg"];*/

//    Product *pr3 = [Product productWithTitle:@"Pasta 1" description:@"Short desc" andType:SPPasta];
//    Product *pr4 = [Product productWithTitle:@"Pasta 2" description:@"Short desc 2" andType:SPPasta];
   // [Customer customerWithUsername:@"nik2" password:@"1234" name:@"Nikolai" andAddress:@"Sofia"];
    /*__block BOOL success = YES;
    while ([[SPManager sharedManager] privateChildMOContext] && success) {
        [[[SPManager sharedManager] privateChildMOContext] performBlockAndWait:^{
            NSError * error_context=nil;
            
            success = [[[SPManager sharedManager] privateChildMOContext] [[SPManager sharedManager] saveParentContextToStore]:&error_context];
            if(success == false){
                NSLog(@"Save did not complete successfully, Error: %@", [error_context localizedDescription]);
            }
        }];
        [[SPManager sharedManager] [[SPManager sharedManager] privateChildMOContext]] = context.parentContext;
    }*/
    //[[SPManager sharedManager] saveParentContextToStore];
    
    [FBSDKLoginButton class];
    return [[FBSDKApplicationDelegate sharedInstance] application:application
                                    didFinishLaunchingWithOptions:launchOptions];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    [FBSDKAppEvents activateApp];
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    
    return [[FBSDKApplicationDelegate sharedInstance] application:application
                                                          openURL:url
                                                sourceApplication:sourceApplication
                                                       annotation:annotation];
}
@end
