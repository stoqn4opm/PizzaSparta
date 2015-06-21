//
//  SPOrderHistoryTableViewCell.h
//  PizzaSparta
//
//  Created by Stoqn Stoqnov on 6/18/15.
//  Copyright (c) 2015 MentorMate Academy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserOrders.h"

@interface SPOrderHistoryTableViewCell : UITableViewCell

-(void)configureWithOrder:(UserOrders*)order;
@end
