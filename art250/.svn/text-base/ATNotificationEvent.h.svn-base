//
//  ATNotificationEvent.h
//  art250
//
//  Created by Winfred Raguini on 11/4/13.
//  Copyright (c) 2013 Art250. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ATNotificationEventDelegate <NSObject>
@optional
- (void)didIncrementTrigger;
- (BOOL)shouldTriggerNotification;
- (void)didCancelNotificationTrigger;
- (void)didAcceptNotificationTrigger;

@end

@interface ATNotificationEvent : NSObject <UIAlertViewDelegate>
@property (nonatomic, strong) NSString *event;
@property (nonatomic, strong) NSNumber *threshold;
@property (nonatomic, strong) NSString *messageString;
@property (nonatomic, strong) NSString *defaultButtonTitle;
@property (nonatomic, strong) NSString *cancelButtonTitle;
@property (nonatomic, strong) NSString *notificationTitle;
@property (nonatomic, assign) id delegate;
- (void)didSendNotification;
- (BOOL)isCompleted;
- (void)incrementTrigger;
- (BOOL)shouldTriggerNotification;
- (BOOL)eventNotificationSent;
- (int)numEventsTriggered;
- (BOOL)shouldIncrementTrigger;
- (NSString*)eventNotificationKey;
- (NSString*)eventNotificationSentKey;
- (id)initWithEvent:(NSString*)event forThreshold:(int)threshold;
@end
