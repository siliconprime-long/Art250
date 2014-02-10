    //
//  ATWishlistViewController.m
//  art250
//
//  Created by Winfred Raguini on 8/24/12.
//  Copyright (c) 2012 Art250. All rights reserved.
//

#import "UIImageView+AFNetworking.h"
#import "ATWishlistViewController.h"
#import "ATHangitContainerViewController.h"
#import "ATArtManager.h"
#import "ATArtImageView.h"
#import "ATArtDetailView.h"
#import "ATGlobalConstants.h"
#import "ATAppDelegate.h"
#import "ATShareViewController.h"
#import "ATCartViewController.h"
#import "ATProfileSettingsViewController.h"
#import "ATImagePickerViewController.h"
#import "ATCameraOverlayViewController.h"
#import "ATSettingsNavigationController.h"
#import "ATSettingsViewController.h"
#import "ATCustomPopoverBackgroundView.h"
#import "ATSettingsNavigationController.h"
#import "ATShareCelebrationViewController.h"
#import "ATIntroViewController.h"
#import "ATFTDIntroViewController.h"
#import "ATFTDWalkthrough2ViewController.h"
#import "ATFTDWalkthrough3ViewController.h"
#import "ATFTDWalkthrough4ViewController.h"
#import "ATFTDWalkthrough5ViewController.h"
#import "ATFTDWalkthrough6ViewController.h"
#import "ATFTDWalkthrough7ViewController.h"
#import "ATFTDWalkthrough8ViewController.h"
#import "Artist.h"
#import "ArtistProfile.h"
#import "ATUserManager.h"
#import "ATFacebookUser.h"
#import "ATSignOutViewController.h"
#import "ATUser.h"
#import "ATAPIClient.h"
#import "ATCollectionManager.h"
#import "ATCollectionChooserViewController.h"
#import "MBProgressHUD.h"
#import "ATInactiveArtworkProxy.h"
#import "SearchableArtistProfile.h"

#define WISHLIST_SCROLLVIEW_STARTING_Y 60.0f
#define WISHLIST_IMAGEVIEW_SIZE 110.0f
#define TABLEVIEW_Y_OFFSET 165.0f
#define TABLEVIEW_ROW_HEIGHT 150.0f
#define TABLEVIEW_HORIZONTAL_HEIGHT 118.0f
#define HANGIT_BUTTON_WIDTH 155.0f

#define SAMPLE_ROOM_IMG_NAME @"sample_room.png"



@interface ATWishlistViewController ()

typedef enum {
    ATDockTopButtonTypeCollection = 0,
    ATDockTopButtonTypeInfo
} ATDockTopButtonType;
@property (nonatomic, assign) BOOL isMenuDisplayed;
@property (nonatomic, strong) ATSignOutViewController *signOutController;
@property (nonatomic, readwrite, strong) UITableView *tableView;
//New Dock
@property (nonatomic, strong) UIView *progressBarView;
@property (nonatomic, assign, readwrite) BOOL showingCollection;
@property (nonatomic, strong) UIImageView *cartBubbleImageView;
@property (nonatomic, strong) UILabel *cartNotificationsLabel;
@property (nonatomic, assign) BOOL isTryingToShareArtwork;
- (void)presentHangItViewControllerWithImage:(UIImage*)image;
- (void)chooseExistingPhoto;
- (void)performLogin;
- (void)useSampleRoomPhoto;
- (void)bottomBarButtonSelected;
- (void)displayDockView:(UIView*)dockView updateCollectionImmediately:(BOOL) updateCollection;
- (void)didTapDockView;
@end

@implementation ATWishlistViewController
@synthesize tableView = tableView_;
@synthesize delegate = delegate_;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [UIView setAnimationsEnabled:YES];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didSaveMergedImage:) name:kdidSaveMergedImageNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didUpdateCarousel:) name:kdidUpdateCarouselNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(chooseExistingPhoto) name:kdidInvokeImportPhotoNotification object:nil];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(chooseAnotherSize) name:kdidInvokeChangeArtworkSizeNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(useSampleRoomPhoto) name:kdidInvokeUseSampleRoomNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(takePhoto) name:kdidInvokeTakePhotoNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didCompleteAddToCartAnimation:) name:kdidCompleteAddToCartAnimationNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(displayCartScreen) name:kdidInvokePurchaseScreenNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didInvokeFeedbackScreen:) name:kdidInvokeFeedbackScreenNotification object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didDismissCartView:) name:kdidDismissCartViewNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didProgressThroughRecommendedArtwork:) name:kdidProgressThroughRecommendedArtworkNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didUpdateCurrentArtwork:) name:kdidChangeCurrentArtworkNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didShowBottomToolbar:) name:kdidShowBottomToolbarNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(artworkDidGetAddedToCollection:) name:kArtworkDidGetAddedToCollection object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateCollectionSlots) name:kdidInvokeUpdateCollectionDockNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didLogIntoFacebook:) name:kdidLogIntoFacebookNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didLogOutOfFacebook:) name:kdidLogOutOfFacebookNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didLogInWithEmail:) name:kdidLogInWithEmailNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didLogIn:) name:kdidLoginNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(alreadyLoggedIntoFacebook:) name:kalreadyLoggedIntoFacebookNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didCloseArtworkDetail:) name:kdidCloseArtworkDetailNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(useLaunchScreenSampleRoomPhoto:) name:kinvokeLaunchScreenSampleRoomNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didChooseCollectionFromPicker:) name:kdidChooseCollectionFromPickerNotification object:nil];
    
    
    UIFont *bottomDockButtonFont = [UIFont fontWithName:@"ProximaNova-Light" size:16.0f];
   
    
    
    
    self.progressBarView = [[UIView alloc] initWithFrame:CGRectMake(self.view.frame.size.width * -1.0f, 0.0f, self.view.frame.size.width * 2, 5.0f)];
    UIImageView *progressBarDarkImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"progress_background.png"]];
    CGRect progressBarDarkViewFrame = progressBarDarkImageView.frame;
    progressBarDarkViewFrame.origin.x = self.view.frame.size.width;
    progressBarDarkViewFrame.origin.y = 0.0f;
    [progressBarDarkImageView setFrame:progressBarDarkViewFrame];
    
    UIImageView *progressBarLightImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"progress_overlay.png"]];
    CGRect progressBarLightViewFrame = progressBarLightImageView.frame;
    progressBarLightViewFrame.origin.x = 0.0f;
    progressBarLightViewFrame.origin.y = 0.0f;
    [progressBarLightImageView setFrame:progressBarLightViewFrame];
    
    [self.progressBarView addSubview:progressBarDarkImageView];
    [self.progressBarView addSubview:progressBarLightImageView];
    
    
    [self.progressBarView setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:self.progressBarView];
    
    self.cartBubbleImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"notifications_badge.png"]];
    CGRect cartBubbleImageViewFrame = self.cartBubbleImageView.frame;
    cartBubbleImageViewFrame.origin.x = self.checkoutBtn.frame.size.width/2;
    cartBubbleImageViewFrame.origin.y = 4.0f;
    [self.cartBubbleImageView setFrame:cartBubbleImageViewFrame];
    self.cartNotificationsLabel = [[UILabel alloc] initWithFrame:self.cartBubbleImageView.frame];
    CGRect cartNotificationsLabelFrame = self.cartNotificationsLabel.frame;
    cartNotificationsLabelFrame.origin = CGPointMake(0.0f, 0.0f);
    [self.cartNotificationsLabel setFrame:cartNotificationsLabelFrame];
    
    UIFont *cartNotificationsFont = [UIFont fontWithName:@"ProximaNova-Light" size:14.0f];
    [self.cartNotificationsLabel setFont:cartNotificationsFont];
    [self.cartNotificationsLabel setTextColor:[UIColor whiteColor]];
    [self.cartNotificationsLabel setTextAlignment:NSTextAlignmentCenter];
    [self.cartBubbleImageView addSubview:self.cartNotificationsLabel];
    
    
    
    [self.checkoutBtn addSubview:self.cartBubbleImageView];
    

    
    [self updateInfoDock];
    [self updateCartBubble];
    [self updateAddToCartButton];
    
    //Vessel stuff
    
    
    [[ATArtManager sharedManager] loadCarouselMetadata];
    [self updateCollectionsButton];
    
//    [VesselAB getTestWithSuccessBlock:^(NSString *testName, VesselABTestVariation variation)
//     {
//         if ([testName isEqualToString:@"menuDockCartButtonTitle"]) {
//             
//         }
//     } failureBlock:^(void){
//         
//     }];
    [self.backgroundView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapDockView)]];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [self updateCollectionSlots];
}

- (void)viewDidAppear:(BOOL)animated
{
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

- (void)didUpdateCurrentArtwork:(NSNotification*)note
{
    [self updateInfoDock];
    
}

- (void)didShowBottomToolbar:(NSNotification*)note
{
    
}

- (void)artworkDidGetAddedToCollection:(NSNotification*)note
{
    [self updateHeartInfo];
}

- (void)didCompleteAddToCartAnimation:(NSNotification*)note
{
    [self updateCartBubble];
    [self updateAddToCartButton];
}

- (void)didProgressThroughRecommendedArtwork:(NSNotification*)note
{
    NSDictionary *userInfo = [note userInfo];
    int currIndex = [[userInfo objectForKey:@"currIndex"] intValue];
    
    [self updateProgressBarForRecommendedArtworkIndex:currIndex];
}

- (void)updateInfoDock
{
    id currentArtObject = [[ATArtManager sharedManager] currentArtObject];
    
    if ([currentArtObject isKindOfClass:[Artwork class]]) {
        [self.freeShippingLabel setHidden:NO];
        [self.artistNameLabel setHidden:NO];
        [self.artistLocationLabel setHidden:NO];
        [self.portfolioLabel setHidden:NO];
        Artwork *artwork = (Artwork*)currentArtObject;
        self.artworkTitleLabel.text = artwork.title;
        
        CGRect artworkTitleLabelFrame = self.artworkTitleLabel.frame;
        artworkTitleLabelFrame.size = CGSizeMake(350, 29);
        self.artworkTitleLabel.frame = artworkTitleLabelFrame;
        [self.artworkTitleLabel sizeToFit];

        self.priceLabel.text = [NSString stringWithFormat:@"$%1.0f", [artwork.price floatValue]];
        
        Artist *artist = artwork.artist;
        
        //NSLog(@"artist email %@", artist.email);
        
        SearchableArtistProfile *profile;
        
        if (artwork.searchableProfile == nil) {
            profile = (SearchableArtistProfile*)artist.profile;
        } else {
            profile = artwork.searchableProfile;
        }

        //NSLog(@"profile %@", profile);
        
        //NSLog(@"profile name %@", profile.firstName);
        
        
        self.artistNameLabel.text = profile.fullName;
        
        CGRect artistNameLabelFrame = self.artistNameLabel.frame;
        artistNameLabelFrame.size = CGSizeMake(205.0f, 22.0f);
        self.artistNameLabel.frame = artistNameLabelFrame;
        [self.artistNameLabel sizeToFit];
        
        NSString *artistLocationLabelString = [NSString stringWithFormat:@"• %@",profile.locationString];
        self.artistLocationLabel.text = artistLocationLabelString;
        CGRect artistLocationLabelFrame = self.artistLocationLabel.frame;
        artistLocationLabelFrame.size = CGSizeMake(400,29);
        artistLocationLabelFrame.origin.x = CGRectGetMaxX(self.artistNameLabel.frame) + 5.0f;
        self.artistLocationLabel.frame = artistLocationLabelFrame;
        [self.artistLocationLabel sizeToFit];

        CGRect portfolioLabelFrame = self.portfolioLabel.frame;
        portfolioLabelFrame.origin.x = CGRectGetMaxX(self.artistLocationLabel.frame) + 5.0f;
        [self.portfolioLabel setFrame:portfolioLabelFrame];
        
        self.portfolioLabel.text = [NSString stringWithFormat:@"• %d in portfolio", [artist numArtwork]];
    } else {
        //Its an ATInactiveArtworkProxy
        
        
        ATInactiveArtworkProxy *inactiveArtwork = (ATInactiveArtworkProxy*)currentArtObject;
        self.artworkTitleLabel.text = @"";
        self.priceLabel.text = @"";
        
        [self.freeShippingLabel setHidden:YES];
        
        SearchableArtistProfile *profile;
        profile = inactiveArtwork.artistProfile;
        
        
        if (profile == nil) {
            [self.artistNameLabel setHidden:YES];
            [self.artistLocationLabel setHidden:YES];
            [self.portfolioLabel setHidden:YES];
        } else {
            [self.artistNameLabel setHidden:NO];
            [self.artistLocationLabel setHidden:NO];
            [self.portfolioLabel setHidden:NO];
        }
        
        self.artistNameLabel.text = profile.fullName;

        CGRect artistNameLabelFrame = self.artistNameLabel.frame;
        artistNameLabelFrame.size = CGSizeMake(205.0f, 22.0f);
        self.artistNameLabel.frame = artistNameLabelFrame;
        [self.artistNameLabel sizeToFit];

        NSString *artistLocationLabelString = [NSString stringWithFormat:@"• %@",profile.locationString];
        self.artistLocationLabel.text = artistLocationLabelString;
        CGRect artistLocationLabelFrame = self.artistLocationLabel.frame;
        artistLocationLabelFrame.size = CGSizeMake(400,29);
        artistLocationLabelFrame.origin.x = CGRectGetMaxX(self.artistNameLabel.frame) + 5.0f;
        self.artistLocationLabel.frame = artistLocationLabelFrame;
        [self.artistLocationLabel sizeToFit];

        CGRect portfolioLabelFrame = self.portfolioLabel.frame;
        portfolioLabelFrame.origin.x = CGRectGetMaxX(self.artistLocationLabel.frame) + 5.0f;
        [self.portfolioLabel setFrame:portfolioLabelFrame];
        
        self.portfolioLabel.text = [NSString stringWithFormat:@"• 0 in portfolio"];
    }
    
    
    [self updateShare];
    [self updateHeartInfo];
    [self updateCartBubble];
    [self updateAddToCartButton];
   
}

- (void)updateCollectionSlots
{
    [[ATArtManager sharedManager] updateCollectionStatus];
}

- (void)updateProgressBarForRecommendedArtworkIndex:(int)index
{
    CGFloat progressSegmentWidth = self.view.frame.size.width / [[[ATArtManager sharedManager] artCarousel] count];
    CGFloat startOriginX = -1024.0f;
    [UIView animateWithDuration:1.0f animations:^(void){
        CGRect progressBarFrame = self.progressBarView.frame;
        progressBarFrame.origin.x = startOriginX + (progressSegmentWidth * index);
        [self.progressBarView setFrame:progressBarFrame];
    } completion:^(BOOL finished){
        
    }];
}

- (IBAction)collectionsChooserButtonSelected:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(hideMenuDock)]) {
        [self.delegate performSelectorOnMainThread:@selector(hideMenuDock) withObject:nil waitUntilDone:NO];
    }
    
    
    [[ATTrackingManager sharedManager] trackEvent:FL_SETTINGS_SCREEN_DISPLAYED];
    [self bottomBarButtonSelected];
    UIButton *button = (UIButton*)sender;
    ATCollectionChooserViewController *collectionChooserController = [[ATCollectionChooserViewController alloc] initWithNibName:@"ATCollectionChooserViewController" bundle:nil];
    
   
    self.pickerPopoverController = [[UIPopoverController alloc] initWithContentViewController:collectionChooserController];
    
    CGRect buttonFrame = button.frame;
    if ([ATAppDelegate systemGreaterThanVersion:@"7.0"]) {
        [self.pickerPopoverController presentPopoverFromRect:buttonFrame inView:button permittedArrowDirections:UIPopoverArrowDirectionDown animated:YES];
        
    } else {
        buttonFrame.origin.x = -95.0f;
        buttonFrame.origin.y = -140.0f;
        self.pickerPopoverController.popoverBackgroundViewClass = [ATCustomPopoverBackgroundView class];
        [self.pickerPopoverController presentPopoverFromRect:buttonFrame inView:button permittedArrowDirections:UIPopoverArrowDirectionDown animated:YES];
    }
}

- (void)didChooseCollectionFromPicker:(NSNotification*)note
{
    NSDictionary *userInfo = [note userInfo];
    
    int collectionChoice = [[userInfo objectForKey:@"collectionChoice"] intValue];
    NSString *collectionLoaded;
    switch (collectionChoice) {
        case 0:
            [[ATArtManager sharedManager] loadRecommendations];
            collectionLoaded = @"recommendations";
            
            break;
            
        case 1:
             [[ATArtManager sharedManager] loadFavorites];
            collectionLoaded = @"favorites";
            
            break;
        case 2:
            if ([self.delegate respondsToSelector:@selector(showArtistDirectory)]) {
                [self.delegate performSelector:@selector(showArtistDirectory) withObject:nil];
            }
            collectionLoaded = @"artists";
            break;
    }
    
    //Using the userInfo dictionary figure out what collection to add to the carousel
    [self.pickerPopoverController dismissPopoverAnimated:YES];
}

- (void)didUpdateCarousel:(NSNotification*)note
{
    [self updateCollectionsButton];
}

- (void)updateCollectionsButton
{
    [self.collectionsBtn setTitle:[[ATArtManager sharedManager] collectionTitle] forState:UIControlStateNormal];
}

- (IBAction)settingsButtonSelected:(id)sender
{
    [[ATTrackingManager sharedManager] trackEvent:FL_SETTINGS_SCREEN_DISPLAYED];
    [self bottomBarButtonSelected];
    UIButton *button = (UIButton*)sender;
    ATSettingsViewController *settingController = [[ATSettingsViewController alloc] initWithNibName:@"ATSettingsViewController" bundle:nil];

    self.settingsNavController = [[ATSettingsNavigationController alloc] initWithRootViewController:settingController];
    self.pickerPopoverController = [[UIPopoverController alloc] initWithContentViewController:self.settingsNavController];
    
    CGRect buttonFrame = button.frame;
    if ([ATAppDelegate systemGreaterThanVersion:@"7.0"]) {
        [self.pickerPopoverController presentPopoverFromRect:CGRectMake(0.0f, 0.0f, 118.0f, 120.0f) inView:button permittedArrowDirections:UIPopoverArrowDirectionDown animated:YES];
        
    } else {
        buttonFrame.origin.x = -95.0f;
        buttonFrame.origin.y = -140.0f;
        self.pickerPopoverController.popoverBackgroundViewClass = [ATCustomPopoverBackgroundView class];
        [self.pickerPopoverController presentPopoverFromRect:buttonFrame inView:button permittedArrowDirections:UIPopoverArrowDirectionDown animated:YES];
    }

}


- (IBAction)collectionDockBuyButtonSelected:(id)sender{
    [VesselAB checkpointVisited:VESSEL_COLLECTION_DOCK_CART_BUTTON_SELECTED];
    [self cartButtonSelected:sender];
}

- (IBAction)menuDockBuyButtonSelected:(id)sender{
    [VesselAB checkpointVisited:VESSEL_MENU_DOCK_CART_BUTTON_SELECTED];
    [self cartButtonSelected:sender];
}

- (IBAction)addToCartButtonSelected:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(hideMenuDock)]) {
        [self.delegate performSelectorOnMainThread:@selector(hideMenuDock) withObject:nil waitUntilDone:NO];
    }
    
    [self addCurrentArtworkToCart];
}

- (void)addCurrentArtworkToCart
{
    Artwork *currentArtwork = [[ATArtManager sharedManager] currentArtObject];
    if ([currentArtwork.inCart boolValue]) {
        //Then just open the checkout
        [self cartButtonSelected];
    } else {
        [[ATArtManager sharedManager] addArtObjectToCart:[[ATArtManager sharedManager] currentArtObject]];
        if ([self.delegate respondsToSelector:@selector(didAddArtworkToCart)]) {
            [self.delegate performSelectorOnMainThread:@selector(didAddArtworkToCart) withObject:nil waitUntilDone:NO];
        }
    }
}

- (IBAction)cartButtonSelected:(id)sender{
    [[ATTrackingManager sharedManager] trackEvent:FL_CART_BUTTON_SELECTED];
    [self cartButtonSelected];
    
}

- (void)cartButtonSelected
{
    [VesselAB startSession:VESSEL_CHECKOUT_SESSION];
    if ([[[ATArtManager sharedManager] cart] count] > 0) {
        [self displayCartScreen];
    } else {
        UIAlertView *emptyCartAlert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Your cart is empty.",nil) message:NSLocalizedString(@"Add this to your cart?",nil) delegate:self cancelButtonTitle:@"No thanks." otherButtonTitles:@"Yes please!", nil];
        [emptyCartAlert show];
    }
}

- (void)displayCartScreen
{
    [self bottomBarButtonSelected];
    //NSLog(@"cartButtonSelected");
    
    ATCartViewController *cartController = [[ATCartViewController alloc] initWithNibName:@"ATCartViewController" bundle:nil];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:cartController];
    
    [Flurry logAllPageViews:navigationController];
    
    [self presentViewController:navigationController animated:YES completion:nil];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kdidDisplayPurchaseScreenNotification object:nil];
    
}

- (IBAction)feedbackButtonSelected:(id)sender
{
    self.isTryingToShareArtwork = YES;
    if ([self.delegate respondsToSelector:@selector(hideMenuDock)]) {
        [self.delegate performSelectorOnMainThread:@selector(hideMenuDock) withObject:nil waitUntilDone:NO];
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kdidChooseShareButtonNotification object:nil];
    
}

- (void)didSaveMergedImage:(NSNotification*)note
{
    if (self.isTryingToShareArtwork) {
        [self displayFeedbackScreen];
    }
}

- (void)didInvokeFeedbackScreen:(NSNotification*)note
{
    self.isTryingToShareArtwork = YES;
    [[NSNotificationCenter defaultCenter] postNotificationName:kdidChooseShareButtonNotification object:nil];
}

- (void)displayFeedbackScreen
{
    self.isTryingToShareArtwork = NO;
    ATShareCelebrationViewController *celebrationController = [[ATShareCelebrationViewController alloc] initWithNibName:@"ATShareCelebrationViewController" bundle:nil];
    celebrationController.shareTitleString = @"SHARE TO GET FEEDBACK";
    celebrationController.shareMessageString = @"My wall needs art! What do you think of this piece in my space? #originalart #designdilemma @ARTtwo50";
    celebrationController.displayCollection = NO;
    celebrationController.shouldShowThumbnails = NO;
    NSArray *artworkArray = [NSArray arrayWithObjects:[[ATArtManager sharedManager] currentArtObject],nil];
    [celebrationController setArtworkArray:artworkArray];
    
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:celebrationController];
    [self presentViewController:navController animated:YES completion:^(void){
        //        NSLog(@"presented celebration");
    }];
    
    [Flurry logAllPageViews:navController];
}

- (void)performLogin
{
//    ATAppDelegate * appDelegate = [UIApplication sharedApplication].delegate;
//    [appDelegate openSession];
}

- (void)disablePhotoButton
{
}

- (void)enablePhotoButton
{
}

- (void)takePhoto
{
    [self takePhoto:YES];
}

- (void)takePhoto:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] postNotificationName:kdidChooseTakeNewPhotoOptionNotification object:nil];
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        [[ATTrackingManager sharedManager] trackEvent:FL_STARTED_TAKING_PHOTO timed:YES];
        ATImagePickerViewController *imagePicker = [[ATImagePickerViewController alloc] init];
        imagePicker.delegate = self;
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        imagePicker.allowsEditing = YES;
        imagePicker.showsCameraControls = NO;

        self.cameraOverlayController = [[ATCameraOverlayViewController alloc] initWithNibName:@"ATCameraOverlayViewController" bundle:nil];
        [self.cameraOverlayController setDelegate:imagePicker];
        
        imagePicker.cameraOverlayView = self.cameraOverlayController.view;
        
        [self presentViewController:imagePicker animated:animated completion:nil];
    }
}


- (void)chooseExistingPhoto
{
    [[NSNotificationCenter defaultCenter] postNotificationName:kdidChooseNewPhotoOptionNotification object:nil];
    ATImagePickerViewController *imagePicker = [[ATImagePickerViewController alloc] init];
    imagePicker.delegate = self;
    imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    imagePicker.allowsEditing = NO;


    self.photoPickerPopoverController = [[UIPopoverController alloc] initWithContentViewController:imagePicker];
    self.photoPickerPopoverController.delegate = self;
    [self.photoPickerPopoverController presentPopoverFromRect:CGRectMake(0.0f, -345.0f, 60.0f, 60.0f) inView:self.view permittedArrowDirections:UIPopoverArrowDirectionLeft animated:YES];
}


- (void)samplePhotoButtonSelected:(id)sender
{
    [self useSampleRoomPhoto];
}

- (void)newPhotoButtonSelected:(id)sender
{
    [self takePhoto];
}

- (IBAction)tutorialButtonSelected:(id)sender
{
    [self showAppTutorial];
}

- (IBAction)importPhotoButtonSelected:(id)sender
{
    [self chooseExistingPhoto];
}

- (IBAction)buyNowButtonSelected:(id)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:kdidChooseBuyNowButtonNotification object:nil];
    
    [[ATTrackingManager sharedManager] trackEvent:FL_BUY_NOW_BUTTON_SELECTED];
    Artwork *artwork = [[ATArtManager sharedManager] currentArtObject];
    
    if (![artwork sold]) {
        
        artwork.inCart = [NSNumber numberWithBool:YES];
        artwork.addedToCartAt = [NSDate date];
        
        NSManagedObjectContext *ctx = [[RKObjectManager sharedManager] managedObjectStore].mainQueueManagedObjectContext;
        
        NSError *executeError = nil;
        if(![ctx saveToPersistentStore:&executeError]) {
            NSLog(@"Failed to save to data store");
        }
        
    }

    [self displayCartScreen];
}

- (void)changeSizeButtonSelected:(id)sender
{
    [self chooseAnotherSize];
}

- (void)chooseAnotherSize
{
    if ([self.delegate respondsToSelector:@selector(updateHangitBackgroundImageWithCurrentRoomImage)]) {
        [self.delegate performSelector:@selector(updateHangitBackgroundImageWithCurrentRoomImage) withObject:nil];
    }
}


- (void)useSampleRoomPhoto
{
    [[NSNotificationCenter defaultCenter] postNotificationName:kdidChooseNewPhotoOptionNotification object:nil];
    UIImage *image = [UIImage imageNamed:SAMPLE_ROOM_IMG_NAME];
 
    if ([self.delegate respondsToSelector:@selector(updateHangitBackgroundImageWithSampleRoomImage:)]) {
        [self.delegate performSelector:@selector(updateHangitBackgroundImageWithSampleRoomImage:) withObject:image];
    }
}

- (void)useLaunchScreenSampleRoomPhoto:(NSNotification*)note
{
    [[NSNotificationCenter defaultCenter] postNotificationName:kdidChooseNewPhotoOptionNotification object:nil];
    UIImage *image = [UIImage imageNamed:SAMPLE_ROOM_IMG_NAME];
    if ([self.delegate respondsToSelector:@selector(displayLaunchScreenSampleRoomImage:)]) {
        [self.delegate performSelector:@selector(displayLaunchScreenSampleRoomImage:) withObject:image];
    }
}

- (void)presentHangItViewControllerWithImage:(UIImage*)image
{
    ATHangitContainerViewController *hangitController = [[ATHangitContainerViewController alloc] init];
    hangitController.hangitImage = image;
    [self presentViewController:hangitController animated:NO completion:nil];
}


- (void)processImageForPhotoTaken:(UIImage*)image
{
    [self cacheBackgroundImage:image];
    [[NSOperationQueue mainQueue] addOperationWithBlock:^ {
        if ([self.delegate respondsToSelector:@selector(updateHangitBackgroundImage:)]) {
            [self.delegate performSelector:@selector(updateHangitBackgroundImage:) withObject:[[ATArtManager sharedManager] cachedBackgroundImage]];
        }
    }];
}

- (void)processImageForExistingPhoto:(UIImage*)image
{
    [[ATArtManager sharedManager] cacheBackgroundImage:image];
    //Have to do it this way for iPad air limitations
    [[NSOperationQueue mainQueue] addOperationWithBlock:^ {
        if ([self.delegate respondsToSelector:@selector(updateHangitBackgroundImageWithRoomImage:)]) {
            [self.delegate performSelector:@selector(updateHangitBackgroundImageWithRoomImage:) withObject:[[ATArtManager sharedManager] cachedBackgroundImage]];
        }
    }];
}

-(void)cacheBackgroundImage:(UIImage*)image
{
    UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
    [[ATArtManager sharedManager] cacheBackgroundImage:image];
}

- (void)didTapDockView
{
    if ([self.delegate respondsToSelector:@selector(didTapOnArtwork)]) {
        [self.delegate performSelector:@selector(didTapOnArtwork) withObject:nil];
    }
}

#pragma mark
#pragma mark UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    if ([self.delegate respondsToSelector:@selector(clearBackground)]) {
        [self.delegate performSelector:@selector(clearBackground) withObject:nil];
    }
    
    if ([self.delegate respondsToSelector:@selector(hideMenuDock)]) {
        [self.delegate performSelectorOnMainThread:@selector(hideMenuDock) withObject:nil waitUntilDone:NO];
    }
    
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    if (picker.sourceType == UIImagePickerControllerSourceTypePhotoLibrary) {
        [self.photoPickerPopoverController dismissPopoverAnimated:YES];
        [self performSelectorInBackground:@selector(processImageForExistingPhoto:) withObject:image];
    } else {
        if ([self.delegate respondsToSelector:@selector(showArtRecommendationHUD)]) {
            [self.delegate performSelector:@selector(showArtRecommendationHUD) withObject:nil];
        }
        [self performSelectorInBackground:@selector(processImageForPhotoTaken:) withObject:image];
       
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}



- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
}

- (void)closeCameraButtonSelected
{
    [self bottomBarButtonSelected];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)heartButtonSelected:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(hideMenuDock)]) {
        [self.delegate performSelectorOnMainThread:@selector(hideMenuDock) withObject:nil waitUntilDone:NO];
    }
    
    UIButton *heartButton = (UIButton*)sender;
    if (heartButton.selected) {
        
        Artwork *artwork = [[ATArtManager sharedManager] currentArtObject];
        [[ATArtManager sharedManager] removeArtObjectFromCollection:artwork];
        
         NSDictionary *dict = [[NSDictionary alloc] initWithObjectsAndKeys:artwork, @"artObject", nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:kArtworkDidGetAddedToCollection object:nil userInfo:dict];
        
    } else {
        if ([[ATUserManager sharedManager] isLoggedIn]) {
            [self addCurrentArtworkToCollection];
        } else {
            if ([self.delegate respondsToSelector:@selector(showSignUpDialog)]) {
                [[ATUserManager sharedManager] setIsTryingToFavoriteCurrentArtwork:YES];
                [self.delegate performSelectorOnMainThread:@selector(showSignUpDialog) withObject:nil waitUntilDone:NO];
            }

            
        }
        
    }
    [self updateHeartInfo];
}

- (void)didDismissCartView:(NSNotification*)note
{
    [self updateAddToCartButton];
    [self updateCartBubble];
}

- (void)addCurrentArtworkToCollection
{
    Artwork *artwork = [[ATArtManager sharedManager] currentArtObject];
    [[ATArtManager sharedManager] addArtworkToCollection:artwork];
    
    NSDictionary *dict = [[NSDictionary alloc] initWithObjectsAndKeys:artwork, @"artObject", nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:kArtworkDidGetAddedToCollection object:nil userInfo:dict];
}

- (void)updateShare
{
    id currentObject = [[ATArtManager sharedManager] currentArtObject];
    if ([currentObject isKindOfClass:[Artwork class]]) {
        [self.shareBtn setUserInteractionEnabled:YES];
    } else {
        [self.shareBtn setUserInteractionEnabled:NO];
    }
}

- (void)updateHeartInfo
{
    id currentObject = [[ATArtManager sharedManager] currentArtObject];
    if ([currentObject isKindOfClass:[Artwork class]]) {
        Artwork *currentArtwork = (Artwork*)currentObject;
        [self.heartBtn setUserInteractionEnabled:YES];
        if ([currentArtwork.inCollection boolValue]) {
            [self.heartBtn setSelected:YES];
            int numLikes = [currentArtwork.numInOtherCollections intValue];
            [self.heartBtn setTitle:[NSString stringWithFormat:@"%d", numLikes] forState:UIControlStateSelected];
        } else {
            [self.heartBtn setSelected:NO];
            [self.heartBtn setTitle:@"" forState:UIControlStateSelected];
        }
    } else {
        [self.heartBtn setSelected:NO];
        [self.heartBtn setTitle:@"" forState:UIControlStateSelected];
        [self.heartBtn setUserInteractionEnabled:NO];
    }
}

- (void)updateCartBubble
{
    if ([[[ATArtManager sharedManager] cart] count] > 0) {
        [self.cartBubbleImageView setHidden:NO];
        [self.cartNotificationsLabel setText:[NSString stringWithFormat:@"%d", [[[ATArtManager sharedManager] cart] count]]];
    } else{
        [self.cartBubbleImageView setHidden:YES];
    }
}

- (void)updateAddToCartButton
{
    id currentObject = [[ATArtManager sharedManager] currentArtObject];
    UIColor *cartRedColor = [UIColor colorWithRed:208.0f/255.0f green:41.0f/255.0f blue:15.0f/255.0f alpha:1.0f];
    if ([currentObject isKindOfClass:[Artwork class]]) {
        Artwork *currentArtwork = (Artwork*)currentObject;
        
        if (currentArtwork.sold) {
            [self.addToCartBtn setBackgroundColor:[UIColor clearColor]];
            [self.addToCartBtn setTitleColor:cartRedColor forState:UIControlStateNormal];
            [self.addToCartBtn setTitle:@"Sold" forState:UIControlStateNormal];
            [self.addToCartBtn setUserInteractionEnabled:NO];
            
        } else {
            [self.addToCartBtn setUserInteractionEnabled:YES];
            if ([currentArtwork.inCart boolValue]) {
                [self.addToCartBtn setBackgroundColor:[UIColor clearColor]];
                [self.addToCartBtn setTitleColor:cartRedColor forState:UIControlStateNormal];
                [self.addToCartBtn setTitle:@"In Cart" forState:UIControlStateNormal];
            } else {
                [self.addToCartBtn setBackgroundColor:cartRedColor];
                [self.addToCartBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                [self.addToCartBtn setTitle:@"Add to Cart" forState:UIControlStateNormal];
            }
        }
    } else {
        [self.addToCartBtn setBackgroundColor:[UIColor clearColor]];
        [self.addToCartBtn setTitleColor:cartRedColor forState:UIControlStateNormal];
        [self.addToCartBtn setTitle:@"Not for sale" forState:UIControlStateNormal];
        [self.addToCartBtn setUserInteractionEnabled:NO];
    }
    
    
}

- (void)skipTourButtonSelected
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)showAppTourScreens:(NSNotification*)note
{
    [self showAppTutorial];
}

- (void)showAppTutorial
{
    [self.pickerPopoverController dismissPopoverAnimated:YES];
    
    UIImage *backgroundImage = nil;
    UIImage *overlayImage = nil;
    if ([[ATArtManager sharedManager] cachedBackgroundImage] != nil) {
        backgroundImage = [[ATArtManager sharedManager] cachedBackgroundImage];
        overlayImage = [UIImage imageNamed:@"overlay.png"];
    }
    
    
    ATFTDIntroViewController *recommendationFTDWalkthroughController = [[ATFTDIntroViewController alloc] initWithNibName:@"ATFTDIntroViewController" bundle:nil];
    recommendationFTDWalkthroughController.delegate = self;
    
    
    
    [recommendationFTDWalkthroughController.view setBackgroundColor:[UIColor clearColor]];
    
    
    if (backgroundImage != nil) {
        [recommendationFTDWalkthroughController.backgroundView setImage:backgroundImage];
        [recommendationFTDWalkthroughController.overlayView setImage:overlayImage];
    }
    
    
    ATFTDWalkthrough2ViewController *walkthrough2Controller = [[ATFTDWalkthrough2ViewController alloc] initWithNibName:@"ATFTDWalkthrough2ViewController" bundle:nil];
    
    [recommendationFTDWalkthroughController addChildViewController:walkthrough2Controller];
    
    
    ATFTDWalkthrough3ViewController *walkthrough3Controller = [[ATFTDWalkthrough3ViewController alloc] initWithNibName:@"ATFTDWalkthrough3ViewController" bundle:nil];
    
    [recommendationFTDWalkthroughController addChildViewController:walkthrough3Controller];
    
    ATFTDWalkthrough4ViewController *walkthrough4Controller = [[ATFTDWalkthrough4ViewController alloc] initWithNibName:@"ATFTDWalkthrough4ViewController" bundle:nil];
    [recommendationFTDWalkthroughController addChildViewController:walkthrough4Controller];
    
    ATFTDWalkthrough5ViewController *walkthrough5Controller = [[ATFTDWalkthrough5ViewController alloc] initWithNibName:@"ATFTDWalkthrough5ViewController" bundle:nil];
    [recommendationFTDWalkthroughController addChildViewController:walkthrough5Controller];
    
    ATFTDWalkthrough6ViewController *walkthrough6Controller = [[ATFTDWalkthrough6ViewController alloc] initWithNibName:@"ATFTDWalkthrough6ViewController" bundle:nil];
    [recommendationFTDWalkthroughController addChildViewController:walkthrough6Controller];
    
    ATFTDWalkthrough7ViewController *walkthrough7Controller = [[ATFTDWalkthrough7ViewController alloc] initWithNibName:@"ATFTDWalkthrough7ViewController" bundle:nil];
    [recommendationFTDWalkthroughController addChildViewController:walkthrough7Controller];
    
    ATFTDWalkthrough8ViewController *walkthrough8Controller = [[ATFTDWalkthrough8ViewController alloc] initWithNibName:@"ATFTDWalkthrough8ViewController" bundle:nil];
    [recommendationFTDWalkthroughController addChildViewController:walkthrough8Controller];
    
    
    
    [self presentViewController:recommendationFTDWalkthroughController animated:YES completion:nil];

}

- (void)didEndTour
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark
#pragma mark Private

- (IBAction)infoCollectionButtonSelected:(id)sender
{
//    if (self.infoCollectionBtn.tag == ATDockTopButtonTypeCollection) {
//        [self displayCollectionDock];
//    } else {
//        [self displayInfoDock];
//    }
}

- (IBAction)menuButtonSelected:(id)sender
{
    [self.menuBtn setEnabled:NO];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kdidChooseMenuButtonNotification object:nil];
    
    if (self.menuBtn.selected) {
        [self hideMenuDock];
        [self.menuBtn setSelected:NO];
    } else {
        [self showMenuDock];
        [self.menuBtn setSelected:YES];
    }
}


- (void)showMenuDock
{
    
    if ([self.delegate respondsToSelector:@selector(showMenuDock)]) {
        [self.delegate performSelectorOnMainThread:@selector(showMenuDock) withObject:nil waitUntilDone:NO];
    }
    
}

- (void)hideMenuDock
{
    if ([self.delegate respondsToSelector:@selector(hideMenuDock)]) {
        [self.delegate performSelectorOnMainThread:@selector(hideMenuDock) withObject:nil waitUntilDone:YES];
    }
   
}




BOOL _infoDockDisplayed = NO;
BOOL _collectionDockDisplayed = NO;

- (void)displayDockView:(UIView*)dockView
{
    [self displayDockView:dockView updateCollectionImmediately:YES];
}


- (void)displayDockView:(UIView*)dockView updateCollectionImmediately:(BOOL)updateCollection
{
    
    if (!_isAnimatingDock) {
        
        
        
        CGRect dockViewFrame = dockView.frame;
        dockViewFrame.origin.y = self.view.frame.size.height + 1.0f;
        [self.view addSubview:dockView];
        [dockView setFrame:dockViewFrame];
        
        [self disableDockMenuButtons];
        
        [UIView animateWithDuration:0.1f animations:^(void){
            
            CGRect dockViewFrame = dockView.frame;
            dockViewFrame.origin.y = 5.0f;
            [dockView setFrame:dockViewFrame];
            
        } completion:^(BOOL finished){
                    
            [self enableDockMenuButtons];
            
            
            
        }];
    }
}

BOOL _isAnimatingDock = NO;

- (void)disableDockMenuButtons
{
    _isAnimatingDock = YES;
}

- (void)enableDockMenuButtons
{
    _isAnimatingDock = NO;
}


- (void)displayInfoDock
{
    [self updateInfoDock];
    [self displayDockView:self.view];
}

- (void)distance5ButtonSelected:(id)sender
{
    //NSLog(@"distance5ButtonSelected");
}

- (void)cameraButtonSelected:(id)sender
{
    [self bottomBarButtonSelected];
//    [self.imagePicker takePicture];
}

- (void)bottomBarButtonSelected
{
    [[NSNotificationCenter defaultCenter] postNotificationName:kdidInteractWithApp object:nil];
}

- (void)didLogIntoFacebook:(NSNotification*)note
{
    [self updateFBLoginView];
}

//- (void)didLogInWithEmail:(NSNotification*)note
//{
//    NSDictionary *loggedInInfo = [note userInfo];
//    [[ATUserManager sharedManager] setATUserWithATUserDictionary:[loggedInInfo objectForKey:@"user"]];
//    [self updateATLoginView];
//    if ([self.delegate respondsToSelector:@selector(hideSignUpDialog)]) {
//        [self.delegate performSelector:@selector(hideSignUpDialog) withObject:nil];
//    }
//}

- (void)didLogIn:(NSNotification*)note
{
    //Since you can only really get this when trying to favorite something assume that the current artwork should be favorited
    
    if ([self.delegate respondsToSelector:@selector(hideSignUpDialog)]) {
        [self.delegate performSelector:@selector(hideSignUpDialog) withObject:nil];
    }
    if ([[ATUserManager sharedManager] isTryingToFavoriteCurrentArtwork]) {
        [self addCurrentArtworkToCollection];
        [self updateHeartInfo];
    }
    
}

- (void)updateFBLoginView
{
    //Update the menu button with the user image and name
//    if ([[ATUserManager sharedManager] isLoggedIn]) {
//        NSString *fbFirstName = [[[ATUserManager sharedManager] fbUser] firstName];
//        [self.signInLabel setText:fbFirstName];
//        [self.fbProfilePictureView setUserInteractionEnabled:YES];
//        self.fbProfilePictureView.profileID = [[[ATUserManager sharedManager] fbUser] fbID];
//        [self.signInButton addSubview:self.fbProfilePictureView];
//    } else {
//        [self resetSignInButton];
//    }

}
//


- (void)didLogOutOfFacebook:(NSNotification*)note
{
    //[self resetSignInButton];
}
//
//- (void)resetSignInButton
//{
//    self.signedInImageView.image = nil;
//    self.fbProfilePictureView.profileID = nil;
//    [self.signInLabel setText:@"Log in"];
//}
//
//- (void)signOutButtonSelected:(id)sender
//{
//    if ([[ATUserManager sharedManager] isLoggedInByFacebook]) {
//        [self.signOutPopoverController dismissPopoverAnimated:YES];
//        [[ATUserManager sharedManager] setFbUser:nil];
//        [[FBSession activeSession] closeAndClearTokenInformation];
//        [self resetSignInButton];
//        [self updateFBLoginView];
//    } else {
//        [self.signOutPopoverController dismissPopoverAnimated:YES];
//        
//        [[ATAPIClient sharedClient] getPath:@"users/sign_out.json" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject){
//            NSDictionary *responseDict = responseObject;
//            if ([[responseDict objectForKey:@"logged_out"] intValue] == 1) {
//                [[NSNotificationCenter defaultCenter] postNotificationName:kdidLogOutWithEmailNotification object:nil userInfo:responseDict];
//                //[self resetSignInButton];
//                [self updateATLoginView];
//                
//            } else {
//                UIAlertView *failedLogin = [[UIAlertView alloc] initWithTitle:@"Could not log out" message:@"" delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles: nil];
//                [failedLogin show];
//            }
//        } failure:^(AFHTTPRequestOperation *operation, NSError *error){
//            
//        }];
//        
//    }
//
//}

//- (void)alreadyLoggedIntoFacebook:(NSNotification*)note
//{
//    [self updateFBLoginView];
//}
//

- (void)didLogInWithEmail:(NSNotification*)note
{
//    NSDictionary *loggedInInfo = [note userInfo];
//    [[ATUserManager sharedManager] setATUserWithATUserDictionary:[loggedInInfo objectForKey:@"user"]];
//    [self updateATLoginView];
    if ([self.delegate respondsToSelector:@selector(hideSignUpDialog)]) {
        [self.delegate performSelector:@selector(hideSignUpDialog) withObject:nil];
    }
}

- (void)didCloseArtworkDetail:(NSNotification*)note
{
    //[self updateCollectionSlots];
    //[self displayDockView:self.collectionDockView updateCollectionImmediately:NO];
    [self updateInfoDock];
}



#pragma mark
#pragma mark UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:
            
            break;
            
        case 1:
            [self addCurrentArtworkToCart];
            break;
    }
}

@end
