 //
//  ATHangitViewController.m
//  art250
//
//  Created by Winfred Raguini on 9/10/12.
//  Copyright (c) 2012 Art250. All rights reserved.
//

#import "ATHangitContainerViewController.h"
#import "UIImage+WRExtensions.h"
#import "ATArtObject.h"
#import "ATArtManager.h"
#import "ATLongPressImageView.h"
#import "ATGlobalConstants.h"
#import "QuartzCore/CALayer.h"
#import "UIColor+WRExtensions.h"
#import "ATArtworkDetailViewController.h"
#import "ATIntroViewController.h"
#import "ATIntroScreen1ViewController.h"
#import "ATIntroScreen2ViewController.h"
#import "ATIntroScreen3ViewController.h"
#import "ATIntroScreen4ViewController.h"
#import "ATAppDelegate.h"
#import "ATImagePickerViewController.h"
#import "ATCameraOverlayViewController.h"
#import "ATArtObject.h"
#import "ATSlotView.h"
#import "ATWalkThroughView1Controller.h"
#import "ATWalkThroughView6Controller.h"
#import "ATHintScreenView.h"
#import "ATDelegatedUIImageView.h"
#import "MBProgressHUD.h"
#import "ATPaymentManager.h"
#import "UIImageView+AFNetworking.h"
#import "ATShareCelebrationViewController.h"
#import "Artwork.h"
#import "Artist.h"
#import "ATUserManager.h"
#import "UIImage+ImageEffects.h"
#import "SearchableArtistProfile.h"
#import "ATInactiveArtworkProxy.h"

#define LOAD_MORE_ARTISTS_THRESHOLD 20
#define ARROW_SIZE_WIDTH 60.0f
#define ARROW_SIZE_HEIGHT 150.0f
#define ARROW_POS_Y 300.0f
#define RIGHT_ARROW_POS_X_OFFSET 90.0f
#define LEFT_ARROW_POS_X 30.0f

#define DEGREES_TO_RADIANS(angle) ((angle) / 180.0 * M_PI)

//#define PIX_PER_INCH 6.5f

#define SLIDE_ARTWORK_ANIMATION_DURATION 0.2f

typedef enum {
    ATCustomButtonAlertViewTypeLoadArt = 0,
    ATCustomButtonAlertViewTypeCollectionFull,
    ATCustomButtonAlertViewTypeCompletedPurchase,
    ATCustomButtonAlertViewTypeNoMoreRecommendations,
    ATCustomButtonAlertViewTypeWelcomeBack,
    ATCustomButtonAlertViewTypeEndOfArtists
}ATCustomButtonAlertViewType;


typedef enum {
    ATSlideViewTypePrevious = 0,
    ATSlideViewTypeCurrent,
    ATSlideViewTypeNext
}ATSlideViewType;


typedef enum {
    ATHintsViewTypeTap = 0,
    ATHintsViewTypeHoldAndDrag
} ATHintsViewType;

//@implementation UINavigationBar (customNav)
//- (CGSize)sizeThatFits:(CGSize)size {
//    CGSize newSize = CGSizeMake(self.frame.size.width, 43.0f);
//    return newSize;
//}
//@end


@interface ATHangitContainerViewController () {
    int _animatingExpandedView;
}


@property (nonatomic, strong) NSMutableArray *additionalArtwork;
@property (nonatomic, assign, readwrite) int prevIndex;
@property (nonatomic, assign, readwrite) int currIndex;
@property (nonatomic, assign, readwrite) int nextIndex;

@property (nonatomic, assign) BOOL updatingArtistCarousel;
@property (nonatomic, assign, readwrite) int verticalCurrIndex;
@property (nonatomic, assign, readwrite) int verticalUpIndex;
@property (nonatomic, assign, readwrite) int verticalDownIndex;


@property (nonatomic, assign) BOOL previewModeEnabled;
@property (nonatomic, assign, readwrite) BOOL displayingButtonAlert;

@property (nonatomic, strong, readwrite) UIImageView *hangitImageView;

@property (nonatomic, strong) UIViewController *recommendationWalkthroughController;

@property (nonatomic, strong, readwrite) ATLongPressImageView *prevPaintingView;
@property (nonatomic, strong, readwrite) ATLongPressImageView *currPaintingView;
@property (nonatomic, strong, readwrite) ATLongPressImageView *nextPaintingView;

@property (nonatomic, strong, readwrite) ATCustomButtonAlertView *welcomeBackAlertView;
@property (nonatomic, strong, readwrite) ATCustomButtonAlertView *prevAlertView;
@property (nonatomic, strong, readwrite) ATCustomButtonAlertView *currAlertView;
@property (nonatomic, strong, readwrite) ATCustomButtonAlertView *nextAlertView;


@property (nonatomic, strong, readwrite) ATLongPressImageView *upPaintingView;
@property (nonatomic, strong, readwrite) ATLongPressImageView *middlePaintingView;
@property (nonatomic, strong, readwrite) ATLongPressImageView *downPaintingView;


@property (nonatomic, strong) ATDelegatedUIImageView *tempButtonAlertView;

@property (nonatomic, strong, readwrite) ATLongPressImageView *tempPaintingView;
@property (nonatomic, strong, readwrite) ATLongPressImageView *previewPaintingView;

@property (nonatomic, strong, readwrite) ATLongPressImageView *expandingPaintingView;
@property (nonatomic, strong, readwrite) UIView *grayView;
@property (nonatomic, assign, readwrite) BOOL isAnimating;
@property (nonatomic, strong, readwrite) UIView *averageColorView;
@property (nonatomic, strong, readwrite) UIView *complementaryColorView;
@property (nonatomic, strong, readwrite) NSMutableArray *averageColorViewArray;
@property (nonatomic, strong, readwrite) ATArtworkDetailViewController *artworkDetailViewController;
@property (nonatomic, strong, readwrite) ATIntroViewController *introViewController;
@property (nonatomic, strong) ATCustomButtonAlertView *defaultCustomButtonAlertView;

@property (nonatomic, strong) UIImageView *blurryImageOverlayView;
@property (nonatomic, strong) UIView *slideOutMenuView;

- (void)displayFirstTimeDragArtworkView;
- (void)displayNextPaintingWithDeletion:(BOOL)deletion;
- (void)displayPreviousPainting;
- (void)nextPaintingButtonSelected:(id)sender;
- (void)previousPaintingButtonSelected:(id)sender;
- (void)viewSwipedLeft:(UIGestureRecognizer*)recognizer;
- (void)viewSwipedRight:(UIGestureRecognizer*)recognizer;
- (void)updateCurrentArtObject;
- (void)longPressDetected:(UILongPressGestureRecognizer*)recognizer;
- (CGPoint)centerOfScreen;
- (void)presentArtworkDetailViewController;
- (void)distanceButtonSelected:(id)sender;
- (void)moveCurrPaintingViewLeftOffScreen;
- (void)moveCurrPaintingViewBackOnScreen;
- (void)useSampleRoomImage;
- (void)dismissDetailView;
- (void)closeCameraButtonSelected;
- (void)clearHintScreen;
- (void)resetScrollView;
- (void)resetScrollViewAndShuffleViewForward;
- (void)shuffleViewsBackward;
- (CGPoint)centerOfScreenForVerticalScrollWithPageIndex:(int)index;
- (UIImage*)blurredBackgroundImage;

@end

@implementation ATHangitContainerViewController 

int colorIndex = 0;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization

    }
    return self;
}

UIPinchGestureRecognizer *_pinchRecognizer;

- (void)viewDidLoad
{
    [super viewDidLoad];
    //Replacing our animation with a UIScrollView
        
    
    self.displayingButtonAlert = NO;
    self.previewModeEnabled = NO;
    
    
    UITapGestureRecognizer *doubleTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didDoubleTapOnScroll:)];
    doubleTapRecognizer.numberOfTapsRequired = 2;
    
    UIGestureRecognizer *scrollTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapOnScroll:)];
    
    [scrollTapRecognizer requireGestureRecognizerToFail:doubleTapRecognizer];
    [self.horizontalScrollView addGestureRecognizer:scrollTapRecognizer];
    [self.horizontalScrollView addGestureRecognizer:doubleTapRecognizer];
    
    
    [self.horizontalScrollView setDelegate:self];
    [self.horizontalScrollView setShowsHorizontalScrollIndicator:NO];
    [self.horizontalScrollView setPagingEnabled:YES];
    [self.horizontalScrollView setScrollEnabled:NO];
    
    
    [self.verticalScrollView setDelegate:self];
    [self.verticalScrollView setShowsHorizontalScrollIndicator:NO];
    [self.verticalScrollView setShowsVerticalScrollIndicator:NO];
    [self.verticalScrollView setPagingEnabled:YES];
    
    CGRect verticalScrollViewFrame = self.verticalScrollView.frame;
    verticalScrollViewFrame.origin.y = 0.0f;
    [self.verticalScrollView setFrame:verticalScrollViewFrame];

    
    self.previewPaintingView = [[ATLongPressImageView alloc] initWithFrame:CGRectZero];
    [self.previewPaintingView setDelegate:self];
    self.previewPaintingView.center = [self centerOfScreenForPageIndex:1];
    [self.horizontalScrollView addSubview:self.previewPaintingView];
    
    
    self.prevPaintingView = [[ATLongPressImageView alloc] initWithFrame:CGRectZero];
    [self.prevPaintingView setDelegate:self];
    self.prevPaintingView.center = [self centerOfScreenForPageIndex:0];
    [self.horizontalScrollView addSubview:self.prevPaintingView];
    
    self.prevAlertView = [[ATCustomButtonAlertView alloc] initWithFrame:CGRectMake(0.0, 0.0, 417.0f, .0f)];
    [self.prevAlertView setDelegate:self];
    self.prevAlertView.center = [self centerOfScreenForPageIndex:0];
    [self.horizontalScrollView addSubview:self.prevAlertView];
    
    
    self.currPaintingView = [[ATLongPressImageView alloc] initWithFrame:CGRectZero];
    [self.currPaintingView setDelegate:self];
    self.currPaintingView.center = [self centerOfScreenForPageIndex:1];
    [self.horizontalScrollView addSubview:self.currPaintingView];
    
    self.currAlertView = [[ATCustomButtonAlertView alloc] initWithFrame:CGRectMake(0.0, 0.0, 417.0f, .0f)];
    [self.currAlertView setDelegate:self];
    self.currAlertView.center = [self centerOfScreenForPageIndex:1];
    [self.horizontalScrollView addSubview:self.currAlertView];
    
    
    self.nextPaintingView = [[ATLongPressImageView alloc] initWithFrame:CGRectZero];
    [self.nextPaintingView setDelegate:self];
    self.nextPaintingView.center = [self centerOfScreenForPageIndex:2];
    [self.horizontalScrollView addSubview:self.nextPaintingView];
    
    self.nextAlertView = [[ATCustomButtonAlertView alloc] initWithFrame:CGRectMake(0.0, 0.0, 417.0f, .0f)];
    [self.nextAlertView setDelegate:self];
    self.nextAlertView.center = [self centerOfScreenForPageIndex:1];
    [self.horizontalScrollView addSubview:self.nextAlertView];
    
    
    [self.horizontalScrollView setContentSize:CGSizeMake(self.view.frame.size.width * 3, self.view.frame.size.height)];
    //Scroll to "middle panel"
    [self.horizontalScrollView scrollRectToVisible:CGRectMake(self.view.frame.size.width, 0, self.view.frame.size.width, self.view.frame.size.height) animated:NO];
    
    [self.verticalScrollView setContentSize:CGSizeMake(self.view.frame.size.width, self.view.frame.size.height * 3)];
    //Also scroll to "middle panel"
    [self.verticalScrollView scrollRectToVisible:CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, self.view.frame.size.height) animated:NO];
    
    
    self.upPaintingView = [[ATLongPressImageView alloc] initWithFrame:CGRectZero];
    [self.upPaintingView setDelegate:self];
    [self.verticalScrollView addSubview:self.upPaintingView];
    
    self.middlePaintingView = [[ATLongPressImageView alloc] initWithFrame:CGRectZero];
    [self.middlePaintingView setDelegate:self];
    [self.verticalScrollView addSubview:self.middlePaintingView];
    
    self.downPaintingView = [[ATLongPressImageView alloc] initWithFrame:CGRectZero];
    [self.downPaintingView setDelegate:self];
    [self.verticalScrollView addSubview:self.downPaintingView];
    
    //[self hideVerticalCarousel];
    
    [self.verticalScrollView setScrollEnabled:YES];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadArtworkForArtistProfile:) name:kdidInvokeLoadArtworkForArtistProfile object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didLogIn:) name:kdidLoginNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(willLogIn:) name:kwillLogInNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didFailLogin:) name:kdidFailLoginNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didUpdateCarousel:) name:kdidUpdateCarouselNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didChooseShareButton:) name:kdidChooseShareButtonNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didAddCurrentArtworkToCart:) name:kdidAddCurrentArtworkToCartNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didChooseMenuButton:) name:kdidChooseMenuButtonNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(imageLoadCount:) name:@"com.alamofire.networking.operation.finish" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didSwapWithArtObject:) name:@"didSwap" object:nil];
    

    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didDismissShareScreen:) name:kdidDismissShareScreenNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didDismissCartView:) name:kdidDismissCartViewNotification object:nil];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(willDismissArtworkPreview:) name:kwillDismissArtworkPreview object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didPresentArtworkDetailView:) name:kdidPresentArtworkDetailView object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didDismissHintsView:) name:kdidDismissHintsView object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(artworkAddedToCollection:)
                                                 name:kArtworkDidGetAddedToCollection object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didSelectCloseCameraButton:) name:kdidSelectCloseCameraButton object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didIncrementArtCounter:) name:kdidIncrementArtCounter object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didLoadFinalIntroScreen:) name:kdidLoadFinalIntroScreen object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didInvokeSampleRoomPhoto:) name:kinvokeLaunchScreenSampleRoomNotification object:nil];
    
    
    //Notifications to clear hint screen
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(clearHintScreen) name:kdidInteractWithApp object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(clearHintScreen) name:kdidPresentArtworkDetailView object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(clearHintScreen) name:kDidTapOnArtworkBackground object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(clearHintScreen) name:kdidScrollArtBackwardNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(clearHintScreen) name:kdidScrollArtForwardNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didCompleteLoadingAdditionalArtwork) name:kdidCompleteLoadingAdditionalArtworkNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didFillCollection) name:kdidFillCollectionNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didCompletePurchase) name:kdidDismissCompletedPurchaseScreenNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didDisplayPurchaseScreen) name:kdidDisplayPurchaseScreenNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didChooseNewPhotoOption:) name:kdidChooseNewPhotoOptionNotification object:nil];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didTakeNewPhotoOption:) name:kdidChooseTakeNewPhotoOptionNotification object:nil];

        
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didChooseBuyNowButton:) name:kdidChooseBuyNowButtonNotification object:nil];
    
    
    [self addObserver:self forKeyPath:@"currIndex" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];

    
    [self addObserver:self forKeyPath:@"currPaintingView" options:NSKeyValueObservingOptionNew context:nil];
    
    
    
    if ([[ATArtManager sharedManager] cachedBackgroundImage] != nil) {
        [self.backgroundImageView setImage:[[ATArtManager sharedManager] cachedBackgroundImage]];
    } else {
        if ([[ATArtManager sharedManager] savedBackgroundImage] != nil) {
            [self.backgroundImageView setImage:[[ATArtManager sharedManager] savedBackgroundImage]];
        }
    }
    
    //Add tap recognizer to background image
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backgroundTapDetected:)];
    [self.backgroundImageView addGestureRecognizer:tapRecognizer];
    
    _pinchRecognizer = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchDetected:)];
    
    self.averageColorView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 40.0f, 50.0f, 50.0f)];
    [self.view addSubview:self.averageColorView];
    
    self.complementaryColorView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, self.averageColorView.frame.size.height + self.averageColorView.frame.origin.y, 50.0f,50.0f)];
    [self.view addSubview:self.complementaryColorView];

    
    self.previewCloseButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.previewCloseButton addTarget:self action:@selector(previewCloseButtonSelected:) forControlEvents:UIControlEventTouchUpInside];
    CGRect previewCloseButtonFrame = self.previewCloseButton.frame;
    previewCloseButtonFrame.origin.y = 0.0f;
    previewCloseButtonFrame.origin.x = 934.0f;
    previewCloseButtonFrame.size.height = 77.0f;
    previewCloseButtonFrame.size.width = 86.0f;

    [self.previewCloseButton setFrame:previewCloseButtonFrame];
    [self.previewCloseButton setImage:[UIImage imageNamed:@"btn_close_default.png"] forState:UIControlStateNormal];
    [self.view addSubview:self.previewCloseButton];
    [self.previewCloseButton setAlpha:0.0f];
    
    
    self.averageColorViewArray = [[NSMutableArray alloc] init];
    CGFloat _x2 = 0, _y2 = 200;
    CGFloat side2 = 20;
    for (int i=0; i < 11; i++) {
        if ((_x2 + side2) > self.view.frame.size.width ) {
            _x2 = 0;
            _y2 = _y2 + side2;
        }
        
        UIView *hueColorView = [[UIView alloc] initWithFrame:CGRectMake(_x2, _y2, side2, side2)];
        [hueColorView setBackgroundColor:[UIColor clearColor]];
        _x2 = _x2 + side2;
        [self.view addSubview:hueColorView];
        [self.averageColorViewArray addObject:hueColorView];
    }
        
    if ([[ATArtManager sharedManager] firstTimeUser]) {
    
        if  ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]) {
            self.imagePicker = [[ATImagePickerViewController alloc] init];
            CGRect imagePickerFrame = self.imagePicker.view.frame;
            imagePickerFrame.origin.y = 43.0f;
            [self.imagePicker.view setFrame:imagePickerFrame];
            self.imagePicker.delegate = self;
            self.imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
            self.imagePicker.allowsEditing = YES;
            self.imagePicker.showsCameraControls = NO;
            
            
            self.cameraOverlayController = [[ATCameraOverlayViewController alloc] initWithNibName:@"ATCameraOverlayViewController" bundle:nil];
            [self.cameraOverlayController setDelegate:self.imagePicker];
            self.cameraOverlayController.mode = ATCameraModeTutorial;
            self.cameraOverlayController.hideCloseButton = YES;
            
            self.imagePicker.cameraOverlayView = self.cameraOverlayController.view;
        }
        
        self.introViewController = [[ATIntroViewController alloc] initWithNibName:@"ATIntroViewController" bundle:nil];
        
        [self.introViewController.view setBackgroundColor:[UIColor clearColor]];
        
        
        ATWalkThroughView1Controller *walkThrough1Controller = [[ATWalkThroughView1Controller alloc] initWithNibName:@"ATWalkThroughViewController" bundle:nil];
        walkThrough1Controller.delegate = self.introViewController;

        ATWalkThroughView6Controller *walkThrough6Controller = [[ATWalkThroughView6Controller alloc] initWithNibName:@"ATWalkThroughViewController" bundle:nil];
        

        [self.introViewController addChildViewController:walkThrough1Controller];
        [self.introViewController addChildViewController:walkThrough6Controller];


        
        [self addChildViewController:self.introViewController];
        [self.introViewController didMoveToParentViewController:self];
        
        [self.view addSubview:self.introViewController.view];
        
        [[ATTrackingManager sharedManager] trackEvent:FL_STARTED_INTRO timed:YES];
        
    } else {
        
    }
    
    [[ATTrackingManager sharedManager] registerUserTracking];
    

    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    [self removeObserver:self forKeyPath:@"currPaintingView"];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"currPaintingView"])
    {
        //NSLog(@"Changing painting view");
//        CGRect imageBounds = self.currPaintingView.bounds;
//        [self.currPaintingView.layer setAnchorPoint:CGPointMake(1.0, 0)];
//        self.currPaintingView.center = [self centerOfScreen];
    } else if ([keyPath isEqualToString:@"currIndex"]) {
        int oldIndex = [[change objectForKey:NSKeyValueChangeOldKey] intValue];
        int newIndex =[[change objectForKey:NSKeyValueChangeNewKey] intValue];
        
        if (oldIndex != newIndex) {
            NSDictionary *userInfo = [[NSDictionary alloc] initWithObjectsAndKeys:[NSNumber numberWithInt:self.currIndex], @"currIndex", nil];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:kdidProgressThroughRecommendedArtworkNotification object:nil userInfo:userInfo];
//            NSLog(@"Magically currIndex is %d", [[change objectForKey:NSKeyValueChangeNewKey] intValue]);
//            NSLog(@"index is %d", self.currIndex);
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    [UIImageView clearImageCache];
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}


#pragma mark
#pragma mark Private

- (void)willLogIn:(NSNotification*)note
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.labelText = NSLocalizedString(@"Logging in...",nil);
    [hud show:YES];
}

- (void)didLogIn:(NSNotification*)note
{
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
}

- (void)didFailLogin:(NSNotification*)note
{
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
}

- (void)showSlideOutView
{
    self.slideOutMenuView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 380.0f, 704.0f)];
    [self.slideOutMenuView setBackgroundColor:[UIColor redColor]];
    UIButton *testButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [testButton addTarget:self action:@selector(testButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    CGRect testButtonFrame = testButton.frame;
    testButtonFrame = CGRectMake(70.0f, 30.0f, 60.0f, 60.0f);
    [testButton setFrame:testButtonFrame];
    [self.slideOutMenuView addSubview:testButton];
    
    [self.view addSubview:self.slideOutMenuView];
}


- (void)didChooseMenuButton:(NSNotification*)note
{
//    if (self.blurryImageOverlayView.hidden || self.blurryImageOverlayView.alpha < 1.0f) {
//        [self showBlurryBackground];
//    } else {
//        [self hideBlurryBackground];
//    }
}




#pragma mark
#pragma mark UITapGestureRecognizer - for scroll
- (void)didTapOnScroll:(UITapGestureRecognizer*)recognizer
{
    if ([self.delegate respondsToSelector:@selector(hideMenuDock)]) {
        [self.delegate performSelectorOnMainThread:@selector(hideMenuDock) withObject:nil waitUntilDone:NO];
    }
    
    CGPoint pointOnView = [recognizer locationInView:self.horizontalScrollView];
    if (CGRectContainsPoint(self.currPaintingView.frame, pointOnView)) {
        id currentObject = [[ATArtManager sharedManager] currentArtObject];
        if ([currentObject isKindOfClass:[Artwork class]]) {
            [self displayDetailedView];
        }
    } else {
        id currentObject = [[ATArtManager sharedManager] currentArtObject];
        if ([currentObject isKindOfClass:[Artwork class]]) {
            [self togglePreviewMode];
        }
    }
}

- (void)didDoubleTapOnScroll:(UITapGestureRecognizer*)recognizer
{
    CGPoint pointOnView = [recognizer locationInView:self.horizontalScrollView];
    if (CGRectContainsPoint(self.currPaintingView.frame, pointOnView)) {
        id currentObject = [[ATArtManager sharedManager] currentArtObject];
        if ([currentObject isKindOfClass:[Artwork class]]) {
            Artwork *artwork = (Artwork*)currentObject;
            if ([artwork.inCollection boolValue]) {
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
        }
        
    } else {
        
    }
}

- (void)addCurrentArtworkToCollection
{
    Artwork *artwork = [[ATArtManager sharedManager] currentArtObject];
//    NSLog(@"current artwork is %@", artwork.title);
    [[ATArtManager sharedManager] addArtworkToCollection:artwork];
    
    NSDictionary *dict = [[NSDictionary alloc] initWithObjectsAndKeys:artwork, @"artObject", nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:kArtworkDidGetAddedToCollection object:nil userInfo:dict];
}

- (void)setupPages
{
    
}

- (void)togglePreviewMode
{
    if (self.previewModeEnabled) {
        if ([self.delegate respondsToSelector:@selector(showBottomToolBar)]) {
            [self.delegate performSelector:@selector(showBottomToolBar) withObject:nil];
        }
        [self.currPaintingView updateWithArtObject:[[ATArtManager sharedManager] currentArtObject] withRatio:[[ATArtManager sharedManager] pixelsPerInch] forEventType:0];
        [self.middlePaintingView updateWithArtObject:[[ATArtManager sharedManager] currentArtObject] withRatio:[[ATArtManager sharedManager] pixelsPerInch] forEventType:0];
        
        self.previewModeEnabled = NO;
    } else {
        if ([self.delegate respondsToSelector:@selector(hideBottomToolBar)]) {
            [self.delegate performSelector:@selector(hideBottomToolBar) withObject:nil];
        }
        if ([self.delegate respondsToSelector:@selector(hideMenuDock)]) {
            [self.delegate performSelector:@selector(hideMenuDock) withObject:nil];
        }
        [self.currPaintingView updateWithArtObject:[[ATArtManager sharedManager] currentArtObject] withRatio:[[ATArtManager sharedManager] pixelsPerInch] forEventType:ATArtworkEventTypePreview];
        [self.middlePaintingView updateWithArtObject:[[ATArtManager sharedManager] currentArtObject] withRatio:[[ATArtManager sharedManager] pixelsPerInch] forEventType:ATArtworkEventTypePreview];
        
        
        self.previewModeEnabled = YES;
    }
    

}


- (void)hidePaintings
{
    [self.currPaintingView setHidden:YES];
    [self.nextPaintingView setHidden:YES];
    [self.prevPaintingView setHidden:YES];
    [self.upPaintingView setHidden:YES];
    [self.middlePaintingView setHidden:YES];
    [self.downPaintingView setHidden:YES];
}

- (void)showPaintings
{
    [self.currPaintingView setHidden:NO];
    [self.nextPaintingView setHidden:NO];
    [self.prevPaintingView setHidden:NO];
    [self.upPaintingView setHidden:NO];
    [self.downPaintingView setHidden:NO];
}

- (void)loadPageWithId:(int)index onPage:(int)page {
	// load data for page
    
    Artwork *artObject;
#ifdef DEBUG
    //NSLog(@"index is %d", index);
#endif
	switch (page) {
		case 0:
            

            self.prevAlertView.hidden = YES;
            self.prevPaintingView.hidden= NO;
            //NSLog(@"index is %d", index);
            
            [self.prevPaintingView cancelImageRequestOperation];
            
            artObject = [[[ATArtManager sharedManager] artCarousel] objectAtIndex:index];
            if ([artObject isKindOfClass:[ATInactiveArtworkProxy class]]) {
                ATInactiveArtworkProxy *proxy = (ATInactiveArtworkProxy*)artObject;
                Artwork *foundArtwork = [[ATArtManager sharedManager] findAnyArtworkForArtistProfile:proxy.artistProfile];
                
                if (foundArtwork != nil) {
                    [[ATArtManager sharedManager] replaceArtworkAtIndex:index withArtwork:foundArtwork];
                    [self.prevPaintingView updateWithArtObject:foundArtwork withRatio:[[ATArtManager sharedManager] pixelsPerInch] forEventType:ATArtworkEventTypeUnknown];
                } else {
                    [self.prevPaintingView updateWithInactiveArtworkProxy:proxy];
                }
            } else {
                [self.prevPaintingView updateWithArtObject:artObject withRatio:[[ATArtManager sharedManager] pixelsPerInch] forEventType:ATArtworkEventTypeUnknown];
               
            }
            self.prevPaintingView.center = [self centerOfScreenForPageIndex:page];
                

			break;
		case 1:
            
                
            [self.currAlertView removeFromSuperview];
            self.currAlertView = nil;
            
            self.currPaintingView.hidden= NO;
            artObject = [[[ATArtManager sharedManager] artCarousel] objectAtIndex:index];
            //Preload large Image
            [[ATArtManager sharedManager] setCurrentArtObject:artObject];
            [self.currPaintingView cancelImageRequestOperation];
            [[ATArtManager sharedManager] setCurrentIndex:self.currIndex];
            if ([artObject isKindOfClass:[ATInactiveArtworkProxy class]]) {
                
                ATInactiveArtworkProxy *proxy = (ATInactiveArtworkProxy*)artObject;
                Artwork *foundArtwork = [[ATArtManager sharedManager] findAnyArtworkForArtistProfile:proxy.artistProfile];
                
                if (foundArtwork != nil) {
                    [[ATArtManager sharedManager] replaceCurrentArtworkWithArtwork:foundArtwork];
                    [self.currPaintingView updateWithArtObject:foundArtwork withRatio:[[ATArtManager sharedManager] pixelsPerInch] forEventType:ATArtworkEventTypeUnknown];
                    [self.verticalScrollView setUserInteractionEnabled:YES];
                    [self.verticalScrollView setHidden:NO];
                } else {
                    [self.currPaintingView updateWithInactiveArtworkProxy:proxy];
                    [self.verticalScrollView setUserInteractionEnabled:NO];
                    [self.verticalScrollView setHidden:YES];
                }
            } else {
                [self.currPaintingView updateWithArtObject:artObject withRatio:[[ATArtManager sharedManager] pixelsPerInch] forEventType:ATArtworkEventTypeUnknown];
                
                [self.verticalScrollView setUserInteractionEnabled:YES];
                [self.verticalScrollView setHidden:NO];
            }
            self.currPaintingView.center = [self centerOfScreenForPageIndex:page];
			break;
		case 2:
            
                
            self.nextAlertView.hidden = YES;
            self.nextPaintingView.hidden = NO;
            artObject = [[[ATArtManager sharedManager] artCarousel] objectAtIndex:index];
            
            [self.nextPaintingView cancelImageRequestOperation];
            if ([artObject isKindOfClass:[ATInactiveArtworkProxy class]]) {
                
                ATInactiveArtworkProxy *proxy = (ATInactiveArtworkProxy*)artObject;
                Artwork *foundArtwork = [[ATArtManager sharedManager] findAnyArtworkForArtistProfile:proxy.artistProfile];
                
                if (foundArtwork != nil) {
                    [[ATArtManager sharedManager] replaceArtworkAtIndex:index withArtwork:foundArtwork];
                    [self.nextPaintingView updateWithArtObject:foundArtwork withRatio:[[ATArtManager sharedManager] pixelsPerInch] forEventType:ATArtworkEventTypeUnknown];
                } else {
                    [self.nextPaintingView updateWithInactiveArtworkProxy:proxy];
                }
                
                
            } else {
                [self.nextPaintingView updateWithArtObject:artObject withRatio:[[ATArtManager sharedManager] pixelsPerInch] forEventType:ATArtworkEventTypeUnknown];
            }
            self.nextPaintingView.center = [self centerOfScreenForPageIndex:page];

			break;
	}
}

- (void)setCurrIndex:(int)currIndex
{
    [[ATArtManager sharedManager] setCurrentIndex:currIndex];
    //Save the carousel current index for later
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:currIndex] forKey:@"currIndex"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (int)currIndex
{
    return [[ATArtManager sharedManager] currentIndex];
}


int count = 0;

- (void)imageLoadCount:(NSNotification*)note
{
    count += 1;
}



- (void)displayBackgroundImageColorArray
{
    //
    //    CGFloat _x = 0, _y = 40;
    //    CGFloat side = 20;
    //    for (UIColor *color in self.colorArray) {
    //        if ((_x + side) > self.view.frame.size.width ) {
    //            _x = 0;
    //            _y = _y + side;
    //        }
    //
    //        UIView *colorView = [[UIView alloc] initWithFrame:CGRectMake(_x, _y, side, side)];
    //        [colorView setBackgroundColor:color];
    //        _x = _x + side;
    //        [self.view addSubview:colorView];
    //    }
//    CGFloat _x2 = 0, _y2 = 200;
//    CGFloat side2 = 20;
//    for (UIColor *hueColor in hueArray) {
//        if ((_x2 + side2) > self.view.frame.size.width ) {
//            _x2 = 0;
//            _y2 = _y2 + side2;
//        }
//        
//        UIView *hueColorView = [[UIView alloc] initWithFrame:CGRectMake(_x2, _y2, side2, side2)];
//        [hueColorView setBackgroundColor:hueColor];
//        _x2 = _x2 + side2;
//        [self.view addSubview:hueColorView];
//    }
    
    
//    for (UIView *view in self.averageColorViewArray) {
//        [view setBackgroundColor:[UIColor clearColor]];
//    }
//    
//    int i = 0;
//    for (UIColor *hueColor in hueArray) {
//        UIView *view = [self.averageColorViewArray objectAtIndex:i];
//        [view setBackgroundColor:hueColor];
//        i++;
//    }
//    //NSLog(@"This is the number dog %d", [hueArray count]);
}

- (CGPoint)centerOfScreen
{
    return CGPointMake(self.view.frame.size.width/2.0f, self.view.frame.size.height/2.0f - VIRTUAL_PAINTING_POS_Y_OFFSET);
}

- (CGPoint)centerOfScreenForPageIndex:(int)index
{
    
    return CGPointMake(self.view.frame.size.width/2.0f + (self.view.frame.size.width * index), self.view.frame.size.height/2.0f - VIRTUAL_PAINTING_POS_Y_OFFSET);
}

- (CGPoint)centerOfScreenForVerticalScrollWithPageIndex:(int)index
{
    
    return CGPointMake(self.view.frame.size.width/2.0f, self.view.frame.size.height/2.0f + (self.view.frame.size.height * index) - VIRTUAL_PAINTING_POS_Y_OFFSET);
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    return YES;
}


- (void)darkenHangitView
{
    [self lightenHangitView];
    if (self.grayView == nil) {
        self.grayView = [[UIView alloc] initWithFrame:self.view.frame];
    }
    [self.grayView setOpaque:YES];
    [self.grayView setBackgroundColor:[UIColor blackColor]];
    [self.grayView setAlpha:0.6f];
    [self.grayView setUserInteractionEnabled:YES];
    [self.backgroundImageView addSubview:self.grayView];
}

- (void)lightenHangitView
{
    [self.grayView removeFromSuperview];
}


- (void)previewCloseButtonSelected:(id)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:kwillDismissArtworkPreview object:nil];
}

- (void)backgroundTapDetected:(UIGestureRecognizer*)recognizer
{
    [[NSNotificationCenter defaultCenter] postNotificationName:kwillDismissArtworkPreview object:nil];
}

- (void)nextPaintingButtonSelected:(id)sender
{
    [self.horizontalScrollView scrollRectToVisible:CGRectMake(self.view.frame.size.width*2,0,self.view.frame.size.width,self.view.frame.size.height) animated:YES];
    
    [self performSelector:@selector(resetScrollViewAndShuffleViewForward) withObject:nil afterDelay:0.2f];
}


- (void)previousPaintingButtonSelected:(id)sender
{
    [self.horizontalScrollView scrollRectToVisible:CGRectMake(0,0,self.view.frame.size.width,self.view.frame.size.height) animated:YES];
    
    [self performSelector:@selector(resetScrollViewAndShuffleViewBackward) withObject:nil afterDelay:0.2f];
}

- (void)resetScrollViewAndShuffleViewBackward
{
    [self resetScrollView];
    [self shuffleViewsBackward];
}

- (void)resetScrollViewAndShuffleViewForward
{
    [self resetScrollView];
    [self shuffleViewsForward];
}

- (void)resetScrollView
{
    [self.horizontalScrollView scrollRectToVisible:CGRectMake(self.view.frame.size.width,0,self.view.frame.size.width,self.view.frame.size.height) animated:NO];
}

- (void)refreshAllScrollViewSubviews
{
    [self showPaintings];
    if (self.currIndex == [[[ATArtManager sharedManager] artCarousel] count]) {
        [self.horizontalScrollView setScrollEnabled:YES];
        [self.verticalScrollView setScrollEnabled:YES];
    }
    
    // We are moving forward. Load the current doc data on the first page.
    int tempPrevIndex = [self safelyDecrementCurrIndex];
    [self loadPageWithId:tempPrevIndex onPage:0];
    
    // Add one to the currentIndex or reset to 0 if we have reached the end.
    [self loadPageWithId:self.currIndex onPage:1];
    // Load content on the last page. This is either from the next item in the array
    // or the first if we have reached the end.
    int tempNextIndex = [self safelyIncrementCurrIndex];
    [self loadPageWithId:tempNextIndex onPage:2];
    
    //Go ahead and refresh the vertical middle scrollview
    Artwork *middleArtwork = [self.additionalArtwork objectAtIndex:self.verticalCurrIndex];
    
    [self.middlePaintingView updateWithArtObject:middleArtwork withRatio:[[ATArtManager sharedManager] pixelsPerInch] forEventType:ATArtworkEventTypeUnknown];
}

- (void)shuffleViewsForward
{
    [[NSNotificationCenter defaultCenter] postNotificationName:kdidScrollArtForwardNotification object:nil];
    
    // We are moving forward. Load the current doc data on the first page.
    self.currIndex = [self safelyRefreshCurrIndex];
    [self loadPageWithId:self.currIndex onPage:0];
    
    // Add one to the currentIndex or reset to 0 if we have reached the end.
    self.currIndex = [self safelyIncrementCurrIndex];
    
    [self trackVisibleArtObject];
    
    [self loadPageWithId:self.currIndex onPage:1];
    // Load content on the last page. This is either from the next item in the array
    // or the first if we have reached the end.
    _nextIndex = [self safelyIncrementCurrIndex];
    [self loadPageWithId:_nextIndex onPage:2];
    
}

- (void)trackVisibleArtObject
{

    if (self.currIndex < [[[ATArtManager sharedManager] artCarousel] count])
    {
        [[ATTrackingManager sharedManager] trackEvent:FL_ART_SWIPES];
        Artwork *currArtObject = [[[ATArtManager sharedManager] artCarousel] objectAtIndex:self.currIndex];
        if ([currArtObject isKindOfClass:[Artwork class]]) {
            [[ATArtManager sharedManager] trackArtObject:currArtObject];
        }
    }
}


- (void)shuffleViewsBackward
{
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kdidScrollArtBackwardNotification object:nil];
    // We are moving backward. Load the current doc data on the last page.
    self.currIndex = [self safelyRefreshCurrIndex];
    [self loadPageWithId:self.currIndex onPage:2];
    // Subtract one from the currentIndex or go to the end if we have reached the beginning.
    self.currIndex = [self safelyDecrementCurrIndex];
    
    [self trackVisibleArtObject];
    
    [self loadPageWithId:self.currIndex onPage:1];
    // Load content on the first page. This is either from the prev item in the array
    // or the last if we have reached the beginning.
    _prevIndex = [self safelyDecrementCurrIndex];
    [self loadPageWithId:_prevIndex onPage:0];
}

- (int)safelyRefreshCurrIndex
{
    return (self.currIndex > [self maxScrollViewIndex]) ? 0 : self.currIndex;
}

- (int)safelyDecrementCurrIndex
{
    return (self.currIndex == 0) ? [self maxScrollViewIndex] : self.currIndex - 1;
}

- (int)safelyIncrementCurrIndex
{
    return (self.currIndex >= [self maxScrollViewIndex]) ? 0 : self.currIndex + 1;
}


- (int)safelyRefreshVerticalCurrIndex
{
    return (self.verticalCurrIndex >= self.additionalArtwork.count - 1) ? 0 : self.verticalCurrIndex;
}

- (int)safelyDecrementVerticalCurrIndex
{
    return (self.verticalCurrIndex == 0) ? self.additionalArtwork.count - 1 : self.verticalCurrIndex - 1;
}

- (int)safelyIncrementVerticalCurrIndex
{
    return (self.verticalCurrIndex >= self.additionalArtwork.count - 1) ? 0 : self.verticalCurrIndex + 1;
}

- (int)maxScrollViewIndex
{
    return [[[ATArtManager sharedManager] artCarousel] count] - 1;
}

- (void)displayNextPainting
{
    [self displayNextPaintingWithDeletion:YES];
}

- (void)animatePreviewPainting
{
    [UIView animateWithDuration:SLIDE_ARTWORK_ANIMATION_DURATION animations:^(void){
        self.previewPaintingView.center = [self centerOfScreenForPageIndex:1];
        [self.previewCloseButton setAlpha:1.0f];
    } completion:^(BOOL finished){

    }];
    
    //NSLog(@"width %1.2f; height %1.2f, x: %1.2f, y: %1.2f", self.previewPaintingView.frame.size.width, self.previewPaintingView.frame.size.height, self.previewPaintingView.frame.origin.x, self.previewPaintingView.frame.origin.y);
}

- (void)moveCurrPaintingViewBackOnScreen
{
    [UIView animateWithDuration:1.0f animations:^(){
        [self.currPaintingView setCenter:[self centerOfScreenForPageIndex:1]];
    }];
}


- (void)moveCurrAlertViewBackOnScreen
{
    [UIView animateWithDuration:1.0f animations:^(){
        [self.currAlertView setCenter:[self centerOfScreenForPageIndex:1]];
    }];
}

- (void)moveCurrPaintingViewLeftOffScreen
{
    [UIView animateWithDuration:1.0f animations:^(){
        CGRect currPaintingViewFrame = self.currPaintingView.frame;
        currPaintingViewFrame.origin.x = self.currPaintingView.frame.size.width * -1.0f;
        [self.currPaintingView setFrame:currPaintingViewFrame];
    }];
}

- (void)moveCurrAlertViewLeftOffScreen
{
    [UIView animateWithDuration:1.0f animations:^(){
        CGRect currPaintingViewFrame = self.currAlertView.frame;
        currPaintingViewFrame.origin.x = self.currAlertView.frame.size.width * -1.0f;
        [self.currAlertView setFrame:currPaintingViewFrame];
    }];
}

- (void)presentArtworkDetailViewControllerWithArt:(Artwork*)artObject
{
    [[ATUserManager sharedManager] incrementWithFlurryKey:kFlurryNumDetailViewsSeen];
    
    ATArtworkDetailViewController *artworkDetailController = [[ATArtworkDetailViewController alloc] initWithNibName:@"ATArtworkDetailViewController" bundle:nil];
    artworkDetailController.delegate = self;
    artworkDetailController.artObject = artObject;
    
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:artworkDetailController];
    [self presentViewController:navigationController animated:NO completion:nil];
}



- (ATLongPressImageView*)copyPaintingView:(ATLongPressImageView*)view
{
    ATLongPressImageView *imageView = [[ATLongPressImageView alloc] initWithFrame:view.frame];
    [imageView setImage:view.image];
    return imageView;
}


- (void)didChooseBuyNowButton:(NSNotification*)note
{
    [self createHangitMergedImageFromCurrentArtwork];
}

- (void)didChooseShareButton:(NSNotification*)note
{
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.labelText = NSLocalizedString(@"Prepping your artwork to share...",nil);
    //[self createHangitMergedImageFromCurrentArtwork];
    //[hud show:YES];
    //[hud showAnimated:YES whileExecutingBlock:^(void){
        [self createHangitMergedImageForArtObject:[[ATArtManager sharedManager] currentArtObject]];
    //}];
    
    
}

- (void)createHangitMergedImageFromCurrentArtwork
{
    dispatch_queue_t createHangitMergeQueue;
    createHangitMergeQueue = dispatch_queue_create("com.arttwo50.createHangitMergedImage", NULL);
    
    dispatch_async(createHangitMergeQueue, ^{
        //printf("Do some work here.\n");
        [self createHangitMergedImageForArtObject:[[ATArtManager sharedManager] currentArtObject]];
    });
}

- (void)createHangitMergedImageForArtObject:(id)artObject
{
    Artwork *artwork = (Artwork*)artObject;
    UIImage *sharedImage = [self mergedBackgroundImageForArtwork:artwork];
    
    //[[NSNotificationCenter defaultCenter] postNotificationName:kdidSaveMergedImageNotification object:nil];
    if (sharedImage != nil)
    {
        [[ATArtManager sharedManager] saveShareImage:sharedImage forArtObject:artObject];
        [[NSNotificationCenter defaultCenter] postNotificationName:kdidSaveMergedImageNotification object:nil];
    } else {
        [[NSNotificationCenter defaultCenter] postNotificationName:kdidFailSavingMergedImageNotification object:nil];

    }
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];


}

- (UIImage*)mergedBackgroundImageForArtwork:(id)artObject
{
    
    ATLongPressImageView *currPaintingViewCopy = [[ATLongPressImageView alloc] initWithFrame:CGRectZero];
    
    if ([artObject isKindOfClass:[ATInactiveArtworkProxy class]]) {
        ATInactiveArtworkProxy *proxy = (ATInactiveArtworkProxy*)artObject;
        [currPaintingViewCopy updateWithInactiveArtworkProxy:proxy];
    } else {
        Artwork *artwork = (Artwork*)artObject;
        [currPaintingViewCopy updateWithArtObject:artwork withRatio:[[ATArtManager sharedManager] pixelsPerInch] forEventType:ATArtworkEventTypeUnknown];
    }
    
    currPaintingViewCopy.center = CGPointMake(1536.0f, 183.50f);//[self centerOfScreenForPageIndex:1];
    
    //is it this x:1536.00 y:183.50
    
    if (currPaintingViewCopy.image == nil) {
        //NSLog(@"The current image is blank ");
    } else {
        //NSLog(@"It's not blank SO YEAH!");
    }
    
    UIImage *backgroundImage = self.backgroundImageView.image;
    UIImage *paintingImage = currPaintingViewCopy.image;
    
    
    CGRect currPaintingViewCopyFrame = [self.view convertRect:currPaintingViewCopy.frame fromView:self.horizontalScrollView];
    
    
    ATAppDelegate* myDelegate = (((ATAppDelegate*) [UIApplication sharedApplication].delegate));
    UIWindow *window = myDelegate.window;
    
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(1024.0f, 768.0f), YES, window.screen.scale);
    
    [backgroundImage drawInRect:CGRectMake(0.0f, 0.0f, 1024.0f, 768.0f)];
    [paintingImage drawInRect:currPaintingViewCopyFrame];
    
    //    NSLog(@"self.backgroundImageView.bounds.size.width %1.2f height %1.2f", self.backgroundImageView.bounds.size.width, self.backgroundImageView.bounds.size.height);
    //    NSLog(@"window.bounds.size.width %1.2f height %1.2f", window.bounds.size.width, window.bounds.size.height);
    
    
    UIImage* sharedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return sharedImage;
}


- (UIImage*)blurredBackgroundImage
{
    UIImage *backgroundImage = [self mergedBackgroundImageForArtwork:[[ATArtManager sharedManager] currentArtObject]];
    UIColor *tintColor = [UIColor colorWithWhite:1.0 alpha:0.3];
    return [backgroundImage applyBlurWithRadius:7 tintColor:tintColor saturationDeltaFactor:1.8 maskImage:nil];
}

- (void)processImageForPhotoTaken:(UIImage*)image
{
    [self.backgroundImageView setImage:nil];
    [self cacheBackgroundImage:image];
    [[NSOperationQueue mainQueue] addOperationWithBlock:^ {
        if ([self.delegate respondsToSelector:@selector(updateHangitBackgroundImage:)]) {
            [self.delegate performSelector:@selector(updateHangitBackgroundImage:) withObject:[[ATArtManager sharedManager] cachedBackgroundImage]];
        }
    }];
}


-(void)cacheBackgroundImage:(UIImage*)image
{
    UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
    [[ATArtManager sharedManager] cacheBackgroundImage:image];
}

#pragma mark
#pragma mark UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    if ([self.delegate respondsToSelector:@selector(clearBackground)]) {
        [self.delegate performSelector:@selector(clearBackground) withObject:nil];
    }
    
    if ([self.delegate respondsToSelector:@selector(showArtRecommendationHUD)]) {
        [self.delegate performSelector:@selector(showArtRecommendationHUD) withObject:nil];
    }
    
    [self performSelectorInBackground:@selector(processImageForPhotoTaken:) withObject:image];
    [self.imagePicker.view removeFromSuperview];
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    if ([picker.view superview] == self.view) {
        [self.imagePicker.view removeFromSuperview];
        if ([self.delegate respondsToSelector:@selector(showBottomToolBar)]) {
            [self.delegate performSelector:@selector(showBottomToolBar) withObject:nil];
        }
    } else {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}


- (void)didSelectCloseCameraButton:(NSNotification*)note
{
    [[NSNotificationCenter defaultCenter] postNotificationName:kdidChooseCloseCameraButtonNotification object:nil];
    [self refreshAllScrollViewSubviews];
    //NSLog(@"should close camera");
    
}

- (void)didSwapWithArtObject:(NSNotification*)notif
{
    NSDictionary *userDict = [notif userInfo];
    Artwork *artworkAddedToCollection = [userDict objectForKey:@"artObject"];
    //[[ATArtManager sharedManager] replaceCurrentArtworkWithArtwork:artworkAddedToCollection];
    [self safelyRefreshCurrIndex];
    [self refreshAllScrollViewSubviews];
    //[self populateAdditionalArtworkByArtistWithID:artworkAddedToCollection.userID];
}


- (void)noMoreArtworkToday
{
    UIAlertView *noMoreArtworkAlert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"We apologize.",nil) message:NSLocalizedString(@"Try taking a new photo from the menu screen to get fresh recommendations.",nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"Okay",nil) otherButtonTitles: nil];
    [noMoreArtworkAlert show];
}


- (void)initializeArtworkOrderWithIndex:(NSNumber*)index
{
    //Resetting the current index
    self.currIndex = [index integerValue];
    
    [self.backgroundImageView setUserInteractionEnabled:YES];
    [self.horizontalScrollView setScrollEnabled:YES];
    [self.verticalScrollView setScrollEnabled:YES];
    
    [self.view addGestureRecognizer:_pinchRecognizer];
    
    int prevIndex;
    int nextIndex;
    if (self.currIndex == 0) {
        prevIndex = [self maxScrollViewIndex];
    } else {
        prevIndex = self.currIndex - 1;
    }
    
    if (self.currIndex >= [self maxScrollViewIndex]) {
        nextIndex = 0;
    } else {
        nextIndex = self.currIndex + 1;
    }
    
    //[self loadPageWithId:[[[ATArtManager sharedManager] artCarousel] count] onPage:0];
    [self loadPageWithId:prevIndex onPage:0];
    [self loadPageWithId:self.currIndex onPage:1];
    [self loadPageWithId:nextIndex onPage:2];
    
    [self trackVisibleArtObject];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kdidInitializeArtworkNotification object:nil];
    id currentObject = [[ATArtManager sharedManager] currentArtObject];
    if ([currentObject isKindOfClass:[Artwork class]]) {
        Artwork *currentArtwork = (Artwork*)currentObject;
        [self populateAdditionalArtworkByArtistWithID:currentArtwork.userID];
    }
    

}

- (void)removeIntroScreens
{
    if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]) {
        [self addChildViewController:self.imagePicker];
        [self.view addSubview:self.imagePicker.view];
    }
    
    [self removeIntroViewController];
    
}

- (void)didInvokeSampleRoomPhoto:(NSNotification*)note
{
    [self removeIntroViewController];
}

- (void)removeIntroViewController
{
    [UIView animateWithDuration:1.0f animations:^(void) {
        [self.introViewController.view setAlpha:0.0f];
        
    } completion:^(BOOL finished){
        if (finished) {
            [self.introViewController.view removeFromSuperview];
        }
        
    }];
}

- (void)didLoadFinalIntroScreen:(NSNotification*)note
{
    [self performSelector:@selector(removeIntroScreens) withObject:nil afterDelay:0.4];
}

- (void)useSampleRoomImage
{
    [self.cameraOverlayController.view removeFromSuperview];
    [self showCurrentPainting];
    NSDictionary *userInfo =[[NSDictionary alloc] initWithObjectsAndKeys:[self.backgroundImageView.image copy], kBackgroundImageKey, nil];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kdidCompleteChoosingOptionsForSampleRoom object:nil userInfo:userInfo];
    
}

- (void)takePicture
{
    //NSLog(@"Taking that picture see");
    [self.imagePicker takePicture];
    
}

- (void)didPresentArtworkDetailView:(NSNotification*)note
{

}

- (void)didDismissHintsView:(NSNotification*)note
{

}


- (void)didDismissShareScreen:(NSNotification*)note
{
    [self refreshAllScrollViewSubviews];
}

- (void)didDismissCartView:(NSNotification*)note
{
    [self refreshAllScrollViewSubviews];
    
}


- (void)displayPreviewPaintingWithArtObject:(Artwork*)artObject
{
    [self clearHintScreen];
    [self.horizontalScrollView setUserInteractionEnabled:NO];
    [self.verticalScrollView setUserInteractionEnabled:NO];
//    [self.scrollView setScrollEnabled:NO];
    [self.backgroundImageView setUserInteractionEnabled:YES];
    [self displayPreviewCloseButton];
    [self.previewPaintingView updateWithArtObject:artObject withRatio:[[ATArtManager sharedManager] pixelsPerInch] forEventType:ATArtworkEventTypePreview];
    
    self.previewPaintingView.center = [self centerOfScreenForPageIndex:1];
    CGRect previewPaintingViewFrame = self.previewPaintingView.frame;
    previewPaintingViewFrame.origin.y = self.view.frame.size.height;
    [self.previewPaintingView setFrame:previewPaintingViewFrame];
    
    [self animatePreviewPainting];
    
    [self moveCurrPaintingViewLeftOffScreen];
    [self moveCurrAlertViewLeftOffScreen];
}

- (void)displayPreviewCloseButton
{
    
}

- (void)artworkAddedToCollection:(NSNotification*)note
{
    Artwork *artwork = [[note userInfo] objectForKey:@"artObject"];
    [self.currPaintingView updateWithArtObject:artwork withRatio:[[ATArtManager sharedManager] pixelsPerInch] forEventType:ATArtworkEventTypeAddedToCollection];
    [self.middlePaintingView updateWithArtObject:artwork withRatio:[[ATArtManager sharedManager] pixelsPerInch] forEventType:ATArtworkEventTypeAddedToCollection];
}


- (void)dismissDetailView
{
    [self.expandingPaintingView removeFromSuperview];
    
    ATLongPressImageView *viewToCopy;
    if (self.previewModeEnabled) {
        viewToCopy = self.previewPaintingView;
    } else {
        viewToCopy = self.currPaintingView;
    }
    self.expandingPaintingView = [self copyPaintingView:viewToCopy];
    [self.expandingPaintingView setBackgroundColor:[UIColor blackColor]];
    [self.expandingPaintingView setContentMode:UIViewContentModeScaleAspectFit];
    CGRect beforeTempPaintingViewFrame = self.expandingPaintingView.frame;
    beforeTempPaintingViewFrame.origin.x = 0.0f;
    beforeTempPaintingViewFrame.origin.y = 0.0f;
    beforeTempPaintingViewFrame.size.height = self.view.bounds.size.height;
    beforeTempPaintingViewFrame.size.width = self.view.bounds.size.width;
    [self.expandingPaintingView setFrame:beforeTempPaintingViewFrame];
    [self.view addSubview:self.expandingPaintingView];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kdidDismissDetailViewNotification object:nil];
    
    [UIView animateWithDuration:0.5f animations:^(void){
        CGRect afterTempPaintingViewFrame = self.expandingPaintingView.frame;
        
        CGRect convertedCurrPaintingFrame;
        if (self.previewModeEnabled) {
            convertedCurrPaintingFrame = [self.view convertRect:self.previewPaintingView.frame fromView:self.horizontalScrollView];
        } else {
            convertedCurrPaintingFrame = [self.view convertRect:self.currPaintingView.frame fromView:self.horizontalScrollView];
        }
        
        afterTempPaintingViewFrame.origin.x = convertedCurrPaintingFrame.origin.x;
        afterTempPaintingViewFrame.origin.y = convertedCurrPaintingFrame.origin.y;
        
        afterTempPaintingViewFrame.size.height = self.currPaintingView.bounds.size.height;
        afterTempPaintingViewFrame.size.width = self.currPaintingView.bounds.size.width;
        [self.expandingPaintingView setFrame:afterTempPaintingViewFrame];
    } completion:^(BOOL finished){
        [self.expandingPaintingView removeFromSuperview];
        [self refreshAllScrollViewSubviews];
    }];
    
    
}


- (void)willDismissArtworkPreview:(NSNotification*)note
{
    [self.horizontalScrollView setUserInteractionEnabled:YES];
    [self.verticalScrollView setUserInteractionEnabled:YES];
//    [self.scrollView setScrollEnabled:YES];
    self.previewModeEnabled = NO;
    
    [UIView animateWithDuration:SLIDE_ARTWORK_ANIMATION_DURATION animations:^(void){
        CGRect previewPaintingViewFrame = self.previewPaintingView.frame;
        previewPaintingViewFrame.origin.y = self.view.frame.size.height;
        [self.previewPaintingView setFrame:previewPaintingViewFrame];
        [self moveCurrAlertViewBackOnScreen];
        [self moveCurrPaintingViewBackOnScreen];
        [self.previewCloseButton setAlpha:0.0f];
    } completion:^(BOOL finished){
        [self.backgroundImageView setUserInteractionEnabled:NO];
    }];
}

- (void)saveCurrentBackgroundImage
{
    self.savedBackgroundImage = self.backgroundImageView.image;
}

- (void)displayModalCameraOverlayController
{
    [self displayModalCameraOverlayController:YES];
}

- (void)displayModalCameraOverlayController:(BOOL)closeable
{
    [self.cameraOverlayController.view removeFromSuperview];
    self.cameraOverlayController = nil;
    [self hideCurrentPainting];

    self.cameraOverlayController = [[ATCameraOverlayViewController alloc] initWithNibName:@"ATCameraOverlayViewController" bundle:nil];
    [self.cameraOverlayController setDelegate:self];
    if (!closeable) {
        [self.cameraOverlayController setHideCloseButton:YES];
    }
    self.cameraOverlayController.mode = ATCameraModeSizeOnlyWithDistanceMid;
    [self.view addSubview:self.cameraOverlayController.view];
}


- (void)displayModalCameraOverlayControllerWithMode:(ATCameraMode)mode
{
    [self.cameraOverlayController.view removeFromSuperview];
    self.cameraOverlayController = nil;
    [self hideCurrentPainting];
    
    self.cameraOverlayController = [[ATCameraOverlayViewController alloc] initWithNibName:@"ATCameraOverlayViewController" bundle:nil];
    [self.cameraOverlayController setDelegate:self];
    self.cameraOverlayController.mode = mode;
    [self.view addSubview:self.cameraOverlayController.view];
}

- (void)closeButtonSelected
{
    //This is for the Sample room
    [[NSNotificationCenter defaultCenter] postNotificationName:kdidInvokeShowBottomToolBarNotification object:nil];
    [self.cameraOverlayController.view removeFromSuperview];
    [self showCurrentPainting];
    [self.backgroundImageView setImage:self.savedBackgroundImage];
}

- (void)hideCurrentPainting
{
    [UIView animateWithDuration:1.0f animations:^(void){
        [self.currPaintingView setAlpha:0.0f];
        [self.middlePaintingView setAlpha:0.0f];
    } completion:^(BOOL finished){
        
    }];
}

- (void)showCurrentPainting
{
    [UIView animateWithDuration:1.0f animations:^(void){
        [self.currPaintingView setAlpha:1.0f];
        [self.middlePaintingView setAlpha:1.0f];
    } completion:^(BOOL finished){
        
    }];
}

- (void)pinchDetected:(UIPinchGestureRecognizer*)recognizer
{
    if (recognizer.scale > 1) {
        id currentObject = [[ATArtManager sharedManager] currentArtObject];
        if ([currentObject isKindOfClass:[Artwork class]]) {
            [self displayDetailedView];
        }
    }
}


//- (void)tapDetected:(UITapGestureRecognizer*)recognizer
//{
//    id currentObject = [[ATArtManager sharedManager] currentArtObject];
//    if ([currentObject isKindOfClass:[Artwork class]]) {
//        [self displayDetailedView];
//    }
//}

- (void)displayDetailedView
{
    if ((self.currAlertView == nil || self.currAlertView.hidden || self.currAlertView.superview == nil) && [self.defaultCustomButtonAlertView superview] == nil && _animatingExpandedView < 1) {
        _animatingExpandedView += 1;
        Artwork *artwork;
        
        if (self.previewModeEnabled) {
            artwork = self.previewPaintingView.artwork;
        } else {
            artwork = [[[ATArtManager sharedManager] artCarousel] objectAtIndex:self.currIndex];
        }
        if (self.currIndex != [[[ATArtManager sharedManager] artCarousel] count]) {
            [self animateExpandingView:artwork];
        }
    }
}

- (void)detailImageLoaded
{
    [self.expandingPaintingView removeFromSuperview];
}

- (void)animateExpandingView:(Artwork*)artObject
{
    [[NSNotificationCenter defaultCenter] postNotificationName:kdidStartDisplayingDetailViewNotification object:nil];
    
    [self.expandingPaintingView removeFromSuperview];
    ATLongPressImageView *viewToCopy;
    if (self.previewModeEnabled) {
        viewToCopy = self.previewPaintingView;
    } else {
        viewToCopy = self.currPaintingView;
    }
    self.expandingPaintingView = [self copyPaintingView:viewToCopy];
    self.expandingPaintingView.center = [self centerOfScreen];
    
    [self.expandingPaintingView setBackgroundColor:[UIColor blackColor]];
    [self.expandingPaintingView setContentMode:UIViewContentModeScaleAspectFit];
    [self.view addSubview:self.expandingPaintingView];
    
    
    
    [UIView animateWithDuration:0.3f animations:^(void){
        CGRect tempPaintingViewFrame = self.expandingPaintingView.frame;
        tempPaintingViewFrame.origin.x = 0.0f;
        tempPaintingViewFrame.origin.y = 0.0f;
        tempPaintingViewFrame.size.height = self.view.bounds.size.height;
        tempPaintingViewFrame.size.width = self.view.bounds.size.width;
        [self.expandingPaintingView setFrame:tempPaintingViewFrame];
    } completion:^(BOOL finished){
        [self presentArtworkDetailViewControllerWithArt:artObject];
        //[self.expandingPaintingView removeFromSuperview];
        _animatingExpandedView = 0;
    }];

}


- (void)didIncrementArtCounter:(NSNotification*)note
{
    if ([[ATArtManager sharedManager] firstTimeUser]) {
        
    }
}

- (void)didUpdateCarousel:(NSNotification*)note
{
    NSDictionary *noteDict = [note userInfo];
    
    [[NSUserDefaults standardUserDefaults] setObject:[[ATArtManager sharedManager] collectionTitle] forKey:@"collectionTitle"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    if ([noteDict objectForKey:@"firstIndex"]) {
        self.updatingArtistCarousel = NO;
        NSNumber *artworkToBeShownFirstIndex = [noteDict objectForKey:@"firstIndex"];
        [self initializeArtworkOrderWithIndex:artworkToBeShownFirstIndex];
        [self refreshAllScrollViewSubviews];
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
//        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//        hud.mode = MBProgressHUDModeText;
//        hud.labelText = [NSString stringWithFormat:@"Your %@ are loaded.", [[[ATArtManager sharedManager] collectionTitle] lowercaseString]];
//        [hud hide:YES afterDelay:2.0f];
        
        
        
    } else if ([noteDict objectForKey:@"updateCurrentIndexWithOffset"]) {
        NSNumber *offset = [noteDict objectForKey:@"updateCurrentIndexWithOffset"];
        self.updatingArtistCarousel = NO;
        self.currIndex = self.currIndex + [offset intValue];
        [self refreshAllScrollViewSubviews];
    } else {
        self.updatingArtistCarousel = NO;
        [self refreshAllScrollViewSubviews];
    }
    
    
   
}


- (void)didAddCurrentArtworkToCart:(NSNotification*)note
{
    __block ATLongPressImageView *copyOfCurrentArtworkView = [self copyPaintingView:self.currPaintingView];
    copyOfCurrentArtworkView.center = [self centerOfScreen];
  
    [self.view addSubview:copyOfCurrentArtworkView];
    
    [UIView animateWithDuration:0.7f delay:0.0f options:UIViewAnimationOptionCurveEaseInOut animations:^(void){
        CGRect copyOfCurrentArtworkFrame = copyOfCurrentArtworkView.frame;
        copyOfCurrentArtworkFrame.origin = CGPointMake(879.0f, 768.0f - 40.0f);
        copyOfCurrentArtworkFrame.size = CGSizeMake(0.0f, 0.0f);
        
        [copyOfCurrentArtworkView setFrame:copyOfCurrentArtworkFrame];
        
    } completion:^(BOOL finished){
        [copyOfCurrentArtworkView removeFromSuperview];
        copyOfCurrentArtworkView = nil;
        [self.currPaintingView updateArtworkStatus];
        [[NSNotificationCenter defaultCenter] postNotificationName:kdidCompleteAddToCartAnimationNotification object:nil];
    }];
}

- (void)clearHintScreen
{
    if ([self.hintView superview] != nil) {

        [UIView animateWithDuration:1.0f animations:^(void){
            [self lightenHangitView];
            [self.hintView setAlpha:0.0f];
        } completion:^(BOOL finished){
            if (finished) {
                [self.hintView removeFromSuperview];
            }
        }];
    }
}


- (void)displayNextPaintingWithDeletion:(BOOL)deletion
{
    [self.horizontalScrollView scrollRectToVisible:CGRectMake(self.view.frame.size.width*2, 0, self.view.frame.size.width, self.view.frame.size.height) animated:YES];
    [self performSelector:@selector(loadPages) withObject:nil afterDelay:0.2f];

}

- (void)loadPages
{
    self.currIndex = [self safelyRefreshCurrIndex];
    [self loadPageWithId:self.currIndex onPage:1];
    _nextIndex = [self safelyIncrementCurrIndex];
    [self loadPageWithId:_nextIndex onPage:2];
    int tempIndex = [self safelyDecrementCurrIndex];
    [self loadPageWithId:tempIndex onPage:0];
    [self.horizontalScrollView scrollRectToVisible:CGRectMake(self.view.frame.size.width, 0, self.view.frame.size.width, self.view.frame.size.height) animated:NO];

}

- (void)hideCarousel
{
    [self.currAlertView setHidden:YES];
    [self.currPaintingView setHidden:YES];
}

- (void)showCarousel
{
    [self.currAlertView setHidden:NO];
    [self.currPaintingView setHidden:NO];
}

- (void)hideVerticalCarousel
{
    [self.middlePaintingView setHidden:YES];
    [self.middlePaintingView setHidden:YES];
}

- (void)showVerticalCarousel
{
    [self.middlePaintingView setHidden:NO];
    [self.middlePaintingView setHidden:NO];
}

#pragma mark
#pragma mark UIScrollViewDelegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if (self.previewModeEnabled) {
        [self togglePreviewMode];
    }
    
    if ([self.delegate respondsToSelector:@selector(hideMenuDock)]) {
        [self.delegate performSelectorOnMainThread:@selector(hideMenuDock) withObject:nil waitUntilDone:NO];
    }
    if (scrollView == self.verticalScrollView) {
        [self hideCarousel];
        [self showVerticalCarousel];
    } else {
        
    }
}


- (void)scrollViewDidEndDecelerating:(UIScrollView *)sender {
	// All data for the documents are stored in an array (documentTitles).
	// We keep track of the index that we are scrolling to so that we
	// know what data to load for each page.

    if (sender == self.verticalScrollView) {
        [self showCarousel];
        [self hideVerticalCarousel];
        BOOL didScrollVertically = YES;
        if(self.verticalScrollView.contentOffset.y > self.verticalScrollView.frame.size.height) {
            //[self shuffleViewsForward];
            
            [[ATUserManager sharedManager] incrementWithFlurryKey:kFlurryNumDownSwipes];
            
            self.verticalCurrIndex = [self safelyDecrementVerticalCurrIndex];
        }else if(self.verticalScrollView.contentOffset.y == 0) {
            //[self shuffleViewsBackward];
            
            [[ATUserManager sharedManager] incrementWithFlurryKey:kFlurryNumUpSwipes];
            
            self.verticalCurrIndex = [self safelyIncrementVerticalCurrIndex];
        }else {
            didScrollVertically = NO;
        }
        if (didScrollVertically) {
            [self updateVerticalScrollView];
        }

        
    } else {
        self.verticalCurrIndex = 0;
        self.verticalUpIndex = [self safelyIncrementVerticalCurrIndex];
        self.verticalDownIndex = [self safelyDecrementVerticalCurrIndex];
        
        if(self.horizontalScrollView.contentOffset.x > (self.horizontalScrollView.frame.size.width )) {
            
            [[ATUserManager sharedManager] incrementWithFlurryKey:kFlurryNumForwardSwipes];
            
            [self shuffleViewsForward];
            
            [self didMoveCarouselForward];
        }
        if(self.horizontalScrollView.contentOffset.x < self.horizontalScrollView.frame.size.width) {
            
            [[ATUserManager sharedManager] incrementWithFlurryKey:kFlurryNumBackwardSwipes];
            
            [self shuffleViewsBackward];
            [self didMoveCarouselBackward];
        }
        // Reset offset back to middle page
        [self resetScrollView];
        //Update the vertical scroll with other art from the current artwork's artist
        id currentObject = [[ATArtManager sharedManager] currentArtObject];
        
        if ([currentObject isKindOfClass:[Artwork class]]) {
            Artwork *currentArtwork = (Artwork*)currentObject;
            [self populateAdditionalArtworkByArtistWithID:currentArtwork.artist.userID];
        }
    }

}

- (void)didMoveCarouselForward
{
    //NSLog(@"Moved carousel forward");
    if ([[ATArtManager sharedManager] collectionType] == ATCollectionTypeArtists) {
        int distanceFromEndOfCarousel = [[[ATArtManager sharedManager] artCarousel] count] - self.currIndex;
        

//        NSLog(@"distanceFromEndOfCarousel is %d", distanceFromEndOfCarousel);
//        
//        NSLog(@"self.currIndex is %d", self.currIndex);
//        
//        NSLog(@"[[[ATArtManager sharedManager] artCarousel] count] %d", [[[ATArtManager sharedManager] artCarousel] count]);
//        
//        if (self.updatingArtistCarousel) {
//            NSLog(@"is updating artist carousel");
//        } else {
//            NSLog(@"is NOT updating artist carousel");
//        }
//        
//        NSLog(@"[[[ATArtManager sharedManager] artistDirectoryObjectIDs] count] %d", [[[ATArtManager sharedManager] artistDirectoryObjectIDs] count]);
//        
        if (distanceFromEndOfCarousel <= LOAD_MORE_ARTISTS_THRESHOLD && !self.updatingArtistCarousel && [[[ATArtManager sharedManager] artistDirectoryObjectIDs] count] > [[[ATArtManager sharedManager] artCarousel] count]) {
            //Then there are still more artists to load - though not sure if they are from the beginning or end
            SearchableArtistProfile *lastProfile;
            id lastArtworkObject = [[[ATArtManager sharedManager] artCarousel] lastObject];
            if ([lastArtworkObject isKindOfClass:[Artwork class]]) {
                Artwork *lastArtwork = (Artwork*)lastArtworkObject;
                lastProfile = (SearchableArtistProfile*)lastArtwork.searchableProfile;
                
            } else {
                ATInactiveArtworkProxy *proxy = (ATInactiveArtworkProxy*)lastArtworkObject;
                lastProfile = proxy.artistProfile;
            }
            
            
            NSManagedObjectID *nextProfileObjectID = [[ATArtManager sharedManager] nextProfileObjectIDFrom:lastProfile];
            
            if (nextProfileObjectID != nil) {
                int numLastArtistLoaded = [[[ATArtManager sharedManager] artistDirectoryObjectIDs] indexOfObject:nextProfileObjectID];
                if (numLastArtistLoaded < [[[ATArtManager sharedManager] artistDirectoryObjectIDs] count]) {
                    self.updatingArtistCarousel = YES;
                    
                    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                        //printf("Do some work here.\n");
                        [[ATArtManager sharedManager] loadAdditionalArtistsFromObjectID:nextProfileObjectID forward:30 backward:0];
                    });
                }
            }
        }
    }
}

- (void)didMoveCarouselBackward
{
    if ([[ATArtManager sharedManager] collectionType] == ATCollectionTypeArtists) {
//        NSLog(@"Moved carousel backward");
//        
//        NSLog(@"self.currIndex %d", self.currIndex);
//        
//        if (self.updatingArtistCarousel) {
//            NSLog(@"still updating the artist carousel");
//        } else {
//            NSLog(@"NOT updating the artist carousel");
//        }
//        
//        NSLog(@"artCarousel is %d", [[[ATArtManager sharedManager] artCarousel] count]);
//        
//        NSLog(@"artistDirectory is %d", [[[ATArtManager sharedManager] artistDirectoryObjectIDs] count]);
//        
//        
        if (self.currIndex <= LOAD_MORE_ARTISTS_THRESHOLD && !self.updatingArtistCarousel && [[[ATArtManager sharedManager] artistDirectoryObjectIDs] count] > [[[ATArtManager sharedManager] artCarousel] count]) {
            
            //Then there are still more artists to load - though not sure if they are from the beginning or end
            SearchableArtistProfile *firstProfile;
            id firstArtworkObject = [[[ATArtManager sharedManager] artCarousel] firstObject];
            if ([firstArtworkObject isKindOfClass:[Artwork class]]) {
                Artwork *firstArtwork = (Artwork*)firstArtworkObject;
                firstProfile = (SearchableArtistProfile*)firstArtwork.searchableProfile;
            } else {
                ATInactiveArtworkProxy *proxy = (ATInactiveArtworkProxy*)firstArtworkObject;
                firstProfile = proxy.artistProfile;
            }
            NSManagedObjectID *prevProfileObjectID = [[ATArtManager sharedManager] previousProfileObjectIDFrom:firstProfile];
            
            if (prevProfileObjectID != nil) {
                NSLog(@"This last artists is at index %d",[[[ATArtManager sharedManager] artistDirectoryObjectIDs] indexOfObject:prevProfileObjectID]);
                int indexOfFirstArtistLoaded = [[[ATArtManager sharedManager] artistDirectoryObjectIDs] indexOfObject:prevProfileObjectID];
                if (indexOfFirstArtistLoaded > 0) {
                    self.updatingArtistCarousel = YES;
                    [[ATArtManager sharedManager] loadAdditionalArtistsFromObjectID:prevProfileObjectID forward:0 backward:MIN(30, indexOfFirstArtistLoaded)];
                }
            }
        }
    }
    
}

- (void)updateVerticalScrollView
{

    id additionalArtwork = [self.additionalArtwork objectAtIndex:self.verticalCurrIndex];

    //Replace the current artwork with the new one from the additional artwork array
    [[ATArtManager sharedManager] replaceCurrentArtworkWithArtwork:additionalArtwork];
    [self.middlePaintingView updateWithArtObject:additionalArtwork withRatio:[[ATArtManager sharedManager] pixelsPerInch] forEventType:ATArtworkEventTypeUnknown];
    self.middlePaintingView.center = [self centerOfScreenForVerticalScrollWithPageIndex:1];
    
    
    Artwork *artwork2 = [self.additionalArtwork objectAtIndex:[self safelyDecrementVerticalCurrIndex]];
    [self.downPaintingView updateWithArtObject:artwork2 withRatio:[[ATArtManager sharedManager] pixelsPerInch] forEventType:ATArtworkEventTypeUnknown];
    
    self.downPaintingView.center = [self centerOfScreenForVerticalScrollWithPageIndex:2];
    
    
    Artwork *artwork = [self.additionalArtwork objectAtIndex:[self safelyIncrementVerticalCurrIndex]];
    [self.upPaintingView updateWithArtObject:artwork withRatio:[[ATArtManager sharedManager] pixelsPerInch] forEventType:ATArtworkEventTypeUnknown];
    
    self.upPaintingView.center = [self centerOfScreenForVerticalScrollWithPageIndex:0];
    
    //Move verticalScrollView to fake infinity
    [self.verticalScrollView scrollRectToVisible:CGRectMake(0, self.view.frame.size.height,self.view.frame.size.width,self.view.frame.size.height) animated:NO];
    
    [self refreshAllScrollViewSubviews];
}

- (void)populateAdditionalArtworkByArtistWithID:(NSNumber *)artistID
{
    [[ATArtManager sharedManager] additionalArtworkByArtistWithID:artistID completionBlock:^(NSArray *artworks, NSError *error){
        if (error) {
            NSLog(@"OOOOPPPSS! %@", [error localizedDescription]);
        } else {
            NSMutableArray *tempArtworkArray = [[NSMutableArray alloc] init];
            for (Artwork *artwork in artworks) {

                if ([[[ATArtManager sharedManager] currentArtObject] isEqual:artwork]) {
                    [tempArtworkArray insertObject:artwork atIndex:0];
                } else {
                    if ([artwork isKindOfClass:[ATInactiveArtworkProxy class]]) {
                        [tempArtworkArray addObject:[[ATInactiveArtworkProxy alloc] init]];
                    } else {
                        [tempArtworkArray addObject:artwork];
                    }
                }
            }
            self.additionalArtwork = tempArtworkArray;
//            NSLog(@"Found %d pieces of additional art", self.additionalArtwork.count);
            [self setupAdditionalArtwork];
            
        }
    }];
    
    
}

- (void)setupAdditionalArtwork
{
    Artwork *artwork = [self.additionalArtwork objectAtIndex:0];
    [self.middlePaintingView updateWithArtObject:artwork withRatio:[[ATArtManager sharedManager] pixelsPerInch] forEventType:ATArtworkEventTypeUnknown];
    self.middlePaintingView.center = [self centerOfScreenForVerticalScrollWithPageIndex:1];
    self.verticalCurrIndex = 0;
    if ([self.additionalArtwork count] > 1) {
        self.verticalUpIndex = [self safelyIncrementVerticalCurrIndex];
        self.verticalDownIndex = [self safelyDecrementVerticalCurrIndex];
       
    } else {
        self.verticalUpIndex = 0;
        self.verticalDownIndex = 0;
    }
    
    Artwork *artworkUp = [self.additionalArtwork objectAtIndex:self.verticalUpIndex];
    [self.upPaintingView updateWithArtObject:artworkUp withRatio:[[ATArtManager sharedManager] pixelsPerInch] forEventType:ATArtworkEventTypeUnknown];
    self.upPaintingView.center = [self centerOfScreenForVerticalScrollWithPageIndex:0];
    
    Artwork *artworkDown = [self.additionalArtwork objectAtIndex:self.verticalDownIndex];
    [self.downPaintingView updateWithArtObject:artworkDown withRatio:[[ATArtManager sharedManager] pixelsPerInch] forEventType:ATArtworkEventTypeUnknown];
    self.downPaintingView.center = [self centerOfScreenForVerticalScrollWithPageIndex:2];
}

- (void)didCompleteLoadingAdditionalArtwork
{
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    
    [self refreshAllScrollViewSubviews];
}

#pragma mark
#pragma mark ATCustomButtonAlertViewDelegate

- (void)customButtonAlertView:(ATCustomButtonAlertView*)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (alertView.tag) {
        case ATCustomButtonAlertViewTypeCollectionFull:
            [self handleFullCollectionAlertViewForButtonIndex:buttonIndex];
            break;
        case ATCustomButtonAlertViewTypeCompletedPurchase:
            [self handleCompletedPurchaseForButtonIndex:buttonIndex];
            break;
        case ATCustomButtonAlertViewTypeNoMoreRecommendations:
            [self handleNoMoreRecommendationsForButtonIndex:buttonIndex];
            break;
        case ATCustomButtonAlertViewTypeWelcomeBack:
            [self handleWelcomeBackForButtonIndex:buttonIndex];
            break;
        case ATCustomButtonAlertViewTypeEndOfArtists:
            [self handleEndOfArtistsForButtonIndex:buttonIndex];
            break;
    }
}

- (void)handleEndOfArtistsForButtonIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:
            [[NSNotificationCenter defaultCenter] postNotificationName:kdidInvokeFeedbackScreenNotification object:nil];
            self.displayingButtonAlert = NO;
            [self hideCustomButtonAlertView];
            break;
        default:
            [self.defaultCustomButtonAlertView removeFromSuperview];
            self.defaultCustomButtonAlertView = nil;
            [self refreshAllScrollViewSubviews];
            self.displayingButtonAlert = NO;
            break;
    }
}

- (void)handleAskAdviceForButtonIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:
            [[NSNotificationCenter defaultCenter] postNotificationName:kdidInvokeFeedbackScreenNotification object:nil];
            self.displayingButtonAlert = NO;
            [self hideCustomButtonAlertView];
            break;
        case 1:
            [self hideCustomButtonAlertView];
            break;
        default:
            [self.defaultCustomButtonAlertView removeFromSuperview];
            self.defaultCustomButtonAlertView = nil;
            [self refreshAllScrollViewSubviews];
            self.displayingButtonAlert = NO;
            break;
    }
}

- (void)handleNoMoreRecommendationsForButtonIndex:(NSInteger)buttonIndex
{
    
    switch (buttonIndex) {
        case 0:
            [[ATTrackingManager sharedManager] trackEvent:FL_ATTEMPTED_TO_BUY_ART];
            self.displayingButtonAlert = NO;
            [self.horizontalScrollView setScrollEnabled:YES];
            [self.verticalScrollView setScrollEnabled:YES];
            [[NSNotificationCenter defaultCenter] postNotificationName:kdidInvokePurchaseScreenNotification object:nil];
            [self hideCustomButtonAlertView];
            break;
        case 1:
            [[ATTrackingManager sharedManager] trackEvent:FL_VIEW_FAVORITES];
            [self loadFavorites];
            break;
        default:
            [[ATTrackingManager sharedManager] trackEvent:FL_REVIEWED_RECOMMENDATIONS];
            [self loadRecommendations];
            break;
    }
    

}

- (void)loadArtworkForArtistProfile:(NSNotification*)note
{
    if ([self.delegate respondsToSelector:@selector(hideBottomToolBar)]) {
        [self.delegate performSelector:@selector(hideBottomToolBar) withObject:nil];
    }
    if ([self.delegate respondsToSelector:@selector(hideMenuDock)]) {
        [self.delegate performSelector:@selector(hideMenuDock) withObject:nil];
    }
    
    NSDictionary *userInfo = [note userInfo];
    NSManagedObjectID *objectID = [userInfo objectForKey:@"objectID"];
    NSString *artistProfileName;
    
    NSManagedObjectContext *ctx = [[RKObjectManager sharedManager] managedObjectStore].mainQueueManagedObjectContext;
    
    SearchableArtistProfile *artistProfile = (SearchableArtistProfile*)[ctx objectWithID:objectID];
    artistProfileName = [NSString stringWithFormat:@"%@ %@", artistProfile.firstName, artistProfile.lastName];
    
    
    [self.currPaintingView setHidden:YES];
    [self.middlePaintingView setHidden:YES];
    [self.horizontalScrollView setUserInteractionEnabled:NO];
    [self.verticalScrollView setUserInteractionEnabled:NO];
    [self.view removeGestureRecognizer:_pinchRecognizer];
    [self.backgroundImageView setUserInteractionEnabled:NO];
    
    
    
    [[ATArtManager sharedManager] showArtRecommendationHUDForView:self.view withText:[NSString stringWithFormat:@"Loading artwork from %@", artistProfileName]];
    
    
    [[ATArtManager sharedManager] loadArtworkForArtistProfilewithObjectID:objectID];
    
}

- (void)loadFavorites
{
    [[ATArtManager sharedManager] loadFavorites];
}

- (void)loadRecommendations
{
    [[ATArtManager sharedManager] loadRecommendations];
}

- (void)handleWelcomeBackForButtonIndex:(NSInteger)buttonIndex
{
    [self.currAlertView removeFromSuperview];
    self.currAlertView = nil;
    
    [self.horizontalScrollView setScrollEnabled:YES];
    switch (buttonIndex) {
        //Get suggested artwork
        case 0:
            [[NSNotificationCenter defaultCenter] postNotificationName:kRetrieveSuggestedArtworkForSavedImgNotification object:nil];
            break;
        //Take a new photo
        case 1:
            [[NSNotificationCenter defaultCenter] postNotificationName:kdidInvokeTakePhotoNotification object:nil];
            break;
        default:
            self.currIndex = [self safelyIncrementCurrIndex];
            [self displayNextPainting];
            break;
    }
    
    [self hideCustomButtonAlertView];
}

- (void)handleCompletedPurchaseForButtonIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:
            [self displayPurchasedArtworkShareScreen];
            break;
        case 1:
            [[NSNotificationCenter defaultCenter] postNotificationName:kdidInvokeTakePhotoNotification object:nil];
            [self removeCompletedPurchaseScreen];
            break;
        default:
            [self removeCompletedPurchaseScreen];
            break;
    }
}

- (void)removeCompletedPurchaseScreen
{
    [[NSNotificationCenter defaultCenter] postNotificationName:kdidInvokeDeletingSharedImgForCartNotification object:nil];
    [[ATArtManager sharedManager] emptyPurchasedArtwork];
    [self showVisiblePaintingOrPrompt];
    [self.backgroundImageView setUserInteractionEnabled:YES];
    [self.horizontalScrollView setScrollEnabled:YES];
    [self.verticalScrollView setScrollEnabled:YES];
    
    [self.defaultCustomButtonAlertView removeFromSuperview];
    self.defaultCustomButtonAlertView = nil;
}

- (void)displayPurchasedArtworkShareScreen
{
    ATShareCelebrationViewController *celebrationController = [[ATShareCelebrationViewController alloc] initWithNibName:@"ATShareCelebrationViewController" bundle:nil];
    
    celebrationController.displayCollection = NO;
    [celebrationController setArtworkArray:[[ATArtManager sharedManager] purchasedArtwork]];
    
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:celebrationController];
    [self presentViewController:navController animated:YES completion:^(void){
//        NSLog(@"presented celebration");
    }];
}

- (void)handleFullCollectionAlertViewForButtonIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:
            [[NSNotificationCenter defaultCenter] postNotificationName:kdidInvokePurchaseScreenNotification object:nil];
            break;
        case 1:
            [[NSNotificationCenter defaultCenter] postNotificationName:kdidInvokeFeedbackScreenNotification object:nil];
            break;
        default:
            break;
    }
    //[self enableCollection]; Do later
    [self hideFullCollectionAlertView];
}

- (void)enableCollection
{
    
}

- (void)disableCollection
{
    
}

- (void)didDisplayPurchaseScreen
{
    [self hideFullCollectionAlertView];
}

- (void)hideFullCollectionAlertView
{
    [self hideCustomButtonAlertView];
    [[NSNotificationCenter defaultCenter] postNotificationName:kdidDismissFullCollectionAlertNotification object:nil];
}

- (void)hideCustomButtonAlertView
{
    [UIView animateWithDuration:1.0f animations:^(void){
        [self.defaultCustomButtonAlertView setAlpha:0.0f];
    } completion:^(BOOL finished){
        [self showVisiblePaintingOrPrompt];
        [self.backgroundImageView setUserInteractionEnabled:YES];
        [self.horizontalScrollView setScrollEnabled:YES];
        [self.verticalScrollView setScrollEnabled:YES];
        [self.defaultCustomButtonAlertView removeFromSuperview];
        self.defaultCustomButtonAlertView = nil;
    }];
}



- (void)hideVisiblePaintingOrPrompt
{
    [UIView animateWithDuration:0.5f animations:^(void){
        [self.currAlertView setAlpha:0.0f];
        [self.currPaintingView setAlpha:0.0f];
        [self.middlePaintingView setAlpha:0.0f];
    }];
}

- (void)showVisiblePaintingOrPrompt
{
    [UIView animateWithDuration:0.5f animations:^(void){
        [self.currAlertView setAlpha:1.0f];
        [self.currPaintingView setAlpha:1.0f];
        [self.middlePaintingView setAlpha:1.0f];
    }];
}

- (void)didCompletePurchase
{
    //Also remove all other 
    Artwork *artwork = [[ATArtManager sharedManager] currentArtObject];
    [self.currPaintingView updateWithArtObject:artwork withRatio:[[ATArtManager sharedManager] pixelsPerInch] forEventType:ATArtworkEventTypeAddedToCollection];
    
    [self.backgroundImageView setUserInteractionEnabled:NO];
    [self.horizontalScrollView setScrollEnabled:NO];
    [self.verticalScrollView setScrollEnabled:NO];
    
       
    if (self.defaultCustomButtonAlertView == nil) {
        self.defaultCustomButtonAlertView = [[ATCustomButtonAlertView alloc] initWithFrame:CGRectZero];
        [self.defaultCustomButtonAlertView setDelegate:self];
    }
    
    CGRect alertViewFrame = self.defaultCustomButtonAlertView.frame;
    alertViewFrame.size.width = 417.0f;
    alertViewFrame.size.height = 420.0f;
    alertViewFrame.origin.y = 40.0f;
    alertViewFrame.origin.x = self.view.frame.size.width/2 - alertViewFrame.size.width/2;
    self.defaultCustomButtonAlertView.topLabelText = NSLocalizedString(@"Your wall is going to look great!",nil);
    self.defaultCustomButtonAlertView.bottomLabelText = NSLocalizedString(@"Please check your email for order confirmation and shipping updates\n\n Next, would you like to:",nil);
    self.defaultCustomButtonAlertView.bottomLabelHeight = 85.0f;

    self.defaultCustomButtonAlertView.buttonTitles = [NSArray arrayWithObjects:NSLocalizedString(@"CELEBRATE_AND_SHARE", nil), NSLocalizedString(@"Take photo of a new wall",nil), NSLocalizedString(@"No thanks, I'm done for now",nil), nil];
    [self.defaultCustomButtonAlertView setTag:ATCustomButtonAlertViewTypeCompletedPurchase];
    [self.defaultCustomButtonAlertView setFrame:alertViewFrame];
    
    
    [self.defaultCustomButtonAlertView setAlpha:0.0f];
    [self.defaultCustomButtonAlertView setNeedsDisplay];
    [self.view addSubview:self.defaultCustomButtonAlertView];
    
    [UIView animateWithDuration:1.0f animations:^(void){
       [self.defaultCustomButtonAlertView setAlpha:1.0f];
    } completion:^(BOOL finished){
        [self hideVisiblePaintingOrPrompt];
    }];
    
    
}

- (void)didFillCollection
{
    [self.backgroundImageView setUserInteractionEnabled:NO];
    [self.horizontalScrollView setScrollEnabled:NO];
    [self.verticalScrollView setScrollEnabled:NO];
    
    
    //[self disableCollection]; Do later
    
    if (self.defaultCustomButtonAlertView == nil) {
        self.defaultCustomButtonAlertView = [[ATCustomButtonAlertView alloc] initWithFrame:CGRectZero];
        [self.defaultCustomButtonAlertView setDelegate:self];
    }
    
    CGRect alertViewFrame = self.defaultCustomButtonAlertView.frame;
    alertViewFrame.size.width = 417.0f;
    alertViewFrame.size.height = 365.0f;
    alertViewFrame.origin.y = 40.0f;
    alertViewFrame.origin.x = self.view.frame.size.width/2 - alertViewFrame.size.width/2;
    self.defaultCustomButtonAlertView.topLabelText = NSLocalizedString(@"Your collection is now full.",nil);
    self.defaultCustomButtonAlertView.bottomLabelText = NSLocalizedString(@"Would you like to:",nil);
    self.defaultCustomButtonAlertView.buttonTitles = [NSArray arrayWithObjects:NSLocalizedString(@"Go to Cart",nil), NSLocalizedString(@"Get feedback from friends",nil), NSLocalizedString(@"Keep browsing",nil), nil];
    [self.defaultCustomButtonAlertView setTag:ATCustomButtonAlertViewTypeCollectionFull];
    [self.defaultCustomButtonAlertView setFrame:alertViewFrame];
   
    
    [self.defaultCustomButtonAlertView setNeedsDisplay];
    [self.defaultCustomButtonAlertView setAlpha:0.0f];
    [self.view addSubview:self.defaultCustomButtonAlertView];
    
    
    [UIView animateWithDuration:1.0f animations:^(void){
        [self.defaultCustomButtonAlertView setAlpha:1.0f];
    } completion:^(BOOL finished){
        [self hideVisiblePaintingOrPrompt];
    }];
}

- (BOOL)welcomeBackScreenDisplayed
{
    return (self.currAlertView.tag == ATCustomButtonAlertViewTypeWelcomeBack) && [self.currAlertView superview];
}

#pragma mark
#pragma mark - UINotification actions

- (void)didChooseNewPhotoOption:(NSNotification*)note
{
    [self clearScreen];
}

- (void)didTakeNewPhotoOption:(NSNotification*)note
{
    [self clearScreen];
}

- (void)clearScreen
{
    [[ATUserManager sharedManager] incrementWithFlurryKey:kFlurryNumWallChanges];
    //[self hideCurrentPainting];
    [self.defaultCustomButtonAlertView removeFromSuperview];
    self.defaultCustomButtonAlertView = nil;
    [self.currAlertView removeFromSuperview];
    self.currAlertView = nil;
    [self.horizontalScrollView setScrollEnabled:YES];
    [self.verticalScrollView setScrollEnabled:YES];
}

#pragma mark
#pragma mark MFMailComposeSheetViewDelegate

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{
    switch (result)
    {
        case MFMailComposeResultCancelled:
            [[ATTrackingManager sharedManager] trackEvent:FL_ASK_LIZZY_CANCELLED];
            //NSLog(@"Mail cancelled: you cancelled the operation and no email message was queued.");
            break;
        case MFMailComposeResultSaved:
            //NSLog(@"Mail saved: you saved the email message in the drafts folder.");
            break;
        case MFMailComposeResultSent:
            [[ATTrackingManager sharedManager] trackEvent:FL_ASK_LIZZY_SENT];
            [self showAdviceEmailSentMessage];
            //NSLog(@"Mail send: the email message is queued in the outbox. It is ready to send.");
            break;
        case MFMailComposeResultFailed:
            //NSLog(@"Mail failed: the email message was not saved or queued, possibly due to an error.");
            break;
        default:
            //NSLog(@"Mail not sent.");
            break;
    }
    [self refreshAllScrollViewSubviews];
    // Remove the mail view
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)showAdviceEmailSentMessage
{
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.labelText = @"Email sent. Thank you.";
    [hud hide:YES afterDelay:3.0f];
}

@end
