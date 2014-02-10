//
//  ATArtContainerViewController.m
//  art250
//
//  Created by Winfred Raguini on 8/24/12.
//  Copyright (c) 2012 Art250. All rights reserved.
//

#import "ATArtContainerViewController.h"
//#import "ATSearchViewController.h"
#import "ATWishlistViewController.h"
#import "ATArtDetailView.h"
#import "ATHangitContainerViewController.h"
#import "Artwork.h"
#import "UIImage+WRExtensions.h"
#import "ATArtManager.h"
#import "ATAppDelegate.h"
#import <QuartzCore/QuartzCore.h>
#import "ATGlobalConstants.h"
#import "ATSlotView.h"
#import "MBProgressHUD.h"
#import "ATCameraOverlayViewController.h"
#import "ATFTDIntroViewController.h"
#import "ATFTDWalkthrough1ViewController.h"
#import "ATFTDWalkthrough2ViewController.h"
#import "ATFTDWalkthrough3ViewController.h"
#import "ATFTDWalkthrough4ViewController.h"
#import "ATFTDWalkthrough5ViewController.h"
#import "ATFTDWalkthrough6ViewController.h"
#import "ATFTDWalkthrough7ViewController.h"
#import "ATFTDWalkthrough8ViewController.h"
#import "ATUserManager.h"
#import "ATMenuViewController.h"
#import "ATDatabaseManager.h"
#import "ArtistProfile.h"
#import "SearchableArtistProfile.h"
#import "ATTransientArtistProfile.h"
#import "ATTransientArtwork.h"

#define SLOT_FILL_ALERT_ACTIVATION_THRESHOLD 2
#define SLOTVIEW_POS_Y 658.0f
#define  COLLECTION_SLOT_ORIGIN_Y_OFFSET 17.0f
#define SLOTVIEW_X_OFFSET 5.0f

@class ATSlotView;
@interface ATArtContainerViewController ()
@property (nonatomic, strong) UIViewController *activeMenuController;
@property (nonatomic, strong) UIImage *blurredBackgroundImage;
@property (nonatomic, strong) UIImageView *blurryImageOverlayView;
@property (nonatomic, strong) UIImageView *dragToCollectionImageView;
@property (nonatomic, strong, readwrite) UIImageView *draggablePaintingView;
@property (nonatomic, strong, readwrite) UIImageView *splashView;
@property (nonatomic, strong) ATFTDIntroViewController *recommendationFTDWalkthroughController;
@property (nonatomic, assign) BOOL fullCollectionAlertActivated;
@property (nonatomic, copy) NSManagedObjectID *bufferedArtworkObjectID;
@property (nonatomic, strong) ATSlotView *bufferedSlotView;
@property (nonatomic, assign) BOOL isAddingArtworkToCollection;
@property (nonatomic, strong) ATMenuViewController *menuViewController;
@property (nonatomic, strong) UIView *slideOutView;
- (void)didLogin:(NSNotification*)note;
- (void)handlePan:(UILongPressGestureRecognizer *)recognizer;
- (void)updateHangitBackgroundImage:(UIImage*)backgroundImage;
- (void)updateHangitBackgroundImageWithSampleRoomImage:(UIImage *)backgroundImage;
- (void)createDraggablePaintingThumb:(NSDictionary*)userInfo;
- (void)hideBottomToolBar;
- (void)showBottomToolBar;
- (void)retrieveSuggestedArtworkForBackgroundImage:(UIImage*)image;
- (void)retrieveSuggestedArtworkForSavedBackgroundImage;
- (void)artObjectRemovedFromCollection:(Artwork*)artObject;
- (BOOL)artObjectInCollection:(Artwork*)artObject;
- (void)swapSlotsForArtObject:(Artwork*)currentArtObject withSlotView:(ATSlotView*)replacedSlotView;
- (void)retrieveSuggestedArtworkFromCache;
- (void)lightenView;
- (void)darkenView;
- (void)showSlideOutView;
- (void)showArtistDirectory;
@end

@implementation ATArtContainerViewController
@synthesize detailView = detailView_;
@synthesize hangItController = hangItController_;
@synthesize draggablePaintingView = _draggablePaintingView;
@synthesize backgroundImage = _backgroundImage;

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
    
    //DB initialization
    [[ATDatabaseManager sharedManager] initializeDB];
        
    
    [[ATArtManager sharedManager] initializeArtistProfileObjectIDs];

    
    if ([FBSession openActiveSessionWithAllowLoginUI:NO]) {
        [FBRequestConnection
         startForMeWithCompletionHandler:^(FBRequestConnection *connection,
                                           id<FBGraphUser> user,
                                           NSError *error) {
             [[ATUserManager sharedManager] setFBUserWithFBGraphUser:user];
         }];
    }
    
    
    //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didDisplayNextPainting:) name:kdidDisplayNextPainting object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hideMenuDock) name:kdidInvokeHideMenuDockNotification object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didChooseNewPhotoOption:) name:kdidChooseNewPhotoOptionNotification object:nil];
    
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didTakeNewPhotoOption:) name:kdidChooseTakeNewPhotoOptionNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didSelectCloseCameraButton:) name:kdidSelectCloseCameraButton object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didTapOnArtworkInCollection:) name:kDidTapOnArtObjectInCollection object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(willDismissArtworkPreview:) name:kwillDismissArtworkPreview object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didLoadFinalIntroScreen:) name:kdidLoadFinalIntroScreen object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didGetSuggestedArtworkFailure:) name:kdidGetSuggestedArtworkFailure object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didCompleteChoosingOptionsForSampleRoom:) name:kdidCompleteChoosingOptionsForSampleRoom object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didStartDisplayingDetailView:) name:kdidStartDisplayingDetailViewNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didDismissDetailView:) name:kdidDismissDetailViewNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showFirstTimeDirections) name:kdidChooseTakeTourNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didChooseSkipTourButton) name:kdidChooseSkipTourButtonNotification object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didInitializeArtwork:) name:kdidInitializeArtworkNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(resetFullCollectionAlertActivation) name:kdidDismissFullCollectionAlertNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didCompletePurchase) name:kdidDismissCompletedPurchaseScreenNotification object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didInvokeShowBottomToolbar) name:kdidInvokeShowBottomToolBarNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(retrieveSuggestedArtworkForSavedBackgroundImage) name:kRetrieveSuggestedArtworkForSavedImgNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didGetSuggestedArtworkSuccessfully:) name:kdidGetSuggestedArtworkSuccessfullyNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deleteSharedImagesForPurchasedArtwork) name:kdidInvokeDeletingSharedImgForCartNotification object:nil];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didDisplayCollectionDock:) name:kdidDisplayCollectionDockNotification object:nil];
    
    
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(removeArtworkFromCollection:) name:kremoveArtworkFromCollectionNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didShowSignUpDialog:) name:kdidShowSignUpDialogNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didHideSignUpDialog:) name:kdidHideSignUpDialogNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didLogIn:) name:kdidLoginNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didCancelSignInDialog:) name:kdidCancelSignInDialogNotification object:nil];
    
    NSLog(@"about to load hangitcontroller");
    
    self.hangItController = [[ATHangitContainerViewController alloc] initWithNibName:@"ATHangitContainerViewController" bundle:nil];
    NSLog(@"loaded hangitcontroller");
    self.hangItController.delegate = self;
    [self addChildViewController:self.hangItController];
    [self.hangItController didMoveToParentViewController:self];
    [self.view addSubview:self.hangItController.view];
    
    
    
    self.blurryImageOverlayView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.view.frame.size.width, self.view.frame.size.height)];
    [self.blurryImageOverlayView setUserInteractionEnabled:YES];
    [self.view addSubview:self.blurryImageOverlayView];
    [self.blurryImageOverlayView setAlpha:0.0f];
    [self.blurryImageOverlayView setHidden:YES];
    
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(blurryImageTapDetected:)];
    [self.blurryImageOverlayView setGestureRecognizers:[NSArray arrayWithObject:tapRecognizer]];

    
    self.slideOutView = [[UIView alloc] initWithFrame:CGRectMake(-320.0f, 0.0f, 380.0f, 704.0f)];
    [self.slideOutView setBackgroundColor:[UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.6f]];
    [self.view addSubview:self.slideOutView];
    [self.slideOutView setHidden:YES];
    
    
    self.wishlistController = [[ATWishlistViewController alloc] initWithNibName:@"ATWishlistViewController" bundle:nil];
    [self.wishlistController setDelegate:self];
    CGRect wishlistRectFrame = self.wishlistController.view.frame;
    wishlistRectFrame.origin.y = self.view.frame.size.height - self.wishlistController.view.frame.size.height;
    
    self.wishlistController.view.frame = wishlistRectFrame;
    [self addChildViewController:self.wishlistController];
    [self.wishlistController didMoveToParentViewController:self];
    
    [self.view addSubview:self.wishlistController.view];

    
//#if !(TARGET_IPHONE_SIMULATOR)
    if ([[ATArtManager sharedManager] firstTimeUser]) {
        [self hideBottomToolBar];
    }
    
//#endif
    
    //Add the layer the darkeningView will sit in
    self.darkeningViewContainerView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.view.frame.size.width, self.view.frame.size.height)];
    [self.darkeningViewContainerView setUserInteractionEnabled:NO];
    [self.darkeningViewContainerView setBackgroundColor:[UIColor clearColor]];
    
    [self.view addSubview:self.darkeningViewContainerView];
    
    //Add the layer the darkeningView will sit in
    self.signUpSignInContainerView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.view.frame.size.width, self.view.frame.size.height)];
    [self.signUpSignInContainerView setUserInteractionEnabled:NO];
    [self.signUpSignInContainerView setBackgroundColor:[UIColor clearColor]];
    
    [self.view addSubview:self.signUpSignInContainerView];
    
    
    
    //Create menu dock
    self.menuViewController = [[ATMenuViewController alloc] initWithNibName:@"ATMenuViewController" bundle:nil];
    [self.menuViewController setDelegate:self];
    [self addChildViewController:self.menuViewController];
    [self.menuViewController didMoveToParentViewController:self];
    
    CGRect sideMenuViewFrame = self.menuViewController.view.frame;
    sideMenuViewFrame.origin.x = -60.0f;
    sideMenuViewFrame.origin.y = 0;
    [self.menuViewController.view setFrame:sideMenuViewFrame];
    [self.view addSubview:self.menuViewController.view];
    
    [self retrieveSuggestedArtworkFromCache];
}


- (void)checkNotifications:(NSNotification*)note
{
    //NSLog("notification name:%@", [note name]);
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)viewDidAppear:(BOOL)animated
{

    
}

- (void)takePhoto
{
    [self.wishlistController takePhoto:NO];
    
    for (UIView *view in self.view.subviews) {
        if (view == self.splashView) {
            [view removeFromSuperview];
        } 
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if (interfaceOrientation == UIInterfaceOrientationLandscapeRight || interfaceOrientation == UIInterfaceOrientationLandscapeLeft) {
        return YES;
    } else {
        return NO;
    }
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

#pragma mark
#pragma mark Private

- (void)showBlurryBackground
{
   
    [self.blurryImageOverlayView setImage:self.blurredBackgroundImage];
    [self.blurryImageOverlayView setHidden:NO];
    [UIView animateWithDuration:1.0f animations:^(void){
        
        [self.blurryImageOverlayView setAlpha:1.0f];
        
    } completion:^(BOOL finished){
        if (finished) {
            
        }
    }];
}

- (void)hideBlurryBackground
{
    [UIView animateWithDuration:1.0f animations:^(void){
        
        [self.blurryImageOverlayView setAlpha:0.0f];
        
        
    } completion:^(BOOL finished){
        if (finished) {
            [self.blurryImageOverlayView setHidden:YES];
        }
    }];
}

- (void)blurryImageTapDetected:(UITapGestureRecognizer*)recognizer
{
    [self hideMenuDock];
}

- (void)showMenuDock
{
    [self performSelectorInBackground:@selector(createBlurredImageFromCurrentArtwork) withObject:nil];
    //[self performSelectorOnMainThread:@selector(createBlurredImageFromCurrentArtwork) withObject:nil waitUntilDone:NO];
    //[self createBlurredImageFromCurrentArtwork];
    
    [UIView animateWithDuration:0.5f animations:^(void){
        CGRect sideMenuViewFrame = self.menuViewController.view.frame;
        sideMenuViewFrame.origin.x = 0.0f;
        [self.menuViewController.view setFrame:sideMenuViewFrame];
    } completion:^(BOOL finished){
        [self.wishlistController.menuBtn setEnabled:YES];
    }];
}


- (void)hideMenuDock
{
    [self hideBlurryBackground];
    [self.menuViewController hideSlideOutView];
    [self.view endEditing:YES];
    [UIView animateWithDuration:0.5f animations:^(void){
        CGRect sideMenuViewFrame = self.menuViewController.view.frame;
        sideMenuViewFrame.origin.x = -60.0f;
        [self.menuViewController.view setFrame:sideMenuViewFrame];
    } completion:^(BOOL finished){
        [self.wishlistController.menuBtn setSelected:NO];
        [self.menuViewController hideSlideOutView];
        [self.wishlistController.menuBtn setEnabled:YES];
    }];
}


- (void)removeMenu
{
    [self.menuViewController removeFromParentViewController];
    [self.menuViewController.view removeFromSuperview];
    self.menuViewController = nil;
}

- (void)showSlideOutView
{
    [self.slideOutView setHidden:NO];
    [UIView animateWithDuration:1.0f animations:^(void){
        CGRect slideOutViewFrame = self.slideOutView.frame;
        slideOutViewFrame.origin.x = 0.0f;
        [self.slideOutView setFrame:slideOutViewFrame];
    } completion:^(BOOL finished){
        [self.menuViewController didShowSlideOutView];
    }];
}

- (void)hideSlideOutView
{
    [UIView animateWithDuration:1.0f animations:^(void){
        CGRect slideOutViewFrame = self.slideOutView.frame;
        slideOutViewFrame.origin.x = -320.0f;
        [self.slideOutView setFrame:slideOutViewFrame];
    } completion:^(BOOL finished){
        [self.slideOutView setHidden:YES];
        [self.menuViewController showFakeSlideOutView];
        [self.menuViewController didHideSlideOutView];
    }];
}

- (void)clearMenu
{
//    for (UIView *subView in self.slideOutView.subviews) {
//        [subView removeFromSuperview];
//    }
    if ([self.slideOutView.subviews count] == 1) {
        UIView *menuView = [self.slideOutView.subviews objectAtIndex:0];
        [menuView removeFromSuperview];
        [self.activeMenuController removeFromParentViewController];
        self.activeMenuController = nil;
    }

}

- (void)pushToMenuViewController:(UIViewController*)viewController
{
    self.activeMenuController = viewController;
    CGRect viewControllerFrame = self.activeMenuController.view.frame;
    viewControllerFrame.origin.y = 0.0f;
    viewControllerFrame.origin.x = 60.0f;
    viewControllerFrame.size.width = 320.0f;
    [self.activeMenuController.view setFrame:viewControllerFrame];
    [self.slideOutView addSubview:self.activeMenuController.view];
    [self addChildViewController:self.activeMenuController];
    
}

- (void)testButtonAction:(id)sender
{
}

- (void)createBlurredImageFromCurrentArtwork
{
    self.blurredBackgroundImage = [self.hangItController blurredBackgroundImage];
}

- (void)didInvokeShowBottomToolbar
{
    [self showBottomToolBar];
}

- (void)didInitializeArtwork:(NSNotification*)note
{
    [self activateBrowsing];
    [[ATArtManager sharedManager] hideArtRecommendationView];
    
    if ([[ATArtManager sharedManager] firstTimeUser]) {
        //
        [self showNavigationMenu];
        [[ATArtManager sharedManager] setFirstTimeUser:NO];
    }
}

- (void)updateHangitBackgroundImageWithCurrentRoomImage
{
    [self.hangItController saveCurrentBackgroundImage];
    [self hideBottomToolBar];
    [self.hangItController displayModalCameraOverlayControllerWithMode:ATCameraModeSizeOnly];
}

- (void)updateHangitBackgroundImageWithSampleRoomImage:(UIImage *)backgroundImage
{
    [self updateHangitBackgroundImageWithSampleRoomImage:backgroundImage closeable:YES];
}

- (void)displayLaunchScreenSampleRoomImage:(UIImage*)backgroundImage
{
    [self updateHangitBackgroundImageWithSampleRoomImage:backgroundImage closeable:NO];
}

- (void)updateHangitBackgroundImageWithSampleRoomImage:(UIImage *)backgroundImage closeable:(BOOL)closeable
{
    //First save the current background in case they cancel
    [self.hangItController saveCurrentBackgroundImage];
    
    [self hideBottomToolBar];
    [self setWallWithImage:backgroundImage];
    [self.hangItController displayModalCameraOverlayController:closeable];
}

- (void)updateHangitBackgroundImageWithRoomImage:(UIImage *)backgroundImage
{
    //First save the current background in case they cancel
    [self.hangItController saveCurrentBackgroundImage];
    [self.hangItController.backgroundImageView setImage:nil];
    [self hideBottomToolBar];
    [self setWallWithImage:backgroundImage];
    [self.hangItController displayModalCameraOverlayControllerWithMode:ATCameraModeAlbumPhoto];
}

- (void)clearBackground
{
    [self.hangItController hidePaintings];
    [self.hangItController.backgroundImageView setImage:nil];
}

- (void)updateHangitBackgroundImage:(id)backgroundImage
{
    UIImage *image = (UIImage*)backgroundImage;
    [self setWallWithImage:image];
    [self retrieveSuggestedArtworkForBackgroundImage:backgroundImage];
}

- (void)setWallWithImage:(UIImage*)backgroundImage
{
    self.hangItController.backgroundImageView.image = backgroundImage;
    [[ATArtManager sharedManager] setWallImage:backgroundImage];
    [[ATArtManager sharedManager] setPrimaryBackgroundImageColors:[backgroundImage averageColorArray]];
    [[ATArtManager sharedManager] cacheBackgroundImage:backgroundImage];
}


- (void)retrieveSuggestedArtworkForSavedBackgroundImage
{
    [self retrieveSuggestedArtworkForBackgroundImage:[[ATArtManager sharedManager] cachedBackgroundImage]];
}

BOOL _startedWalkthroughTutorial = NO;

- (void)retrieveSuggestedArtworkFromCache
{
    [[ATArtManager sharedManager] retrieveSuggestedArtworkFromCache];
    if ([[[ATArtManager sharedManager] artCarousel] count] > 0) {
        NSNumber *currIndexNumber = [[NSUserDefaults standardUserDefaults] objectForKey:@"currIndex"];
        
        if ([currIndexNumber intValue] >= [[[ATArtManager sharedManager] artCarousel] count]) {
            int index = [[[ATArtManager sharedManager] artCarousel] count] - 1;
            currIndexNumber = [NSNumber numberWithInt:index];
            [[NSUserDefaults standardUserDefaults] setObject:currIndexNumber forKey:@"currIndex"];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
        
        [self.hangItController initializeArtworkOrderWithIndex:currIndexNumber];
    }
    
//    else {
//        if (error) {
//            UIAlertView *errorAlertView = [[UIAlertView alloc] initWithTitle:@"Ooops!" message:[NSString stringWithFormat:@"Error: %@", error.localizedDescription] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
//            [errorAlertView show];
//        } else {
//            [self.hangItController noMoreArtworkToday];
//        }
//    }
    
    
//    [[ATArtManager sharedManager] retrieveSuggestedArtworkFromCacheWithBlock:^(BOOL finished, NSError *error){
//        if (finished) {
//            
//            if ([[[ATArtManager sharedManager] artCarousel] count] > 0) {
//                [self.hangItController initializeArtworkOrder];
//            } else {
//                if (error) {
//                    UIAlertView *errorAlertView = [[UIAlertView alloc] initWithTitle:@"Ooops!" message:[NSString stringWithFormat:@"Error: %@", error.localizedDescription] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
//                    [errorAlertView show];
//                } else {
//                    [self.hangItController noMoreArtworkToday];
//                }
//            }
//        }
//    }];
}

- (void)showArtRecommendationHUD
{
    [[ATArtManager sharedManager] showArtRecommendationHUDForView:self.view withText:[NSString stringWithFormat:@"Finding %d recommendations inspired by you and the colors in your space.", [[ATArtManager sharedManager] maxArtworkThreshold]]];
}

- (void)retrieveSuggestedArtworkForBackgroundImage:(UIImage*)image
{
    _startedWalkthroughTutorial = NO;
    
    if ([[ATArtManager sharedManager] firstTimeUser]) {
        [self performSelector:@selector(retrieveSuggestedArtworkForImage:) withObject:image afterDelay:5.0f];
        
    } else {
        [self retrieveSuggestedArtworkForImage:image];
    }
}

- (void)retrieveSuggestedArtworkForImage:(UIImage *)image
{
    [[ATArtManager sharedManager] deleteSuggestedArtwork];
    
    [[ATArtManager sharedManager] retrieveSuggestedArtworkWithBackgroundImage:image completionBlock:^(BOOL finished){
        if (finished) {
            
        }
    }];
}



- (void)didGetSuggestedArtworkSuccessfully:(NSNotification*)note
{
    if (!_startedWalkthroughTutorial) {
        [self.recommendationFTDWalkthroughController.view removeFromSuperview];
        [self showRecommendedArtwork];
    }
}

- (void)createWalkthroughViews
{
    if (self.recommendationFTDWalkthroughController) {
        
        ATFTDWalkthrough2ViewController *walkthrough2Controller = [[ATFTDWalkthrough2ViewController alloc] initWithNibName:@"ATFTDWalkthrough2ViewController" bundle:nil];
        
        [self.recommendationFTDWalkthroughController addChildViewController:walkthrough2Controller];
        
        
        ATFTDWalkthrough3ViewController *walkthrough3Controller = [[ATFTDWalkthrough3ViewController alloc] initWithNibName:@"ATFTDWalkthrough3ViewController" bundle:nil];
        
        [self.recommendationFTDWalkthroughController addChildViewController:walkthrough3Controller];
        
        ATFTDWalkthrough4ViewController *walkthrough4Controller = [[ATFTDWalkthrough4ViewController alloc] initWithNibName:@"ATFTDWalkthrough4ViewController" bundle:nil];
        [self.recommendationFTDWalkthroughController addChildViewController:walkthrough4Controller];
        
        ATFTDWalkthrough5ViewController *walkthrough5Controller = [[ATFTDWalkthrough5ViewController alloc] initWithNibName:@"ATFTDWalkthrough5ViewController" bundle:nil];
        [self.recommendationFTDWalkthroughController addChildViewController:walkthrough5Controller];
        
        ATFTDWalkthrough6ViewController *walkthrough6Controller = [[ATFTDWalkthrough6ViewController alloc] initWithNibName:@"ATFTDWalkthrough6ViewController" bundle:nil];
        [self.recommendationFTDWalkthroughController addChildViewController:walkthrough6Controller];
        
        ATFTDWalkthrough7ViewController *walkthrough7Controller = [[ATFTDWalkthrough7ViewController alloc] initWithNibName:@"ATFTDWalkthrough7ViewController" bundle:nil];
        [self.recommendationFTDWalkthroughController addChildViewController:walkthrough7Controller];
        
        ATFTDWalkthrough8ViewController *walkthrough8Controller = [[ATFTDWalkthrough8ViewController alloc] initWithNibName:@"ATFTDWalkthrough8ViewController" bundle:nil];
        [self.recommendationFTDWalkthroughController addChildViewController:walkthrough8Controller];
    }


}

- (void)showFirstTimeDirections
{
    _startedWalkthroughTutorial = YES;
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kdidStartFirstTimeDirectionsTutorialNotification object:nil];
    
    self.recommendationFTDWalkthroughController = [[ATFTDIntroViewController alloc] initWithNibName:@"ATFTDIntroViewController" bundle:nil];
    self.recommendationFTDWalkthroughController.delegate = self;
    
    [self createWalkthroughViews];
    
    [self.view addSubview:self.recommendationFTDWalkthroughController.view];
    
}

- (void)didChooseSkipTourButton
{
    self.recommendationFTDWalkthroughController = nil;
    [self showRecommendedArtwork];
}

- (void)showRecommendedArtwork
{
    [[ATArtManager sharedManager] hideArtRecommendationView];
    self.recommendationFTDWalkthroughController = nil;
    if ([[[ATArtManager sharedManager] artCarousel] count] > 0) {
        [self.hangItController initializeArtworkOrderWithIndex:[NSNumber numberWithInt:0]];
    } else {
        [self.hangItController noMoreArtworkToday];
    }
}

- (void)scrollViewDidScroll:(UIScrollView*)scrollView
{
    _startedWalkthroughTutorial = YES;
    [[NSNotificationCenter defaultCenter] postNotificationName:kdidStartFirstTimeDirectionsTutorialNotification object:nil];
}

- (void)retrieveArtForImage:(UIImage*)image
{

}

- (void)createHangitMergedImageForArtObject:(Artwork*)artObject
{
    dispatch_queue_t createHangitMergeQueue;
    createHangitMergeQueue = dispatch_queue_create("com.arttwo50.createHangitMergedImage", NULL);
    
    dispatch_async(createHangitMergeQueue, ^{
        printf("Do some work here.\n");
        [self.hangItController createHangitMergedImageForArtObject:artObject];
    });
}

- (void)didAddArtworkToCart
{
    [self.hangItController createHangitMergedImageFromCurrentArtwork];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}



- (void)removeArtworkFromCollection:(NSNotification*)note
{
    NSDictionary *userInfo = [note userInfo];
    Artwork *artwork = [userInfo objectForKey:@"artObject"];
    [self artObjectRemovedFromCollection:artwork moveForward:YES];
}


- (void)didLogIn:(NSNotification*)note
{
    [self hideMenuDock];
    
    if ([[ATUserManager sharedManager] isTryingToFavoriteCurrentArtwork]) {
        [[ATArtManager sharedManager] addArtworkToCollection:[[ATArtManager sharedManager] currentArtObject]];
        [[ATUserManager sharedManager] setIsTryingToFavoriteCurrentArtwork:NO];
    }
}

- (void)didCancelSignInDialog:(NSNotification*)note
{
    if (self.isAddingArtworkToCollection) {
        if (self.bufferedArtworkObjectID != nil) {
            [self removeArtworkFromCollectionWithObjectID:self.bufferedArtworkObjectID];
        }
        self.isAddingArtworkToCollection = NO;
    }


}

- (void)removeArtworkFromCollectionWithObjectID:(NSManagedObjectID*)objectID
{
    NSManagedObjectContext *ctx = [[RKObjectManager sharedManager] managedObjectStore].mainQueueManagedObjectContext;
    Artwork *artwork = (Artwork*)[ctx objectWithID:objectID];
    if (artwork) {
        [self artObjectRemovedFromCollection:artwork moveForward:NO replaceCurrentArtwork:NO];
        self.bufferedArtworkObjectID = nil;
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kdidInvokeUpdateCollectionDockNotification object:nil];
}

- (void)showSignUpDialog
{
    
    [[ATUserManager sharedManager] showSignUpDialogInView:self.signUpSignInContainerView forDelegate:self];
}

- (void)showNavigationMenu
{
    [self showMenuDock];
    [self.menuViewController showFirstTimeUserNavMenu];
}

- (void)hideSignUpDialog
{
    [[ATUserManager sharedManager] hideSignInDialog];
}


- (void)showArtistDirectory
{
    [self showMenuDock];
    [self.menuViewController showArtistDirectory];
}




- (void)deleteSharedImagesForPurchasedArtwork
{
    
#warning WIN - Fix this so the shared Images are deleted for any purchased art!!!

}


- (void)didDisplayCollectionDock:(NSNotification*)note
{

}


- (void)collectionDockWillDisappear:(NSNotification*)note
{

}


- (void)resetFullCollectionAlertActivation
{
    self.fullCollectionAlertActivated = NO;
}

- (void)buttonClicked:(id)sender
{
    
}




- (void)profileButtonSelected
{
}

- (void)closeButtonSelected:(id)sender
{
    [UIView animateWithDuration:2.0f
                     animations:^{
                         [self.detailView removeFromSuperview];
                     }
                     completion:^(BOOL finished){
                         
                     }];
}



- (void)hideBottomToolBar
{
    [UIView animateWithDuration:0.5f animations:^(void){
        CGRect wishlistRectFrame = self.wishlistController.view.frame;
        wishlistRectFrame.origin.y = self.view.frame.size.height;
        self.wishlistController.view.frame = wishlistRectFrame;
    } completion:^(BOOL finished) {
        
    }];
    
}

- (void)activateBrowsing
{
    [self showBottomToolBar];
    [self.hangItController.horizontalScrollView setUserInteractionEnabled:YES];
    [self.hangItController.verticalScrollView setUserInteractionEnabled:YES];
}

- (void)showBottomToolBar
{
     [UIView animateWithDuration:0.5f delay:0.0f usingSpringWithDamping:0.8 initialSpringVelocity:0.7 options:UIViewAnimationOptionCurveEaseInOut animations:^(void){
        CGRect wishlistRectFrame = self.wishlistController.view.frame;
        wishlistRectFrame.origin.y = 704.0f;
        self.wishlistController.view.frame = wishlistRectFrame;
    } completion:^(BOOL finished){
        if (finished) {
            //Can show the slot views here if the collectionDock is showing
            [[NSNotificationCenter defaultCenter] postNotificationName:kdidShowBottomToolbarNotification object:nil];
            
            
        }
    }];

}



- (void)artObjectRemovedFromCollection:(Artwork*)artObject
{
    [self artObjectRemovedFromCollection:artObject moveForward:YES];
}

- (void)artObjectRemovedFromCollection:(Artwork *)artObject moveForward:(BOOL)moveForward
{
    [self artObjectRemovedFromCollection:artObject moveForward:moveForward replaceCurrentArtwork:YES];
}

- (void)artObjectRemovedFromCollection:(Artwork*)artObject moveForward:(BOOL)moveForward replaceCurrentArtwork:(BOOL)replaceCurrentArtwork
{


    //Remove object from cart
    [[ATArtManager sharedManager] removeArtObjectFromCart:artObject];
    //Remove object from the actual collection
    [[ATArtManager sharedManager] removeArtObjectFromCollection:artObject];
    [[ATArtManager sharedManager] deleteShareImageforArtObject:artObject];
    

    int tempNextIndex;

    
    tempNextIndex = [self.hangItController currIndex];
    
    if ([[ATArtManager sharedManager] currentArtObject] != artObject) {
        [[ATArtManager sharedManager] removeArtworkFromSuggestedArtwork:artObject];
        [[ATArtManager sharedManager] insertArtObject:artObject atIndex:tempNextIndex];
    }


    [self.hangItController refreshAllScrollViewSubviews];
    [self.hangItController.horizontalScrollView setScrollEnabled:YES];
    [self.hangItController.verticalScrollView setScrollEnabled:YES];
    

    [self.hangItController populateAdditionalArtworkByArtistWithID:artObject.userID];
    

}


- (void)didCompleteChoosingOptionsForSampleRoom:(NSNotification*)note
{
    NSDictionary *userInfo = [note userInfo];
    UIImage *backgroundImage = [userInfo objectForKey:kBackgroundImageKey];
    [self showArtRecommendationHUD];
    [self retrieveSuggestedArtworkForBackgroundImage:backgroundImage];
}

- (void)didIncrementArtCounter:(NSNotification*)note
{

}

- (void)disablePhotoButton
{
    [self.wishlistController disablePhotoButton];
}

- (void)enablePhotoButton
{
    [self.wishlistController enablePhotoButton];
}

- (void)didTapOnArtwork
{
    [self.hangItController displayDetailedView];
}

- (void)didTapOnArtworkInCollection:(NSNotification*)note
{
    NSDictionary *dict = [note userInfo];
    Artwork *artObject = [dict objectForKey:@"artObject"];
    [self hideBottomToolBar];
    [self.hangItController displayPreviewPaintingWithArtObject:artObject];
}

- (void)didChooseNewPhotoOption:(NSNotification*)note
{
    //Nothing
}

- (void)didTakeNewPhotoOption:(NSNotification*)note
{
    [self hideBottomToolBar];
}

- (void)didSelectCloseCameraButton:(NSNotification*)note
{
    [self showBottomToolBar];
}


- (void)willDismissArtworkPreview:(NSNotification*)note
{
    
    [self showBottomToolBar];
}

- (void)didLoadFinalIntroScreen:(NSNotification*)note
{
#if (TARGET_IPHONE_SIMULATOR)
    [self showBottomToolBar];
#endif
}


- (void)didGetSuggestedArtworkFailure:(NSNotification*)note
{
    NSDictionary *userInfo = [note userInfo];
    NSError *error = [userInfo objectForKey:kServerErrorKey];
    
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    
    UIAlertView *errorAlertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Ooops!",nil) message:[error localizedDescription] delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil];
    [errorAlertView show];
    
    [[ATArtManager sharedManager] hideArtRecommendationView];
    
    [self showBottomToolBar];
}



#pragma mark
#pragma mark ATSlotViewDelegate



- (void)didCompletePurchase
{
    
    //Will need to show the cart for the congratulatory message screen
    //Empty cart and remove it from the collection
    [[ATArtManager sharedManager] moveCartToPurchasedArtwork];
    [[ATArtManager sharedManager] moveCartToSold];
    [[ATArtManager sharedManager] emptyCart];
    
}

- (void)didStartDisplayingDetailView:(NSNotification*)note
{
    [self hideBottomToolBar];
}

- (void)didDismissDetailView:(NSNotification*)note
{
    [self showBottomToolBar];
}

- (void)darkenView
{
    if (self.darkeningView == nil) {
        self.darkeningView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.view.frame.size.height, self.view.frame.size.width)];
        [self.darkeningView setBackgroundColor:[UIColor blackColor]];
        [self.darkeningView setAlpha:.5f];
    }
    [self.darkeningViewContainerView setUserInteractionEnabled:YES];
    [self.darkeningViewContainerView addSubview:self.darkeningView];
}


- (void)lightenView
{
    [self.darkeningViewContainerView setUserInteractionEnabled:NO];
    [self.darkeningView removeFromSuperview];
}

- (void)didShowSignUpDialog:(NSNotification*)note
{
    //[self darkenView];
}

- (void)didHideSignUpDialog:(NSNotification*)note
{
    [self lightenView];
    [self.signUpSignInContainerView setUserInteractionEnabled:NO];
}

#pragma mark
#pragma mark UIPopoverControllerDelegate

- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController
{
    [[NSNotificationCenter defaultCenter] postNotificationName:kdidCancelSignInDialogNotification object:nil];
}



@end
