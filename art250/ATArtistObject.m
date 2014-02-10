//
//  ATArtistObject.m
//  art250
//
//  Created by Winfred Raguini on 8/25/12.
//  Copyright (c) 2012 Art250. All rights reserved.
//

#import "ATArtistObject.h"


#define kDefaultProfileImageURL @"/assets/fallback/default_profile.jpg"

@implementation ATArtistObject

- (id)initWithAttributes:(NSDictionary *)attributes {
    self = [super init];
    if (!self) {
        return nil;
    }
    
    //    "artist":
    //        {"activated":false,"created_at":"2013-01-24T21:00:09Z","email":"j@p.com","id":74,"invites_left":5,"max_artwork_sales":5,"merchant_ready":false,"merchant_tier":null,"roles_mask":null,"updated_at":"2013-01-24T21:00:09Z","verified":false},"user_profile":{"address1":null,"address2":null,"artist_statement":"","city":"","created_at":"2013-01-24T21:00:09Z","first_name":"","id":64,"last_name":"","profile_image":{"url":"http://com.arttwo50.s3-us-west-2.amazonaws.com/staging/uploads/user_profile/profile_image/64/december-11-blue_december__83-nocal-1920x1200_1_.jpg","preview":{"url":"http://com.arttwo50.s3-us-west-2.amazonaws.com/staging/uploads/user_profile/profile_image/64/preview_december-11-blue_december__83-nocal-1920x1200_1_.jpg"},"thumb":{"url":"http://com.arttwo50.s3-us-west-2.amazonaws.com/staging/uploads/user_profile/profile_image/64/thumb_december-11-blue_december__83-nocal-1920x1200_1_.jpg"}},"public_url":null,"state":"","status":"","updated_at":"2013-01-24T21:02:04Z","user_id":74}}
    
    //    {:address1, :address2, :city, :first_name, :last_name, :profile_image, :artist_statement, :state}
    
    
    
//    _artist = [[ATArtistObject alloc] initWithAttributes:[attributes valueForKeyPath:@"artist"]];
    //    _postID = [[attributes valueForKeyPath:@"id"] integerValue];
    //    _text = [attributes valueForKeyPath:@"text"];
    //
    //    _user = [[User alloc] initWithAttributes:[attributes valueForKeyPath:@"user"]];
    
    
    
    _userId =  [NSNumber numberWithInteger:[[attributes valueForKeyPath:@"id"] integerValue]];
    _artistImageURL = [attributes valueForKeyPath:@"user_profile.profile_image.profile_image.url"];
    _firstName = [attributes valueForKeyPath:@"user_profile.first_name"];
    _lastName = [attributes valueForKeyPath:@"user_profile.last_name"];
    _artistStatement = [attributes valueForKeyPath:@"user_profile.artist_statement"];
    _city = [attributes valueForKeyPath:@"user_profile.city"];
    _state = [attributes valueForKeyPath:@"user_profile.state"];
//    _artworkCount = [NSNumber numberWithInteger:[[attributes valueForKeyPath:@"ARTWORK_COUNT_KEY"] integerValue]];
    return self;
}


- (void)encodeWithCoder:(NSCoder *)encoder {
    //Encode properties, other class variables, etc
    [encoder encodeObject:self.userId forKey:@"userId"];
    [encoder encodeObject:self.artistImageURL forKey:@"artistImageURL"];
    [encoder encodeObject:self.firstName forKey:@"first_name"];
    [encoder encodeObject:self.lastName forKey:@"last_name"];
    [encoder encodeObject:self.artistStatement forKey:@"artist_statement"];
    [encoder encodeObject:self.city forKey:@"city"];
    [encoder encodeObject:self.state forKey:@"state"];
}

- (id)initWithCoder:(NSCoder *)decoder {
    if((self = [super init])) {
        //decode properties, other class vars
        self.userId = [decoder decodeObjectForKey:@"userId"];
        self.artistImageURL = [decoder decodeObjectForKey:@"artistImageURL"];
        self.firstName = [decoder decodeObjectForKey:@"first_name"];
        self.lastName = [decoder decodeObjectForKey:@"last_name"];
        self.artistStatement = [decoder decodeObjectForKey:@"artist_statement"];
        self.city = [decoder decodeObjectForKey:@"city"];
        self.state = [decoder decodeObjectForKey:@"state"];
    }
    return self;
}


- (BOOL)hasUploadedProfileImage
{
    return ![self.artistImageURL isEqualToString:kDefaultProfileImageURL];
}

- (NSString*)fullName
{
    return [NSString stringWithFormat:@"%@ %@", self.firstName, self.lastName];
}

@end
