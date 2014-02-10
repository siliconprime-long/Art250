//
//  ATHangitViewController.h
//  art250
//
//  Created by Winfred Raguini on 9/10/12.
//  Copyright (c) 2012 Art250. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ATCustomButtonAlertView.h"
#import "ATCameraOverlayViewController.h"
#import "ATScrollView.h"
#import "ATTouchView.h"
#import <MessageUI/MessageUI.h>

@class ATCameraOverlayViewController;
@class ATImagePickerViewController;
@class ATHintScreenView;
@class Artwork;
@interface ATHangitContainerViewController : UIViewController <MFMailComposeViewControllerDelegate, UIGestureRecognizerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIScrollViewDelegate, ATCustomButtonAlertViewDelegate>
{

}
@property (nonatomic, strong, readwrite) UIImage *hangitImage;
@property (nonatomic, strong, readwrite) IBOutlet UIImageView *backgroundImageView;
@property (nonatomic, weak, readwrite) id delegate;
@property (nonatomic, strong) UIImage *savedBackgroundImage;
@property (nonatomic, strong, readwrite) ATImagePickerViewController *imagePicker;
@property (nonatomic, strong) ATCameraOverlayViewController *cameraOverlayController;
@property (nonatomic, strong) ATHintScreenView *hintView;
@property (nonatomic, readwrite) UIButton *previewCloseButton;

@property (nonatomic, strong) IBOutlet ATScrollView *horizontalScrollView;
@property (nonatomic, strong) IBOutlet ATScrollView *verticalScrollView;

@property (nonatomic, strong) IBOutlet ATTouchView *touchView;

@property (nonatomic, strong, readwrite) IBOutlet UIButton *rightArrowButton;
@property (nonatomic, strong, readwrite) IBOutlet UIButton *leftArrowButton;


@property (nonatomic, assign, readonly) int prevIndex;
@property (nonatomic, assign, readonly) int currIndex;
@property (nonatomic, assign, readonly) int nextIndex;

@property (nonatomic, assign, readonly) BOOL displayingButtonAlert;

- (UIImage*)blurredBackgroundImage;
- (void)displayPreviewPaintingWithArtObject:(Artwork*)artObject;
- (void)darkenHangitView;
- (void)lightenHangitView;
- (void)displayBackgroundImageColorArray;
- (void)createHangitMergedImageFromCurrentArtwork;
- (void)createHangitMergedImageForArtObject:(Artwork*)artObject;
- (void)setDraggableImage:(UIImage*)image;
- (void)displayCurrentArtwork;
- (void)displayNextPainting;
- (void)noMoreArtworkToday;
- (void)initializeArtworkOrderWithIndex:(NSNumber*)index;
- (void)displayModalCameraOverlayController;
- (void)displayModalCameraOverlayController:(BOOL)closeable;
- (void)displayModalCameraOverlayControllerWithMode:(ATCameraMode)mode;
- (IBAction)nextPaintingButtonSelected:(id)sender;
- (IBAction)previousPaintingButtonSelected:(id)sender;
- (void)refreshAllScrollViewSubviews;
- (void)saveCurrentBackgroundImage;
- (BOOL)welcomeBackScreenDisplayed;
- (void)shuffleViewsForward;
- (void)setupAdditionalArtwork;
- (void)populateAdditionalArtworkByArtistWithID:(NSNumber*)artistID;
- (void)showSlideOutView;
- (void)hidePaintings;
- (void)displayDetailedView;
@end
