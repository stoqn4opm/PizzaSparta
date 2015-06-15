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

@interface SPLoginTableViewController () <UITextFieldDelegate>{
    BOOL _firstEntrance;
}
@property (weak, nonatomic) IBOutlet UIImageView *curvedTiles;
@property (weak, nonatomic) IBOutlet UIImageView *logoImage;
@property (weak, nonatomic) IBOutlet UIButton *btnLogin;
@property (weak, nonatomic) IBOutlet UIButton *btnFBLogin;
@property (weak, nonatomic) IBOutlet UIImageView *fbIcon;
@property (weak, nonatomic) IBOutlet UIButton *btnRegister;
@property (weak, nonatomic) IBOutlet UIButton *btnSkipLogin;
@property (weak, nonatomic) IBOutlet UITextField *txtPassword;
@property (weak, nonatomic) IBOutlet UITextField *txtUsername;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@end

@implementation SPLoginTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _firstEntrance = TRUE;
    [[SPDatabaseManager sharedDatabaseManager] getAllProductsFromDataBase];

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
    
    UITapGestureRecognizer *fbIconTap = [[UITapGestureRecognizer alloc]
                                         initWithTarget:self action:@selector(fbLoginTapped)];
    
    [self.view addGestureRecognizer:dismissKeyboardTap];
    [self.fbIcon addGestureRecognizer:fbIconTap];
    [self.fbIcon setUserInteractionEnabled:YES];
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
    
    [[SPDatabaseManager sharedDatabaseManager]
     loginUserWithUsername:self.txtUsername.text andPassword:self.txtPassword.text
     
     completion:^(User *user){
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

- (IBAction)fbLoginTapped {
    [self.fbIcon setAlpha:0.5];
    [UIView animateWithDuration:0.2 animations:^{
        [self.fbIcon setAlpha:1];
    }];
    NSLog(@"Will Be implemented soon");
}

- (IBAction)registerTapped {
    [self presentRegistration];
}

#pragma mark - User Actions Helper Methods
-(BOOL) emptyFields{
return [NSString isEmptyString:self.txtUsername.text] ||
       [NSString isEmptyString:self.txtPassword.text];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"RegisterSegue"]) {
//        [self presentRegisterAnimation];
        
    }
}
@end
