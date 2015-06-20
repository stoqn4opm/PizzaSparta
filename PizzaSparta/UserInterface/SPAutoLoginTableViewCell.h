//
//  SPAutoLoginTableViewCell.h
//  PizzaSparta
//
//  Created by Stoqn Stoqnov on 6/18/15.
//  Copyright (c) 2015 MentorMate Academy. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SPAutoLoginTableViewCellDelegate <NSObject>

-(void)dismissToLogin;
@end

@interface SPAutoLoginTableViewCell : UITableViewCell

@property (nonatomic, weak) id<SPAutoLoginTableViewCellDelegate> delegate;
-(void) configure;
@end
