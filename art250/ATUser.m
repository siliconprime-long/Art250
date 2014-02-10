//
//  ATUser.m
//  art250
//
//  Created by Winfred Raguini on 10/17/13.
//  Copyright (c) 2013 Art250. All rights reserved.
//

#import "ATUser.h"

@interface ATUser ()
@property (nonatomic, strong, readwrite) NSString *firstName;
@property (nonatomic, strong, readwrite) NSString *lastName;
@property (nonatomic, strong, readwrite) NSString *profileImageURLString;
@property (nonatomic, strong, readwrite) NSString *profileID;
@end

@implementation ATUser

- (id)initWithDictionary:(NSDictionary*)userDictionary
{
    if (self = [super init]) {
        self.firstName = [userDictionary objectForKey:@"first_name"];
        self.lastName = [userDictionary objectForKey:@"last_name"];
        NSDictionary *profileImageDict = [userDictionary objectForKey:@"profile_image"];
        NSDictionary *previewProfileImageDict = [profileImageDict objectForKey:@"thumb"];
        self.profileImageURLString = [previewProfileImageDict objectForKey:@"url"];
        NSNumber *profileIdentifier = [userDictionary objectForKey:@"id"];
        self.profileID = [NSString stringWithFormat:@"%d", [profileIdentifier intValue]];
                       
    }
    
    return self;
}

//- (NSString*)profileImageURLString
//{
//    return _profileImageURLString;
//    //@"http://cache.arttwo50.com/production/uploads/user_profile/profile_image/804/preview_win_face.jpg";
//}


//{
//    address1 = "946 Geary St. #3";
//    address2 = "";
//    "artist_statement" = "Dude. Gosh man. I don't know what to do.";
//    "bp_customer_uri" = "<null>";
//    city = "San Francisco";
//    "created_at" = "2013-10-15T03:00:04Z";
//    "first_name" = Winfred;
//    id = 3495;
//    "last_name" = Raguini;
//    phone = 123231321;
//    "postal_code" = 94109;
//    "profile_image" =         {
//        preview =             {
//            url = "http://cache.arttwo50.com/development/uploads/user_profile/profile_image/804/preview_win_face.jpg";
//        };
//        thumb =             {
//            url = "http://cache.arttwo50.com/development/uploads/user_profile/profile_image/804/thumb_win_face.jpg";
//        };
//        url = "http://cache.arttwo50.com/development/uploads/user_profile/profile_image/804/win_face.jpg";
//    };
//    "profile_image_id" = 804;
//    "public_url" = "";
//    state = California;
//    status = complete;
//    "updated_at" = "2013-10-15T17:53:48Z";
//}

@end
