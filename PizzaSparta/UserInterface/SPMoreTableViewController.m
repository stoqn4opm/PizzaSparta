//
//  SPSettingsTableViewController.m
//  PizzaSparta
//
//  Created by Stoqn Stoqnov on 6/4/15.
//  Copyright (c) 2015 MentorMate Academy. All rights reserved.
//

#import "SPMoreTableViewController.h"
#import "UIViewController+SPCustomNavControllerSetup.h"

@interface SPMoreTableViewController ()

@end

@implementation SPMoreTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setupNavigationBarBackground];
    [self setupSpartaLabel];
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

@end
