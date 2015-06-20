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
#import "SPDatabaseManager.h"
#import "SPUIHeader.h"
#import "SPItemDetailsTableViewController.h"
#import "UIViewController+SPCustomNavControllerSetup.h"

@interface SPCartTableViewController ()

@end

@implementation SPCartTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupNavigationBarBackground];
    self.tableView.allowsMultipleSelectionDuringEditing = NO;

    [self.navigationItem
     setTitleView:[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"CartLabel"]]];
    [self prepareUI];
}
-(void)viewWillAppear:(BOOL)animated{
    [self.tableView reloadData];
}

-(void) prepareUI{
    
    if([[SPManager sharedManager] isUserLogIn]){
        
        UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:@"Order"
                                                                        style:UIBarButtonItemStyleBordered target:self action:@selector(makeOrder)];
        rightButton.tintColor=[UIColor whiteColor];
        self.navigationItem.rightBarButtonItem = rightButton;
    }
    else{
        UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:@"logIn"
                                                                        style:UIBarButtonItemStyleBordered target:self action:@selector(logOutAction)];
        rightButton.tintColor=[UIColor whiteColor];
        self.navigationItem.rightBarButtonItem = rightButton;
    }
}


#pragma mark - <UITableViewDataSource> Methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [[[SPManager sharedManager] cart] count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SPCartTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SPCartTableViewCell" forIndexPath:indexPath];
    
    Product *currProduct = [[[[SPManager sharedManager]cart] objectAtIndex:indexPath.row] valueForKey: @"Product"];
    NSNumber *amount     = [[[[SPManager sharedManager]cart] objectAtIndex:indexPath.row] valueForKey: @"Amount"];
    
    [cell configureCartCellWithProduct:currProduct andAmount:amount];
    
    return cell;
}
#pragma mark - <UITableViewDelegate> Methods
-(BOOL) tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == [[[SPManager sharedManager] cart] count]) {
        return NO;
    }
    return YES;
}

-(void) tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [[[SPManager sharedManager] cart] removeObjectAtIndex: indexPath.row];
        [self.tableView deleteRowsAtIndexPaths: @[indexPath] withRowAnimation: YES];
    }
}
@end
