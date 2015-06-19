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

@interface SPItemDetailsTableViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *lblName;
@property (weak, nonatomic) IBOutlet UITextView *lblDescription;
@property (weak, nonatomic) IBOutlet UITextField *txtAmmount;
@property (weak, nonatomic) IBOutlet UILabel *lblCurrency;
@property (weak, nonatomic) IBOutlet UIView *priceBackgroundView;
@property (weak, nonatomic) IBOutlet UIImageView *imgMinus;
@property (weak, nonatomic) IBOutlet UIImageView *imgPlus;
@property (weak, nonatomic) IBOutlet UILabel *lblPrice;

@end

@implementation SPItemDetailsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.lblName setText:self.selectedProduct.title];
    [self.lblDescription setText:self.selectedProduct.productDesc];
    [self.lblPrice setText:[NSString stringWithFormat:@"%@",self.selectedProduct.price]];
    [self currentAmout: [[SPManager sharedManager] amountForProductInCart: self.selectedProduct withSize: @"Large"]];
//#warning TODO Load image in background thread
//    NSData  *image = [NSData dataWithContentsOfURL:[self.selectedProduct urlPhoto]];
//    [self.imageView setImage:[UIImage imageWithData:image]];
    
    
    [self prepareUI];
}

- (void) currentAmout:(NSInteger)currentAmount{
    self.currentAmount = currentAmount;
    self.txtAmmount.text = [NSString stringWithFormat: @"%ld", self.currentAmount];
}

- (void)prepareUI{
    dispatch_async(dispatch_get_global_queue(0,0), ^{
        NSData * data = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString: self.selectedProduct.photoURL]];
        if ( data == nil )
            return;
        dispatch_async(dispatch_get_main_queue(), ^{
            self.imageView.image = [UIImage imageWithData: data];
        });
    });
    [self.navigationItem setTitle:@""];
    [self shoppingCartActionsInit];
    [self setUpImageBackButton];
    
    [self.priceBackgroundView.layer setCornerRadius:SPCORNER_RADIUS];
    [self.priceBackgroundView setClipsToBounds:YES];
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
        //        self.lblAmmount.text = [NSString stringWithFormat:@"%ld",(unsigned long)--self.currentAmount];
        //        [[SPManager sharedManager]addProductToCart:_currentProduct amount:-1];
        [self currentAmout: self.currentAmount -1];
        NSMutableDictionary* product = [[NSMutableDictionary alloc] init];
        [product setValue: self.selectedProduct forKey: @"Product"];
        [product setValue: @(-1) forKey: @"Amount"];
        [product setValue: @"Large" forKey: @"Size"];
        [[SPManager sharedManager] addProductToCart: product];
    }
}


-(void) plusPressed{
    
    [self.imgPlus setAlpha:0];
    
    [UIView animateWithDuration:0.3 animations:^{
        [self.imgPlus setAlpha:1];
    }];
    [self currentAmout: self.currentAmount +1];

    if (self.currentAmount > 0) {
        //        self.lblAmmount.text = [NSString stringWithFormat:@"%ld",(unsigned long)--self.currentAmount];
        //        [[SPManager sharedManager]addProductToCart:_currentProduct amount:-1];
        NSMutableDictionary* product = [[NSMutableDictionary alloc] init];
        [product setValue: self.selectedProduct forKey: @"Product"];
        [product setValue: @(1) forKey: @"Amount"];
        [product setValue: @"Large" forKey: @"Size"];
        [[SPManager sharedManager] addProductToCart: product];
    }
}

@end
