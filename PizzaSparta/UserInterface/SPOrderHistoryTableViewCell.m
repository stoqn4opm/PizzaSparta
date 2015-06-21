//
//  SPOrderHistoryTableViewCell.m
//  PizzaSparta
//
//  Created by Stoqn Stoqnov on 6/18/15.
//  Copyright (c) 2015 MentorMate Academy. All rights reserved.
//

#import "SPOrderHistoryTableViewCell.h"

@interface SPOrderHistoryTableViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *lblOrderPlaced;
@property (weak, nonatomic) IBOutlet UIImageView *imgGoToDetailedView;
@property (weak, nonatomic) IBOutlet UILabel *isDelivered;
@end

@implementation SPOrderHistoryTableViewCell
-(void)configureWithOrder:(UserOrders*)order{
    
    _lblOrderPlaced.text= [NSString stringWithFormat:@"Placed: %@",[order dateOrder]];
    if([order isDelivered] == 0){
        _isDelivered.text = @"not Delivered";
    }
    else if([order isDelivered] == 2){
        _isDelivered.text = @"out for Delivery";
    }
    else{
        _isDelivered.text = @"Delivered";
    }
}
@end
