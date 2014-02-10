//
//  ArtistProfile.m
//  art250
//
//  Created by Winfred Raguini on 12/9/13.
//  Copyright (c) 2013 Art250. All rights reserved.
//

#import "ArtistProfile.h"
#import "Artist.h"


@implementation ArtistProfile

@dynamic address1;
@dynamic address2;
@dynamic artistStatement;
@dynamic city;
@dynamic firstName;
@dynamic lastName;
@dynamic profileID;
@dynamic profileImageURL;
@dynamic profilePreviewURL;
@dynamic profileThumbURL;
@dynamic state;
@dynamic artist;

- (NSString*)fullName
{
    NSString *firstName;
    if (self.firstName != nil) {
        firstName = self.firstName;
    } else {
        firstName = @"";
    }
    NSString *lastName;
    if (self.lastName != nil) {
        lastName = self.lastName;
    } else {
        lastName = @"";
    }
    return [NSString stringWithFormat:@"%@ %@", firstName, lastName];
}

- (NSString*)locationString
{
    NSString *city;
    if (self.city != nil) {
        city = self.city;
    } else {
        city = @"";
    }
    NSString *state;
    if (self.state != nil) {
        state = self.state;
    } else {
        state = @"";
    }
    return [NSString stringWithFormat:@"%@, %@", city, state];
}

- (BOOL)hasUploadedProfileImage
{
    return self.profileImageURL != nil;
}


@end
