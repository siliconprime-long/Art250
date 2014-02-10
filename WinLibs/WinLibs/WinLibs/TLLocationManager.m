//
//  CLController.m
//  TamaleLadyIsHere
//
//  Created by Winfred Raguini on 2/24/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "TLLocationManager.h"

@interface TLLocationManager () {
    
}
@property (nonatomic, readwrite) CLLocation *currentUserLocation;
@end


@implementation TLLocationManager
@synthesize locationManager = _locationManager;
@synthesize delegate = delegate_;
@synthesize currentUserLocation = currentUserLocation_;

+ (TLLocationManager *)sharedInstance;
{
	static TLLocationManager *theSharedInstance = nil;
	@synchronized(self)
	{
		if (theSharedInstance == nil)
		{
			theSharedInstance = [[TLLocationManager alloc] init];
		}
	}
	return theSharedInstance;
}

- (id)init
{
	if (self = [super init]) {
		self.locationManager = [[CLLocationManager alloc] init];
		self.locationManager.delegate = self;
	}
	return self;
}



- (void)locationManager:(CLLocationManager*)manager
	didUpdateToLocation:(CLLocation*)newLocation fromLocation:(CLLocation*)oldLocation
{
    self.currentUserLocation = newLocation;
	[self.delegate locationUpdate:newLocation];
}

- (void)locationManager:(CLLocationManager*)manager
	   didFailWithError:(NSError*)error
{
	DLog(@"Error: %@ ", [error description]);	
	[self.delegate locationError:error];
}

@end
