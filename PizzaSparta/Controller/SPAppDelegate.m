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

@implementation SPAppDelegate

- (BOOL)application:(UIApplication *)application
didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    if ([application respondsToSelector:@selector(registerUserNotificationSettings:)]) {
        [application registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert|UIUserNotificationTypeBadge|UIUserNotificationTypeSound categories:nil]];
    }
    UILocalNotification *notification = [launchOptions objectForKey:UIApplicationLaunchOptionsLocalNotificationKey];
    if(application.applicationState == UIApplicationStateBackground){
        if (notification) {
            [self showNotification:notification.alertBody];
                NSLog(@"AppDelegate didFinishLaunchingWithOptions");
            application.applicationIconBadgeNumber = 0;
        }
    }
    [self.window setTintColor:SPCOLOR_RED];
    [[SPManager sharedManager] updateMenu];
    [FBSDKLoginButton class];
    
    return [[FBSDKApplicationDelegate sharedInstance] application:application
                                    didFinishLaunchingWithOptions:launchOptions];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    [FBSDKAppEvents activateApp];
    application.applicationIconBadgeNumber = 0;
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
- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{
    if (application.applicationState == UIApplicationStateActive) {
        [self dismissAlerts];
        [self showNotification:notification.alertBody];
    }
}
- (void)showNotification:(NSString *)text {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Order status"
                                                        message:text delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
    [alertView show];
}
-(void)dismissAlerts{
    for (UIWindow* window in [UIApplication sharedApplication].windows) {
        NSArray* subviews = window.subviews;
        if ([subviews count] > 0)
            if ([[subviews objectAtIndex:0] isKindOfClass:[UIAlertView class]])
                [(UIAlertView *)[subviews objectAtIndex:0] dismissWithClickedButtonIndex:[(UIAlertView *)[subviews objectAtIndex:0] cancelButtonIndex] animated:NO];
    }
}
@end
