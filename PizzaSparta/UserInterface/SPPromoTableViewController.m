//
//  SPPromoTableViewController.m
//  PizzaSparta
//
//  Created by Stoqn Stoqnov on 6/4/15.
//  Copyright (c) 2015 MentorMate Academy. All rights reserved.
//

#import "SPPromoTableViewController.h"
#import <CoreData/CoreData.h>
#import "SPItemTableViewCell.h"
#import "SPItemDetailsTableViewController.h"
#import "SPManager.h"
#import "UIViewController+SPCustomNavControllerSetup.h"
#import "SPPromoTableViewCell.h"

@interface SPPromoTableViewController () <NSFetchedResultsControllerDelegate>
@property (nonatomic, strong) NSFetchedResultsController *fetchController;
@property (nonatomic, strong) NSIndexPath *selectedIndexPath;

@end

@implementation SPPromoTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupNavigationBarBackground];
    
    [self.navigationItem
     setTitleView:[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"PromoLabel"]]];
    [self.fetchController performFetch:nil];
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
    SPPromoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SPItemTableViewCell"
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
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"isPromo == %@", @TRUE];
    [fetchRequest setPredicate:predicate];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"title"
                                                                   ascending:YES];
    [fetchRequest setSortDescriptors:@[sortDescriptor]];
    
    _fetchController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                                           managedObjectContext:uiContext
                                                             sectionNameKeyPath:nil
                                                                      cacheName:nil];
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
            [self.tableView insertRowsAtIndexPaths:@[newIndexPath]
                                  withRowAnimation:UITableViewRowAnimationFade];
            break;
        }
        case NSFetchedResultsChangeDelete: {
            [self.tableView deleteRowsAtIndexPaths:@[indexPath]
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
            [self.tableView deleteRowsAtIndexPaths:@[indexPath]
                                  withRowAnimation:UITableViewRowAnimationFade];
            [self.tableView insertRowsAtIndexPaths:@[newIndexPath]
                                  withRowAnimation:UITableViewRowAnimationFade];
            break;
        }
    }
}
@end
