//
//  SPOrderDietailsTableViewController.m
//  PizzaSparta
//
//  Created by Student03 on 6/20/15.
//  Copyright (c) 2015 MentorMate Academy. All rights reserved.
//

#import "SPOrderDetailsTableViewController.h"
#import "SPManager.h"
#import "SPUIHeader.h"
#import "SPOrderDetailsTableViewCell.h"
#import "UIViewController+SPCustomNavControllerSetup.h"

@interface SPOrderDetailsTableViewController ()

@end

@implementation SPOrderDetailsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpImageBackButton];
    [self setupNavigationBarBackground];
    
    [self.navigationItem
     setTitleView:[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"OrderHistoryLabel"]]];

    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}
-(void)viewWillAppear:(BOOL)animated{
    [self.tableView reloadData];
}



#pragma mark - <UITableViewDataSource> Methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if([[[[SPManager sharedManager] loggedUser] currentOrderDetails] count] > 0){

        return [[[[SPManager sharedManager] loggedUser] currentOrderDetails] count];
    }
    return 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView
        cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    SPOrderDetailsTableViewCell *cell = [tableView
                                         dequeueReusableCellWithIdentifier:@"SPDetailsOrderTableViewCell"
                                         forIndexPath:indexPath];
    
    [cell configureCartCellWithProduct:[[[SPManager sharedManager] loggedUser] currentOrderDetails][indexPath.row]];
    return cell;
}

#pragma mark - <UITableViewDelegate> Methods
- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell* cell = [tableView cellForRowAtIndexPath:indexPath];
    if(cell.selectionStyle == UITableViewCellSelectionStyleNone){
        return nil;
    }
    return indexPath;
}
@end
