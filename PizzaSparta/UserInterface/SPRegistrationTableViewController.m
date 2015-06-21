//
//  SPRegistrationTableViewController.m
//  PizzaSparta
//
//  Created by Stoyan Stoyanov on 6/15/15.
//  Copyright (c) 2015 MentorMate Academy. All rights reserved.
//

#import "SPRegistrationTableViewController.h"
#import "NSString+Check.h"
#import "SPUIHeader.h"
#import "SPDatabaseManager.h"

@interface SPRegistrationTableViewController () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *curvedTiles;
@property (weak, nonatomic) IBOutlet UIImageView *logoImage;
@property (weak, nonatomic) IBOutlet UITextField *txtUsername;
@property (weak, nonatomic) IBOutlet UITextField *txtPassword;
@property (weak, nonatomic) IBOutlet UITextField *txtRepeatPassword;
@property (weak, nonatomic) IBOutlet UITextField *txtName;
@property (weak, nonatomic) IBOutlet UITextField *txtAddress;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *createUserActivity;
@property (weak, nonatomic) IBOutlet UIButton *btnCreateUser;
@property (weak, nonatomic) IBOutlet UIButton *btnBackToLogin;

@end

@implementation SPRegistrationTableViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self prepareUI];
}

#pragma mark - UI Related
-(void) prepareUI{
    
    [self.txtUsername setDelegate:self];
    [self.txtPassword setDelegate:self];
    [self.txtPassword setSecureTextEntry:YES];
    [self.txtRepeatPassword setDelegate:self];
    [self.txtRepeatPassword setSecureTextEntry:YES];
    [self.txtName setDelegate:self];
    [self.txtAddress setDelegate:self];
    
    [self.createUserActivity setHidesWhenStopped:YES];
    UITapGestureRecognizer *dismissKeyboardTap = [[UITapGestureRecognizer alloc]
                                                  initWithTarget:self action:@selector(dismissKB)];
    
    [self.view addGestureRecognizer:dismissKeyboardTap];
    [self entranceAnimation];
}

- (void) dismissKB{
    [self.txtUsername resignFirstResponder];
    [self.txtPassword resignFirstResponder];
    [self.txtRepeatPassword resignFirstResponder];
    [self.txtName resignFirstResponder];
    [self.txtAddress resignFirstResponder];
}

- (void) entranceAnimation{
    [UIView animateWithDuration:2 animations:^{
        
        self.curvedTiles.frame = CGRectMake(self.curvedTiles.frame.origin.x, -200,
                                            self.curvedTiles.frame.size.width,
                                            self.curvedTiles.frame.size.height);
        
        self.logoImage.frame = CGRectMake(self.logoImage.frame.origin.x, -145,
                                          self.logoImage.frame.size.width,
                                          self.logoImage.frame.size.height);
    }];
}

#pragma mark - <UITextFieldDelegate> Methods
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - User Actions Methods
- (IBAction)backToLoginTapped {
    
    [UIView animateWithDuration:2 animations:^{
        self.curvedTiles.frame = CGRectMake(self.curvedTiles.frame.origin.x, 300,
                                            self.curvedTiles.frame.size.width,
                                            self.curvedTiles.frame.size.height);
        
        self.logoImage.frame = CGRectMake(self.logoImage.frame.origin.x, 300,
                                          self.logoImage.frame.size.width,
                                          self.logoImage.frame.size.height);
    } completion:^(BOOL finished) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
}

- (IBAction)createUserTapped {
    
    [self.createUserActivity startAnimating];
    if ([self fieldsAreEmpty]) {
        [SPUIHeader alertViewWithType:SPALERT_TYPE_EMPTY_REGISTER_FIELDS];
        [self.createUserActivity stopAnimating];
        return;
    }
    if (![self passwordsMatch]) {
        [SPUIHeader alertViewWithType:SPALERT_TYPE_REGISTER_PASSWORD_MISSMATCH];
        [self.createUserActivity stopAnimating];
        return;
    }
    [[SPDatabaseManager sharedDatabaseManager]
     registerNewUserWithUsername:self.txtUsername.text
     password:self.txtPassword.text
     name:self.txtName.text
     andFirstAdress:self.txtAddress.text
     completion:^(User *user){
        
         if ( user ) {
            [[SPManager sharedManager] setLoggedUser:user];
            [[SPManager sharedManager] setIsUserLogIn:YES];
            [self performSegueWithIdentifier:@"MainScreenSegue" sender:nil];
        }
        else if ([[SPManager sharedManager] doesUserExist]){
            [SPUIHeader alertViewWithType:SPALERT_TYPE_USER_ALREADY_REGISTERED];
        }else{
            [SPUIHeader alertViewWithType:SPALERT_TYPE_REGISTER_ERROR];
        }
        [self.createUserActivity stopAnimating];
    }];
}

#pragma mark - User Actions Helper Methods
-(BOOL)fieldsAreEmpty{
    
    return [NSString isEmptyString:self.txtAddress.text]        ||
           [NSString isEmptyString:self.txtName.text]           ||
           [NSString isEmptyString:self.txtPassword.text]       ||
           [NSString isEmptyString:self.txtRepeatPassword.text] ||
           [NSString isEmptyString:self.txtUsername.text];
}
-(BOOL)passwordsMatch{
    return [self.txtPassword.text isEqualToString:self.txtRepeatPassword.text];
}
@end
