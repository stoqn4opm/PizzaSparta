//
//  SPCartTableViewController.m
//  PizzaSparta
//
//  Created by Stoqn Stoqnov on 6/4/15.
//  Copyright (c) 2015 MentorMate Academy. All rights reserved.
//

#import "SPCartTableViewController.h"
#import <CoreData/CoreData.h>
#import "Product+Modify.h"
#import "SPCartTableViewCell.h"
#import "SPManager.h"
#import "SPItemDetailsTableViewController.h"

@interface SPCartTableViewController ()

@end

@implementation SPCartTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationController.navigationBar
     setBackgroundImage:[UIImage imageNamed:@"TiledBackgroundWithStatusBar"]
     forBarMetrics:UIBarMetricsDefault];
    
    [self.navigationItem
     setTitleView:[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"CartLabel"]]];
}
-(void)viewWillAppear:(BOOL)animated{
    [self.tableView reloadData];
}
#pragma mark - <UITableViewDataSource> Methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [[[[SPManager sharedManager] cart]objectForKey:@"Product"]count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SPCartTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SPCartTableViewCell" forIndexPath:indexPath];
    
    Product *currProduct = [[[SPManager sharedManager]cart] objectForKey:@"Product"][indexPath.row];
    NSNumber *amount     = [[[SPManager sharedManager]cart] objectForKey:@"Amount"][indexPath.row];
    
    [cell configureCartCellWithProduct:currProduct andAmount:amount];
    return cell;
}
@end
