//
//  ATArtworkDetailViewController.m
//  art250
//
//  Created by Winfred Raguini on 12/24/12.
//  Copyright (c) 2012 Art250. All rights reserved.
//

#import "ATArtworkDetailViewController.h"
#import "UIImageView+AFNetworking.h"
#import "ATArtistObject.h"
#import "UIImageView+AFNetworking.h"
#import "Artwork.h"
#import "Artist.h"
#import "ArtistProfile.h"
#import "ATUserManager.h"
#import "ATArtManager.h"
#import "ATCartViewController.h"
#import "SearchableArtistProfile.h"
#import "ATShareCelebrationViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>

#define CLOSE_BTN_OFFSET 40.0f
#define CLOSE_BTN_WIDTH 50.0f
#define CLOSE_BTN_HEIGHT 30.0f



@interface ATArtworkDetailViewController ()
@property (nonatomic, strong, readwrite) UIView *artworkInformationView;
@property (nonatomic, assign) CGFloat lastZoomScale;
@property (nonatomic, assign) BOOL isTryingToShareArtwork;
@property (nonatomic, strong) UIImageView *cartBubbleImageView;
@property (nonatomic, strong) UILabel *cartNotificationsLabel;
- (void)displayArtworkInformation;
- (void)hideArtworkInformation;
- (void)createArtworkInformationView;
@end

@implementation ATArtworkDetailViewController

BOOL _userInteracted;

BOOL _animatingClose;

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
    
   
    
    [self.fullScreenImageView setContentMode:UIViewContentModeScaleAspectFit];
    
    [[ATTrackingManager sharedManager] trackEvent:FL_ARTWORK_DETAIL_VIEWED timed:YES];
    
    [[ATTrackingManager sharedManager] trackEvent:FL_ARTWORK_DESCRIPTION_VIEWED];
    
    UITapGestureRecognizer *tapRecogizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapDetected:)];
    [tapRecogizer setNumberOfTapsRequired:1];
    [self.scrollView addGestureRecognizer:tapRecogizer];
    
    UITapGestureRecognizer *doubleTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTapDetected:)];
    [doubleTapRecognizer setNumberOfTapsRequired:2];
    [self.scrollView addGestureRecognizer:doubleTapRecognizer];
    
    [tapRecogizer requireGestureRecognizerToFail:doubleTapRecognizer];
    
    
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
    
    
    [self.buyNowButton.titleLabel setFont:[UIFont fontWithName:@"ProximaNova-Semibold" size:self.buyNowButton.titleLabel.font.pointSize]];

    [self displayArtworkInformation];
    
    [self updateBottomToolbarInfo];
    
    

}

- (void)viewWillAppear:(BOOL)animated
{
    
    [self.navigationController.navigationBar setHidden:YES];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didSaveMergedImage:) name:kdidSaveMergedImageNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didFailSavingMergedImage:) name:kdidFailSavingMergedImageNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didLogin:) name:kdidLoginNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didCancelSignInDialog:) name:kdidCancelSignInDialogNotification object:nil];
    
    if (self.lastArtObject != self.artObject) {
        
        self.inOtherCollections.text = [NSString stringWithFormat:@"in %d other collections", [self.artObject.numInOtherCollections intValue]];
        
        
        self.fullScreenImageView.image = nil;
        self.profileImageView.image = nil;
        
        self.artistObject = self.artObject.artist;
        
        SearchableArtistProfile *profile;
        
        if (self.artObject.searchableProfile != nil) {
            profile = self.artObject.searchableProfile;
        } else {
            profile = (SearchableArtistProfile*)self.artistObject.profile;
        }
        
        
        
        
        if (profile.profileThumbURL != nil) {
            NSURL *url = [NSURL URLWithString:profile.profilePreviewURL];
            //NSLog(@"artistImageURl %@", self.artistObject.artistImageURL);
            if ([profile hasUploadedProfileImage]) {
                [self.profileImageView setImageWithURL:url];
            }
        }
        
        
        if (profile.fullName != (id)[NSNull null]) {
            self.artistNameLabel.text = profile.fullName;
        }
        
        if (profile.city != (id)[NSNull null] && profile.state != (id)[NSNull null]) {
            self.artistCityStateLabel.text = [NSString stringWithFormat:@"%@, %@", profile.city, profile.state];
        }
        
        
        if (profile.artistStatement != (id)[NSNull null] && [profile.artistStatement length] > 0) {
            self.artistStatementView.text = profile.artistStatement;
        }
        
        
        // For supporting zoom,
        self.scrollView.minimumZoomScale = 1.0;
        self.scrollView.maximumZoomScale = 3.0;
        
        
        self.scrollView.delegate = self;
        self.scrollView.contentSize = self.fullScreenImageView.image.size;
        self.titleLabel.text = [self.artObject title];
        self.artistNameLabel.text = profile.fullName;
        self.descriptionView.text = [self.artObject artworkDescription];
        self.mediaLabel.text = [self.artObject mediumString];
        self.genreLabel.text = [self.artObject genreString];
        
        self.widthLabel.text = [NSString stringWithFormat:@"%1.1f\"", [[self.artObject width] floatValue]];
        self.heightLabel.text = [NSString stringWithFormat:@"%1.1f\"", [[self.artObject height] floatValue]];
        self.depthLabel.text = [NSString stringWithFormat:@"%1.1f\"", [[self.artObject depth] floatValue]];
        
        [self.mainActionButton addTarget:self action:@selector(mainActionButtonSelected:) forControlEvents:UIControlEventTouchUpInside];
        
        
        //Add image to fullscreen image view
        
        NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:[self.artObject ipadDisplayImgURL]]];
        
        __weak ATArtworkDetailViewController *detailController = self;
        
        [self.spinnerView startAnimating];
        
//        [self.fullScreenImageView setImageWithURLRequest:request placeholderImage:nil success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image){
//            [detailController performSelectorOnMainThread:@selector(stopSpinner:) withObject:image waitUntilDone:NO];
//        } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error){
//            [detailController performSelectorOnMainThread:@selector(requestError) withObject:nil waitUntilDone:NO];
//        }];
//        
        
        [self.fullScreenImageView setImageWithURL:[NSURL URLWithString:[self.artObject ipadDisplayImgURL]] placeholderImage:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType){
            if (error == nil) {
                [detailController performSelectorOnMainThread:@selector(stopSpinner:) withObject:image waitUntilDone:NO];
            } else {
                NSLog(@"Error %@", [error localizedDescription]);
                [detailController performSelectorOnMainThread:@selector(requestError) withObject:nil waitUntilDone:NO];
            }
        }];
        
    }


    if (![self.artObject.inCollection boolValue]) {
        [self.addToCollectionButton setHidden:YES];
    } else {
        [self.addToCollectionButton setHidden:NO];
    }
    
    if ([self.artObject.inCollection boolValue]) {
        [self changeCollectionButtonToRemove];
    } else {
        [self changeCollectionButtonToAdd];
    }

    
    NSManagedObjectContext *ctx = [[RKObjectManager sharedManager] managedObjectStore].mainQueueManagedObjectContext;
    
    [ctx refreshObject:self.artObject mergeChanges:YES];
    
    if ([self.artObject sold]) {
        [self.addToCollectionButton setHidden:YES];
        [self.buyNowButton setUserInteractionEnabled:NO];
        [self.buyNowButton setTitle:@"SOLD" forState:UIControlStateNormal];
        [self.buyNowButton setBackgroundImage:[UIImage imageNamed:@"btn_sold_disabled"] forState:UIControlStateNormal];
    } else {
        [self.buyNowButton setUserInteractionEnabled:YES];
        [self.buyNowButton setTitle:@"Buy Now" forState:UIControlStateNormal];
        [self.buyNowButton setBackgroundImage:[UIImage imageNamed:@"btn_buy_now.png"] forState:UIControlStateNormal];
    }
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    self.detailBioControl.selectedSegmentIndex = 0;
    [self showDetailView];
    _animatingClose = NO;
    _userInteracted = NO;
    [[NSNotificationCenter defaultCenter] postNotificationName:kdidPresentArtworkDetailView object:nil];
    //[self performSelector:@selector(checkForUserInteraction) withObject:nil afterDelay:1.5f];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    self.lastArtObject = self.artObject;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    self.fullScreenImageView.image = nil;
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

#pragma mark
#pragma mark Private

- (void)stopSpinner:(UIImage*)image
{
    self.fullScreenImageView.image = image;
    [self.spinnerView stopAnimating];
    if ([self.delegate respondsToSelector:@selector(detailImageLoaded)]){
        [self.delegate performSelector:@selector(detailImageLoaded)];
    }
}

- (void)requestError
{
    [self.spinnerView stopAnimating];
}


- (void)checkForUserInteraction
{
    //If there hasnt been any userinteraction then close the detail screen.
    if (!_userInteracted) {
        [self hideArtworkInformation];
    }
}

- (IBAction)detailBioControlChanged
{
    _userInteracted = YES;
    switch (self.detailBioControl.selectedSegmentIndex) {
        case 0:
            [[ATTrackingManager sharedManager] trackEvent:FL_ARTWORK_DESCRIPTION_VIEWED];
            [self showDetailView];
            break;
            
        default:
            [[ATTrackingManager sharedManager] trackEvent:FL_ARTIST_BIO_VIEWED];
            [self showBioView];
            break;
    }
}

- (void)showDetailView
{
    self.detailContainerView.hidden = NO;
    self.infoContainerView.hidden = YES;
}

- (void)showBioView
{
    [[ATUserManager sharedManager] incrementWithFlurryKey:kFlurryNumBioViewsSeen];
    
    self.detailContainerView.hidden = YES;
    self.infoContainerView.hidden = NO;
}



- (void)createArtworkInformationView
{
//    self.artworkInformationView = [[UIView alloc] initWithFrame:CGRectMake(-399.0f, 0.0f, 400.0f, 768.0f)];
//    
//    UIView *backgroundView = [[UIView alloc] initWithFrame:self.artworkInformationView.frame];
//    [backgroundView setBackgroundColor:[UIColor blackColor]];
//    [backgroundView setAlpha:0.8f];
//    [self.artworkInformationView addSubview:backgroundView];
//    
//    UILabel *artworkLabel = [[UILabel alloc] initWithFrame:CGRectMake(-390.0f, 10.0f, 380.0f, 100.0f)];
//    [artworkLabel setText:@"Artwork Title Title Title Title Title Title Title Title Title Title"];
//    [artworkLabel setBackgroundColor:[UIColor clearColor]];
//    [artworkLabel setTextColor:[UIColor whiteColor]];
//    [artworkLabel setFont:[UIFont fontWithName:@"Georgia" size:36.0f]];
//    [artworkLabel setNumberOfLines:0];
//    [self.artworkInformationView addSubview:artworkLabel];
//    
//
//    
//    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    [backButton addTarget:self action:@selector(backButtonSelected:) forControlEvents:UIControlEventTouchUpInside];
//    [backButton setBackgroundImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
//    [backButton setBackgroundImage:[UIImage imageNamed:@"back_down.png"] forState:UIControlStateSelected];
//    CGRect backButtonFrame = backButton.frame;
//    backButtonFrame.origin.x = -100.0f;
//    backButtonFrame.origin.y = self.artworkInformationView.frame.size.height - 50.0f;
//    backButtonFrame.size.height = 35.0f;
//    backButtonFrame.size.width = 35.0f;
//    [backButton setFrame:backButtonFrame];
//    [self.artworkInformationView addSubview:backButton];
//    
//    [self.view addSubview:self.artworkInformationView];
}

- (void)displayArtworkInformation
{
    //NSLog(@"display");
    [UIView animateWithDuration:0.5
                          delay:0.0
                        options: UIViewAnimationCurveEaseInOut
                     animations:^{
                         [self.detailView setAlpha:1.0];
                         [self.closeButton setAlpha:1.0];
//                         [self.infoButton setHidden:YES];
//                         CGRect informationViewFrame = self.detailView.frame;
//                         informationViewFrame.origin.x = 0.0f;
//                         informationViewFrame.origin.y = 0.0f;
//                         [self.detailView setFrame:informationViewFrame];
//                         //NSLog(@"x: %1.2f, y:%1.2f, width:%1.2f, height:%1.2f", self.detailView.frame.origin.x, self.detailView.frame.origin.y, self.detailView.frame.size.width, self.detailView.frame.size.height);
                     }
                     completion:^(BOOL finished){
                         if(finished) {
                             
                         }
                             //NSLog(@"Finished !!!!!");
                                             // do any stuff here if you want
    }];
}

- (void)hideArtworkInformation
{
    //NSLog(@"display");
    [UIView animateWithDuration:0.5
                          delay:0.0
                        options: UIViewAnimationCurveEaseInOut
                     animations:^{
                         [self.detailView setAlpha:0.0];
                         [self.closeButton setAlpha:0.0];
                         //                         [self.infoButton setHidden:YES];
                         //                         CGRect informationViewFrame = self.detailView.frame;
                         //                         informationViewFrame.origin.x = 0.0f;
                         //                         informationViewFrame.origin.y = 0.0f;
                         //                         [self.detailView setFrame:informationViewFrame];
                         //                         //NSLog(@"x: %1.2f, y:%1.2f, width:%1.2f, height:%1.2f", self.detailView.frame.origin.x, self.detailView.frame.origin.y, self.detailView.frame.size.width, self.detailView.frame.size.height);
                     }
                     completion:^(BOOL finished){
                         if(finished) {
                             
                         }
                             //NSLog(@"Finished !!!!!");
                         // do any stuff here if you want
                     }];
}


- (void)backButtonSelected:(id)sender
{
    //NSLog(@"backButtonSelected");
    [UIView animateWithDuration:1.0
                          delay:0.0
                        options: UIViewAnimationCurveEaseInOut
                     animations:^{

//                         CGRect informationViewFrame = self.detailView.frame;
//                         informationViewFrame.origin.x = -450.0f;
//                         informationViewFrame.origin.y = 0.0f;
//                         [self.detailView setFrame:informationViewFrame];
//                         //NSLog(@"x: %1.2f, y:%1.2f, width:%1.2f, height:%1.2f", self.detailView.frame.origin.x, self.detailView.frame.origin.y, self.detailView.frame.size.width, self.detailView.frame.size.height);
                     }
                     completion:^(BOOL finished){
                         if(finished) {
                             
                         }
//                             [self.infoButton setHidden:NO];
                         //NSLog(@"Finished !!!!!");
                         // do any stuff here if you want
                     }];
}

// Implement a single scroll view delegate method
- (UIView*)viewForZoomingInScrollView:(UIScrollView *)aScrollView {
    return self.fullScreenImageView;
}

- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(float)scale
{
    if (scale == 1.0f && self.lastZoomScale == 1.0f) {
        [self closeDetailScreen];
    } else {
        self.lastZoomScale = scale;
    }
}

- (IBAction)buyNowButtonSelected:(id)sender
{
    Artwork *artwork = [[ATArtManager sharedManager] currentArtObject];
    artwork.inCart = [NSNumber numberWithBool:YES];
    artwork.addedToCartAt = [NSDate date];
    
    NSManagedObjectContext *ctx = [[RKObjectManager sharedManager] managedObjectStore].mainQueueManagedObjectContext;
    
    NSError *executeError = nil;
    if(![ctx saveToPersistentStore:&executeError]) {
        NSLog(@"Failed to save to data store");
    }
    
    ATCartViewController *cartController = [[ATCartViewController alloc] initWithNibName:@"ATCartViewController" bundle:nil];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:cartController];
    
    [Flurry logAllPageViews:navigationController];
    
    [self presentViewController:navigationController animated:YES completion:nil];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kdidDisplayPurchaseScreenNotification object:nil];
}

- (IBAction)addToCollectionButtonSelected:(id)sender
{
    [self changeCollectionButtonToRemove];
    
    if ([[ATUserManager sharedManager] isLoggedIn]) {
        NSDictionary *dict = [[NSDictionary alloc] initWithObjectsAndKeys:self.artObject, @"artObject", nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:kaddArtworkToCollectionNotification object:nil userInfo:dict];
    } else {
        [[ATUserManager sharedManager] showSignUpDialogInView:self.view forDelegate:self];
    }

}

- (void)changeCollectionButtonToRemove
{
    [self.addToCollectionButton removeTarget:self action:@selector(addToCollectionButtonSelected:) forControlEvents:UIControlEventTouchUpInside];
    [self.addToCollectionButton setTitle:@"Remove from Collection" forState:UIControlStateNormal];
    [self.addToCollectionButton setBackgroundImage:[UIImage imageNamed:@"btn_remove_collection.png"] forState:UIControlStateNormal];
    
    [self.addToCollectionButton.titleLabel setFont:[UIFont fontWithName:@"ProximaNova-Semibold" size:14.0f]];
    [self.addToCollectionButton addTarget:self action:@selector(removeFromCollectionButtonSelected:) forControlEvents:UIControlEventTouchUpInside];
}

- (IBAction)removeFromCollectionButtonSelected:(id)sender
{
    NSDictionary *dict = [[NSDictionary alloc] initWithObjectsAndKeys:self.artObject, @"artObject", nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:kremoveArtworkFromCollectionNotification object:nil userInfo:dict];
    
    [self changeCollectionButtonToAdd];
}

- (void)changeCollectionButtonToAdd
{
    [self.addToCollectionButton removeTarget:self action:@selector(removeFromeCollectionButtonSelected:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.addToCollectionButton setTitle:@"Add to Collection" forState:UIControlStateNormal];
    
    [self.addToCollectionButton setBackgroundImage:[UIImage imageNamed:@"btn_add_collection.png"] forState:UIControlStateNormal];
    
    [self.addToCollectionButton.titleLabel setFont:[UIFont fontWithName:@"ProximaNova-Semibold" size:16.0f]];
    [self.addToCollectionButton addTarget:self action:@selector(addToCollectionButtonSelected:) forControlEvents:UIControlEventTouchUpInside];

}



- (IBAction)mainActionButtonSelected:(id)sender
{
    [self toggleArtworkDetail];
}

- (void)didLogin:(NSNotification*)note
{
    //Will change this to some sort of buffering system when needed
    NSDictionary *dict = [[NSDictionary alloc] initWithObjectsAndKeys:self.artObject, @"artObject", nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:kaddArtworkToCollectionNotification object:nil userInfo:dict];
    [[ATArtManager sharedManager] addArtworkToCollection:self.artObject];
    [self updateHeartInfo];
}

- (void)didCancelSignInDialog:(NSNotification*)note
{
    //[self changeCollectionButtonToAdd];
}


#pragma mark
#pragma mark UIGestureRecognizer actions
- (void)tapDetected:(UITapGestureRecognizer*)recognizer
{
    [self toggleArtworkDetail];
    
}

- (void)doubleTapDetected:(UITapGestureRecognizer*)recognizer
{
    [self.scrollView setZoomScale:1.0 animated:YES];
}


- (void)toggleArtworkDetail
{
    _userInteracted = YES;
    if ([self.detailView alpha] == 1.0) {
        [self hideArtworkInformation];
    } else {
        [self displayArtworkInformation];
    }
}

- (void)pinchDetected:(UIPinchGestureRecognizer*)recognizer
{
    _userInteracted = YES;
    if (recognizer.scale < 1) {
        if (!_animatingClose) {
            _animatingClose = YES;
            [self closeDetailScreen];
        }
    }
}

- (void)closeButtonSelected:(id)sender
{
    [self closeDetailScreen];
    
}

- (void)closeDetailScreen
{
    [Flurry endTimedEvent:FL_ARTWORK_DETAIL_VIEWED withParameters:nil];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kdidCloseArtworkDetailNotification object:nil];
    
    [self dismissViewControllerAnimated:NO completion:^(void){
        if ([self.delegate respondsToSelector:@selector(dismissDetailView)]) {
            [self.delegate performSelector:@selector(dismissDetailView)];
        }
    }];
}

- (void)updateBottomToolbarInfo
{
    [self updateHeartInfo];
    [self updateCartBubble];
    [self updateAddToCartButton];
}


- (void)updateHeartInfo
{
    if ([self.artObject.inCollection boolValue]) {
        [self.heartBtn setSelected:YES];
        int numLikes = [self.artObject.numInOtherCollections intValue];
        [self.heartBtn setTitle:[NSString stringWithFormat:@"%d", numLikes] forState:UIControlStateSelected];
    } else {
        [self.heartBtn setSelected:NO];
        [self.heartBtn setTitle:@"" forState:UIControlStateSelected];
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
    UIColor *cartRedColor = [UIColor colorWithRed:208.0f/255.0f green:41.0f/255.0f blue:15.0f/255.0f alpha:1.0f];
    if (self.artObject.sold) {
        [self.addToCartBtn setBackgroundColor:[UIColor clearColor]];
        [self.addToCartBtn setTitleColor:cartRedColor forState:UIControlStateNormal];
        [self.addToCartBtn setTitle:@"Sold" forState:UIControlStateNormal];
        [self.addToCartBtn setUserInteractionEnabled:NO];
        
    } else {
        [self.addToCartBtn setUserInteractionEnabled:YES];
        if ([self.artObject.inCart boolValue]) {
            [self.addToCartBtn setBackgroundColor:[UIColor clearColor]];
            [self.addToCartBtn setTitleColor:cartRedColor forState:UIControlStateNormal];
            [self.addToCartBtn setTitle:@"In Cart" forState:UIControlStateNormal];
        } else {
            [self.addToCartBtn setBackgroundColor:cartRedColor];
            [self.addToCartBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [self.addToCartBtn setTitle:@"Add to Cart" forState:UIControlStateNormal];
        }
    }
    
}

- (IBAction)shareButtonSelected:(id)sender
{
    self.isTryingToShareArtwork = YES;
    [[NSNotificationCenter defaultCenter] postNotificationName:kdidChooseShareButtonNotification object:nil];
}

- (void)didSaveMergedImage:(NSNotification*)note
{
    if (self.isTryingToShareArtwork) {
        self.isTryingToShareArtwork = NO;
        ATShareCelebrationViewController *celebrationController = [[ATShareCelebrationViewController alloc] initWithNibName:@"ATShareCelebrationViewController" bundle:nil];
        celebrationController.shareTitleString = @"SHARE TO GET FEEDBACK";
        celebrationController.shareMessageString = @"My wall needs art! What do you think of this piece? #originalart #designdilemma @ARTtwo50";
        celebrationController.displayCollection = NO;
        celebrationController.shouldShowThumbnails = NO;
        NSArray *artworkArray = [NSArray arrayWithObjects:[[ATArtManager sharedManager] currentArtObject],nil];
        [celebrationController setArtworkArray:artworkArray];
        
        UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:celebrationController];
        [self presentViewController:navController animated:YES completion:^(void){
            //        NSLog(@"presented celebration");
        }];
    }
}

- (void)didFailSavingMergedImage:(NSNotification*)note
{
    self.isTryingToShareArtwork = NO;
}

- (IBAction)heartButtonSelected:(id)sender
{
    
    UIButton *heartButton = (UIButton*)sender;
    if (heartButton.selected) {
        
        [[ATArtManager sharedManager] removeArtObjectFromCollection:self.artObject];
        
//        NSDictionary *dict = [[NSDictionary alloc] initWithObjectsAndKeys:self.artObject, @"artObject", nil];
//        [[NSNotificationCenter defaultCenter] postNotificationName:kArtworkDidGetAddedToCollection object:nil userInfo:dict];
        
    } else {
        if ([[ATUserManager sharedManager] isLoggedIn]) {
            NSDictionary *dict = [[NSDictionary alloc] initWithObjectsAndKeys:self.artObject, @"artObject", nil];
            [[NSNotificationCenter defaultCenter] postNotificationName:kaddArtworkToCollectionNotification object:nil userInfo:dict];
            [[ATArtManager sharedManager] addArtworkToCollection:self.artObject];
        } else {
            [[ATUserManager sharedManager] showSignUpDialogInView:self.view forDelegate:self];
        }
        
    }
    [self updateHeartInfo];
}

- (IBAction)cartButtonSelected:(id)sender
{
    [VesselAB startSession:VESSEL_CHECKOUT_SESSION];
    if ([[[ATArtManager sharedManager] cart] count] > 0) {
        [self displayCartScreen];
    } else {
        UIAlertView *emptyCartAlert;
        if ([self.artObject sold]) {
                emptyCartAlert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Your cart is empty.",nil) message:NSLocalizedString(@"Go find something you love.",nil) delegate:nil cancelButtonTitle:@"Okay." otherButtonTitles: nil];
        } else {
                emptyCartAlert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Your cart is empty.",nil) message:NSLocalizedString(@"Add this to your cart?",nil) delegate:self cancelButtonTitle:@"No thanks." otherButtonTitles:@"Yes please!", nil];
        }
        [emptyCartAlert show];
    }
}

- (void)displayCartScreen
{
    //NSLog(@"cartButtonSelected");
    
    ATCartViewController *cartController = [[ATCartViewController alloc] initWithNibName:@"ATCartViewController" bundle:nil];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:cartController];
    
    [Flurry logAllPageViews:navigationController];
    
    [self presentViewController:navigationController animated:YES completion:nil];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kdidDisplayPurchaseScreenNotification object:nil];
    
}

- (IBAction)addToCartButtonSelected:(id)sender
{
    if ([self.artObject.inCart boolValue]) {
        //Then just open the checkout
        [self displayCartScreen];
    } else {
        [self addCurrentArtworkToCart];
    }
}

- (void)addCurrentArtworkToCart
{
    [[ATArtManager sharedManager] addArtObjectToCart:self.artObject];
    if ([self.delegate respondsToSelector:@selector(didAddArtworkToCart)]) {
        [self.delegate performSelectorOnMainThread:@selector(didAddArtworkToCart) withObject:nil waitUntilDone:NO];
    }
    [self updateAddToCartButton];
    [self updateCartBubble];
}

#pragma mark
#pragma mark UIPopoverControllerDelegate

- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController
{
    [self changeCollectionButtonToAdd];
}

#pragma mark
#pragma mark UIAlertViewDelegate



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
