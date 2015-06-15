//
//  SPMenuItemsTableViewController.m
//  PizzaSparta
//
//  Created by Stoqn Stoqnov on 6/6/15.
//  Copyright (c) 2015 MentorMate Academy. All rights reserved.
//

#import "SPMenuItemsTableViewController.h"
#import <CoreData/CoreData.h>
#import "SPItemTableViewCell.h"
#import "Product+Modify.h"
#import "SPItemDetailsTableViewController.h"
#import "SPManager.h"
#import "UIViewController+SPImageBackButton.h"

@interface SPMenuItemsTableViewController () <NSFetchedResultsControllerDelegate>
@property (nonatomic, strong) NSFetchedResultsController *fetchController;
@property (nonatomic, strong) NSIndexPath *selectedIndexPath;
@property (nonatomic, strong) UIImageView *createCustomPizza;
@end

@implementation SPMenuItemsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.fetchController performFetch:nil];
    [self prepareUI];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
}

#pragma mark - UI Preparation
-(void) prepareUI{
    
    if ([self.selectedType isEqualToString:SPPizza]) {

        [self.navigationItem
         setTitleView:[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"PizzasTitleLabel"]]];
        
    }else if ([self.selectedType isEqualToString:SPPasta]){

        [self.navigationItem
         setTitleView:[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"PastasTitleLabel"]]];
        
    }else if ([self.selectedType isEqualToString:SPDrinks]){
    
        [self.navigationItem
         setTitleView:[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"DrinksTitleLabel"]]];
    }
    
    // This will remove extra separators from tableview
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self setUpImageBackButton];
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:@"logOut"
                                                                    style:UIBarButtonItemStyleBordered target:self action:@selector(logOutAction)];
    self.navigationItem.rightBarButtonItem = rightButton;
}

#pragma mark - <UITableViewDataSource> Methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [[self.fetchController sections] count];
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
    
    return [[self.fetchController fetchedObjects] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    Product *productEntry = [self.fetchController objectAtIndexPath:indexPath];
    SPItemTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SPItemTableViewCell"
                                                            forIndexPath:indexPath];
    [cell configureItemCell:productEntry];
    return cell;
}

#pragma mark - <UITableViewDelegate> Methods
-(void)tableView:(UITableView *)tableView
    didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    self.selectedIndexPath = indexPath;
    [self performSegueWithIdentifier:@"ShowDetails" sender:nil];
}

-(UIView *)tableView:(UITableView *)tableView
    viewForHeaderInSection:(NSInteger)section{
    
    if (section > 0 ||
        [self.selectedType isEqualToString:SPPasta] ||
        [self.selectedType isEqualToString:SPDrinks] ) {
        return nil;
    }
    
    UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 40)];
    
    
    self.createCustomPizza = [[UIImageView alloc]
                                      initWithFrame:CGRectMake(0, 0, header.frame.size.width, 30)];

    [self.createCustomPizza setBackgroundColor:SPCOLOR_GREEN];
    [self.createCustomPizza setImage:[UIImage imageNamed:@"CreateCustomPizza"]];
    [self.createCustomPizza setContentMode:UIViewContentModeScaleAspectFit];
    [self.createCustomPizza setUserInteractionEnabled:YES];
    
    UIView *brownLine = [[UIView alloc]
                         initWithFrame:CGRectMake(0, 30, header.frame.size.width, 10)];
    
    [brownLine setBackgroundColor:SPCOLOR_DARK_BROWN];
    [header addSubview:self.createCustomPizza];
    [header addSubview:brownLine];
    
    UITapGestureRecognizer *customPizzaTapped = [[UITapGestureRecognizer alloc]
                                                 initWithTarget:self
                                                 action:@selector(createCustomPizzaTapped)];
    [customPizzaTapped setNumberOfTapsRequired:1];
    [customPizzaTapped setNumberOfTouchesRequired:1];
    
    [self.createCustomPizza addGestureRecognizer:customPizzaTapped];
    return header;
}

#pragma mark - Create Custom Pizza Handler
-(void) createCustomPizzaTapped{
    
    [self.createCustomPizza setAlpha:0];
    [UIView animateWithDuration:0.3 animations:^{
        [self.createCustomPizza setAlpha:1.0];
    }];
    NSLog(@"custom pizza");
    //[self performSegueWithIdentifier:@"CustomPizza" sender:nil];
}

#pragma mark - Navigation
-(void)prepareForSegue:(UIStoryboardSegue *)segue
                sender:(id)sender{
    
    Product *selectedProduct = [self.fetchController objectAtIndexPath:self.selectedIndexPath];
    [[segue destinationViewController] setSelectedProduct:selectedProduct];
}

#pragma mark - NSResultsFetchController Init
-(NSFetchedResultsController *)fetchController{

    if (_fetchController) {
        return _fetchController;
    }
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSManagedObjectContext *uiContext = [[SPManager sharedManager]mainUIMOContext];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Product"
                                              inManagedObjectContext:uiContext];
    [fetchRequest setEntity:entity];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"type == %@", self.selectedType];
    [fetchRequest setPredicate:predicate];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"title"
                                                                   ascending:YES];
    [fetchRequest setSortDescriptors:[NSArray arrayWithObjects:sortDescriptor, nil]];
    
    _fetchController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                                           managedObjectContext:uiContext
                                                             sectionNameKeyPath:nil
                                                                      cacheName:@"cache"];
    [_fetchController setDelegate:self];
    return _fetchController;
    
}

#pragma mark - <NSFetchResultsControllerDelegate> Methods
- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
    [self.tableView beginUpdates];
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    [self.tableView endUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller
   didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath
     forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath {
    
    switch (type) {
            
        case NSFetchedResultsChangeInsert: {
            [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath]
                                  withRowAnimation:UITableViewRowAnimationFade];
            break;
        }
        case NSFetchedResultsChangeDelete: {
            [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                                  withRowAnimation:UITableViewRowAnimationFade];
            break;
        }
        case NSFetchedResultsChangeUpdate: {
            Product *product = [self.fetchController objectAtIndexPath:indexPath];
            [(SPItemTableViewCell *)[self.tableView
                                     cellForRowAtIndexPath:indexPath]configureItemCell:product];
            
            break;
        }
        case NSFetchedResultsChangeMove: {
            [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                                  withRowAnimation:UITableViewRowAnimationFade];
            [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath]
                                  withRowAnimation:UITableViewRowAnimationFade];
            break;
        }
    }
}

-(void)logOutAction{
    NSLog(@"click");
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    UIViewController *addAlbumViewController = [mainStoryboard instantiateViewControllerWithIdentifier:@"loginController"];
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:addAlbumViewController];
    [self presentViewController:navController animated:YES completion:^{
        [[SPManager sharedManager] setLoggedUser:nil];
    }];
}
@end
