//
//  ATTrackingManager.m
//  art250
//
//  Created by Winfred Raguini on 10/25/13.
//  Copyright (c) 2013 Art250. All rights reserved.
//

#import "ATTrackingManager.h"
#import "ATUserManager.h"
#import "ATFacebookUser.h"
#import "Mixpanel.h"
#import "ATNotificationManager.h"

@implementation ATTrackingManager

+(ATTrackingManager*)sharedManager
{
    static ATTrackingManager* _theManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _theManager = [[ATTrackingManager alloc] init];
    });
    return _theManager;
}

- (id)init
{
    if (self = [super init]) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(registerUserTracking) name:kdidLoginNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(registerUserTracking) name:kdidLogOutNotification object:nil];
    }
    return  self;
}

- (void)trackEvent:(NSString*)event
{
    [self trackEvent:event timed:NO];
    
    //Now track the event on our ATNotificationManager to throw up notifications when it needs to
    [[ATNotificationManager sharedManager] trackEvent:event];
}

- (void)trackEvent:(NSString*)event withParameters:(NSDictionary*)params
{
    [self trackEvent:event withParameters:params timed:NO];
}

- (void)trackEvent:(NSString*)event timed:(BOOL)timed
{
//    if (timed) {
//        [Flurry logEvent:event timed:timed];
//    } else {
//        [Flurry logEvent:event];
//    }
    [[Mixpanel sharedInstance] track:event];
}

- (void)trackEvent:(NSString *)event withParameters:(NSDictionary *)params timed:(BOOL)timed
{
//    [Flurry logEvent:event withParameters:params timed:timed];
    [[Mixpanel sharedInstance] track:event properties:params];
}

- (void)registerUserTracking

{
    if ([[ATUserManager sharedManager] isLoggedInByEmail]) {
        [[Mixpanel sharedInstance] registerSuperProperties:@{@"User Type" : @"Logged in with email"}];

    } else if ([[ATUserManager sharedManager] isLoggedInByFacebook]) {
        [[Mixpanel sharedInstance] registerSuperProperties:@{@"User Type" : @"Logged in with FB"}];
        ATFacebookUser *fbUser = [[ATUserManager sharedManager] fbUser];
        [[Mixpanel sharedInstance] registerSuperProperties:@{@"gender": fbUser.gender, @"location": fbUser.location}];
    } else {
        [[Mixpanel sharedInstance] registerSuperProperties:@{@"User Type" : @"Not logged in"}];
    }
}


@end
