//
//  SPUIHeader.h
//  PizzaSparta
//
//  Created by Stoqn Stoqnov on 6/4/15.
//  Copyright (c) 2015 MentorMate Academy. All rights reserved.
//

/*
 COLOR_WHITE will be for all the text
 COLOR_GREEN will be for the background (may change it later)
 COLOR_RED   will be the tint color
 
 COLOR_DARK_GRAY, COLOR_LIGHT_GRAY will be used in a tiled pattern
 */
#import <UIKit/UIKit.h>

#define SPCOLOR_DARK_BROWN    [UIColor colorWithRed:0.63 green:0.37 blue:0.28 alpha:1.0]
#define SPCOLOR_LIGHT_BROWN   [UIColor colorWithRed:0.83 green:0.77 blue:0.61 alpha:1.0]
#define SPCOLOR_WHITE         [UIColor colorWithRed:0.82 green:0.82 blue:0.82 alpha:1.0]
#define SPCOLOR_GREEN         [UIColor colorWithRed:0.27 green:0.46 blue:0.32 alpha:1.0]
#define SPCOLOR_RED           [UIColor colorWithRed:0.67 green:0.21 blue:0.16 alpha:1.0]


#define SPCORNER_RADIUS 9.0f

typedef NSString SPMenuType;
#define SPPizza @"Pizza"
#define SPPasta @"Pasta"
#define SPDrinks @"Drinks"

typedef enum{
    SPALERT_TYPE_WRONG_USERNAME_PASSWORD = 0,
    SPALERT_TYPE_EMPTY_LOGIN_FIELDS,
    SPALERT_TYPE_EMPTY_REGISTER_FIELDS,
    SPALERT_TYPE_REGISTER_PASSWORD_MISSMATCH,
    SPALERT_TYPE_USER_ALREADY_REGISTERED,
    SPALERT_TYPE_REGISTER_ERROR,
    SPALERT_TYPE_ORDER_ERROR,
    SPALERT_TYPE_EMPTY_CART,
    SPALERT_TYPE_SUCCESS_ORDER,
    SPALERT_TYPE_ADDRESS_EXIST,
    SPALERT_TYPE_ADDRESS_DELETE_ERROR,
    SPALERT_TYPE_ADDRESS_DELETE_LAST
}SPAlertType;

@interface SPUIHeader : NSObject
+ (void) alertViewWithType:(SPAlertType) alertType;
@end
