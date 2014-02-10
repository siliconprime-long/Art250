//
//  ATArtworkFoundInOtherCollectionEvent.m
//  art250
//
//  Created by Winfred Raguini on 11/6/13.
//  Copyright (c) 2013 Art250. All rights reserved.
//

#import "ATArtworkFoundInOtherCollectionEvent.h"
#import "ATCollectionManager.h"
#import "Artwork.h"
#import "ATArtManager.h"

@implementation ATArtworkFoundInOtherCollectionEvent



- (NSString*)messageString
{
    Artwork *randomArtwork = [[ATCollectionManager sharedManager] randomArtwork];
    return [NSString stringWithFormat:@"'%@' has just been favorited. Don't let it get away.", randomArtwork.title];
}

- (NSString*)cancelButtonTitle
{
    return @"Keep browsing";
}

- (NSString*)defaultButtonTitle
{
    return @"Load my favorites";
}

- (BOOL)shouldIncrementTrigger
{
    return [[[ATCollectionManager sharedManager] collection] count] > 0;
}


- (BOOL)shouldTriggerNotification
{
    NSArray *collection = [[ATCollectionManager sharedManager] collection];
    int effectiveNumEvents = [self numEventsTriggered] % [self.threshold intValue];
    int randomNum = arc4random() % 3;
    if (effectiveNumEvents == 0  && ![self eventNotificationSent] && [collection count] > 0 && randomNum == 0) {
        return YES;
    } else {
        return NO;
    }
}

- (NSString*)notificationTitle
{
    return @"Oh snap!";
}

- (void)didAcceptNotificationTrigger
{
    [[ATTrackingManager sharedManager] trackEvent:USR_LOADED_FAV_IN_APP];
    [[ATArtManager sharedManager] loadFavorites];
}

- (void)didCancelNotificationTrigger
{
    //Nothing
}
@end
