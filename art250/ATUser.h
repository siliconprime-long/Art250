//
//  ATUser.h
//  art250
//
//  Created by Winfred Raguini on 10/17/13.
//  Copyright (c) 2013 Art250. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ATUser : NSObject
@property (nonatomic, strong, readonly) NSString *firstName;
@property (nonatomic, strong, readonly) NSString *lastName;
@property (nonatomic, strong, readonly) NSString *profileImageURLString;
@property (nonatomic, strong, readonly) NSString *profileID;
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
- (id)initWithDictionary:(NSDictionary*)userDictionary;
@end
