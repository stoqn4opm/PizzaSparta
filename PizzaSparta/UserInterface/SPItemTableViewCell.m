//
//  SPItemTableViewCell.m
//  PizzaSparta
//
//  Created by Stoqn Stoqnov on 6/6/15.
//  Copyright (c) 2015 MentorMate Academy. All rights reserved.
//

#import "SPItemTableViewCell.h"
#import "SPUIHeader.h"
#import "SPManager.h"

@interface SPItemTableViewCell ()
@property (nonatomic, weak) IBOutlet UILabel *lblName;
@property (nonatomic, weak) IBOutlet UITextView *lblDesc;
@property (nonatomic, weak) IBOutlet UILabel *lblPrice;
@property (weak, nonatomic) IBOutlet UILabel *lblCurrency;
@property (weak, nonatomic) IBOutlet UIImageView *imgMinus;
@property (weak, nonatomic) IBOutlet UIImageView *imgPlus;
@property (weak, nonatomic) IBOutlet UILabel *lblAmmount;

@property NSUInteger currentAmount;
@property (strong, nonatomic) Product *currentProduct;
@end

@implementation SPItemTableViewCell
#pragma mark - Cell Configuration
- (void)configureItemCell :(Product *)product{
    
    [self.lblName setText:[product title]];
    [self.lblPrice setText:[NSString stringWithFormat:@"%@", [product price]]];
    [self.lblDesc setText:[product productDesc]];
    [self.lblDesc.layer setCornerRadius:SPCORNER_RADIUS];
    [self.lblDesc setClipsToBounds:YES];
    [self.lblAmmount setText:@""];
    [self setupUserInteraction];
    // Currency for now is hardcoded
    [self.lblCurrency setText:@"BGN"];
    
    self.currentAmount = 0;
    self.currentProduct = product;
}

-(void) setupUserInteraction {
    UITapGestureRecognizer *minusTap = [[UITapGestureRecognizer alloc]
                                        initWithTarget:self action:@selector(minusTapped)];
    
    [minusTap setNumberOfTouchesRequired:1];
    [minusTap setNumberOfTapsRequired:1];
    
    [self.imgMinus setUserInteractionEnabled:YES];
    [self.imgMinus addGestureRecognizer:minusTap];
    
    UITapGestureRecognizer *plusTap = [[UITapGestureRecognizer alloc]
                                       initWithTarget:self action:@selector(plusTapped)];
    
    [plusTap setNumberOfTapsRequired:1];
    [plusTap setNumberOfTouchesRequired:1];
    
    [self.imgPlus setUserInteractionEnabled:YES];
    [self.imgPlus addGestureRecognizer:plusTap];
    
}

#pragma mark - Action Handlers
- (void)minusTapped{

    [self.imgMinus setAlpha:0];
    
    [UIView animateWithDuration:0.3 animations:^{
        [self.imgMinus setAlpha:1];
    }];
    
    if (self.lblAmmount.text.intValue > 0) {
        self.lblAmmount.text = [NSString stringWithFormat:@"%ld",(unsigned long)--self.currentAmount];
        [[SPManager sharedManager]addProductToCart:_currentProduct amount:-1];
    }
}

- (void)plusTapped{

    [self.imgPlus setAlpha:0];
    
    [UIView animateWithDuration:0.3 animations:^{
        [self.imgPlus setAlpha:1];
    }];
    
    self.lblAmmount.text = [NSString stringWithFormat:@"%ld",(unsigned long)++self.currentAmount];
    [[SPManager sharedManager] addProductToCart:self.currentProduct amount:1];
}

@end
