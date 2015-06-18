//
//  SPAutoLoginTableViewCell.m
//  PizzaSparta
//
//  Created by Stoqn Stoqnov on 6/18/15.
//  Copyright (c) 2015 MentorMate Academy. All rights reserved.
//

#import "SPAutoLoginTableViewCell.h"
#import "SPManager.h"

@interface SPAutoLoginTableViewCell ()
@property (weak, nonatomic) IBOutlet UISwitch *loginSwitch;

@end

@implementation SPAutoLoginTableViewCell

-(void)configure{
    if ([[SPManager sharedManager] hasAccountBeenStoredForAutologIn]) {
        [self.loginSwitch setOn:YES];
    }else{
        [self.loginSwitch setOn:NO];
    }
}

- (IBAction)loginSwitchValueChanged:(UISwitch *)sender {
    
    if (sender.on) {
        if([[SPManager sharedManager]isUserLogIn]){
            [[SPManager sharedManager]saveLoggedUserForAutologin];
        }
    }else{
        [[SPManager sharedManager]clearLoggedAccounts];
    }
}

@end
