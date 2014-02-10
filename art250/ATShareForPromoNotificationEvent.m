//
//  ATShareForPromoNotificationEvent.m
//  art250
//
//  Created by Winfred Raguini on 11/8/13.
//  Copyright (c) 2013 Art250. All rights reserved.
//

#import "ATShareForPromoNotificationEvent.h"

@implementation ATShareForPromoNotificationEvent


- (BOOL)shouldIncrementTrigger
{
    return YES;
}

- (NSString*)messageString
{
    return [NSString stringWithFormat:@"Enter promo code SHARE at checkout to redeem your $25 off"];
}

- (NSString*)cancelButtonTitle
{
    return @"Keep browsing";
}

- (NSString*)defaultButtonTitle
{
    return @"Buy Now";
}


- (void)didAcceptNotificationTrigger
{
    //Nothing
    [[NSNotificationCenter defaultCenter] postNotificationName:kdidInvokeBuyOnShareScreenNotification object:nil];
}

- (void)didCancelNotificationTrigger
{
    //Nothing
}


@end
