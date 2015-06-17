//
//  SPCartTableViewCell.h
//  PizzaSparta
//
//  Created by Stoyan Stoyanov on 6/16/15.
//  Copyright (c) 2015 MentorMate Academy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Product+Modify.h"

@interface SPCartTableViewCell : UITableViewCell
- (void)configureCartCellWithProduct:(Product *)product andAmount:(NSNumber *) amount;

@end
