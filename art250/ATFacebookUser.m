//
//  ATFacebookUser.m
//  art250
//
//  Created by Winfred Raguini on 10/15/13.
//  Copyright (c) 2013 Art250. All rights reserved.
//

#import "ATFacebookUser.h"
#import "ATAPIClient.h"

@interface ATFacebookUser()
@property (nonatomic, strong, readwrite) NSString *fbID;
@property (nonatomic, strong, readwrite) NSString *bio;
@property (nonatomic, strong, readwrite) NSString *email;
@property (nonatomic, strong, readwrite) NSString *firstName;
@property (nonatomic, strong, readwrite) NSString *lastName;
@property (nonatomic, strong, readwrite) NSString *gender;
@property (nonatomic, strong, readwrite) NSString *hometown;
@property (nonatomic, strong, readwrite) NSString *location;
@property (nonatomic, strong, readwrite) NSString *link;
@end

@implementation ATFacebookUser
- (id)initWithFBGraphUser:(id<FBGraphUser>)user {
    //Fill 'er up
    if (self = [super init]) {
        self.fbID = user[@"id"];
        self.bio = user[@"bio"];
        self.email = user[@"email"];
        self.firstName = user[@"first_name"];
        self.lastName = user[@"last_name"];
        self.gender = user[@"gender"];
        self.hometown = user[@"hometown"];
        if (user[@"location"]) {
            self.location = user[@"location"][@"name"];
        }
        self.link = user[@"link"];
//     //Fetch user data
//        [FBRequestConnection
//         startForMeWithCompletionHandler:^(FBRequestConnection *connection,
//                                           id<FBGraphUser> user,
//                                           NSError *error) {
//             if (!error) {
//                 NSString *userInfo = @"";
//
//                 // Example: typed access (name)
//                 // - no special permissions required
//                 userInfo = [userInfo
//                             stringByAppendingString:
//                             [NSString stringWithFormat:@"Name: %@\n\n",
//                              user.name]];
//
//                 // Example: typed access, (birthday)
//                 // - requires user_birthday permission
//                 userInfo = [userInfo
//                             stringByAppendingString:
//                             [NSString stringWithFormat:@"Birthday: %@\n\n",
//                              user.birthday]];
//
//                 // Example: partially typed access, to location field,
//                 // name key (location)
//                 // - requires user_location permission
//                 userInfo = [userInfo
//                             stringByAppendingString:
//                             [NSString stringWithFormat:@"Location: %@\n\n",
//                              user.location[@"name"]]];
//
//                 // Example: access via key (locale)
//                 // - no special permissions required
//                 userInfo = [userInfo
//                             stringByAppendingString:
//                             [NSString stringWithFormat:@"Locale: %@\n\n",
//                              user[@"locale"]]];
//
//                 // Example: access via key for array (languages)
//                 // - requires user_likes permission
//                 if (user[@"languages"]) {
//                     NSArray *languages = user[@"languages"];
//                     NSMutableArray *languageNames = [[NSMutableArray alloc] init];
//                     for (int i = 0; i < [languages count]; i++) {
//                         languageNames[i] = languages[i][@"name"];
//                     }
//                     userInfo = [userInfo
//                                 stringByAppendingString:
//                                 [NSString stringWithFormat:@"Languages: %@\n\n",
//                                  languageNames]];
//                 }   
//                 
//                 // Display the user info
//                 //self.userInfoTextView.text = userInfo;
//                 NSLog(@"Hello dude. %@", user);
//             }
//         }];
    }
    return self;
}

- (NSString*)gender
{
    if (_gender == nil) {
        return @"None";
    } else {
        return _gender;
    }
}

- (NSString*)location
{
    if (_location == nil) {
        return @"None";
    } else {
        return _location;
    }
}


- (BOOL)alreadyExists
{
    return [[self fbUsers] containsObject:self.fbID];
}

- (void)save
{
    //Don't forget to send to the server
    NSMutableArray *fbUserMutableArray = [[NSMutableArray alloc] initWithArray:[self fbUsers]];
    [fbUserMutableArray addObject:self.fbID];
    [[NSUserDefaults standardUserDefaults] setObject:[NSArray arrayWithArray:fbUserMutableArray] forKey:kFBUsersKey];
    
    NSDictionary *params = [[NSDictionary alloc] initWithObjectsAndKeys:self.fbID, @"fb_id", self.email, @"email", self.firstName, @"first_name", self.lastName, @"last_name", self.gender, @"gender", self.location, @"location", self.link, @"fb_link", nil];
    NSDictionary *userParams = [[NSDictionary alloc] initWithObjectsAndKeys:params, @"fb_user", nil];
    
    [[ATAPIClient sharedClient] postPath:@"facebook_users.json" parameters:userParams success:^(AFHTTPRequestOperation *operation, id responseObject){
        NSDictionary *responseDict = responseObject;
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error){
        
    }];
}

- (NSArray*)fbUsers
{
    if ([[NSUserDefaults standardUserDefaults] objectForKey:kFBUsersKey]  == nil) {
        return [NSArray array];
    } else {
        return [[NSUserDefaults standardUserDefaults] objectForKey:kFBUsersKey];
    }
}

- (NSString*)description
{
    return [NSString stringWithFormat:@"fbID: %@", self.fbID];
}
@end
