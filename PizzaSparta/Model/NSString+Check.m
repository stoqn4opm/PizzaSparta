//
//  NSString+Check.m
//  PizzaSparta
//
//  Created by Student03 on 6/8/15.
//  Copyright (c) 2015 MentorMate Academy. All rights reserved.
//

#import "NSString+Check.h"

@implementation NSString (Check)

+(BOOL)isEmptyString:(NSString *)checkingString{
    NSString* tmpString = [checkingString stringByReplacingOccurrencesOfString:@" " withString:@""];
    if([tmpString isEqualToString:@""]){
        return YES;
    }
    return NO;
}

@end
