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

    Product *pt4 = [Product productWithTitle:@"From SPAppDelegate" size:@"Large" price:@10 description:@"Test of Background image load" Type:SPPizza isPromo:@1 poductID:@124 andPhotoURL:@"http://cdn.wonderfulengineering.com/wp-content/uploads/2014/07/background-wallpapers-32.jpg"];
    [[SPManager sharedManager] updateMenu];
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
