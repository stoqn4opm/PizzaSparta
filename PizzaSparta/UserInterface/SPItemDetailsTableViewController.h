//
//  SPItemDetailsTableViewController.h
//  PizzaSparta
//
//  Created by Stoqn Stoqnov on 6/6/15.
//  Copyright (c) 2015 MentorMate Academy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Product+Modify.h"

@interface SPItemDetailsTableViewController : UITableViewController
@property (nonatomic, strong) Product *selectedProduct;
@property (nonatomic) NSInteger currentAmount;

@end
