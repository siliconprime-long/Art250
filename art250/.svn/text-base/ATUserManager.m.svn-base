//
//  ATUserManager.m
//  art250
//
//  Created by Winfred Raguini on 6/10/13.
//  Copyright (c) 2013 Art250. All rights reserved.
//

#import "ATUserManager.h"
#import "ATPaymentManager.h"
#import "BPCustomer.h"
#import "ATSignInSignUpViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "ATFacebookUser.h"
#import "ATUser.h"
#import "ATAPIClient.h"
#import "ATAppDelegate.h"

#define SIGNUP_DIALOG_WIDTH 450

@interface ATUserManager ()
@property (nonatomic, strong) UIPopoverController *popoverController;
@end


@implementation ATUserManager

+(ATUserManager*)sharedManager
{
    static ATUserManager *_sharedManager;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        _sharedManager = [[ATUserManager alloc] init];
    });
    
    return _sharedManager;

}

- (id)init
{
    if (self = [super init]) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(willLogin:) name:kwillLogInNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didLogOutWithEmail:) name:kdidLogOutWithEmailNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didLogInWithEmail:) name:kdidLogInWithEmailNotification object:nil];
    }
    return self;
}

- (NSString*)userType
{
    if (self.fbUser != nil) {
        return @"fb";
    } else {
        return @"art250";
    }
}

- (NSString*)userID
{
    if (self.fbUser != nil) {
        return self.fbUser.fbID;
    } else {
        return self.atUser.profileID;
    }
}

- (NSString*)fullName
{
    NSString *firstName;
    NSString *lastName;
    if (self.fbUser != nil) {
        if (self.fbUser.firstName == nil) {
            firstName = @"no first name";
        } else {
            firstName = self.fbUser.firstName;
        }
        if (self.fbUser.lastName == nil) {
            lastName = @"no last name";
        } else {
            lastName = self.fbUser.lastName;
        }
    } else {
        if (self.atUser.firstName == nil) {
            firstName = @"no first name";
        } else {
            firstName = self.atUser.firstName;
        }
        if (self.atUser.lastName == nil) {
            lastName = @"no last name";
        } else {
            lastName = self.atUser.lastName;
        }
    }
    return [NSString stringWithFormat:@"%@ %@", firstName, lastName];
}

- (BOOL)hasBuyerAccount
{
    //if the user has already purchased an artwork before from ARTtwo50
    //return [[NSUserDefaults standardUserDefaults] integerForKey:kARTtwo50BuyerIdKey] > 0;
    return [[[ATPaymentManager sharedManager] currentBPCustomer] buyerId] > 0;
}

- (NSNumber*)buyerAccountId
{
    return [[[ATPaymentManager sharedManager] currentBPCustomer] buyerId];
}

- (void)setBuyerAccountId:(NSNumber*)buyerAccountId
{
    BPCustomer *account = [[ATPaymentManager sharedManager] currentBPCustomer];
    //NSLog(@"account %@", account);
    //NSLog(@"Need to save this buyer ID %d", [buyerAccountId intValue]);
    [account setBuyerId:buyerAccountId];
    [account save];
}

- (void)incrementWithFlurryKey:(NSString*)flurryKey
{
    int count = [[NSUserDefaults standardUserDefaults] integerForKey:flurryKey];
    count = count + 1;
    [[NSUserDefaults standardUserDefaults] setInteger:count forKey:flurryKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)resetFlurryData
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setInteger:0 forKey:kFlurryNumForwardSwipes];
    [userDefaults setInteger:0 forKey:kFlurryNumBackwardSwipes];
    [userDefaults setInteger:0 forKey:kFlurryNumDetailViewsSeen];
    [userDefaults setInteger:0 forKey:kFlurryNumBioViewsSeen];
    [userDefaults setInteger:0 forKey:kFlurryNumItemsAddedToCollection];
    [userDefaults setInteger:0 forKey:kFlurryNumUniquePiecesSeen];
    [userDefaults setInteger:0 forKey:kFlurryNumUpSwipes];
    [userDefaults setInteger:0 forKey:kFlurryNumDownSwipes];
    [userDefaults setInteger:0 forKey:kFlurryNumWallChanges];
    [userDefaults synchronize];
}


- (BOOL)isLoggedIn {
    
    return [self isLoggedInByFacebook] || [self isLoggedInByEmail];
}

- (BOOL)isLoggedInByFacebook
{
    if (self.fbUser != nil) {
        //[[NSNotificationCenter defaultCenter] postNotificationName:kalreadyLoggedIntoFacebookNotification object:nil];
        return YES;
    } else {
        return NO;
    }
}

- (BOOL)isLoggedInByEmail
{
    return self.atUser != nil;
}

- (void)showSignUpDialogInView:(UIView*)view forDelegate:(id<UIPopoverControllerDelegate>)delegate
{
    
    ATSignInSignUpViewController *signUpController = [[ATSignInSignUpViewController alloc] initWithNibName:@"ATSignInSignUpViewController" bundle:nil];
    [signUpController setDelegate:self];
    
    self.signUpNavController = [[UINavigationController alloc] initWithRootViewController:signUpController];


    [self.signUpNavController.navigationBar setBarStyle:UIBarStyleBlackOpaque];
    [self.signUpNavController.navigationBar setTranslucent:NO];
    
    [self.signUpNavController setPreferredContentSize:CGSizeMake(450, 422)];

    
    self.popoverController = [[UIPopoverController alloc] initWithContentViewController:self.signUpNavController];

    [self.popoverController setDelegate:delegate];
    [self.popoverController presentPopoverFromRect:CGRectMake(view.center.x, view.center.y - 70, 1, 1) inView:view permittedArrowDirections:0 animated:YES];
    

    
    [[NSNotificationCenter defaultCenter] postNotificationName:kdidShowSignUpDialogNotification object:nil];
}

- (void)hideSignInDialog
{
    [self.popoverController dismissPopoverAnimated:YES];
    self.signUpNavController = nil;
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kdidHideSignUpDialogNotification object:nil];
}

- (void)closeSignInSignUpSelected
{
    [[NSNotificationCenter defaultCenter] postNotificationName:kdidCancelSignInDialogNotification object:nil];
    [self hideSignInDialog];
}

- (void)setFBUserWithFBGraphUser:(id<FBGraphUser>)fbGraphUser
{
    self.fbUser = [[ATFacebookUser alloc] initWithFBGraphUser:fbGraphUser];
    
    //Check to see if this user has logged in before
    if (![self.fbUser alreadyExists]) {
        
        [self.fbUser save];
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kdidLogIntoFacebookNotification object:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:kdidLoginNotification object:nil];
    
}

- (void)setATUserWithATUserDictionary:(NSDictionary*)atUserDictionary
{
    self.atUser = [[ATUser alloc] initWithDictionary:atUserDictionary];
    [[NSNotificationCenter defaultCenter] postNotificationName:kdidLoginNotification object:nil];
}

- (void)willLogin:(NSNotification*)note
{
    [self hideSignInDialog];
}

- (void)didLogInWithEmail:(NSNotification*)note
{
    NSDictionary *loggedInInfo = [note userInfo];
    [self setATUserWithATUserDictionary:[loggedInInfo objectForKey:@"user"]];
}

- (void)didLogOutWithEmail:(NSNotification*)note
{
    self.atUser = nil;
     [[NSNotificationCenter defaultCenter] postNotificationName:kdidLogOutNotification object:nil];
}

#pragma mark
#pragma mark FBLoginViewDelegate

- (void)loginViewShowingLoggedInUser:(FBLoginView *)loginView {
     [self hideSignInDialog];
}

/*!
 @abstract
 Tells the delegate that the view is has now fetched user info
 
 @param loginView   The login view that transitioned its view mode
 
 @param user        The user info object describing the logged in user
 */
- (void)loginViewFetchedUserInfo:(FBLoginView *)loginView
                            user:(id<FBGraphUser>)user {
     [self setFBUserWithFBGraphUser:user];
}

/*!
 @abstract
 Tells the delegate that the view is now in logged out mode
 
 @param loginView   The login view that transitioned its view mode
 */
- (void)loginViewShowingLoggedOutUser:(FBLoginView *)loginView {
     self.fbUser = nil;
    [[NSNotificationCenter defaultCenter] postNotificationName:kdidLogOutOfFacebookNotification object:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:kdidLogOutNotification object:nil];
}

/*!
 @abstract
 Tells the delegate that there is a communication or authorization error.
 
 @param loginView           The login view that transitioned its view mode
 @param error               An error object containing details of the error.
 @discussion See https://developers.facebook.com/docs/technical-guides/iossdk/errors/
 for error handling best practices.
 */
- (void)loginView:(FBLoginView *)loginView
      handleError:(NSError *)error {
    NSLog(@"loginView:loginView handleError:error");
}

@end
