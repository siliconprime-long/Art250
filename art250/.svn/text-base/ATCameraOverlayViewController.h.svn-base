//
//  ATCameraOverlayViewController.h
//  art250
//
//  Created by Winfred Raguini on 3/30/13.
//  Copyright (c) 2013 Art250. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    ATCameraButtonTypeCamera = 0,
    ATCameraButtonTypeNonCamera
} ATCameraButtonType;

typedef enum {
    ATCameraModeNormal = 0,
    ATCameraModeDistanceOnly,
    ATCameraModeSizeOnlyWithDistanceMid,
    ATCameraModeTutorial,
    ATCameraModeAlbumPhoto,
    ATCameraModeSizeOnly
} ATCameraMode;

typedef enum {
    ATDistanceButtonTypeNear = 0,
    ATDistanceButtonTypeMid,
    ATDistanceButtonTypeFar,
    ATDistanceButtonTypeUnknown
} ATDistanceButtonType;

typedef enum {
    ATSizeButtonTypeSmall = 0,
    ATSizeButtonTypeMedium,
    ATSizeButtonTypeLarge,
    ATSizeButtonTypeUnknown
} ATSizeButtonType;

typedef enum {
    ATDistanceSizeControlTypeDistance = 0,
    ATDistanceSizeControlTypeSize
} ATDistanceSizeControlType;

typedef enum {
    ATCameraControlsModeDistance = 0,
    ATCameraControlsModeSize
} ATCameraControlsMode;

@interface ATCameraOverlayViewController : UIViewController <UINavigationControllerDelegate>
@property (nonatomic, assign) id delegate;

@property (nonatomic, assign) ATCameraMode mode;

//Distance buttons
@property (nonatomic, strong) IBOutlet UIButton *smallButton;
@property (nonatomic, strong) IBOutlet UIButton *mediumButton;
@property (nonatomic, strong) IBOutlet UIButton *largeButton;
@property (nonatomic, strong) IBOutlet UIButton *closeButton;

//Distance + Size control buttons
@property (nonatomic, strong) IBOutlet UIButton *distanceControlButton;
@property (nonatomic, strong) IBOutlet UIButton *sizeControlButton;

@property (nonatomic, assign) ATCameraControlsMode controlsMode;

@property (nonatomic, strong) IBOutlet UIButton *cameraButton;
@property (nonatomic, assign) BOOL startHideActionControls;
@property (nonatomic, strong) IBOutlet UIImageView *targetView;

@property (nonatomic,strong) IBOutlet UILabel *menuLabel;
@property (nonatomic, strong) IBOutlet UILabel *titleLabel;
@property (nonatomic, strong) IBOutlet UILabel *descriptionLabel;
@property (nonatomic, strong) IBOutlet UIView *distancePanelView;
@property (nonatomic, strong) IBOutlet UIImageView *distancePanelImageView;

@property (nonatomic, strong) IBOutlet UIView *instructionsBackgroundView;
@property (nonatomic, strong) IBOutlet UILabel *instructionsTitleLabel;
@property (nonatomic, strong) IBOutlet UITextView *instructionsTextView;
@property (nonatomic, strong) IBOutlet UISegmentedControl *distanceSizeControl;
@property (nonatomic, strong) NSArray *distanceButtonsArray;
@property (nonatomic, strong) NSArray *optionsButtonsArray;
@property (nonatomic, strong) NSArray *distanceSizeControlsArray;

@property (nonatomic, assign) BOOL hideCloseButton;
-(IBAction)cameraButtonSelected:(id)sender;
//Distance + Size Control
-(IBAction)distanceSizeControlButtonSelected:(id)sender;
- (IBAction)closeButtonSelected:(id)sender;
//Buttons
-(IBAction)optionButtonSelected:(id)sender;
-(IBAction)sizeButtonSelected:(id)sender;
-(void)showActionControls;
- (void)deselectAllButtonsInArray:(NSArray*)buttons exceptForType:(int)buttonType;
@end
