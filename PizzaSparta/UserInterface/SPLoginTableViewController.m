//
//  SPLoginTableViewController.m
//  PizzaSparta
//
//  Created by Stoyan Stoyanov on 6/15/15.
//  Copyright (c) 2015 MentorMate Academy. All rights reserved.
//

#import "SPLoginTableViewController.h"
#import "SPUIHeader.h"
#import "SPDatabaseManager.h"
#import "NSString+Check.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>

@interface SPLoginTableViewController () <UITextFieldDelegate, FBSDKLoginButtonDelegate>{
    BOOL _firstEntrance;
    BOOL _autoLogin;
}
@property (weak, nonatomic) IBOutlet UIImageView *curvedTiles;
@property (weak, nonatomic) IBOutlet UIImageView *logoImage;
@property (weak, nonatomic) IBOutlet UIButton *btnLogin;
@property (weak, nonatomic) IBOutlet UIButton *btnRegister;
@property (weak, nonatomic) IBOutlet UIButton *btnSkipLogin;
@property (weak, nonatomic) IBOutlet UITextField *txtPassword;
@property (weak, nonatomic) IBOutlet UITextField *txtUsername;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (weak, nonatomic) IBOutlet FBSDKLoginButton *btnFBLogin;

@end

@implementation SPLoginTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _firstEntrance = TRUE;
    //[[SPDatabaseManager sharedDatabaseManager] getAllProductsFromDataBase];
    
    self.btnFBLogin.readPermissions = @[@"email"];
    
    if ([FBSDKAccessToken currentAccessToken]) {
        // User is logged in facebook on this device,
        // do work such as go to next view controller, if autologin is enabled
        NSString *fbUser = @"";
        NSString *fbCurrentCity = @"";
        [[SPDatabaseManager sharedDatabaseManager] loggInUserWithUsername:fbUser AndPassword:fbUser completion:^(User *user) {
            if (user) {
                // segue to main screen
            }else{
                [[SPDatabaseManager sharedDatabaseManager] registerNewUserWithUsername:fbUser Password:fbUser Name:fbUser AndFirstAdress:fbCurrentCity completion:^(User *user) {
                        if (user) {
                            // segue to main screen
                        }else{
//                            not logged in but again to main screen
                        }
                }];
            }
        }];
        /* sample way to get dictionary with logged facebook user info:
         
             [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:nil]
             
             startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error){
                 if (!error) {
                     NSLog(@"fetched user:%@", result);
                 }
             }];
         
         */
    }
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self prepareUI];
}
#pragma mark - UI Related
-(void) prepareUI{

    [self.txtUsername setDelegate:self];
    [self.txtPassword setDelegate:self];
    [self.txtPassword setSecureTextEntry:YES];
    [self.activityIndicator setHidesWhenStopped:YES];
    UITapGestureRecognizer *dismissKeyboardTap = [[UITapGestureRecognizer alloc]
                                                  initWithTarget:self action:@selector(dismissKB)];
    
    [self.view addGestureRecognizer:dismissKeyboardTap];
    if (_firstEntrance) {
        [self firstEntranceAnimation];
        _firstEntrance = FALSE;
    }else{
        [self secondEntranceAnimation];
    }
}

- (void) dismissKB{
    [self.txtUsername resignFirstResponder];
    [self.txtPassword resignFirstResponder];
}

- (void) firstEntranceAnimation{
    [self.logoImage setAlpha:0];
    [UIView animateWithDuration:2 animations:^{
        
        self.curvedTiles.frame = CGRectMake(self.curvedTiles.frame.origin.x, -200,
                                            self.curvedTiles.frame.size.width,
                                            self.curvedTiles.frame.size.height);
    } completion:^(BOOL finished) {
        
        [UIView animateWithDuration:2 animations:^{
            [self.logoImage setAlpha:1.0];
        }];
    }];
}
-(void)secondEntranceAnimation{
    self.curvedTiles.frame = CGRectMake(self.curvedTiles.frame.origin.x, 300,
                                        self.curvedTiles.frame.size.width,
                                        self.curvedTiles.frame.size.height);
    
    self.logoImage.frame = CGRectMake(self.logoImage.frame.origin.x, 300,
                                      self.logoImage.frame.size.width,
                                      self.logoImage.frame.size.height);
    
    [UIView animateWithDuration:2 animations:^{
        self.curvedTiles.frame = CGRectMake(self.curvedTiles.frame.origin.x, 0,
                                            self.curvedTiles.frame.size.width,
                                            self.curvedTiles.frame.size.height);
        
        self.logoImage.frame = CGRectMake(self.logoImage.frame.origin.x, 20,
                                          self.logoImage.frame.size.width,
                                          self.logoImage.frame.size.height);
    }];
}
- (void) presentRegistration{
    
    [UIView animateWithDuration:2 animations:^{
        
        self.curvedTiles.frame = CGRectMake(self.curvedTiles.frame.origin.x, 200,
                                            self.curvedTiles.frame.size.width,
                                            self.curvedTiles.frame.size.height);
        
        self.logoImage.frame = CGRectMake(self.logoImage.frame.origin.x, 200,
                                          self.logoImage.frame.size.width,
                                          self.logoImage.frame.size.height);
    } completion:^(BOOL finished) {
        
        [self performSegueWithIdentifier:@"RegisterSegue" sender:nil];
    }];

}

#pragma mark - <UITextFieldDelegate> Methods
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - User Actions
- (IBAction)loginTapped {
    
    [self.activityIndicator startAnimating];
    if ([self emptyFields]) {
        [SPUIHeader alertViewWithType:SPALERT_TYPE_EMPTY_LOGIN_FIELDS];
        [self.activityIndicator stopAnimating];
        return;
    }
    [[SPDatabaseManager sharedDatabaseManager] loggInUserWithUsername:self.txtUsername.text AndPassword:self.txtPassword.text completion:^(User *user){
         if ( user ) {
            [[SPManager sharedManager] setLoggedUser:user];
            [[SPManager sharedManager] setIsUserLogIn:YES];
            NSLog(@"%@", [[[SPManager sharedManager] loggedUser] username]);
             [self performSegueWithIdentifier:@"MainScreenSegue" sender:nil];
             [self.activityIndicator stopAnimating];
        }
         else{
             [SPUIHeader alertViewWithType:SPALERT_TYPE_WRONG_USERNAME_PASSWORD];
             [self.activityIndicator stopAnimating];
         }}];
}

- (IBAction)registerTapped {
    [self presentRegistration];
}

#pragma mark User Actions Helper Methods
-(BOOL) emptyFields{
return [NSString isEmptyString:self.txtUsername.text] ||
       [NSString isEmptyString:self.txtPassword.text];
}

#pragma mark - Facebook Related Methods
-(void)loginButton:(FBSDKLoginButton *)loginButton
didCompleteWithResult:(FBSDKLoginManagerLoginResult *)result
             error:(NSError *)error{

    
}

-(void)loginButtonDidLogOut:(FBSDKLoginButton *)loginButton{
    
}

@end