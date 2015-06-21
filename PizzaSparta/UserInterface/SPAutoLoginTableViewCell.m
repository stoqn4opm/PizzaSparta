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
@property (weak, nonatomic) IBOutlet UILabel *lblRemember;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;

@end

@implementation SPAutoLoginTableViewCell

-(void)configure{
    if ([[SPManager sharedManager] hasAccountBeenStoredForAutologIn]) {
        [self.loginSwitch setOn:YES];
    }else{
        [self.loginSwitch setOn:NO];
    }
    
    if ([[SPManager sharedManager]isUserLogIn]) {
        [self.loginButton setTitle:@"Log Out" forState:UIControlStateNormal];
        [self.lblRemember setHidden:NO];
        [self.loginSwitch setHidden:NO];
        
        NSLayoutConstraint *btnLeading = [NSLayoutConstraint
                                            constraintWithItem:self.loginButton
                                            attribute:NSLayoutAttributeLeading
                                            relatedBy:NSLayoutRelationEqual
                                            toItem:self
                                            attribute:NSLayoutAttributeLeadingMargin
                                            multiplier:1 constant:0];
        
        NSLayoutConstraint *btnTop = [NSLayoutConstraint
                                            constraintWithItem:self.loginButton
                                            attribute:NSLayoutAttributeTop
                                            relatedBy:NSLayoutRelationEqual
                                            toItem:self
                                            attribute:NSLayoutAttributeTop
                                            multiplier:1 constant:0];
        [self addConstraint:btnLeading];
        [self addConstraint:btnTop];
    }
    else{
        [self.loginButton setTitle:@"Log In, to use this Feature" forState:UIControlStateNormal];
        
        NSLayoutConstraint *btnHorCenter = [NSLayoutConstraint
                                            constraintWithItem:self.loginButton
                                            attribute:NSLayoutAttributeCenterX
                                            relatedBy:NSLayoutRelationEqual
                                            toItem:self
                                            attribute:NSLayoutAttributeCenterX
                                            multiplier:1 constant:0];
        
        NSLayoutConstraint *btnverCenter = [NSLayoutConstraint
                                            constraintWithItem:self.loginButton
                                            attribute:NSLayoutAttributeCenterY
                                            relatedBy:NSLayoutRelationEqual
                                            toItem:self
                                            attribute:NSLayoutAttributeCenterY
                                            multiplier:1 constant:0];
        [self addConstraint:btnHorCenter];
        [self addConstraint:btnverCenter];
                                          
        [self.lblRemember setHidden:YES];
        [self.loginSwitch setHidden:YES];
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

- (IBAction)btnLoginPressed:(UIButton *)sender {

    if ([[SPManager sharedManager]isUserLogIn]) {
        
        [[SPManager sharedManager] clearLoggedAccounts];
        [[SPManager sharedManager] setIsUserLogIn:NO];
        [[SPManager sharedManager] setLoggedUser:nil];
    }
    [[[SPManager sharedManager] cart] removeAllObjects];
    [self.delegate dismissToLogin];
}
@end
