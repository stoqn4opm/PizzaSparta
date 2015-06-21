//
//  SPIngredientsCell.h
//  PizzaSparta
//
//  Created by Petar Kanev on 6/15/15.
//  Copyright (c) 2015 MentorMate Academy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Ingredient.h"

@interface SPIngredientsCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UISwitch   *includeSwitch;
@property (strong, nonatomic) Ingredient        *ingredient;

@end
