//
//  SPOrderDietailsTableViewController.m
//  PizzaSparta
//
//  Created by Student03 on 6/20/15.
//  Copyright (c) 2015 MentorMate Academy. All rights reserved.
//

#import "SPOrderDietailsTableViewController.h"
#import "SPManager.h"
#import "SPUIHeader.h"
#import "SPOrderDetailsTableViewCell.h"
#import "UIViewController+SPCustomNavControllerSetup.h"

@interface SPOrderDietailsTableViewController ()

@end

@implementation SPOrderDietailsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpImageBackButton];
    [self setupNavigationBarBackground];
    self.tableView.allowsMultipleSelectionDuringEditing = NO;
    
    [self.navigationItem
     setTitleView:[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"OrderHistoryLabel"]]];
}
-(void)viewWillAppear:(BOOL)animated{
    [self.tableView reloadData];
}



#pragma mark - <UITableViewDataSource> Methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if([[[[SPManager sharedManager] loggedUser] currentOrderDetails] count]>0){
        NSLog(@"%ld",[[[[SPManager sharedManager] loggedUser] currentOrderDetails] count]);
        return [[[[SPManager sharedManager] loggedUser] currentOrderDetails] count];
    }
    return 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SPOrderDetailsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SPDetailsOrderTableViewCell" forIndexPath:indexPath];
    
    [cell configureCartCellWithProduct:[[[[SPManager sharedManager] loggedUser] currentOrderDetails] objectAtIndex:indexPath.row]];
    
    return cell;
}

@end
