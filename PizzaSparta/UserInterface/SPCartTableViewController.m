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

@interface SPCartTableViewController ()<UIActionSheetDelegate, UIAlertViewDelegate>

@property (nonatomic, strong) UIImageView *sendOrderLabel;
@end

@implementation SPCartTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
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
    
    Product *currProduct = [[[SPManager sharedManager]cart][indexPath.row] valueForKey: @"Product"];
    NSNumber *amount     = [[[SPManager sharedManager]cart][indexPath.row] valueForKey: @"Amount"];
    
    [cell configureCartCellWithProduct:currProduct andAmount:amount];
    
    return cell;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 30)];
    
    self.sendOrderLabel = [[UIImageView alloc]
                           initWithFrame:CGRectMake(0, 0, header.frame.size.width, 30)];
    
    [self.sendOrderLabel setBackgroundColor:SPCOLOR_RED];
    if ([[[SPManager sharedManager]cart]count] > 0) {
        
        [self.sendOrderLabel setImage:[UIImage imageNamed:@"SendOrderLabel"]];
    }else{
        [self.sendOrderLabel setImage:[UIImage imageNamed:@"EmptyLabel"]];
    }
    [self.sendOrderLabel setContentMode:UIViewContentModeScaleAspectFit];
    [self.sendOrderLabel setUserInteractionEnabled:YES];
    [header addSubview:self.sendOrderLabel];
    
    UITapGestureRecognizer *sendOrderTapped = [[UITapGestureRecognizer alloc]
                                               initWithTarget:self
                                               action:@selector(showActionSheetChooseAddress)];
    [sendOrderTapped setNumberOfTapsRequired:1];
    [sendOrderTapped setNumberOfTouchesRequired:1];
    
    [self.sendOrderLabel addGestureRecognizer:sendOrderTapped];
    return header;
}

#pragma mark - <UITableViewDelegate> Methods
-(BOOL) tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == [[[SPManager sharedManager] cart] count]) {
        return NO;
    }
    return YES;
}

-(void) tableView:(UITableView *)tableView
commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [[[SPManager sharedManager] cart] removeObjectAtIndex: indexPath.row];
        [self.tableView deleteRowsAtIndexPaths: @[indexPath] withRowAnimation: YES];
    }
    [self.tableView reloadData];
}

#pragma mark - User Actions
-(void)showActionSheetChooseAddress{
    
    [self.sendOrderLabel setAlpha:0];
    [UIView animateWithDuration:0.3 animations:^{
        [self.sendOrderLabel setAlpha:1.0];
    }];
    if (![[SPManager sharedManager] isUserLogIn]) {
        [SPUIHeader alertViewWithType:SPALERT_TYPE_ERROR_ORDER_NOT_LOGGED_IN];
        return;
    }
    if([[[SPManager sharedManager] cart]count] < 1){
        [SPUIHeader alertViewWithType:SPALERT_TYPE_EMPTY_CART];
        return;
    }
    
    NSString* actionSheetTitle  = @"Choose order address";
    NSString* destructiveTitle  = @"Delete products from cart";
    NSString* addNewAddress     = @"Add new address";
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                  initWithTitle:actionSheetTitle
                                  delegate:self
                                  cancelButtonTitle:nil
                                  destructiveButtonTitle:nil
                                  otherButtonTitles: nil];
    
    [actionSheet addButtonWithTitle:addNewAddress];
    
    if([[[[SPManager sharedManager] loggedUser] addresses] count]>0){
        
        for (UserAdress *element in [[[SPManager sharedManager] loggedUser] addresses]) {
            [actionSheet addButtonWithTitle:[element address]];
        }
    }
    
    actionSheet.destructiveButtonIndex = [actionSheet addButtonWithTitle:destructiveTitle];
    actionSheet.cancelButtonIndex = [actionSheet addButtonWithTitle:@"Cancel"];
    
    [actionSheet showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if([actionSheet cancelButtonIndex] == buttonIndex){
        NSLog(@"cancel");
    }
    else if([actionSheet destructiveButtonIndex] == buttonIndex){
        [[[SPManager sharedManager] cart] removeAllObjects];
        [self.tableView reloadData];
    }
    else if(buttonIndex == 0){
        NSLog(@"add address");
        [self addNewAddress];
    }
    else if(buttonIndex - 1 < [[[[SPManager sharedManager] loggedUser] addresses] count]){
        UserAdress* currentAddr = [[[SPManager sharedManager] loggedUser] addresses][(buttonIndex - 1)];
        [self makeOrderWithAddressId:currentAddr];
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 40)];
    
    UILabel *totalLabel=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, header.frame.size.width, 40)];
    [totalLabel setBackgroundColor:SPCOLOR_DARK_BROWN];
    [totalLabel setTintColor:[UIColor whiteColor]];
    [totalLabel setText:[NSString stringWithFormat:@"Total: %.2f", [[SPManager sharedManager] cartTotal]]];
    [totalLabel setTextAlignment:NSTextAlignmentCenter];
    [totalLabel setFont:[UIFont fontWithName:@"Papyrus" size:22]];
    //[headerImage setContentMode:UIViewContentModeScaleAspectFit];
    //[headerImage setUserInteractionEnabled:YES];
    
    UIView *greenLine = [[UIView alloc]
                         initWithFrame:CGRectMake(0, 37, header.frame.size.width, 5)];
    
    [greenLine setBackgroundColor:SPCOLOR_GREEN];
    [header addSubview:totalLabel];
    [header addSubview:greenLine];
    return header;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 40;
}
- (void)makeOrderWithAddressId:(UserAdress*)currentAddress{
    
    [[SPDatabaseManager sharedDatabaseManager]
     createNewOrderForAddressWithId:currentAddress
     withProducts:[[SPManager sharedManager] cart]
     withCompletion:^(NSString* status){
         
        if([status isEqualToString:@"success"]){
            [SPUIHeader alertViewWithType:SPALERT_TYPE_SUCCESS_ORDER];
            [[SPManager sharedManager] getAllOrdersForUser];
            [[[SPManager sharedManager] cart] removeAllObjects];
            [self.tableView reloadData];
        }
        else{
            [SPUIHeader alertViewWithType:SPALERT_TYPE_ORDER_ERROR];
        }
    }];
}

-(void)addNewAddress{
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Add new address"
                                                        message:@" ex. Sofia Motevideo 25"
                                                       delegate:self
                                              cancelButtonTitle:@"Cancel"
                                              otherButtonTitles:@"Save", nil];
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
    }
}
@end
