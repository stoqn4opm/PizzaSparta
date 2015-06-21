//
//  SPItemDetailsTableViewController.m
//  PizzaSparta
//
//  Created by Stoqn Stoqnov on 6/6/15.
//  Copyright (c) 2015 MentorMate Academy. All rights reserved.
//

#import "SPItemDetailsTableViewController.h"
#import "SPUIHeader.h"
#import "UIViewController+SPCustomNavControllerSetup.h"
#import "SPManager.h"
#import "AsyncImageView.h"

@interface SPItemDetailsTableViewController () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIImageView        *imageView;
@property (weak, nonatomic) IBOutlet UILabel            *lblName;
@property (weak, nonatomic) IBOutlet UITextView         *lblDescription;
@property (weak, nonatomic) IBOutlet UITextField        *txtAmmount;
@property (weak, nonatomic) IBOutlet UILabel            *lblCurrency;
@property (weak, nonatomic) IBOutlet UIImageView        *imgMinus;
@property (weak, nonatomic) IBOutlet UIImageView        *imgPlus;
@property (weak, nonatomic) IBOutlet UILabel            *lblPrice;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentLargeMedium;

@end

@implementation SPItemDetailsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.lblName setText:self.selectedProduct.title];
    [self.lblDescription setText:self.selectedProduct.productDesc];
    [self.lblPrice setText:[NSString stringWithFormat:@"%@",self.selectedProduct.price]];
    [self.imageView setImageURL:[self.selectedProduct urlPhoto]];
    [self prepareUI];
}

- (void) currentAmout:(NSInteger)currentAmount{
    self.currentAmount = currentAmount;
    self.txtAmmount.text = [NSString stringWithFormat: @"%ld", (long)self.currentAmount];
}

- (void)prepareUI{
    dispatch_async(dispatch_get_global_queue(0,0), ^{
       
        NSData * data = [[NSData alloc] initWithContentsOfURL: [self.selectedProduct urlPhoto]];
        if ( data == nil )
            return;
        dispatch_async(dispatch_get_main_queue(), ^{
            self.imageView.image = [UIImage imageWithData: data];
        });
    });
    [self.navigationItem setTitle:@""];
    [self shoppingCartActionsInit];
    [self setUpImageBackButton];
    self.txtAmmount.delegate = self;
    [self.segmentLargeMedium addTarget: self
                                action: @selector(changedValue)
                      forControlEvents: UIControlEventValueChanged];
    
    [self updateAmountTF];
}

- (void) changedValue{
    [self updateAmountTF];
    if (self.segmentLargeMedium.selectedSegmentIndex == 0) {
        
        self.lblPrice.text = [NSString stringWithFormat: @"%ld", [self.selectedProduct.price longValue] -3];
    }else
        self.lblPrice.text = [NSString stringWithFormat: @"%ld", [self.selectedProduct.price longValue]];
}

- (void) updateAmountTF{
    self.txtAmmount.text = [NSString stringWithFormat: @"%ld",
                            (long)[[SPManager sharedManager] amountForProductInCart: self.selectedProduct
                                                                           withSize: [self.segmentLargeMedium
                                                                                      titleForSegmentAtIndex: self.segmentLargeMedium.selectedSegmentIndex]]];
}

#pragma mark - Cart Actions
- (void)shoppingCartActionsInit{
    
    UITapGestureRecognizer *minusTap = [[UITapGestureRecognizer alloc]
                                        initWithTarget:self action:@selector(minusPressed)];
    
    [minusTap setNumberOfTapsRequired:1];
    [minusTap setNumberOfTouchesRequired:1];
    [self.imgMinus setUserInteractionEnabled:YES];
    [self.imgMinus addGestureRecognizer:minusTap];
    
    UITapGestureRecognizer *plusTap = [[UITapGestureRecognizer alloc]
                                        initWithTarget:self action:@selector(plusPressed)];
    
    [plusTap setNumberOfTapsRequired:1];
    [plusTap setNumberOfTouchesRequired:1];
    [self.imgPlus setUserInteractionEnabled:YES];
    [self.imgPlus addGestureRecognizer:plusTap];
    
    
    UITapGestureRecognizer *resignKB = [[UITapGestureRecognizer alloc]
                                        initWithTarget:self.txtAmmount
                                        action:@selector(resignFirstResponder)];
    
    [resignKB setNumberOfTapsRequired:1];
    [resignKB setNumberOfTouchesRequired:1];
    [self.view setUserInteractionEnabled:YES];
    [self.view addGestureRecognizer:resignKB];

}

-(void) minusPressed{

    [self.imgMinus setAlpha:0];
    
    [UIView animateWithDuration:0.3 animations:^{
        [self.imgMinus setAlpha:1];
    }];
    
    if (self.currentAmount > 0) {
        [self createOrderForCurrentProduct: @(-1)];
        [self currentAmout: self.currentAmount -1];

    }
}


-(void) plusPressed{
    
    [self.imgPlus setAlpha:0];
    
    [UIView animateWithDuration:0.3 animations:^{
        [self.imgPlus setAlpha:1];
    }];
    [self currentAmout: self.currentAmount +1];

    if (self.currentAmount > 0) {
        [self createOrderForCurrentProduct: @(1)];
    }
}

- (void) createOrderForCurrentProduct: (NSNumber *) amount{
    NSMutableDictionary* product = [[NSMutableDictionary alloc] init];
    [product setValue: self.selectedProduct forKey: @"Product"];
    [product setValue: amount forKey: @"Amount"];
    [product setValue: [self.segmentLargeMedium titleForSegmentAtIndex: [self.segmentLargeMedium selectedSegmentIndex]] forKey: @"Size"];
    [[SPManager sharedManager] addProductToCart: product];
    [self updateAmountTF];

}

#pragma mark - <UITextFieldDelegate>
- (BOOL) textFieldShouldReturn:(UITextField *)textField{
    return YES;
}
- (void)textFieldDidEndEditing:(UITextField *)textField{
    
    NSInteger total = [textField.text integerValue] - [[SPManager sharedManager] amountForProductInCart: self.selectedProduct withSize:[self.segmentLargeMedium titleForSegmentAtIndex: [self.segmentLargeMedium selectedSegmentIndex]]];
    
    [self createOrderForCurrentProduct: @(total)];
}
@end
