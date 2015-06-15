//
//  SPLogInViewController.m
//  PizzaSparta
//
//  Created by Student03 on 6/8/15.
//  Copyright (c) 2015 MentorMate Academy. All rights reserved.
//

#import "NSString+Check.h"
#import "SPOLDLogInViewController.h"
#define kOFFSET_FOR_KEYBOARD 80.0

@interface SPOLDLogInViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *usernameField;
@property (weak, nonatomic) IBOutlet UITextField *userPasswordField;

@end

@implementation SPOLDLogInViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [[SPDatabaseManager sharedDatabaseManager] getAllProductsFromDataBase];
    
    [self prepareUI];
    self.usernameField.delegate = self;
    self.userPasswordField.delegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)viewWillAppear:(BOOL)animated
{
    
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(void) prepareUI{
    
    [self.navigationController.navigationBar
     setBackgroundImage:[UIImage imageNamed:@"TiledBackgroundWithStatusBar"]
     forBarMetrics:UIBarMetricsDefault];
    UILabel* title=[[UILabel alloc] initWithFrame:CGRectMake(0.0,0.0,320.0,20.0)];
    title.text=@"SignIn";
    title.textAlignment = NSTextAlignmentCenter;
    [self.navigationItem
     setTitleView:title];
    
    // This will remove extra separators from tableview
 //   self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    textField.text=@"";
    if(textField.tag == 1){
        [self.userPasswordField setSecureTextEntry:YES];
    }
   
   
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self resetDefaultValues];
    [textField resignFirstResponder];
    return NO;
}

-(void)setDefaultValuetoFields{
    
    self.usernameField.text=@"username";
    
    [self.userPasswordField setSecureTextEntry:NO];
    self.userPasswordField.text=@"password";
    
}

-(void)resetDefaultValues{
    if([NSString isEmptyString:self.usernameField.text] == YES)
    {
        self.usernameField.text=@"username";
    }
    if ([NSString isEmptyString:self.userPasswordField.text] == YES){
        [self.userPasswordField setSecureTextEntry:NO];
        self.userPasswordField.text=@"password";
        
    }
}

- (IBAction)LoginAction:(id)sender {
    
    if( (![NSString isEmptyString:self.usernameField.text]) &&
        (![NSString isEmptyString:self.userPasswordField.text]) )
    {
        [[SPDatabaseManager sharedDatabaseManager] loginUserWithUsername:self.usernameField.text andPassword:self.userPasswordField.text completion:^(User *user){
            if ( user ) {
                [[SPManager sharedManager] setLoggedUser:user];
                [[SPManager sharedManager] setIsUserLogIn:YES];
                NSLog(@"%@", [[[SPManager sharedManager] loggedUser] username]);
                
                
                //example for insert new adress
                /*[[SPDatabaseManager sharedDatabaseManager] insertNewAddressForLoggedUser:user AndNewAddress:@"Burgas Nadezda" WithInsertCompletion:^(NSArray* array){
                    if(array){
                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"InsertAddress"
                                                                        message:@"new address insert"
                                                                       delegate:self
                                                              cancelButtonTitle:@"OK"
                                                              otherButtonTitles:nil];
                        [alert show];
                        
                    }
                    else{
                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"InsertAddress Error"
                                                                        message:@"new address insert error"
                                                                       delegate:self
                                                              cancelButtonTitle:@"OK"
                                                              otherButtonTitles:nil];
                        [alert show];
                    }
                    
                }];*/
                //example delete address for user
                /*[[SPDatabaseManager sharedDatabaseManager] deleteAddressForLoggedUser:user AndNewAddress:[[user addresses] lastObject] WithDeleteCompletion:^(NSArray* array){
                    if(array){
                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Delete Address"
                                                                        message:@"succesful"
                                                                       delegate:self
                                                              cancelButtonTitle:@"OK"
                                                              otherButtonTitles:nil];
                        [alert show];
                        
                    }
                    else{
                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Delete Adress"
                                                                        message:@"error"
                                                                       delegate:self
                                                              cancelButtonTitle:@"OK"
                                                              otherButtonTitles:nil];
                        [alert show];
                    }
                    
                }];*/
                UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
                UIViewController *addAlbumViewController = [mainStoryboard instantiateViewControllerWithIdentifier:@"mainController"];
                UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:addAlbumViewController];
                [self presentViewController:navController animated:YES completion:^{
                    [self setDefaultValuetoFields];
                }];
            } else {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Login Error"
                                                                message:@"Wrong username/password"
                                                               delegate:self
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles:nil];
                [alert show];
                
            }
        }];
    }
    else{
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Login Error"
                                                        message:@"Empty field/s"
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];

    }
    
    
}


@end
