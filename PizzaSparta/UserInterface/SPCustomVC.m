//
//  SPCustomVC.m
//  PizzaSparta
//
//  Created by Petar Kanev on 6/15/15.
//  Copyright (c) 2015 MentorMate Academy. All rights reserved.
//

#import "SPCustomVC.h"
#import "SPIngredientsCell.h"
#import "Ingredient.h"
#import "SPManager.h"
#import "SPCustomPizza.h"
#import "UIViewController+SPCustomNavControllerSetup.h"

#define BASE_PRICE 6

@interface SPCustomVC ()<UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) NSArray           *ingredients;
@property (weak, nonatomic) IBOutlet UILabel    *priceLabel;
@property (nonatomic) float                     totalPrice;

@property (strong, nonatomic) NSArray *layers;
@property (weak, nonatomic) IBOutlet UIImageView *baconLayer;
@property (weak, nonatomic) IBOutlet UIImageView *pepperoniLayer;
@property (weak, nonatomic) IBOutlet UIImageView *olivesLayer;
@property (weak, nonatomic) IBOutlet UIImageView *onionsLayer;
@property (weak, nonatomic) IBOutlet UIImageView *spinachLayer;
@property (weak, nonatomic) IBOutlet UIImageView *pineappleLayer;
@property (weak, nonatomic) IBOutlet UIImageView *imgMinus;
@property (weak, nonatomic) IBOutlet UIImageView *imgPlus;
@property (weak, nonatomic) IBOutlet UILabel     *AmountLabel;

@property (nonatomic) NSInteger productSize;
@property (nonatomic) NSInteger productAmount;
@property (nonatomic) NSInteger sizePrice;
@end

@implementation SPCustomVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUpIngredients];
    [self setupUserInteraction];
    [self setUpLayers];
    
    self.totalPrice = BASE_PRICE;
    [self prepareUI];
    self.productSize = 0;
    self.sizePrice = 0;
    self.productAmount = 1;
    self.AmountLabel.text = @"1";
    [self setTotalPrice:self.totalPrice];
    [self setUpImageBackButton];
}

- (void) setTotalPrice:(float)totalPrice{
    _totalPrice = totalPrice;
   self.priceLabel.text = [NSString stringWithFormat: @"%.2f", (totalPrice*self.productAmount)];
}

- (void)prepareUI{
    
    [self.navigationController setTitle:@"Custom Pizza"];
    [self.navigationItem
     setTitleView:[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"MyPizzaLabel"]]];
    
    UIButton *addToCartButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 35, 32)];
    [addToCartButton setBackgroundImage:[UIImage imageNamed:@"CustomPizzaToCart"] forState:UIControlStateNormal];
    UIBarButtonItem *barAddToCart = [[UIBarButtonItem alloc] initWithCustomView:addToCartButton];
    [addToCartButton addTarget:self action:@selector(doneButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = barAddToCart;
}

-(void)viewWillDisappear:(BOOL)animated{
         [self.navigationController setTitle:@"Menu"];
}

#pragma mark - Pizza layers & ingredients setup
- (void) setUpIngredients{
    
    Ingredient *pepperonni  = [[Ingredient alloc] initWithName:@"Pepperoni" andPrice: 4];
    Ingredient *bacon       = [[Ingredient alloc] initWithName: @"Bacon"    andPrice: 4];
    Ingredient *olives      = [[Ingredient alloc] initWithName: @"Olives"   andPrice: 2];
    Ingredient *onions      = [[Ingredient alloc] initWithName: @"Onions"   andPrice: 2];
    Ingredient *spinach     = [[Ingredient alloc] initWithName: @"Spinach"  andPrice: 2];
    Ingredient *pineapple   = [[Ingredient alloc] initWithName: @"Pineapple"andPrice: 2];
    
    self.ingredients = @[pepperonni, bacon, olives, onions, spinach, pineapple];
}

- (void) setUpLayers{
    
    self.layers = @[self.pepperoniLayer,
                   self.baconLayer, self.olivesLayer, self.onionsLayer,
                   self.spinachLayer, self.pineappleLayer];
    //hide layers
    for (UIImageView *layer in self.layers) {
        [layer setHidden: YES];
    }
}

#pragma mark - <UITableViewDelegate> & <UITableViewDataSource>
- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    SPIngredientsCell *cell = [tableView dequeueReusableCellWithIdentifier: @"igredientCell"
                                                              forIndexPath: indexPath];
    cell.ingredient = self.ingredients[indexPath.row];
    cell.includeSwitch.userInteractionEnabled = YES;
    cell.includeSwitch.tag = indexPath.row;
    [cell.includeSwitch addTarget: self
                           action: @selector(switchTapped:)
                 forControlEvents:UIControlEventValueChanged];
    
    return cell;
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.ingredients count];
}

- (void) switchTapped: (id) sender{
    
    NSInteger index = [((UISwitch *) sender) tag];
    if([[self.ingredients[index] name] isEqualToString:@"Normal"]){
        
        if ([self.ingredients[index] isIncluded]) {
        
            [self.ingredients[index] setIsIncluded: 0];
        }
        else{
            [self.ingredients[index] setIsIncluded: 1];
        }
    }
    if ([self.ingredients[index] isIncluded]) {
        
        self.totalPrice -= [(self.ingredients)[index] priceIngredient];
        [self.ingredients[index] setIsIncluded: 0];
        [self.layers[index] setHidden: YES];
    }else{
        self.totalPrice += [self.ingredients[index] priceIngredient];
        [self.ingredients[index] setIsIncluded: 1];
        [self.layers[index] setHidden: NO];
    }
    
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
    
    if (self.AmountLabel.text.intValue > 1) {
        self.AmountLabel.text = [NSString stringWithFormat:@"%ld",(unsigned long)--self.productAmount];
        [self setTotalPrice:self.totalPrice];
    }
}

- (void)plusTapped{
    
    [self.imgPlus setAlpha:0];
    
    [UIView animateWithDuration:0.3 animations:^{
        [self.imgPlus setAlpha:1];
    }];
    
    self.AmountLabel.text = [NSString stringWithFormat:@"%ld",(unsigned long)++self.productAmount];
    [self setTotalPrice:self.totalPrice];
}

-(IBAction)chooseSize:(id)sender{
    
    UISegmentedControl *segmentedControl = (UISegmentedControl *) sender;
    NSInteger selectedSegment            = segmentedControl.selectedSegmentIndex;
    
    if (selectedSegment == 0) {
        self.productSize = 0;
        if(self.sizePrice == 10){
            self.totalPrice -= self.sizePrice;
            self.sizePrice = 0;
            [self setTotalPrice:self.totalPrice];
        }
    }
    else{
        self.productSize = 1;
        if(self.sizePrice == 0){
            self.sizePrice = 10;
            self.totalPrice += self.sizePrice;
            [self setTotalPrice:self.totalPrice];
        }
    }
}

-(IBAction)doneButtonTapped:(id)sender{
    
    SPCustomPizza *newPizza = [[SPCustomPizza alloc]
                               initCustomPizzaWithName:[NSString stringWithFormat:@"Custom Pizza N%ld",
                                                        (long)arc4random_uniform(100) + 15]
                               WithImage:@""];
    
    newPizza.pepperoni  = self.ingredients[0];
    newPizza.bacon      = self.ingredients[1];
    newPizza.olives     = self.ingredients[2];
    newPizza.onions     = self.ingredients[3];
    newPizza.spinach    = self.ingredients[4];
    newPizza.pineapple  = self.ingredients[5];
    [newPizza setPrice:   self.totalPrice];
    
    NSMutableDictionary* product = [[NSMutableDictionary alloc] init];
    [product setValue: newPizza forKey: @"Product"];
    [product setValue: @(self.productAmount) forKey: @"Amount"];
    
    if(self.productSize == 0){
        [product setValue: @"Normal" forKey: @"Size"];
    }
    else{
        [product setValue: @"Large" forKey: @"Size"];
    }
    [[SPManager sharedManager] addProductToCart:product];
    [self.navigationController popViewControllerAnimated: YES];
}
@end
