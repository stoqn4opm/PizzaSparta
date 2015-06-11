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
#import "Customer+Modify.h"
#import "SPJSONParser.h"

@interface SPAppDelegate ()

@end

@implementation SPAppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [self.window setTintColor:SPCOLOR_RED];

//    Uncomment these to test population of data across views and core data
//    Product *pr1 = [Product productWithTitle:@"Pizza 1" description:@"Short desc" andType:SPPizza];
    Product *pr1 = [Product productWithTitle: @"Pizza margherita" size: @"medium" price: @12 description: @"A classic pizza margherita" Type: SPPizza andPhotoURL: @"http://pizzaexpress071.nl/wp-content/uploads/2014/01/Pizza-Margherita.jpg"];
    Product *pr2 = [Product productWithTitle: @"Pizza pepperoni"size: @"medium" price: @15 description: @"A classic pizza pepperoni" Type: SPPizza andPhotoURL: @"http://bluewallpaperhd.com/wp-content/uploads/2014/08/pepperoni-pizza-pizza-hut-slice.jpg"];
    
    Product *pr3 = [Product productWithTitle: @"Pasta bolognese" size: @"400g" price: @7 description: @"A portion of the classic bolognese pasta" Type: SPPasta andPhotoURL: @"http://031b7b3.netsolhost.com/WordPress/wp-content/uploads/2013/12/tofu-bolognese.jpg"];
    Product *pt4 = [Product productWithTitle: @"Four cheese pasta" size: @"400g" price: @8 description: @"A portion of the classic four cheese pasta" Type: SPPasta andPhotoURL: @"http://www.cellocheese.com/wp-content/uploads/2012/02/fourcheesepasta.jpg"];

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
       return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
    //[self saveContext];
}
@end
