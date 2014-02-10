//
//  ATMenuViewController.m
//  art250
//
//  Created by Winfred Raguini on 11/25/13.
//  Copyright (c) 2013 Art250. All rights reserved.
//

#import "ATMenuViewController.h"
#import "ATUserManager.h"
#import "ATUser.h"
#import "ATFacebookUser.h"
#import "ATAPIClient.h"
#import "ATNewsFeedViewController.h"
#import "ATArtistsDirectoryViewController.h"
#import "ATPriceMenuViewController.h"
#import "ATCollectionsMenuViewController.h"
#import "ATArtManager.h"
#import "ATRoomMenuViewController.h"
#import "ATInfoMenuViewController.h"
#import "ATLoggedInViewController.h"
#import "SearchableArtistProfile.h"

#define SLIDEOUT_WIDTH 380.0f
#define FB_PROFILE_PHOTO_SIZE 46.0f 
#define MENU_WIDTH 60.0f

@interface ATMenuViewController ()
@property (nonatomic, strong) UIButton *lastSelectedMenuButton;
@property (nonatomic, strong) FBProfilePictureView *fbProfilePictureView;
@property (nonatomic, strong) UIView *activeMenuView;
- (IBAction)menuButtonSelected:(id)sender;
- (void)showSlideOutView;
- (void)removeViewFromSuperview;
@end

@implementation ATMenuViewController

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

   [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didLogIn:) name:kdidLoginNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didLogIntoFacebook:) name:kdidLogIntoFacebookNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didLogOutOfFacebook:) name:kdidLogOutOfFacebookNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didLogInWithEmail:) name:kdidLogInWithEmailNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(alreadyLoggedIntoFacebook:) name:kalreadyLoggedIntoFacebookNotification object:nil];
    
    //UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapDetected:)];
    
    
    
    self.fbProfilePictureView = [[FBProfilePictureView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, FB_PROFILE_PHOTO_SIZE, FB_PROFILE_PHOTO_SIZE)];
    self.fbProfilePictureView.center = self.loginBtn.center;
    [self.loginBtn addSubview:self.fbProfilePictureView];
    [self.fbProfilePictureView setHidden:YES];
    
    UITapGestureRecognizer *fbLogoutTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didSelectLoginButton)];
    [self.fbProfilePictureView setGestureRecognizers:[NSArray arrayWithObject:fbLogoutTapRecognizer]];
    
    
    if ([[ATUserManager sharedManager] isLoggedInByEmail]) {
        [self updateATLoginView];
    } else if ([[ATUserManager sharedManager] isLoggedInByFacebook]) {
        [self updateFBLoginView];
    }
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark 
#pragma mark Private




- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    //NSLog(@"Passing all touches to the next view (if any), in the view stack.");
    return NO;
}


//- (void)tapDetected:(UITapGestureRecognizer*)recognizer
//{
//    if ([self.delegate respondsToSelector:@selector(hideMenuDock)]) {
//        [self.delegate performSelectorOnMainThread:@selector(hideMenuDock) withObject:nil waitUntilDone:NO];
//    }
//}

BOOL _animatingMenuView = NO;

- (IBAction)menuButtonSelected:(id)sender
{
    UIButton *selectedBtn = (UIButton*)sender;
    
    if (!_animatingMenuView) {
        if (selectedBtn == self.lastSelectedMenuButton) {
            [self didChooseSelectedMenu];
        } else {
            
            if (selectedBtn == self.loginBtn) {
                if ([[ATUserManager sharedManager] isLoggedIn]) {
                    [self didSelectLoginButton];
                } else {
                    [self willShowSignupDialog];
                }
            } else if (selectedBtn == self.favoritesBtn) {
                [[ATArtManager sharedManager] loadFavorites];
                
                [[NSNotificationCenter defaultCenter] postNotificationName:kdidInvokeHideMenuDockNotification object:nil];
            
            } else {
                if (selectedBtn == self.newsFeedBtn) {
                    if (self.lastSelectedMenuButton != self.newsFeedBtn) {
                        //[self clearActiveMenu];
                        if ([self.delegate respondsToSelector:@selector(clearMenu)]) {
                            [self.delegate performSelectorOnMainThread:@selector(clearMenu) withObject:nil waitUntilDone:YES];
                        }
                        if ([self.delegate respondsToSelector:@selector(pushToMenuViewController:)]) {
                            ATNewsFeedViewController *newsFeedController = [[ATNewsFeedViewController alloc] initWithNibName:@"ATNewsFeedViewController" bundle:nil];
                            [self.delegate performSelectorOnMainThread:@selector(pushToMenuViewController:) withObject:newsFeedController waitUntilDone:YES];
                        }
                    }
                    
                } else if (selectedBtn == self.collectionsBtn) {
                    if (self.lastSelectedMenuButton != self.collectionsBtn) {
                        if ([self.delegate respondsToSelector:@selector(clearMenu)]) {
                            [self.delegate performSelectorOnMainThread:@selector(clearMenu) withObject:nil waitUntilDone:YES];
                        }
                        
                        if ([self.delegate respondsToSelector:@selector(pushToMenuViewController:)]) {
                            ATCollectionsMenuViewController *collectionsMenuController = [[ATCollectionsMenuViewController alloc] initWithNibName:@"ATCollectionsMenuViewController" bundle:nil];
                            
                            UINavigationController *collectionsNavController = [[UINavigationController alloc] initWithRootViewController:collectionsMenuController];
                            
                            [self.delegate performSelectorOnMainThread:@selector(pushToMenuViewController:) withObject:collectionsNavController waitUntilDone:YES];
                        }
                    }
                } else if (selectedBtn == self.artistsBtn) {
                    if (self.lastSelectedMenuButton != self.artistsBtn) {
                        [self showArtistDirectory];
                    }
                } else if (selectedBtn == self.priceBtn) {
                    if (self.lastSelectedMenuButton != self.priceBtn) {
                        if ([self.delegate respondsToSelector:@selector(clearMenu)]) {
                            [self.delegate performSelectorOnMainThread:@selector(clearMenu) withObject:nil waitUntilDone:YES];
                        }
                        if ([self.delegate respondsToSelector:@selector(pushToMenuViewController:)]) {
                            ATPriceMenuViewController *artistDirectoryController = [[ATPriceMenuViewController alloc] initWithNibName:@"ATPriceMenuViewController" bundle:nil];
                            [self.delegate performSelectorOnMainThread:@selector(pushToMenuViewController:) withObject:artistDirectoryController waitUntilDone:YES];
                        }
                        
                    }
                } else if (selectedBtn == self.roomBtn) {
                    if (self.lastSelectedMenuButton != self.roomBtn) {
                        if ([self.delegate respondsToSelector:@selector(clearMenu)]) {
                            [self.delegate performSelectorOnMainThread:@selector(clearMenu) withObject:nil waitUntilDone:YES];
                        }
                        
                        if ([self.delegate respondsToSelector:@selector(pushToMenuViewController:)]) {
                            ATRoomMenuViewController *roomMenuController = [[ATRoomMenuViewController alloc] initWithNibName:@"ATMenuTableViewController" bundle:nil];
                            
                            [roomMenuController setDelegate:self];
                            
                            UINavigationController *roomNavController = [[UINavigationController alloc] initWithRootViewController:roomMenuController];

                            [self.delegate performSelectorOnMainThread:@selector(pushToMenuViewController:) withObject:roomNavController waitUntilDone:YES];
                        }
                        
                    }
                } else if (selectedBtn == self.infoBtn) {
                    if (self.lastSelectedMenuButton != self.infoBtn) {
                        [self showInfoMenuForFirstTimeUser:NO];
                    }
                }
                
                [self showSlideOutView];
            }
            NSArray *menuBtnArray = [[NSArray alloc] initWithObjects:self.loginBtn, self.newsFeedBtn, self.collectionsBtn, self.favoritesBtn, self.artistsBtn, self.priceBtn, self.roomBtn, self.infoBtn, nil];
            
            for (UIButton *menuBtn in menuBtnArray) {
                if (selectedBtn == menuBtn) {
                    [menuBtn setSelected:YES];
                    self.lastSelectedMenuButton = menuBtn;
                } else {
                    [menuBtn setSelected:NO];
                }
            }
        }
    }
}

- (void)showFirstTimeUserNavMenu
{
    [self showInfoMenuForFirstTimeUser:YES];
    [self showSlideOutView];
}

- (void)showArtistDirectory
{
    if ([self.delegate respondsToSelector:@selector(clearMenu)]) {
        [self.delegate performSelectorOnMainThread:@selector(clearMenu) withObject:nil waitUntilDone:YES];
    }
    if ([self.delegate respondsToSelector:@selector(pushToMenuViewController:)]) {
        ATArtistsDirectoryViewController *artistDirectoryController = [[ATArtistsDirectoryViewController alloc] initWithNibName:@"ATArtistsDirectoryViewController" bundle:nil];
        [artistDirectoryController setDelegate:self];
        [self.delegate performSelectorOnMainThread:@selector(pushToMenuViewController:) withObject:artistDirectoryController waitUntilDone:YES];
    }
    [self.artistsBtn setSelected:YES];
    self.lastSelectedMenuButton = self.artistsBtn;
    [self performSelector:@selector(showSlideOutView) withObject:nil afterDelay:0.5];
}


- (void)showInfoMenuForFirstTimeUser:(BOOL)firstTimerUser
{
    if ([self.delegate respondsToSelector:@selector(clearMenu)]) {
        [self.delegate performSelectorOnMainThread:@selector(clearMenu) withObject:nil waitUntilDone:YES];
    }
    
    if ([self.delegate respondsToSelector:@selector(pushToMenuViewController:)]) {
        ATInfoMenuViewController *infoMenuController = [[ATInfoMenuViewController alloc] initWithNibName:@"ATMenuTableViewController" bundle:nil];
        
        [infoMenuController setDelegate:self];
        
        UINavigationController *infoNavController = [[UINavigationController alloc] initWithRootViewController:infoMenuController];
        
        [self.delegate performSelectorOnMainThread:@selector(pushToMenuViewController:) withObject:infoNavController waitUntilDone:YES];
        
        if (firstTimerUser) {
            [infoMenuController performSelector:@selector(showHowToNavigateController) withObject:nil afterDelay:0.2f];
            if ([self.delegate respondsToSelector:@selector(hideMenuDock)]) {
                [self.delegate performSelector:@selector(hideMenuDock) withObject:nil afterDelay:7.0f];
            }
        }
    }
}




- (void)showSlideOutView
{
    _animatingMenuView = YES;
    if ([self.delegate respondsToSelector:@selector(showBlurryBackground)]) {
        [self.delegate performSelectorOnMainThread:@selector(showBlurryBackground) withObject:nil waitUntilDone:NO];
    }
    //Hide fakeslide out view
    [self.fakeSlideOutView setHidden:YES];
    if ([self.delegate respondsToSelector:@selector(showSlideOutView)]) {
        [self.delegate performSelectorOnMainThread:@selector(showSlideOutView) withObject:nil waitUntilDone:NO];
    }
    
}

- (void)didShowSlideOutView
{
    _animatingMenuView = NO;
}

- (void)showArtworkForArtistProfile:(SearchableArtistProfile*)artistProfile
{
    [self hideMenuDock];
    
    NSDictionary *artistProfileDict = [[NSDictionary alloc] initWithObjectsAndKeys:artistProfile.objectID, @"objectID", nil];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kdidInvokeLoadArtworkForArtistProfile object:nil userInfo:artistProfileDict];
}

- (void)hideMenuDock
{
    [[NSNotificationCenter defaultCenter] postNotificationName:kdidInvokeHideMenuDockNotification object:nil];
}

- (void)hideSlideOutView
{
    _animatingMenuView = YES;
    
    self.lastSelectedMenuButton = nil;
    
    NSArray *menuBtnArray = [[NSArray alloc] initWithObjects:self.loginBtn, self.newsFeedBtn, self.collectionsBtn, self.favoritesBtn, self.artistsBtn, self.priceBtn, self.roomBtn, self.infoBtn, nil];
    
    for (UIButton *menuBtn in menuBtnArray) {
        [menuBtn setSelected:NO];
    }
    
    if ([self.delegate respondsToSelector:@selector(hideSlideOutView)]) {
        [self.delegate performSelectorOnMainThread:@selector(hideSlideOutView) withObject:nil waitUntilDone:NO];
    }
}

- (void)didHideSlideOutView
{
    _animatingMenuView = NO;
}

- (void)willShowSignupDialog
{
    if ([self.delegate respondsToSelector:@selector(hideBlurryBackground)]) {
        [self.delegate performSelectorOnMainThread:@selector(hideBlurryBackground) withObject:nil waitUntilDone:NO];
    }
    [self hideSlideOutView];
    if ([self.delegate respondsToSelector:@selector(showSignUpDialog)]) {
        [self.delegate performSelectorOnMainThread:@selector(showSignUpDialog) withObject:nil waitUntilDone:NO];
    }
}

- (void)showFakeSlideOutView
{
    [self.fakeSlideOutView setHidden:NO];
}

- (void)removeViewFromSuperview
{
    [self.view removeFromSuperview];
}

#pragma mark
#pragma mark LogIn stuff
- (void)showLoggedInView
{
    
}

- (void)didLogIn:(NSNotification*)note
{
    NSLog(@"you did Log In!");
}


- (void)didLogIntoFacebook:(NSNotification*)note
{
    NSLog(@"did log into facebook");
    [self updateFBLoginView];
}

- (void)didSelectLoginButton
{
    if (self.lastSelectedMenuButton == self.loginBtn) {
        [self didChooseSelectedMenu];
    } else {
        self.lastSelectedMenuButton = self.loginBtn;
        
        if ([self.delegate respondsToSelector:@selector(clearMenu)]) {
            [self.delegate performSelectorOnMainThread:@selector(clearMenu) withObject:nil waitUntilDone:YES];
        }
        
        if ([self.delegate respondsToSelector:@selector(pushToMenuViewController:)]) {
            ATLoggedInViewController *loggedInController = [[ATLoggedInViewController alloc] initWithNibName:@"ATLoggedInViewController" bundle:nil];
            
            [loggedInController setDelegate:self];
            
            [self.delegate performSelectorOnMainThread:@selector(pushToMenuViewController:) withObject:loggedInController waitUntilDone:YES];
        }
        
        [self showSlideOutView];
    }
}

- (void)didLogOutOfFacebook:(NSNotification*)note
{
    NSLog(@"did log out of facebook");
}

- (void)didLogInWithEmail:(NSNotification*)note
{
    NSLog(@"did log in with email");
    [self updateATLoginView];
}

- (void)alreadyLoggedIntoFacebook:(NSNotification*)note
{
    NSLog(@"already logged Into facebook fool");
}

- (void)updateATLoginView
{
    //Update the menu button with the user image and name
    if ([[ATUserManager sharedManager] isLoggedIn]) {
        [self.fbProfilePictureView setHidden:YES];
        [self.loggedInImageView setHidden:NO];
        [self.loginLabel setHidden:NO];
        [self.loginLabel setText:@"Logged in"];
        //Add the users profile pic from ARTtwo50
        NSURL *imageURL = [NSURL URLWithString:[[[ATUserManager sharedManager] atUser] profileImageURLString]];
        NSLog(@"image URL %@",
              [[[ATUserManager sharedManager] atUser] profileImageURLString]);
        [self.loggedInImageView setImageWithURL:imageURL];
//        NSString *fbFirstName = [[[ATUserManager sharedManager] atUser] firstName];
//        [self.loggedInLabel setText:fbFirstName];
//        [self.loginBtn setSelected:NO];
        
//        [self.signInButton addSubview:self.fbProfilePictureView];
//        [self.fbProfilePictureView removeFromSuperview];
    } else {
        [self resetSignInButton];
    }
}

- (void)updateFBLoginView
{
    //Update the menu button with the user image and name
    if ([[ATUserManager sharedManager] isLoggedInByFacebook]) {
            [self.loginLabel setHidden:YES];
            [self.fbProfilePictureView setUserInteractionEnabled:YES];
            self.fbProfilePictureView.profileID = [[[ATUserManager sharedManager] fbUser] fbID];
            [self.fbProfilePictureView setHidden:NO];
        } else {
            [self resetSignInButton];
    }
    
}

- (void)resetSignInButton
{
    [self.fbProfilePictureView setHidden:YES];
    [self.loggedInImageView setHidden:YES];
    [self.loginLabel setHidden:NO];
    [self.loginLabel setText:@"Log in"];
}

- (void)didChooseSelectedMenu
{
    if (self.lastSelectedMenuButton == self.loginBtn && ![[ATUserManager sharedManager] isLoggedIn]) {
        [self willShowSignupDialog];        
    } else {
        [self hideSlideOutView];
        [self.lastSelectedMenuButton setSelected:NO];
        self.lastSelectedMenuButton = nil;
        //[self fadeOutActiveMenu];
        
        if ([self.delegate respondsToSelector:@selector(hideBlurryBackground)]) {
            [self.delegate performSelectorOnMainThread:@selector(hideBlurryBackground) withObject:nil waitUntilDone:NO];
        }
    }
}

#pragma mark
#pragma mark UITableViewDelegate


#pragma mark
#pragma mark UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"SimpleTableItem";
    
    NSString *cellIdentifier;
    UITableViewCell *cell;
    
    cellIdentifier = simpleTableIdentifier;
    cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleDefault;
    cell.backgroundColor = [UIColor whiteColor];
    cell.textLabel.textColor = [UIColor blackColor];
    
    
    [cell.textLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:18.0f]];
    cell.textLabel.text = @"Test";
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}



@end
