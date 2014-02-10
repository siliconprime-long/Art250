//
//  ATNotificationEvent.m
//  art250
//
//  Created by Winfred Raguini on 11/4/13.
//  Copyright (c) 2013 Art250. All rights reserved.
//

#import "ATNotificationEvent.h"

@implementation ATNotificationEvent

- (id)init
{
    return [self initWithEvent:nil forThreshold:0];
}

- (id)initWithEvent:(NSString*)event forThreshold:(int)threshold
{
    if (self = [super init]) {
        self.event = event;
        self.threshold = [NSNumber numberWithInt:threshold];
        self.notificationTitle = @"Notification";
    }
    return self;
}

- (void)incrementTrigger
{
    //Incremenmt the event trigger by one
    int numEventsTriggered = [[NSUserDefaults standardUserDefaults] integerForKey:[self eventNotificationKey]];
    NSLog(@"numEventsTriggered %d", numEventsTriggered);
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:numEventsTriggered + 1] forKey:[self eventNotificationKey]];
    if ([self.delegate respondsToSelector:@selector(didIncrementTrigger)]) {
        [self.delegate performSelector:@selector(didIncrementTrigger) withObject:nil];
    }
}

- (BOOL)isCompleted
{
    return [[NSUserDefaults standardUserDefaults] boolForKey:[self eventNotificationSentKey]];
}

- (int)numEventsTriggered
{
    return [[NSUserDefaults standardUserDefaults] integerForKey:[self eventNotificationKey]];
}

- (BOOL)shouldTriggerNotification
{
    if ([self numEventsTriggered] >= [self.threshold integerValue]) {
        return YES;
    } else {
        return NO;
    }
}

- (void)didSendNotification
{
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:[self eventNotificationSentKey]];
}

- (BOOL)eventNotificationSent
{
    return [[NSUserDefaults standardUserDefaults] boolForKey:[self eventNotificationSentKey]];
}

- (NSString*)eventNotificationKey
{
    return [NSString stringWithFormat:@"%@ForNotification",self.event];
}


- (NSString*)eventNotificationSentKey
{
    return [NSString stringWithFormat:@"%@sent",[self eventNotificationKey]];
}

- (BOOL)shouldIncrementTrigger
{
    return YES;
}


#pragma mark
#pragma mark UIAlertViewDelegate


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:
            if ([self.delegate respondsToSelector:@selector(didCancelNotificationTrigger)]) {
                [self.delegate performSelector:@selector(didCancelNotificationTrigger) withObject:nil];
            }
            break;
        case 1:
            if ([self.delegate respondsToSelector:@selector(didAcceptNotificationTrigger)]) {
                [self.delegate performSelector:@selector(didAcceptNotificationTrigger) withObject:nil];
            }
            break;
    }
}

@end
