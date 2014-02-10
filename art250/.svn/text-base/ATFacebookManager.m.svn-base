//
//  ATFacebookManager.m
//  art250
//
//  Created by Winfred Raguini on 3/5/13.
//  Copyright (c) 2013 Art250. All rights reserved.
//

#import "ATFacebookManager.h"
#import <FacebookSDK/FacebookSDK.h>
#import <Social/Social.h>
#import "UIViewController+ATExtensions.h"


#define FACEBOOK_APP_ID @"324353187676883"

@interface ATFacebookManager ()
- (void)sessionStateChanged:(FBSession *)session state:(FBSessionState) state error:(NSError *)error;
@property (nonatomic, strong) ACAccountStore *accountStore;
@end

@implementation ATFacebookManager

+(id)sharedManager
{
    static dispatch_once_t pred;
    static ATFacebookManager *_sharedManager = nil;
    dispatch_once(&pred, ^{
        _sharedManager = [[ATFacebookManager alloc] init];
        
    });
    return _sharedManager;
}

- (id)init
{
    if (self = [super init]) {
        _accountStore = [[ACAccountStore alloc] init];
    }
    return self;
}

- (void)checkAccount
{
    ACAccountType *facebookAccountType = [self.accountStore
                                          accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierFacebook];
    
    
    // At first, we only ask for the basic read permission
    NSArray * permissions = @[@"email"];
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithObjectsAndKeys:FACEBOOK_APP_ID, ACFacebookAppIdKey, permissions, ACFacebookPermissionsKey, ACFacebookAudienceOnlyMe, ACFacebookAudienceKey, nil];
    
    
    ACAccountStoreRequestAccessCompletionHandler accountStoreHandler =
    ^(BOOL granted, NSError *error) {
        if (!granted) {
            NSLog(@"[ERROR] An error occurred while asking for user authorization: %@",[error localizedDescription]);
            if([error code]==6) {
                [self performSelectorOnMainThread:@selector(openFacebookSettings) withObject:nil waitUntilDone:NO];
            }
        } else {
            if ([self.delegate respondsToSelector:@selector(fbAccountDoesExist)])
            {
                [self.delegate performSelector:@selector(fbAccountDoesExist) withObject:nil];
            }
        }
    };
    
    
    [self.accountStore requestAccessToAccountsWithType:facebookAccountType options:dict completion:accountStoreHandler];
    

}

- (void)openFacebookSettings
{
    if ([self.delegate respondsToSelector:@selector(fbAccountDoesNotExist)])
    {
        [self.delegate performSelector:@selector(fbAccountDoesNotExist) withObject:nil];
    }
    
    
    SLComposeViewController *tweetSheet = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
    tweetSheet.view.hidden=TRUE;
    
    SLComposeViewControllerCompletionHandler __block completionHandler = ^(SLComposeViewControllerResult result){
        [tweetSheet.view endEditing:YES];
        switch(result){
            case SLComposeViewControllerResultCancelled:
            default:
            {
                //NSLog(@"Cancelled.....");
                
                
            }
                break;
            case SLComposeViewControllerResultDone:
            {
                //NSLog(@"Posted....");
            }
                break;
        }};
    //
    [tweetSheet setCompletionHandler:completionHandler];
    
    [[UIViewController topMostController] presentViewController:tweetSheet animated:NO completion:^{
        [tweetSheet.view endEditing:YES];
        //NSLog(@"check to see if facebook was updated");
    }];
}

- (void)shareWithImage:(UIImage*)image text:(NSString*)text
{
    ACAccountType *facebookAccountType = [self.accountStore
                                          accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierFacebook];
    
    
    // At first, we only ask for the basic read permission
    NSArray * permissions = @[@"email"];
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithObjectsAndKeys:FACEBOOK_APP_ID, ACFacebookAppIdKey, permissions, ACFacebookPermissionsKey, ACFacebookAudienceOnlyMe, ACFacebookAudienceKey, nil];
    
    
    [self.accountStore requestAccessToAccountsWithType:facebookAccountType options:dict completion:^(BOOL granted, NSError *error) {
        if (granted && error == nil) {
            /**
             * The user granted us the basic read permission.
             * Now we can ask for more permissions
             **/
            // Specify App ID and permissions
            NSDictionary *options = @{
                                      ACFacebookAppIdKey: FACEBOOK_APP_ID,
                                      ACFacebookPermissionsKey: @[@"publish_stream", @"publish_actions"],
                                      ACFacebookAudienceKey: ACFacebookAudienceFriends
                                      };
            [self.accountStore requestAccessToAccountsWithType:facebookAccountType
                                                       options:options completion:^(BOOL granted, NSError *e) {
                                                           if (granted) {
                                                               NSArray *accounts = [self.accountStore
                                                                                    accountsWithAccountType:facebookAccountType];
                                                               ACAccount *facebookAccount = [accounts lastObject];
                                                               
                                                               NSDictionary *parameters = @{@"message": text};
                                                               
                                                               NSURL *feedURL = [NSURL URLWithString:@"https://graph.facebook.com/me/photos"];
                                                               
                                                               SLRequest *feedRequest = [SLRequest
                                                                                         requestForServiceType:SLServiceTypeFacebook
                                                                                         requestMethod:SLRequestMethodPOST
                                                                                         URL:feedURL
                                                                                         parameters:parameters];
                                                               
                                                               NSData *imageData = UIImageJPEGRepresentation(image, 1.0f);
                                                               
                                                               [feedRequest addMultipartData:imageData withName:@"source" type:@"multipart/form-data" filename:@"ARTtwo50share"];
                                                               
                                                               feedRequest.account = facebookAccount;
                                                               
                                                               [self.delegate performSelectorOnMainThread:@selector(beginPostingTo:) withObject:@"Facebook" waitUntilDone:NO];
                                                               
                                                               [feedRequest performRequestWithHandler:^(NSData *responseData,
                                                                                                        NSHTTPURLResponse *urlResponse, NSError *error)
                                                                {
                                                                    NSString *reponse = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
                                                                    
                                                                    if (error != nil) {
                                                                        [[ATTrackingManager sharedManager] trackEvent:FL_FACEBOOK_SHARE_FAIL];
                                                                        //NSLog(@"Error %@", [error localizedDescription]);
                                                                        [self.delegate performSelectorOnMainThread:@selector(failedPost:) withObject:@"Facebook" waitUntilDone:NO];
                                                                    } else {
                                                                        [[ATTrackingManager sharedManager] trackEvent:FL_FACEBOOK_SHARE_SUCCESS];
                                                                        [[ATTrackingManager sharedManager] trackEvent:USER_SHARED_SUCCESS];
                                                                        [self.delegate performSelectorOnMainThread:@selector(successfulPost:) withObject:@"Facebook" waitUntilDone:NO];
                                                                    }
                                                                    // Handle response
                                                                }];
                                                               
                                                           }
                                                           else
                                                           {
                                                               //NSLog(@"Error: %@", [e localizedDescription]);
                                                               // Handle Failure
                                                           }
                                                       }];
        } else {
            [self performSelectorOnMainThread:@selector(fbSettingsAlert) withObject:nil waitUntilDone:NO];
        }
    }];
    
}


- (void)getUserData
{
    ACAccountType *facebookTypeAccount = [self.accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierFacebook];
    
    // At first, we only ask for the basic read permission
    NSArray * permissions = @[@"email"];
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithObjectsAndKeys:FACEBOOK_APP_ID, ACFacebookAppIdKey, permissions, ACFacebookPermissionsKey, ACFacebookAudienceOnlyMe, ACFacebookAudienceKey, nil];
    
    [self.accountStore requestAccessToAccountsWithType:facebookTypeAccount
                                           options: dict
                                        completion:^(BOOL granted, NSError *error) {
                                            if(granted){
                                                NSArray *accounts = [_accountStore accountsWithAccountType:facebookTypeAccount];
                                                ACAccount *facebookAccount = [accounts lastObject];
                                                
                                                [self me:facebookAccount];
                                            }else{
                                                // ouch
                                                NSLog(@"Error: %@", error);
                                            }
                                        }];
}

- (void)me:(ACAccount*)facebookAccount {
    NSURL *meurl = [NSURL URLWithString:@"https://graph.facebook.com/me"];
    
    SLRequest *merequest = [SLRequest requestForServiceType:SLServiceTypeFacebook
                                              requestMethod:SLRequestMethodGET
                                                        URL:meurl
                                                 parameters:nil];
    
    merequest.account = facebookAccount;
    
    [merequest performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error) {
        
        NSDictionary* jsonDict = [NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions
                              error:&error];
        self.userData = jsonDict;
        self.name = [self.userData objectForKey:@"name"];
        
        if ([self.delegate respondsToSelector:@selector(didGetFacebookData)]) {
            [self.delegate performSelectorOnMainThread:@selector(didGetFacebookData) withObject:nil waitUntilDone:YES];
        }
    }];
    
}




@end
