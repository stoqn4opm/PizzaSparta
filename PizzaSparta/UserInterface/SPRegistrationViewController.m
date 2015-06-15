//
//  SPRegistrationViewController.m
//  PizzaSparta
//
//  Created by Student03 on 6/11/15.
//  Copyright (c) 2015 MentorMate Academy. All rights reserved.
//

#import "SPRegistrationViewController.h"
#import "NSString+Check.h"

@interface SPRegistrationViewController ()<UITextFieldDelegate>
    @property (weak, nonatomic) IBOutlet UITextField *usernameField;
    @property (weak, nonatomic) IBOutlet UITextField *userPasswordField;
    @property (weak, nonatomic) IBOutlet UITextField *userRePasswordField;
    @property (weak, nonatomic) IBOutlet UITextField *userFullNameField;
    @property (weak, nonatomic) IBOutlet UITextField *userAddressField;
@end

@implementation SPRegistrationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.usernameField.delegate=self;
    self.userPasswordField.delegate=self;
    self.userRePasswordField.delegate= self;
    self.userFullNameField.delegate=self;
    self.userAddressField.delegate=self;
    
    [self prepareUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillAppear:(BOOL)animated{
    [self resetDefaultValues];
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
    title.text=@"Registration";
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
    if(textField.tag == 2){
        [self.userRePasswordField setSecureTextEntry:YES];
    }
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self resetDefaultValues];
    [textField resignFirstResponder];
    return NO;
}

-(void)setDefaultValuetoFields{
    
    [self.userPasswordField setSecureTextEntry:NO];
    [self.userRePasswordField setSecureTextEntry:NO];
    self.usernameField.text=@"username";
    self.userPasswordField.text=@"password";
    self.userRePasswordField.text=@"repeat password";
    self.userFullNameField.text=@"full name";
    self.userAddressField.text=@"address";
    
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
    if ([NSString isEmptyString:self.userRePasswordField.text] == YES){
        [self.userRePasswordField setSecureTextEntry:NO];
        self.userRePasswordField.text=@"repeat password";
    }
    if ([NSString isEmptyString:self.userFullNameField.text] == YES){
        self.userFullNameField.text=@"full name";
    }
    if ([NSString isEmptyString:self.userAddressField.text] == YES){
        self.userAddressField.text=@"address";
    }
}

-(BOOL)validateFields{
    if(([NSString isEmptyString:self.usernameField.text] == NO) && ([NSString isEmptyString:self.userPasswordField.text] == NO)&& ([NSString isEmptyString:self.userRePasswordField.text] == NO) && ([NSString isEmptyString:self.userFullNameField.text] == NO) && ([NSString isEmptyString:self.userAddressField.text] == NO)){
        if([self.userPasswordField.text isEqualToString:self.userRePasswordField.text]){
            return YES;
        }
        else{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Registration Error"
                                                            message:@"second password do not match"
                                                           delegate:self
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
            return NO;
        }
    }
    return NO;
}

- (IBAction)signUpAction:(id)sender {
    if([self validateFields]){
        [[SPDatabaseManager sharedDatabaseManager] registerNewUserWithUsername:self.usernameField.text Password:self.userPasswordField.text name:self.userFullNameField.text andFirstAdress:self.userAddressField.text completion:^(User *user){
            if ( user ) {
                [[SPManager sharedManager] setLoggedUser:user];
                [[SPManager sharedManager] setIsUserLogIn:YES];
                NSLog(@"%@", [[[SPManager sharedManager] loggedUser] username]);
                for(id element in [[[SPManager sharedManager] loggedUser] addresses]){
                    NSLog(@"%@", [element address]);
                }
                [self setDefaultValuetoFields];
                UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
                UIViewController *addAlbumViewController = [mainStoryboard instantiateViewControllerWithIdentifier:@"mainController"];
                UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:addAlbumViewController];
                [self presentViewController:navController animated:YES completion:^{
                    NSLog(@"Add Album View Controller presented");
                }];
                //[self performSegueWithIdentifier:@"show-main-app-log" sender:self];
            }
            else if ([[SPManager sharedManager] doesUserExist]){
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Oops..."
                                                                message:@"this username exist"
                                                               delegate:self
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles:nil];
                [alert show];
            }
            else {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Registration Error"
                                                                message:@"registration error"
                                                               delegate:self
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles:nil];
                [alert show];
                
            }
            
        }];
    }
}

@end
