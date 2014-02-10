//
//  ATTrackingManager.h
//  art250
//
//  Created by Winfred Raguini on 10/25/13.
//  Copyright (c) 2013 Art250. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ATTrackingManager : NSObject
+(ATTrackingManager*)sharedManager;
- (void)trackEvent:(NSString*)event;
- (void)trackEvent:(NSString*)event timed:(BOOL)timed;
- (void)trackEvent:(NSString*)event withParameters:(NSDictionary*)params;
- (void)trackEvent:(NSString *)event withParameters:(NSDictionary *)params timed:(BOOL)timed;
- (void)registerUserTracking;
@end
