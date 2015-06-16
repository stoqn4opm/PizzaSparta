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

#define BASE_PRICE 6

@interface SPCustomVC ()<UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) NSArray *ingredients;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (nonatomic) float totalPrice;

@property (strong, nonatomic) NSArray *layers;
@property (weak, nonatomic) IBOutlet UIImageView *baconLayer;
@property (weak, nonatomic) IBOutlet UIImageView *pepperoniLayer;
@property (weak, nonatomic) IBOutlet UIImageView *olivesLayer;
@property (weak, nonatomic) IBOutlet UIImageView *onionsLayer;
@property (weak, nonatomic) IBOutlet UIImageView *spinachLayer;
@property (weak, nonatomic) IBOutlet UIImageView *pineappleLayer;
@end

@implementation SPCustomVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUpIngredients];
    [self setUpLayers];
    
    self.totalPrice = BASE_PRICE;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) setTotalPrice:(float)totalPrice{
    _totalPrice = totalPrice;
    self.priceLabel.text = [NSString stringWithFormat: @"%f", totalPrice];
}

#pragma mark - Pizza layers & ingredients setup

- (void) setUpIngredients{
    Ingredient *pepperonni = [[Ingredient alloc] initWithName:@"Pepperoni" andPrice: 4];
    Ingredient *bacon = [[Ingredient alloc] initWithName: @"Bacon" andPrice: 4];
    Ingredient *olives = [[Ingredient alloc] initWithName: @"Olives" andPrice: 2];
    Ingredient *onions = [[Ingredient alloc] initWithName: @"Onions" andPrice: 2];
    Ingredient *spinach = [[Ingredient alloc] initWithName: @"Spinach" andPrice: 2];
    Ingredient *pineapple = [[Ingredient alloc] initWithName: @"Pineapple" andPrice: 2];
    
    self.ingredients = [[NSArray alloc] initWithObjects: pepperonni, bacon, olives, onions, spinach, pineapple, nil];
}

- (void) setUpLayers{
    self.layers = [[NSArray alloc] initWithObjects: self.pepperoniLayer, self.baconLayer, self.olivesLayer, self.onionsLayer, self.spinachLayer, self.pineappleLayer, nil];
    //hide layers
    
    for (UIImageView *layer in self.layers) {
        [layer setHidden: YES];
    }
}

#pragma mark - UITableViewDelegate & UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SPIngredientsCell *cell = [tableView dequeueReusableCellWithIdentifier: @"igredientCell" forIndexPath: indexPath];
    
    cell.ingredient = self.ingredients[indexPath.row];
    cell.includeSwitch.userInteractionEnabled = YES;
    cell.includeSwitch.tag = indexPath.row;
    [cell.includeSwitch addTarget: self action: @selector(switchTapped:) forControlEvents:UIControlEventValueChanged];
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
    
    if ([self.ingredients[index] isIncluded]) {
        self.totalPrice -= [self.ingredients[index] price];
        [self.ingredients[index] setIsIncluded: NO];
        [self.layers[index] setHidden: YES];
    }else{
        self.totalPrice += [self.ingredients[index] price];
        [self.ingredients[index] setIsIncluded: YES];
        [self.layers[index] setHidden: NO];
    }
    
}

@end
