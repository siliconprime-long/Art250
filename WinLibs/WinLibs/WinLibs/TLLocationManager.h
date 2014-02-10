//
//  CLController.h
//  TamaleLadyIsHere
//
//  Created by Winfred Raguini on 2/24/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@protocol CLControllerDelegate

@required
- (void)locationUpdate:(CLLocation*)location;
- (void)locationError:(NSError*)error;

@end



@interface TLLocationManager : NSObject <CLLocationManagerDelegate> {
	CLLocationManager *_locationManager;
	id _delegate;
}
@property (nonatomic, readonly) CLLocation *currentUserLocation;
@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, weak) id delegate;
+ (id)sharedInstance;
- (void)locationManager:(CLLocationManager*)manager
	didUpdateToLocation:(CLLocation*)newLocation fromLocation:(CLLocation*)oldLocation;
- (void)locationManager:(CLLocationManager*)manager
	   didFailWithError:(NSError*)error;
@end
