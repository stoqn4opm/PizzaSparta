//
//  SPUserAddressTableViewCell.m
//  PizzaSparta
//
//  Created by Student03 on 6/20/15.
//  Copyright (c) 2015 MentorMate Academy. All rights reserved.
//

#import "SPUserAddressTableViewCell.h"
@interface SPUserAddressTableViewCell()

@property (weak, nonatomic) IBOutlet UILabel *addressLabel;

@end
@implementation SPUserAddressTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)configureAddressLabel:(UserAdress*) address{
    self.addressLabel.text = [address address];
}
@end
