//
//  ATTransientArtistProfile.h
//  art250
//
//  Created by Winfred Raguini on 12/12/13.
//  Copyright (c) 2013 Art250. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ATTransientArtistProfile : NSObject
@property (nonatomic, retain) NSString * address1;
@property (nonatomic, retain) NSString * address2;
@property (nonatomic, retain) NSString * artistStatement;
@property (nonatomic, retain) NSString * city;
@property (nonatomic, retain) NSString * firstName;
@property (nonatomic, retain) NSString * lastName;
@property (nonatomic, retain) NSNumber * profileID;
@property (nonatomic, retain) id profileImageURL;
@property (nonatomic, retain) id profilePreviewURL;
@property (nonatomic, retain) id profileThumbURL;
@property (nonatomic, retain) NSString * state;
@property (nonatomic, retain) NSSet *artworks;
+ (void)artistProfilesWithBlock:(void (^)(NSArray *profiles, NSError *error))block;
@end
