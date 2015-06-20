//
//  SPIngredientsCell.m
//  PizzaSparta
//
//  Created by Petar Kanev on 6/15/15.
//  Copyright (c) 2015 MentorMate Academy. All rights reserved.
//

#import "SPIngredientsCell.h"

@interface SPIngredientsCell ()
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UILabel *priceLabel;

@end

@implementation SPIngredientsCell

- (void) setIngredient:(Ingredient *)ingredient{
    _ingredient = ingredient;
    self.nameLabel.text = _ingredient.name;
    self.priceLabel.text = [NSString stringWithFormat: @"+ %.2f BGN", _ingredient.priceIngredient];
    [self.includeSwitch setOn: _ingredient.isIncluded];
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
