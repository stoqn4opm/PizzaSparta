//
//  SPUserInfoTableViewCell.m
//  PizzaSparta
//
//  Created by Student03 on 6/20/15.
//  Copyright (c) 2015 MentorMate Academy. All rights reserved.
//

#import "SPUserInfoTableViewCell.h"
@interface SPUserInfoTableViewCell()
@property (weak, nonatomic) IBOutlet UILabel        *userInfoCell;
@property (weak, nonatomic) IBOutlet UIImageView    *imgGoToDetailedView;

@end

@implementation SPUserInfoTableViewCell

-(void)configureWithString:(NSString*) labelString{
   
    if ([labelString isEqualToString:@"Addresses"]) {
        self.userInfoCell.text = labelString;
    }
    else{
        self.userInfoCell.text = labelString;
        [self.imgGoToDetailedView setHidden:YES];
    }
}
@end
