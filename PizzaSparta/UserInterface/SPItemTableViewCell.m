//
//  SPItemTableViewCell.m
//  PizzaSparta
//
//  Created by Stoqn Stoqnov on 6/6/15.
//  Copyright (c) 2015 MentorMate Academy. All rights reserved.
//

#import "SPItemTableViewCell.h"
#import "SPUIHeader.h"

@interface SPItemTableViewCell ()
@property (nonatomic, weak) IBOutlet UILabel *lblName;
@property (nonatomic, weak) IBOutlet UITextView *lblDesc;
@property (nonatomic, weak) IBOutlet UILabel *lblPrice;
@property (weak, nonatomic) IBOutlet UILabel *lblCurrency;

@end

@implementation SPItemTableViewCell

- (void)configureItemCell :(Product *)product{
    
    [self.lblName setText:[product title]];
    [self.lblPrice setText:[NSString stringWithFormat:@"%@", [product price]]];
    [self.lblDesc setText:[product productDesc]];
    [self.lblDesc.layer setCornerRadius:SPCORNER_RADIUS];
    [self.lblDesc setClipsToBounds:YES];
    
    // Currency for now is hardcoded
    [self.lblCurrency setText:@"BGN"];
}
@end
