//
//  UIViewController+SPCustomNavControllerSetup.m
//  PizzaSparta
//
//  Created by Stoqn Stoqnov on 6/6/15.
//  Copyright (c) 2015 MentorMate Academy. All rights reserved.
//

#import "UIViewController+SPCustomNavControllerSetup.h"

@implementation UIViewController (SPCustomNavControllerSetup)

- (void)setUpImageBackButton{
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 26, 26)];
    [backButton setBackgroundImage:[UIImage imageNamed:@"BackLabel"] forState:UIControlStateNormal];
    UIBarButtonItem *barBackButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    [backButton addTarget:self action:@selector(popCurrentViewController) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = barBackButtonItem;
    self.navigationItem.hidesBackButton = YES;
}

- (void)popCurrentViewController{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void) setupNavigationBarBackground{
    [self.navigationController.navigationBar
     setBackgroundImage:[UIImage imageNamed:@"TiledBackgroundWithStatusBar"]
     forBarMetrics:UIBarMetricsDefault];
}

-(void)setupSpartaLabel{
    [self.navigationItem
     setTitleView:[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"SpartaLabel"]]];
}
@end
