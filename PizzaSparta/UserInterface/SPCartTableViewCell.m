//
//  SPCartTableViewCell.m
//  PizzaSparta
//
//  Created by Stoyan Stoyanov on 6/16/15.
//  Copyright (c) 2015 MentorMate Academy. All rights reserved.
//

#import "SPCartTableViewCell.h"
#import "SPManager.h"

@interface SPCartTableViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView __block *cellImage;
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblAmountIncart;

@end

@implementation SPCartTableViewCell

#pragma mark - Cell Configuration
-(void)configureCartCellWithProduct:(Product *)product andAmount:(NSNumber *)amount{
    
    [self.lblTitle setText:product.title];
    [self.lblAmountIncart setText:[NSString stringWithFormat:@"%@",amount]];
    [[[SPManager sharedManager] uiOperationQueue] addOperationWithBlock:^{
        
        NSData *imgData = [NSData dataWithContentsOfURL:[NSURL URLWithString:product.photoURL]];
        
        [[NSOperationQueue mainQueue]addOperationWithBlock:^{
            [self.cellImage setImage:[UIImage imageWithData:imgData]];
        }];
    }];
}
@end
