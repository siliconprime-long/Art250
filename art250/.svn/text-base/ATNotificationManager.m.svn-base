//
//  ATNotificationManager.m
//  art250
//
//  Created by Winfred Raguini on 11/4/13.
//  Copyright (c) 2013 Art250. All rights reserved.
//

#import "ATNotificationManager.h"
#import "ATNotificationEvent.h"
#import "ATAddToCollectionNotificationEvent.h"
#import "ATArtworkFoundInOtherCollectionEvent.h"
#import "ATShareForPromoNotificationEvent.h"

@interface ATNotificationManager ()
- (void)addEvent:(ATNotificationEvent*)event;
@end

@implementation ATNotificationManager
+(ATNotificationManager*)sharedManager
{
    static ATNotificationManager *_sharedManager = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        _sharedManager = [[ATNotificationManager alloc] init];
    });
    return _sharedManager;
}

- (id)init
{
    if (self = [super init]) {
        //Custom stuff
        eventDictionary = [[NSMutableDictionary alloc] init];
        //This is where you instantiate a notification event and add it to the event  collection
        ATAddToCollectionNotificationEvent *addToCollectionEvent = [[ATAddToCollectionNotificationEvent alloc] initWithEvent:FL_ART_ADDED_TO_COLLECTION forThreshold:2];
        addToCollectionEvent.delegate = addToCollectionEvent;
        [self addEvent:addToCollectionEvent];
        
        ATArtworkFoundInOtherCollectionEvent *artInOtherCollection = [[ATArtworkFoundInOtherCollectionEvent alloc] initWithEvent:FL_ART_SWIPES forThreshold:30];
        artInOtherCollection.delegate = artInOtherCollection;
        [self addEvent:artInOtherCollection];
        
        ATShareForPromoNotificationEvent *shareForPromoCode = [[ATShareForPromoNotificationEvent alloc] initWithEvent:USER_SHARED_SUCCESS forThreshold:1];
        shareForPromoCode.delegate = shareForPromoCode;
        [self addEvent:shareForPromoCode];
        
        
    }
    return self;
}

- (void)addEvent:(ATNotificationEvent*)event
{
    if ([eventDictionary objectForKey:event.event]) {
        NSMutableArray *eventArray = [eventDictionary objectForKey:event.event];
        [eventArray addObject:event];
        [eventDictionary setObject:eventArray forKey:event.event];
    } else {
        NSMutableArray *newEventArray = [[NSMutableArray alloc] initWithObjects:event, nil];
        [eventDictionary setObject:newEventArray forKey:event.event];
    }
}


- (void)trackEvent:(NSString*)event
{
    //Process here
    if ([self isTrackedEvent:event]) {
        [self processEvent:event];
    }
}

- (void)processEvent:(NSString*)event
{
    //Now find the Notification Triggers that are associated with this event
    //Could be an array of them
    NSArray *eventTriggers = [eventDictionary objectForKey:event];
    for (ATNotificationEvent *event in eventTriggers) {
        if (![event isCompleted] && [event shouldIncrementTrigger]) {
            [event incrementTrigger];
            //Now who checks to see if the threshold has been met?
            if ([event shouldTriggerNotification]) {
                [self triggerNotificationForEvent:event];
                //You shouldn't trigger two events at one time even if it should - trigger the other one
                //next time.
                break;
            }
        }
    }
}

- (void)triggerNotificationForEvent:(ATNotificationEvent*)event
{
    UIAlertView *notificationAlert = [[UIAlertView alloc] initWithTitle:event.notificationTitle message:event.messageString delegate:event cancelButtonTitle:event.cancelButtonTitle otherButtonTitles:event.defaultButtonTitle, nil];
    [notificationAlert show];
    [event didSendNotification];
}


- (BOOL)isTrackedEvent:(NSString*)event
{
    //Probably check a dictionary of events that are tracked
    return [eventDictionary objectForKey:event] != nil;
}

@end
