//
//  ATFacebookUser.h
//  art250
//
//  Created by Winfred Raguini on 10/15/13.
//  Copyright (c) 2013 Art250. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ATFacebookUser : NSObject
@property (nonatomic, strong, readonly) NSString *fbID;
@property (nonatomic, strong, readonly) NSString *bio;
@property (nonatomic, strong, readonly) NSString *email;
@property (nonatomic, strong, readonly) NSString *firstName;
@property (nonatomic, strong, readonly) NSString *lastName;
@property (nonatomic, strong, readonly) NSString *gender;
@property (nonatomic, strong, readonly) NSString *hometown;
@property (nonatomic, strong, readonly) NSString *location;
@property (nonatomic, strong, readonly) NSString *link;

- (id)initWithFBGraphUser:(id<FBGraphUser>)user;
- (BOOL)alreadyExists;
- (void)save;

@end
