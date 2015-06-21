//
//  SPAddressesTableViewController.m
//  PizzaSparta
//
//  Created by Student03 on 6/20/15.
//  Copyright (c) 2015 MentorMate Academy. All rights reserved.
//

#import "SPAddressesTableViewController.h"
#import "UIViewController+SPCustomNavControllerSetup.h"
#import "SPManager.h"
#import "SPUIHeader.h"
#import "SPUserAddressTableViewCell.h"

@interface SPAddressesTableViewController ()<UIAlertViewDelegate>

@property(nonatomic, strong)NSMutableArray* currentAddresses;
@end

@implementation SPAddressesTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNavigationBarBackground];
    [self setUpImageBackButton];
    [self setupSpartaLabel];
    [self getUserAddresses];
    [self prepareUI];
}

- (void)prepareUI{
    
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    UIButton *addAdressButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 26, 26)];
    [addAdressButton setBackgroundImage:[UIImage imageNamed:@"PlusLabel"] forState:UIControlStateNormal];
    UIBarButtonItem *addAdressBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:addAdressButton];
    [addAdressButton addTarget:self action:@selector(addNewAddress) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = addAdressBarButtonItem;
}

#pragma mark - <UITableViewDataSource> Methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(self.currentAddresses.count <1){
        return 0;
    }
    return self.currentAddresses.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView
        cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(self.currentAddresses.count < 1){
        return nil;
    }
    
    SPUserAddressTableViewCell *addressCell = [tableView
                                               dequeueReusableCellWithIdentifier:@"SPUserSingleAddress"
                                               forIndexPath:indexPath];
    
    [addressCell configureAddressLabel:(self.currentAddresses)[indexPath.row]];
    return addressCell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView
commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        if(self.currentAddresses.count>1){
            [self reloadTableContentAfterDeleteAddress:self.currentAddresses[indexPath.row]];
            [self.currentAddresses removeObjectAtIndex:indexPath.row];
            [self.tableView reloadData];
        }
        else{
            [SPUIHeader alertViewWithType:SPALERT_TYPE_ADDRESS_DELETE_LAST];
            [self.tableView reloadData];
        }
    }
}

#pragma mark - <UITableViewDelegate> Methods
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 40)];
    
    UIImageView *headerImage = [[UIImageView alloc]
                                initWithFrame:CGRectMake(0, 0, header.frame.size.width, 30)];
    
    
    [headerImage setImage:[UIImage imageNamed:@"AccountLabel"]];
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


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}

-(void)getUserAddresses{
    [self.currentAddresses removeAllObjects];
    self.currentAddresses = [[NSMutableArray alloc]initWithArray:[[[SPManager sharedManager] loggedUser] addresses]];
}

-(void)reloadTableContentAfterDeleteAddress:(UserAdress*) chaddress{
    [[SPManager sharedManager] deleteForCurrentUserAddress:chaddress completion:^(NSString* status){
        if(![status isEqualToString:@"success"]){
            [self reloadTableViewDate];
            [SPUIHeader alertViewWithType:SPALERT_TYPE_ADDRESS_DELETE_ERROR];
        }
        
    }];
}


-(void)addNewAddress{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Add new address" message:@" ex. Sofia Motevideo 25" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Save", nil] ;
    alertView.tag = 2;
    alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
    [alertView show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    UITextField * alertTextFieldNewAddress = [alertView textFieldAtIndex:0];
    if ([alertTextFieldNewAddress.text isEqualToString:@""]){
        return;
    }
    else if([[[SPManager sharedManager] loggedUser] checkIfAddressExist:alertTextFieldNewAddress.text]){
        [SPUIHeader alertViewWithType:SPALERT_TYPE_ADDRESS_EXIST];
        return;
    }
    else{
        [[SPManager sharedManager] addForCurrentUserNewAddress:alertTextFieldNewAddress.text];
        [NSTimer scheduledTimerWithTimeInterval:5.0 target:self selector:@selector(reloadTableViewDate) userInfo:nil repeats:NO];
    }
}

-(void)reloadTableViewDate{
    [self getUserAddresses];
    [self.tableView reloadData];
}
@end
