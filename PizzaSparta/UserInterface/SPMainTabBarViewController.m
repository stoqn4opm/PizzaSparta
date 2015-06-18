//
//  SPMainTabBarViewController.m
//  PizzaSparta
//
//  Created by Stoqn Stoqnov on 6/18/15.
//  Copyright (c) 2015 MentorMate Academy. All rights reserved.
//

#import "SPMainTabBarViewController.h"
#import "SPManager.h"

@interface SPMainTabBarViewController () <UIAlertViewDelegate>

@end

@implementation SPMainTabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (![[SPManager sharedManager] hasAccountBeenStoredForAutologIn] &&
        [[SPManager sharedManager]isUserLogIn]) {
        [self askAutoLogin];
    }
}

-(void) askAutoLogin{
    [[[UIAlertView alloc]
      initWithTitle:@"Remember Login Details"
      message:@"Would you like PizzaSparta app to remember your login details in order to log you in automatically?"
      delegate:self
      cancelButtonTitle:@"No"
      otherButtonTitles:@"Yes", nil] show];
    
}

#pragma mark - <UIAlertViewDelegate> Methods
-(void)alertView:(UIAlertView *)alertView
clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if ([[alertView buttonTitleAtIndex:buttonIndex] isEqualToString:@"Yes"]) {
        
        [[SPManager sharedManager]saveLoggedUserForAutologin];
    }
}
@end
