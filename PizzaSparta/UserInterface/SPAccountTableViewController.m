//
//  SPAccountTableViewController.m
//  PizzaSparta
//
//  Created by Stoqn Stoqnov on 6/18/15.
//  Copyright (c) 2015 MentorMate Academy. All rights reserved.
//

#import "SPAccountTableViewController.h"
#import "UIViewController+SPCustomNavControllerSetup.h"
#import "SPDatabaseManager.h"
#import "SPUIHeader.h"
#import "SPAutoLoginTableViewCell.h"
#import "SPOrderHistoryTableViewCell.h"
#import "SPUserInfoTableViewCell.h"

@interface SPAccountTableViewController () <SPAutoLoginTableViewCellDelegate>
@property (nonatomic, strong) NSArray __block *allOrdersHistory;
@property (nonatomic, strong) NSArray *userInfo;
@property (nonatomic)NSInteger selectedRow;
@end

@implementation SPAccountTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNavigationBarBackground];
    [self setUpImageBackButton];
    [self setupSpartaLabel];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    refreshControl.tintColor = [UIColor greenColor];
    [refreshControl addTarget:self action:@selector(startReload) forControlEvents:UIControlEventValueChanged];
    self.refreshControl = refreshControl;
    
    _userInfo=[[NSArray alloc] initWithArray:[[SPManager sharedManager] getUserInfoAsArray]];
   
    [self getAllOrdersForUser];
    
}

#pragma mark - <UITableViewDataSource> Methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    }
    else if (section == 1) {
        return [self.userInfo count];
    }
    if(self.allOrdersHistory.count<1){
        return 0;
    }
    return self.allOrdersHistory.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView
        cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        SPAutoLoginTableViewCell *loginCell = [tableView dequeueReusableCellWithIdentifier:@"SPAutoLoginCell" forIndexPath:indexPath];
        [loginCell setDelegate:self];
        [loginCell configure];
        return loginCell;
        
    }
    else if(indexPath.section == 1){
        SPUserInfoTableViewCell *infoCell = [tableView dequeueReusableCellWithIdentifier:@"SPUserInfoCell" forIndexPath:indexPath];
        
        if(indexPath.row == 0){
            [infoCell configureWithString:[NSString stringWithFormat:@"UserName:  %@",self.userInfo[indexPath.row]]];
        }
        else if(indexPath.row == 1){
            [infoCell configureWithString:[NSString stringWithFormat:@"Name:   %@",self.userInfo[indexPath.row]]];
        }
        else{
            [infoCell configureWithString:self.userInfo[indexPath.row]];
        }
        
        
        return infoCell;
        
    }else if(self.allOrdersHistory.count>0){
        SPOrderHistoryTableViewCell *orderCell = [tableView dequeueReusableCellWithIdentifier:@"orderCell" forIndexPath:indexPath];
        [orderCell configureWithOrder:self.allOrdersHistory[indexPath.row]];
        return orderCell;
    }
    return nil;
}

#pragma mark - <UITableViewDelegate> Methods
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 40)];
    
    
    UIImageView *headerImage = [[UIImageView alloc]
                                initWithFrame:CGRectMake(0, 0, header.frame.size.width, 30)];
    
    if (section == 0) {
        [headerImage setImage:[UIImage imageNamed:@"AutoLoginLabel"]];
    }
    else if(section == 1){
        [headerImage setImage:[UIImage imageNamed:@"AccountLabel"]];
    }
    else{
        [headerImage setImage:[UIImage imageNamed:@"OrderHistoryLabel"]];
    }
    [headerImage setBackgroundColor:SPCOLOR_GREEN];
    [headerImage setContentMode:UIViewContentModeScaleAspectFit];
    [headerImage setUserInteractionEnabled:YES];
    
    UIView *brownLine = [[UIView alloc]
                         initWithFrame:CGRectMake(0, 30, header.frame.size.width, 2)];
    
    [brownLine setBackgroundColor:SPCOLOR_DARK_BROWN];
    [header addSubview:headerImage];
    [header addSubview:brownLine];
    return header;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section == 1){
        if(indexPath.row ==2){
            [self performSegueWithIdentifier:@"showAddressesTVC" sender:nil];
        }
    }
    if(indexPath.section == 2){
        
        self.selectedRow=indexPath.row;

        [self performSegueWithIdentifier:@"showDetailsOrder" sender:nil];
    }
}

-(CGFloat)tableView:(UITableView *)tableView
heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}
#pragma mark - Order History
-(void)getAllOrdersForUser{
    
    [[SPDatabaseManager sharedDatabaseManager]
     allOrdersWithType:ORDER_TYPE_ALL
     completion:^(NSArray* array){
     
         if(array){
            [[[SPManager sharedManager] loggedUser] readAllOrders:array];
            self.allOrdersHistory = [[[SPManager sharedManager] loggedUser] orders];
            [self.tableView reloadData];
            [self.refreshControl endRefreshing];
        }else{
            NSLog(@"not found");
        }
    }];
}

#pragma mark - User Actions
-(void)logOutAction{
    
    [self.tabBarController dismissViewControllerAnimated:YES completion:^{
        if ([[SPManager sharedManager] isUserLogIn]) {
            [[SPManager sharedManager] clearLoggedAccounts];
            [[SPManager sharedManager] setLoggedUser:nil];
            [[SPManager sharedManager] setIsUserLogIn:NO];
        }
    }];
}

#pragma mark Order History Actions
-(void)startReload{
    [NSTimer scheduledTimerWithTimeInterval:10.0
                                     target:self
                                   selector:@selector(endReload)
                                   userInfo:nil
                                    repeats:NO];
    [self getAllOrdersForUser];
}

-(void)endReload{
    [self.refreshControl endRefreshing];
}

#pragma mark - <SPAutoLoginTableViewCellDelagate> Methods
-(void)dismissToLogin{
    [self.tabBarController dismissViewControllerAnimated:YES completion:nil];
}


-(void)prepareForSegue:(UIStoryboardSegue *)segue
                sender:(id)sender{
    
    if([[segue identifier]isEqualToString:@"showDetailsOrder"]){
        NSLog(@"%ld", (long)[sender section]);
        NSLog(@"%ld", (long)self.selectedRow);
            [[[SPManager sharedManager] loggedUser] setCurrentOrderDetails:nil];
            [[[SPManager sharedManager] loggedUser] setCurrentOrderDetails:[[self.allOrdersHistory objectAtIndex:self.selectedRow] products]];
            for(id element in [[[SPManager sharedManager] loggedUser] currentOrderDetails]){
                NSLog(@"%@", [element valueForKey:@"title"]);
            }
        
    }
}
@end

