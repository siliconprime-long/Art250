//
//  ATAddToCollectionNotificationEvent.m
//  art250
//
//  Created by Winfred Raguini on 11/6/13.
//  Copyright (c) 2013 Art250. All rights reserved.
//

#import "ATAddToCollectionNotificationEvent.h"
#import "ATCollectionManager.h"

@implementation ATAddToCollectionNotificationEvent

- (BOOL)shouldIncrementTrigger
{
    return [[[ATCollectionManager sharedManager] collection] count] > 0;
}

- (NSString*)messageString
{
    return [NSString stringWithFormat:@"Share any piece with your friends and get $25 off your next purchase"];
}

- (NSString*)cancelButtonTitle
{
    return @"Keep browsing";
}

- (NSString*)defaultButtonTitle
{
    return @"Share Now";
}


- (void)didAcceptNotificationTrigger
{
    //Nothing
    [[NSNotificationCenter defaultCenter] postNotificationName:kdidInvokeFeedbackScreenNotification object:nil];
}

- (void)didCancelNotificationTrigger
{
    //Nothing
}

@end
