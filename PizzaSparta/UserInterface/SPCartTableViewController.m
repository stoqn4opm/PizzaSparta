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

@property (nonatomic, strong) UIImageView *sendOrderLabel;
@end

@implementation SPCartTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
 // nesum siguren 4e trqbva   self.tableView.allowsMultipleSelectionDuringEditing = NO;

    
    [self prepareUI];
}
-(void)viewWillAppear:(BOOL)animated{
    [self.tableView reloadData];
}

-(void) prepareUI{
    [self setupNavigationBarBackground];
    [self.navigationItem
     setTitleView:[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"CartLabel"]]];
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

-(void)makeOrder{
    
    [self.sendOrderLabel setAlpha:0];
    [UIView animateWithDuration:0.3 animations:^{
        [self.sendOrderLabel setAlpha:1.0];
    }];
    
    if([[[SPManager sharedManager] cart]count] < 1){
        [SPUIHeader alertViewWithType:SPALERT_TYPE_EMPTY_CART];
    }
    else{
        [[SPDatabaseManager sharedDatabaseManager]
         createNewOrderForAddressWithId:[[[[SPManager sharedManager] loggedUser]addresses] lastObject]
         withProducts:[[SPManager sharedManager] cart]
         WithCompletion:^(NSString* status){
         
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

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 30)];
    
    self.sendOrderLabel = [[UIImageView alloc]
                                   initWithFrame:CGRectMake(0, 0, header.frame.size.width, 30)];
    
    [self.sendOrderLabel setBackgroundColor:SPCOLOR_GREEN];
    [self.sendOrderLabel setImage:[UIImage imageNamed:@"SendOrderLabel"]];
    [self.sendOrderLabel setContentMode:UIViewContentModeScaleAspectFit];
    [self.sendOrderLabel setUserInteractionEnabled:YES];
    [header addSubview:self.sendOrderLabel];
    
    UITapGestureRecognizer *sendOrderTapped = [[UITapGestureRecognizer alloc]
                                                 initWithTarget:self
                                                 action:@selector(makeOrder)];
    [sendOrderTapped setNumberOfTapsRequired:1];
    [sendOrderTapped setNumberOfTouchesRequired:1];
    
    [self.sendOrderLabel addGestureRecognizer:sendOrderTapped];
    return header;
}

@end