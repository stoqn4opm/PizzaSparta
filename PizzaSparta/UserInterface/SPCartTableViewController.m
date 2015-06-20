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
-(void)logOutAction{
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    UIViewController *addAlbumViewController = [mainStoryboard instantiateViewControllerWithIdentifier:@"loginController"];
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:addAlbumViewController];
    [self presentViewController:navController animated:YES completion:^{
        if ([[SPManager sharedManager] isUserLogIn]) {
            [[SPManager sharedManager] setLoggedUser:nil];
            [[SPManager sharedManager ]setIsUserLogIn:NO];
        }
        
    }];
}
-(void)makeOrder{
    if([[[SPManager sharedManager] cart]count] <1){
        [SPUIHeader alertViewWithType:SPALERT_TYPE_EMPTY_CART];
    }
    else{
        [[SPDatabaseManager sharedDatabaseManager] createNewOrderForAddressWithId:[[[[SPManager sharedManager] loggedUser]addresses] lastObject] withProducts:[[SPManager sharedManager] cart] WithCompletion:^(NSString* status){
            if([status isEqualToString:@"success"]){
                [SPUIHeader alertViewWithType:SPALERT_TYPE_SUCCESS_ORDER];
                [[[SPManager sharedManager] cart] removeAllObjects];
                [self.tableView reloadData];
            }
            else{
                [SPUIHeader alertViewWithType:SPALERT_TYPE_ORDER_ERROR];
            }
        }];
    }
}
@end
