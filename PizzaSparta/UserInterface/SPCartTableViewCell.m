//
//  SPCartTableViewCell.m
//  PizzaSparta
//
//  Created by Stoyan Stoyanov on 6/16/15.
//  Copyright (c) 2015 MentorMate Academy. All rights reserved.
//

#import "SPCartTableViewCell.h"
#import "SPManager.h"
#import "AsyncImageView.h"

@interface SPCartTableViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView __block *cellImage;
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblAmountIncart;

@end

@implementation SPCartTableViewCell

#pragma mark - Cell Configuration
- (void)configureCartCellWithProduct:(id) product andAmount:(NSNumber *) amount{

    if ([product isKindOfClass: [Product class]]) {
        [self.lblTitle setText: [product title]];
        [self.cellImage setImageURL:[NSURL URLWithString:[product photoURL]]];
    }
    else{
        [self.lblTitle setText: @"Custom pizza"];
        [self.cellImage setImage: [UIImage imageNamed: @"PizzaImage"]];
    }
    [self.lblAmountIncart setText:[NSString stringWithFormat:@"%@",amount]];
   }

@end
