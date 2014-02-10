//
//  ATLoggedInViewController.m
//  art250
//
//  Created by Winfred Raguini on 12/2/13.
//  Copyright (c) 2013 Art250. All rights reserved.
//

#import "ATLoggedInViewController.h"
#import "ATUserManager.h"
#import "ATAPIClient.h"
#import "ATUserManager.h"
#import "ATUser.h"
#import "ATFacebookUser.h"

@interface ATLoggedInViewController ()

@end

@implementation ATLoggedInViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.logoutButton.titleLabel setFont:self.loggedInLabel.font];
    
    
    if ([[ATUserManager sharedManager] isLoggedInByEmail]) {
        NSString *fbFirstName = [[[ATUserManager sharedManager] atUser] firstName];
        [self.loggedInLabel setText:fbFirstName];
    } else if ([[ATUserManager sharedManager] isLoggedInByFacebook]) {
        NSString *fbFirstName = [[[ATUserManager sharedManager] fbUser] firstName];
        NSString *fbLastName = [[[ATUserManager sharedManager] fbUser] lastName];
        [self.loggedInLabel setText:[NSString stringWithFormat:@"%@ %@",fbFirstName, fbLastName]];
    }

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)logoutButtonSelected:(id)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:kdidInvokeHideMenuDockNotification object:nil];
    [self logOut];
}

- (void)logOut
{
    if ([[ATUserManager sharedManager] isLoggedInByFacebook]) {
        //[self.signOutPopoverController dismissPopoverAnimated:YES];
        [[ATUserManager sharedManager] setFbUser:nil];
        [[FBSession activeSession] closeAndClearTokenInformation];
        //[self resetSignInButton];
        if ([self.delegate respondsToSelector:@selector(updateFBLoginView)]) {
            [self.delegate performSelector:@selector(updateFBLoginView) withObject:nil];
        }

    } else {
        //[self.signOutPopoverController dismissPopoverAnimated:YES];
        
        [[ATAPIClient sharedClient] getPath:@"users/sign_out.json" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject){
            NSDictionary *responseDict = responseObject;
            if ([[responseDict objectForKey:@"logged_out"] intValue] == 1) {
                [[NSNotificationCenter defaultCenter] postNotificationName:kdidInvokeHideMenuDockNotification object:nil];
                
                [[NSNotificationCenter defaultCenter] postNotificationName:kdidLogOutWithEmailNotification object:nil userInfo:responseDict];
                //[self resetSignInButton];
                if ([self.delegate respondsToSelector:@selector(updateATLoginView)]) {
                    [self.delegate performSelector:@selector(updateATLoginView) withObject:nil];
                }
                
            } else {
                UIAlertView *failedLogin = [[UIAlertView alloc] initWithTitle:@"Could not log out" message:@"" delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles: nil];
                [failedLogin show];
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error){
            
        }];
    }
}


@end
