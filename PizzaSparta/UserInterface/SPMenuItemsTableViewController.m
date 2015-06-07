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
@end

@implementation SPMenuItemsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.fetchController performFetch:nil];
    
    [self prepareUI];
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

#pragma mark - Navigation
-(void)prepareForSegue:(UIStoryboardSegue *)segue
                sender:(id)sender{
    
    Product *selectedProduct = [self.fetchController objectAtIndexPath:self.selectedIndexPath];
    [[segue destinationViewController] setSelectedProduct:selectedProduct];
    NSLog(@"Not yet implemented");
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
@end
