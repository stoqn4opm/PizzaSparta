//
//  SPLogInViewController.m
//  PizzaSparta
//
//  Created by Student03 on 6/8/15.
//  Copyright (c) 2015 MentorMate Academy. All rights reserved.
//

#import "SPLogInViewController.h"

@interface SPLogInViewController ()
@property (weak, nonatomic) IBOutlet UITextField *usernameField;
@property (weak, nonatomic) IBOutlet UITextField *userPasswordField;

@end

@implementation SPLogInViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (IBAction)LoginAction:(id)sender {
    if(([NSString isEmptyString:self.usernameField.text] == NO) && ([NSString isEmptyString:self.userPasswordField.text] == NO))
    {
        [Customer validateCustomersWithUsername:self.usernameField.text  andPassword:self.userPasswordField.text];
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
