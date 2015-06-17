//
//  SPCartTableViewCell.m
//  PizzaSparta
//
//  Created by Stoyan Stoyanov on 6/16/15.
//  Copyright (c) 2015 MentorMate Academy. All rights reserved.
//

#import "SPCartTableViewCell.h"

@interface SPCartTableViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *cellImage;
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblAmountIncart;

@end

@implementation SPCartTableViewCell

#pragma mark - Cell Configuration
-(void)configureCartCellWithProduct:(Product *)product andAmount:(NSNumber *)amount{
    
    [self.lblTitle setText:product.title];
    [self.lblAmountIncart setText:[NSString stringWithFormat:@"%@",amount]];
    NSData *imgData = [NSData dataWithContentsOfURL:[NSURL URLWithString:product.photoURL]];
    [self.cellImage setImage:[UIImage imageWithData:imgData]];
}
@end
