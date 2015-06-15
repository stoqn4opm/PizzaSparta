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
        case SPALERT_TYPE_EMPTY_FIELDS:
            alert = [[UIAlertView alloc]
                     initWithTitle:@"Login Error"
                     message:@"Empty field/s"
                     delegate:self
                     cancelButtonTitle:@"OK"
                     otherButtonTitles:nil];
        default:
            break;
    }
    [alert show];
}

@end