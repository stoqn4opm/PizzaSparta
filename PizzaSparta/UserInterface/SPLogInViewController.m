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

- (IBAction)LoginAction:(id)sender {
    
    if( (![NSString isEmptyString:self.usernameField.text]) &&
        (![NSString isEmptyString:self.userPasswordField.text]) )
    {
        [Customer validateCustomersWithUsername:self.usernameField.text
                                    andPassword:self.userPasswordField.text];
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
