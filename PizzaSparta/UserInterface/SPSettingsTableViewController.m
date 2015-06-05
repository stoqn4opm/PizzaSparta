//
//  SPSettingsTableViewController.m
//  PizzaSparta
//
//  Created by Stoqn Stoqnov on 6/4/15.
//  Copyright (c) 2015 MentorMate Academy. All rights reserved.
//

#import "SPSettingsTableViewController.h"

@interface SPSettingsTableViewController ()

@end

@implementation SPSettingsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationController.navigationBar
     setBackgroundImage:[UIImage imageNamed:@"TiledBackgroundWithStatusBar"]
     forBarMetrics:UIBarMetricsDefault];
    
    [self.navigationItem
     setTitleView:[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"SpartaLabel"]]];
    

}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

@end
