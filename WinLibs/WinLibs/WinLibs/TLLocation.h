//
//  TLLocation.h
//  TamaleLadyIsHere
//
//  Created by Winfred Raguini on 3/6/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>
#import <CoreLocation/CoreLocation.h>

@interface TLLocation : NSObject {
	NSString *_name;
	CGFloat _latitude;
	CGFloat _longitude;
}
@property (nonatomic, retain) NSString *name;
@property (nonatomic, assign) CGFloat latitude;
@property (nonatomic, assign) CGFloat longitude;
@end
