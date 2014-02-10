//
//  ATTwitterEngine.m
//  art250
//
//  Created by Winfred Raguini on 3/4/13.
//  Copyright (c) 2013 Art250. All rights reserved.
//

#import "ATTwitterManager.h"
#import <Accounts/Accounts.h>
#import <Social/Social.h>
#import <Twitter/Twitter.h>
#import "MBProgressHUD.h"
#import "UIViewController+ATExtensions.h"
#import "ATProgressHUDManager.h"

@interface ATTwitterManager()
@property (nonatomic, strong) ACAccountStore *accountStore;
- (void)openTwitterSettings;
@end



@implementation ATTwitterManager


+(id)sharedManager
{
    static dispatch_once_t pred;
    static ATTwitterManager *_sharedManager = nil;
    dispatch_once(&pred, ^{
        _sharedManager = [[ATTwitterManager alloc] init];
    });
    return _sharedManager;
}

- (id)init
{
    self = [super init];
    if (self) {
        _accountStore = [[ACAccountStore alloc] init];
    }
    return self;
}

- (void)dealloc
{
    // implement -dealloc & remove abort() when refactoring for
    // non-singleton use.
    abort();
}

- (void)checkAccount
{
    ACAccountType *twitterType =
    [self.accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
    
    
    ACAccountStoreRequestAccessCompletionHandler accountStoreHandler =
    ^(BOOL granted, NSError *error) {
        if (!granted) {
            NSLog(@"[ERROR] An error occurred while asking for user authorization: %@",[error localizedDescription]);
            if([error code]==6) {
                [self performSelectorOnMainThread:@selector(openTwitterSettings) withObject:nil waitUntilDone:NO];
            }
        } else {
            if ([self.delegate respondsToSelector:@selector(twitterAccountDoesExist)])
            {
                [self.delegate performSelector:@selector(twitterAccountDoesExist) withObject:nil];
            }
        }
    };
    
    [self.accountStore requestAccessToAccountsWithType:twitterType
                                               options:NULL
                                            completion:accountStoreHandler];
}






- (void)postImage:(UIImage *)image withStatus:(NSString *)status
{
    ACAccountType *twitterType =
    [self.accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
    
    SLRequestHandler requestHandler =
    ^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error) {
        if ([self.delegate respondsToSelector:@selector(willSendTweet)]) {
            [self.delegate performSelector:@selector(willSendTweet)];
        }
        if (responseData) {
            NSInteger statusCode = urlResponse.statusCode;
            if (statusCode >= 200 && statusCode < 300) {
                NSDictionary *postResponseData =
                [NSJSONSerialization JSONObjectWithData:responseData
                                                options:NSJSONReadingMutableContainers
                                                  error:NULL];
                NSLog(@"[SUCCESS!] Created Tweet with ID: %@", postResponseData[@"id_str"]);
                [[ATTrackingManager sharedManager] trackEvent:USER_SHARED_SUCCESS];
                if ([self.delegate respondsToSelector:@selector(didSendTweet)]) {
                    [self.delegate performSelector:@selector(didSendTweet)];
                }
            }
            else {
                NSLog(@"[ERROR] Server responded: status code %d %@", statusCode,[NSHTTPURLResponse localizedStringForStatusCode:statusCode]);
                if ([self.delegate respondsToSelector:@selector(tweetDidFail:)]) {
                    [self.delegate performSelector:@selector(tweetDidFail:) withObject:error];
                }
            }
        }
        else {


                //NSLog(@"[ERROR] An error occurred while posting: %@", [error localizedDescription]);
            if ([self.delegate respondsToSelector:@selector(tweetDidFail:)]) {
                [self.delegate performSelector:@selector(tweetDidFail:) withObject:error];
            }
        }
    };
    
    ACAccountStoreRequestAccessCompletionHandler accountStoreHandler =
    ^(BOOL granted, NSError *error) {
        if (granted) {
            NSArray *accounts = [self.accountStore accountsWithAccountType:twitterType];
            NSURL *url = [NSURL URLWithString:@"https://api.twitter.com"
                          @"/1.1/statuses/update_with_media.json"];
            NSDictionary *params = @{@"status" : status};
            SLRequest *request = [SLRequest requestForServiceType:SLServiceTypeTwitter
                                                    requestMethod:SLRequestMethodPOST
                                                              URL:url
                                                       parameters:params];
            NSData *imageData = UIImageJPEGRepresentation(image, 1.f);
            [request addMultipartData:imageData
                             withName:@"media[]"
                                 type:@"image/jpeg"
                             filename:@"image.jpg"];
            [request setAccount:[accounts lastObject]];
            [request performRequestWithHandler:requestHandler];
        }
        else {
            NSLog(@"[ERROR] An error occurred while asking for user authorization: %@",[error localizedDescription]);
            if([error code]==6) {
                [self performSelectorOnMainThread:@selector(openTwitterSettings) withObject:nil waitUntilDone:NO];
            }
        }
    };
    
    [self.accountStore requestAccessToAccountsWithType:twitterType
                                               options:NULL
                                            completion:accountStoreHandler];

}

- (void)openTwitterSettings
{
    if ([self.delegate respondsToSelector:@selector(twitterAccountDoesNotExist)])
    {
        [self.delegate performSelector:@selector(twitterAccountDoesNotExist) withObject:nil];
    }
    
    
    
    SLComposeViewController *tweetSheet = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
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
//    [tweetSheet setCompletionHandler:completionHandler];

    [[UIViewController topMostController] presentViewController:tweetSheet animated:NO completion:^{
        [tweetSheet.view endEditing:YES];
        //NSLog(@"check to see if twitter was updated");
    }];
}

- (void)getUserData
{
    
}

- (NSString*)name
{
    return @"Winfred Raguini (sfkaos)";
}

#pragma mark
#pragma mark UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"prefs:root=TWITTER"]];
}

@end
