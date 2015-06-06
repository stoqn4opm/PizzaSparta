//
//  SPItemTableViewCell.h
//  PizzaSparta
//
//  Created by Stoqn Stoqnov on 6/6/15.
//  Copyright (c) 2015 MentorMate Academy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Product+Modify.h"

@interface SPItemTableViewCell : UITableViewCell
- (void)configureItemCell :(Product *)product;
@end
