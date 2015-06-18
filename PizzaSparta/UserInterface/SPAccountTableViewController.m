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

@interface SPAccountTableViewController ()
@property (nonatomic, strong) NSArray __block *allOrdersHistory;
@end

@implementation SPAccountTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNavigationBarBackground];
    [self setUpImageBackButton];
    [self setupSpartaLabel];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    [[SPDatabaseManager sharedDatabaseManager]
     getAllOrderstoGet:@"delivered"
     WithCompletion:^(NSArray *array) {
      
         self.allOrdersHistory = array;
    }];
    NSLog(@"Current User History Orders: %@. ", self.allOrdersHistory.description);
}

#pragma mark - <UITableViewDataSource> Methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    }
    return self.allOrdersHistory.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView
        cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        SPAutoLoginTableViewCell *loginCell = [tableView dequeueReusableCellWithIdentifier:@"SPAutoLoginCell" forIndexPath:indexPath];
        [loginCell configure];
        return loginCell;
    }else{
        //return [SPOrderHistoryTableViewCell configureWithOrder:self.allOrdersHistory[indexPath.row]];
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
    }else{
        [headerImage setImage:[UIImage imageNamed:@"OrderHistoryLabel"]];
    }
    [headerImage setBackgroundColor:SPCOLOR_GREEN];
    [headerImage setContentMode:UIViewContentModeScaleAspectFit];
    [headerImage setUserInteractionEnabled:YES];
    
    UIView *brownLine = [[UIView alloc]
                         initWithFrame:CGRectMake(0, 30, header.frame.size.width, 10)];
    
    [brownLine setBackgroundColor:SPCOLOR_DARK_BROWN];
    [header addSubview:headerImage];
    [header addSubview:brownLine];
    return header;
}
-(CGFloat)tableView:(UITableView *)tableView
heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}
@end

