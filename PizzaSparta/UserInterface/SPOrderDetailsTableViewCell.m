//
//  SPOrderDetailsTableViewCell.m
//  PizzaSparta
//
//  Created by Student03 on 6/20/15.
//  Copyright (c) 2015 MentorMate Academy. All rights reserved.
//

#import "SPOrderDetailsTableViewCell.h"
#import "AsyncImageView.h"
@interface SPOrderDetailsTableViewCell()

@property (weak, nonatomic) IBOutlet UIImageView __block *cellImage;
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblAmountIncart;

@end

@implementation SPOrderDetailsTableViewCell

- (void)configureCartCellWithProduct:(NSDictionary*)product{
    
    
        [self.lblTitle setText: [product valueForKey:@"title"]];
        [self.lblAmountIncart setText:[product valueForKey:@"numberOfProduct"]];
        if(![[product valueForKey:@"photoURL"] isEqualToString:@"none"]){
            NSString* photourl = [product valueForKey:@"photoURL"];
            [self.cellImage setImageURL:[NSURL URLWithString:photourl]];
        }
        else{
            [self.cellImage setImage: [UIImage imageNamed: @"PizzaImage"]];
        }
  
    
    
    
}


@end
