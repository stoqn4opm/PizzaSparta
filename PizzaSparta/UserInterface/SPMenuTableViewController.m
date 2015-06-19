//
//  SPMenuTableViewController.m
//  PizzaSparta
//
//  Created by Stoqn Stoqnov on 6/4/15.
//  Copyright (c) 2015 MentorMate Academy. All rights reserved.
//

#import "SPMenuTableViewController.h"
#import "SPMenuItemsTableViewController.h"
#import "SPUIHeader.h"
#import "SPManager.h"
#import "UIViewController+SPCustomNavControllerSetup.h"

@interface SPMenuTableViewController ()
@property (nonatomic, strong) SPMenuType *selectedMenuType;
@end

@implementation SPMenuTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self prepareUI];
}

#pragma mark - UI Preparation
-(void) prepareUI{
    
    [self setupNavigationBarBackground];
    
    [self.navigationItem
     setTitleView:[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"MenuLabel"]]];
    
    // This will remove extra separators from tableview
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    if([[SPManager sharedManager] isUserLogIn]){
        UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:@"logOut"
                                                                        style:UIBarButtonItemStyleBordered target:self action:@selector(logOutAction)];
        self.navigationItem.rightBarButtonItem = rightButton;
    }
    else{
        UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:@"logIn"
                                                                        style:UIBarButtonItemStyleBordered target:self action:@selector(logOutAction)];
        self.navigationItem.rightBarButtonItem = rightButton;
    }
}

#pragma mark - <UITableViewDataSource> Methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

#pragma mark - <UITableViewDelegate> Methods
- (void)tableView:(UITableView *)tableView
    didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    switch (indexPath.row) {
        case 0:
            self.selectedMenuType = SPPizza;
            break;
        case 1:
            self.selectedMenuType = SPPasta;
            break;
        case 2:
            self.selectedMenuType = SPDrinks;
        default:
            break;
    }
    [self performSegueWithIdentifier:@"MenuItems" sender:nil];
}

#pragma mark - Navigation
-(void)prepareForSegue:(UIStoryboardSegue *)segue
                sender:(id)sender{
    
    [[segue destinationViewController] setSelectedType:self.selectedMenuType];
}


-(void)logOutAction{
    NSLog(@"click");
    [[SPManager sharedManager] clearLoggedAccounts];
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
@end
