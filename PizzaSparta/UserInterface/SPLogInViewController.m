//
//  SPLogInViewController.m
//  PizzaSparta
//
//  Created by Student03 on 6/8/15.
//  Copyright (c) 2015 MentorMate Academy. All rights reserved.
//

#import "SPLogInViewController.h"

@interface SPLogInViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *usernameField;
@property (weak, nonatomic) IBOutlet UITextField *userPasswordField;

@end

@implementation SPLogInViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    
    [self prepareUI];
    self.usernameField.delegate = self;
    self.userPasswordField.delegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)viewWillAppear:(BOOL)animated{
   
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
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self resetDefaultValues];
    [textField resignFirstResponder];
    return NO;
}

-(void)setDefaultValuetoFields{
    self.usernameField.text=@"username";
    self.userPasswordField.text=@"password";
}

-(void)resetDefaultValues{
    if([NSString isEmptyString:self.usernameField.text] == YES)
    {
        self.usernameField.text=@"username";
    }
    if ([NSString isEmptyString:self.userPasswordField.text] == YES){
        self.userPasswordField.text=@"password";
    }
}

- (IBAction)LoginAction:(id)sender {
    if(([NSString isEmptyString:self.usernameField.text] == NO) && ([NSString isEmptyString:self.userPasswordField.text] == NO))
    {
        [[SPJSONParser sharedJSONParser] LoggInUserWithUsername:self.usernameField.text AndPassword:self.userPasswordField.text completion:^(User *user){
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
                //[self performSegueWithIdentifier:@"show-main-app" sender:self];
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
