//
//  SPUserAddressTableViewCell.h
//  PizzaSparta
//
//  Created by Student03 on 6/20/15.
//  Copyright (c) 2015 MentorMate Academy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserAdress.h"

@interface SPUserAddressTableViewCell : UITableViewCell

- (void) configureAddressLabel:(UserAdress*) address;
@end
