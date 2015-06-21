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
#import "AsyncImageView.h"

@interface SPItemTableViewCell ()
@property (nonatomic, weak) IBOutlet UITextView *lblName;
@property (weak, nonatomic) IBOutlet UIImageView __block *productImage;
@property (nonatomic, weak) IBOutlet UILabel *lblPrice;
@property (weak, nonatomic) IBOutlet UILabel *lblCurrency;
@property (weak, nonatomic) IBOutlet UIImageView *imgMinus;
@property (weak, nonatomic) IBOutlet UIImageView *imgPlus;
@property (weak, nonatomic) IBOutlet UILabel *lblAmmount;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentLargeMedium;
@property (weak, nonatomic) IBOutlet UIImageView *priceCournerImageView;

@property (strong, nonatomic) Product *currentProduct;
@end

@implementation SPItemTableViewCell
#pragma mark - Cell Configuration
- (void)configureItemCell :(Product *)product{
    
    [self.lblName setText:[product title]];
    [self.lblPrice setText:[NSString stringWithFormat:@"%@", [product price]]];
    [self.lblAmmount setText:@""];
    [self setupUserInteraction];
    [self.segmentLargeMedium addTarget: self action: @selector(changedValue) forControlEvents: UIControlEventValueChanged];
    [self.segmentLargeMedium setSelectedSegmentIndex: 1];
    // Currency for now is hardcoded
    [self.lblCurrency setText:@"BGN"];
    
    NSString *size;
    if (self.segmentLargeMedium.selectedSegmentIndex == 0) {
       size = @"Medium";
    }else if (self.segmentLargeMedium.selectedSegmentIndex == 1){
       size = @"Large";
    }
    [self currentAmount:[[SPManager sharedManager] amountForProductInCart:product withSize:size]];
    self.lblName.font = [UIFont fontWithName:@"Chalkboard SE" size:25];
    [self.lblName setTextColor:[UIColor whiteColor]];
    self.segmentLargeMedium.layer.cornerRadius = 4;
    self.currentProduct = product;
    [self.productImage setImageURL:[NSURL URLWithString:self.currentProduct.photoURL]];
    if ([self.currentProduct.type isEqualToString: SPPasta] || [self.currentProduct.type isEqualToString: SPDrinks]) {
        [self.segmentLargeMedium removeSegmentAtIndex: 1 animated: NO];
        [self.segmentLargeMedium setSelectedSegmentIndex: 0];
        [self.segmentLargeMedium setTitle: @"One size" forSegmentAtIndex: 0];
    }
}

- (void) currentAmount:(NSInteger)currentAmount{
    self.currentAmount = currentAmount;
    self.lblAmmount.text = [NSString stringWithFormat: @"%ld", (long)self.currentAmount];
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
    
    if (self.currentAmount > 0) {

        [self currentAmount: self.currentAmount -1];
        NSMutableDictionary* product = [[NSMutableDictionary alloc] init];
        [product setValue: self.currentProduct forKey: @"Product"];
        [product setValue: @(-1) forKey: @"Amount"];
        if (self.segmentLargeMedium.selectedSegmentIndex == 0) {
            [product setValue:@"Medium" forKey:@"Size"];
        }else if (self.segmentLargeMedium.selectedSegmentIndex == 1){
            [product setValue: @"Large" forKey: @"Size"];
        }
        [[SPManager sharedManager] addProductToCart: product];
    }
}

- (void)plusTapped{

    [self.imgPlus setAlpha:0];
    
    [UIView animateWithDuration:0.3 animations:^{
        [self.imgPlus setAlpha:1];
    }];
    
    self.lblAmmount.text = [NSString stringWithFormat:@"%ld",(unsigned long)++self.currentAmount];
    NSMutableDictionary* product = [[NSMutableDictionary alloc] init];
    [product setValue: self.currentProduct forKey: @"Product"];
    [product setValue: @(1) forKey: @"Amount"];
    
    if (self.segmentLargeMedium.selectedSegmentIndex == 0) {
        [product setValue:@"Medium" forKey:@"Size"];
    }else if (self.segmentLargeMedium.selectedSegmentIndex == 1){
        [product setValue: @"Large" forKey: @"Size"];
    }
    [[SPManager sharedManager] addProductToCart: product];

}

- (void) changedValue{
    self.lblAmmount.text = [NSString stringWithFormat: @"%ld",(long)[[SPManager sharedManager] amountForProductInCart:self.currentProduct withSize: [self.segmentLargeMedium titleForSegmentAtIndex: self.segmentLargeMedium.selectedSegmentIndex]]];
    if (self.segmentLargeMedium.selectedSegmentIndex == 0) {
        self.lblPrice.text = [NSString stringWithFormat: @"%ld", [self.currentProduct.price longValue] - 3];
    }else
        self.lblPrice.text = [NSString stringWithFormat: @"%ld", [self.currentProduct.price longValue]];
}

@end
