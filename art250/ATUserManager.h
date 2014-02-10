//
//  ATUserManager.h
//  art250
//
//  Created by Winfred Raguini on 6/10/13.
//  Copyright (c) 2013 Art250. All rights reserved.
//

#import <Foundation/Foundation.h>
@class ATFacebookUser;
@class ATUser;
@interface ATUserManager : NSObject <FBLoginViewDelegate> 
@property (nonatomic, strong) NSNumber *buyerAccountId;
@property (nonatomic, strong) UINavigationController *signUpNavController;
@property (nonatomic, strong) ATFacebookUser *fbUser;
@property (nonatomic, strong) ATUser *atUser;
@property (nonatomic, assign) BOOL isTryingToFavoriteCurrentArtwork;
+(ATUserManager*)sharedManager;
- (BOOL)hasBuyerAccount;
- (void)resetFlurryData;
- (void)incrementWithFlurryKey:(NSString*)flurryKey;
- (BOOL)isLoggedIn;
- (BOOL)isLoggedInByEmail;
- (void)showSignUpDialogInView:(UIView*)view forDelegate:(id<UIPopoverControllerDelegate>)controller;
- (BOOL)isLoggedInByFacebook;
- (void)setFBUserWithFBGraphUser:(id<FBGraphUser>)fbGraphUser;
- (void)setATUserWithATUserDictionary:(NSDictionary*)atUserDictionary;
- (void)hideSignInDialog;
- (NSString*)userType;
- (NSString*)userID;
- (NSString*)fullName;
@end
