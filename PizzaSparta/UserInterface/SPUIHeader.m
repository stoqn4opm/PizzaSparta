//
//  SPUIHeader.m
//  PizzaSparta
//
//  Created by Stoyan Stoyanov on 6/15/15.
//  Copyright (c) 2015 MentorMate Academy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SPUIHeader.H"

@implementation SPUIHeader : NSObject

+ (void)alertViewWithType:(SPAlertType)alertType{
    UIAlertView *alert;
    
    switch (alertType) {
            
        case SPALERT_TYPE_WRONG_USERNAME_PASSWORD:
            alert = [[UIAlertView alloc]
                     initWithTitle:@"Login Error"
                     message:@"Wrong username/password"
                     delegate:self
                     cancelButtonTitle:@"OK"
                     otherButtonTitles:nil];
            break;
        case SPALERT_TYPE_EMPTY_LOGIN_FIELDS:
            alert = [[UIAlertView alloc]
                     initWithTitle:@"Login Error"
                     message:@"Empty field/s"
                     delegate:self
                     cancelButtonTitle:@"OK"
                     otherButtonTitles:nil];
            break;
        case SPALERT_TYPE_EMPTY_REGISTER_FIELDS:
            alert = [[UIAlertView alloc]
                     initWithTitle:@"Registration Error"
                     message:@"Empty field/s"
                     delegate:self
                     cancelButtonTitle:@"OK"
                     otherButtonTitles:nil];
            break;
        case SPALERT_TYPE_REGISTER_PASSWORD_MISSMATCH:
            alert = [[UIAlertView alloc]
                     initWithTitle:@"Registration Error"
                     message:@"Second password do not match"
                     delegate:self
                     cancelButtonTitle:@"OK"
                     otherButtonTitles:nil];
            break;
        case SPALERT_TYPE_USER_ALREADY_REGISTERED:
            alert = [[UIAlertView alloc]
                     initWithTitle:@"Registration Error"
                     message:@"Try other username. Username is not free"
                     delegate:self
                     cancelButtonTitle:@"OK"
                     otherButtonTitles:nil];
            break;
        case SPALERT_TYPE_REGISTER_ERROR:
            alert = [[UIAlertView alloc]
                     initWithTitle:@"Registration Error"
                     message:@"Connection Error. Try again Later"
                     delegate:self
                     cancelButtonTitle:@"OK"
                     otherButtonTitles:nil];
            break;
        default:
            break;
    }
    [alert show];
}

@end