//
//  UIViewController+SPImageBackButton.m
//  PizzaSparta
//
//  Created by Stoqn Stoqnov on 6/6/15.
//  Copyright (c) 2015 MentorMate Academy. All rights reserved.
//

#import "UIViewController+SPImageBackButton.h"

@implementation UIViewController (SPImageBackButton)

- (void)setUpImageBackButton{
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 34, 26)];
    [backButton setBackgroundImage:[UIImage imageNamed:@"BackLabel"] forState:UIControlStateNormal];
    UIBarButtonItem *barBackButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    [backButton addTarget:self action:@selector(popCurrentViewController) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = barBackButtonItem;
    self.navigationItem.hidesBackButton = YES;
}

- (void)popCurrentViewController{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
