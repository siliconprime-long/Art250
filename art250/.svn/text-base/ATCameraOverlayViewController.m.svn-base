//
//  ATCameraOverlayViewController.m
//  art250
//
//  Created by Winfred Raguini on 3/30/13.
//  Copyright (c) 2013 Art250. All rights reserved.
//

#import "ATCameraOverlayViewController.h"
#import "ATArtManager.h"


@interface ATCameraOverlayViewController ()
@property (nonatomic, assign) ATDistanceButtonType distanceType;
@property (nonatomic, assign) ATSizeButtonType sizeType;
- (void)hideActionControls;
- (void)takePhoto;
- (void)toggleCameraControlsMode:(UIButton*)controlButton;
- (void)hideTutorial;
- (void)usePhotoOnScreen;
@end

@implementation ATCameraOverlayViewController

BOOL _firstTimeChoosingDistance;
BOOL _firstTimeChoosingSize;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cameraButtonSelected:) name:kdidSelectCameraButton object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didRemoveFinalIntroScreen:) name:kdidRemoveFinalIntroScreen object:nil];
        self.mode = ATCameraModeNormal;
        self.controlsMode = ATCameraControlsModeDistance;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.cameraButton.hidden = YES;
    
    self.distanceType = ATDistanceButtonTypeUnknown;
    self.sizeType = ATSizeButtonTypeUnknown;
    [self resetQueryOptions];
    [self addObserver:self forKeyPath:@"controlsMode" options:NSKeyValueObservingOptionNew context:nil];
    // Do any additional setup after loading the view from its nib.
    self.optionsButtonsArray = [NSArray arrayWithObjects:self.smallButton, self.mediumButton, self.largeButton, nil];
    self.distanceSizeControlsArray = [NSArray arrayWithObjects:self.distanceControlButton, self.sizeControlButton, nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didChooseWallDistance:) name:kDidChooseWallDistance object:nil];
    if (self.startHideActionControls) {
        [self hideActionControls];
    }
    if (self.hideCloseButton) {
        self.closeButton.hidden = YES;
    } else {
        self.closeButton.hidden = NO;
    }
    
    if (self.mode == ATCameraModeSizeOnlyWithDistanceMid) {
        self.distanceType = ATDistanceButtonTypeMid;
    }
    [self resetCameraDisplayForMode:self.controlsMode];
    if (self.mode == ATCameraModeTutorial) {
        _firstTimeChoosingDistance = YES;
        _firstTimeChoosingSize = YES;
        self.instructionsTitleLabel.text = NSLocalizedString(@"FIRST",nil);
        self.instructionsTitleLabel.textAlignment = NSTextAlignmentCenter;
        self.instructionsTextView.text = NSLocalizedString(@"Select the distance that tells us how far away you are from the wall, so we can scale the art to your space.",nil);
    } else {
        [self hideTutorial];
    }
}


- (void)viewDidUnload
{
    [self removeObserver:self forKeyPath:@"controlsMode"];
}


- (void)viewWillAppear:(BOOL)animated
{
    [self resetDistanceSizeTaps];
    
    if (self.mode != ATCameraModeTutorial) {
         [self hideTutorial];
    }
    
    
    
    if (self.mode == ATCameraModeSizeOnlyWithDistanceMid)
    {
        [self displaySizeOnlyWithMidDistance];
    } else if (self.mode == ATCameraModeSizeOnly) {
        [self displaySizeOnly];
    } else {
        [self displayNormal];
    }
    
    if (self.mode == ATCameraModeAlbumPhoto) {
        [self changePhotoButtomImage:ATCameraButtonTypeNonCamera];
    }
}


- (BOOL)prefersStatusBarHidden {
    return YES;
}

int _distanceButtonTaps;
int _sizeButtonTaps;

- (void)resetDistanceSizeTaps
{
    _distanceButtonTaps = 0;
    _sizeButtonTaps = 0;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if (interfaceOrientation == UIInterfaceOrientationLandscapeRight || interfaceOrientation == UIInterfaceOrientationLandscapeLeft) {
        return YES;
    } else {
        return NO;
    }
}

- (void)changePhotoButtomImage:(ATCameraButtonType)type
{
    switch (type) {
        case ATCameraButtonTypeCamera:
            //Change camerabuttonimage
            break;
            
        default:
            break;
    }
}

- (void)displaySizeOnly
{
    [self.distanceControlButton setUserInteractionEnabled:NO];
    [self.distanceControlButton setHidden:YES];
    self.controlsMode = ATCameraControlsModeSize;
    
    self.distanceType = [[NSUserDefaults standardUserDefaults] integerForKey:klastDistanceChosenKey];
    self.sizeType = [[NSUserDefaults standardUserDefaults] integerForKey:klastSizeChosenKey];
        
    [self resetCameraDisplayForMode:ATCameraControlsModeSize];
    //Change camera button to something else
    [self displayTargetView:self.sizeType];
}

- (void)displaySizeOnlyWithMidDistance
{
    [self.distanceControlButton setUserInteractionEnabled:NO];
    [self.distanceControlButton setHidden:YES];
    self.controlsMode = ATCameraControlsModeSize;
    [self resetCameraDisplayForMode:ATCameraControlsModeSize];
    //Change camera button to something else
}

- (void)displayNormal
{
    [self.distanceControlButton setUserInteractionEnabled:YES];
    [self.distanceControlButton setHidden:NO];
    self.controlsMode = ATCameraControlsModeDistance;
    [self resetCameraDisplayForMode:ATCameraControlsModeDistance];
    //Change camera button to something else
}

- (void)hideTutorial
{
    self.instructionsBackgroundView.hidden = YES;
    self.instructionsTextView.hidden = YES;
    self.instructionsTitleLabel.hidden = YES;
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"controlsMode"])
    {
        ATCameraControlsMode cameraMode = [[change objectForKey:NSKeyValueChangeNewKey] intValue];
        [self resetCameraDisplayForMode:cameraMode];
        
    }
}

- (void)resetCameraDisplayForMode:(ATCameraControlsMode)cameraMode
{
    int buttonType;
    //NSLog(@"cameraMode %d", cameraMode);
    switch (cameraMode) {
        case 0:
            buttonType = self.distanceType;
            break;
            
        default:
            buttonType = self.sizeType;
            break;
    }
    
    //Change button text
    NSString *smallButtonText, *mediumButtonText, *largeButtonText, *menuLabelText;
    if (cameraMode == ATCameraControlsModeDistance) {
        menuLabelText = NSLocalizedString(@"DISTANCE FROM THE WALL",nil);
        smallButtonText = @"8 ft";
        mediumButtonText = @"12 ft";
        largeButtonText = @"16 ft";
        self.distancePanelImageView.image = [UIImage imageNamed:@"bg_distance_menu.png"];
    } else {
        menuLabelText = NSLocalizedString(@"SIZE OF ARTWORK",nil);
        smallButtonText = @"S";
        mediumButtonText = @"M";
        largeButtonText = @"L";
        self.distancePanelImageView.image = [UIImage imageNamed:@"bg_size_menu.png"];
         //NSLog(@"self.distancePanelImageView width: %@",[NSString stringWithFormat:@"%1.2f",self.distancePanelImageView.frame.size.width]);
    }
    [self deselectAllButtonsInArray:self.distanceSizeControlsArray exceptForType:cameraMode];
    
    [self.menuLabel setText:menuLabelText];
    [self.smallButton setTitle:smallButtonText forState:UIControlStateNormal];
    [self.mediumButton setTitle:mediumButtonText forState:UIControlStateNormal];
    [self.largeButton setTitle:largeButtonText forState:UIControlStateNormal];
    
    
    [self deselectAllButtonsInArray:self.optionsButtonsArray exceptForType:buttonType];
    
}

- (void)resetQueryOptions
{
    //Reset 
}

- (void)hideActionControls
{
    [self.distancePanelView setHidden:YES];
    [self.targetView setHidden:YES];
    [self.cameraButton setHidden:YES];
}

- (void)showActionControls
{
    [self.distancePanelView setHidden:NO];
    [self.targetView setHidden:NO];
    [self.cameraButton setHidden:NO];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)cameraButtonSelected:(id)sender
{
    if (self.sizeType == ATSizeButtonTypeUnknown) {
        UIAlertView *distanceAlert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Whoops!",nil) message:NSLocalizedString(@"Please, choose a painting size.",nil) delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles: nil];
        [distanceAlert show];
    } else if (self.distanceType == ATDistanceButtonTypeUnknown) {
        UIAlertView *distanceAlert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Whoops!",nil) message:NSLocalizedString(@"How far are you from the wall?",nil) delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles: nil];
        [distanceAlert show];
    } else {
        
        NSDictionary *params = [[NSDictionary alloc] initWithObjectsAndKeys:@"yes",@"completed", [NSNumber numberWithInt:_distanceButtonTaps], @"number distance taps", [NSNumber numberWithInt:_sizeButtonTaps], @"number size taps", nil];
  
        [Flurry endTimedEvent:FL_STARTED_TAKING_PHOTO withParameters:params];
        
        //Save the current settings
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        
        [userDefaults setInteger:self.sizeType forKey:klastSizeChosenKey];
        [userDefaults setInteger:self.distanceType forKey:klastDistanceChosenKey];
        [userDefaults synchronize];
        
        
        
        if (self.mode == ATCameraModeNormal || self.mode == ATCameraModeTutorial) {
            [self takePhoto];
        } else {
            [self usePhotoOnScreen];
        }
    }

}

#pragma mark
#pragma mark Private
- (void)usePhotoOnScreen
{
    if ([self.delegate respondsToSelector:@selector(useSampleRoomImage)]) {
        [self.delegate performSelector:@selector(useSampleRoomImage)];
    }
}


- (void)takePhoto
{
    //NSLog(@"camera");
 
    if ([self.delegate respondsToSelector:@selector(takePicture)]) {
        [self.delegate performSelector:@selector(takePicture)];
    }    
}

-(IBAction)distanceSizeControlButtonSelected:(id)sender
{
    UIButton *distanceSizeControl = (UIButton*)sender;
    [self deselectAllButtonsInArray:self.distanceSizeControlsArray exceptForType:distanceSizeControl.tag];
    [self toggleCameraControlsMode:distanceSizeControl];
    if (self.mode == ATCameraModeTutorial) {
        //Do stuff like change the text in the box if this is a firstTimeUser
    }
}

- (void)toggleCameraControlsMode:(UIButton*)controlButton
{
    self.controlsMode = controlButton.tag;
    //NSLog(@"now in controls mode %d", self.controlsMode);
}

- (void)verifyCameraButtonVisibility
{
    if (self.distanceType == ATDistanceButtonTypeUnknown || self.sizeType == ATSizeButtonTypeUnknown) {
        self.cameraButton.hidden = YES;
    } else {
        self.cameraButton.hidden = NO;
    }
}

- (IBAction)optionButtonSelected:(id)sender
{
    UIButton *optionButton = (UIButton*)sender;
    //NSLog(@"tag is %d", optionButton.tag);
    [self deselectAllButtonsInArray:self.optionsButtonsArray exceptForType:optionButton.tag];
    if (self.controlsMode == ATCameraControlsModeDistance) {
        
        _distanceButtonTaps += 1;
        
        NSDictionary *flurryParams = [[NSDictionary alloc] initWithObjectsAndKeys:[NSNumber numberWithInt:self.distanceType],@"value", nil];
        
        [[ATTrackingManager sharedManager] trackEvent:FL_TAPPED_DISTANCE_BTN withParameters:flurryParams];
        
        self.distanceType = optionButton.tag;
        
        switch (self.distanceType) {
            case ATDistanceButtonTypeNear:
                
                break;
            case ATDistanceButtonTypeMid:
                break;
            default:
                break;
        }
        
        if ([self.delegate respondsToSelector:@selector(distanceButtonSelected:)]) {
            [self.delegate performSelector:@selector(distanceButtonSelected:) withObject:sender];
        }
        
        [[ATArtManager sharedManager] setDistanceType:self.distanceType];
        
        NSDictionary *dict = [[NSDictionary alloc] initWithObjectsAndKeys:[NSNumber numberWithInt:optionButton.tag],@"distanceButtonTag", nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:kDidChooseWallDistance object:nil userInfo:dict];
        if (self.mode == ATCameraModeTutorial && _firstTimeChoosingDistance) {
            _firstTimeChoosingDistance = NO;
            
            
            [UIView animateWithDuration:2.0f
                             animations:^{
                                 self.instructionsTitleLabel.text = NSLocalizedString(@"SECOND",nil);
                                 self.instructionsTitleLabel.textAlignment = NSTextAlignmentCenter;
                                 self.instructionsTextView.text = NSLocalizedString(@"Choose the approximate size of artwork you would like on your wall.",nil);
                             }
                             completion:^(BOOL finished){
                                 
                             }];
        }
        if (self.sizeType == ATSizeButtonTypeUnknown ) {
            self.controlsMode = ATCameraControlsModeSize;
        }
    } else {
        
        _sizeButtonTaps += 1;
        
        NSDictionary *flurryParams = [[NSDictionary alloc] initWithObjectsAndKeys:[NSNumber numberWithInt:self.sizeType],@"value", nil];
        
        [[ATTrackingManager sharedManager] trackEvent:FL_TAPPED_SIZE_BTN withParameters:flurryParams];
        
        self.sizeType = optionButton.tag;
        [[ATArtManager sharedManager] setSizeType:self.sizeType];
        //Change target image
        [self displayTargetView:optionButton.tag];
        
        if ([self.delegate respondsToSelector:@selector(sizeButtonSelected:)]) {
            [self.delegate performSelector:@selector(sizeButtonSelected:) withObject:sender];
        }
        if (self.mode == ATCameraModeTutorial && _firstTimeChoosingSize) {
            _firstTimeChoosingSize = NO;
            
            
            [UIView animateWithDuration:2.0f
                             animations:^{
                                 self.instructionsTitleLabel.text = NSLocalizedString(@"THIRD",nil);
                                 self.instructionsTitleLabel.textAlignment = NSTextAlignmentCenter;
                                 self.instructionsTextView.textAlignment = NSTextAlignmentCenter;
                                 self.instructionsTextView.text = NSLocalizedString(@"where you want to hang the art and take the photo when you are ready.",nil);
                                 [self.cameraButton setImage:[UIImage imageNamed:@"camera_button.png"] forState:UIControlStateNormal];
                             }
                             completion:^(BOOL finished){
                                 
                             }];
            
        }
    }
    [self verifyCameraButtonVisibility];

}

- (void)displayTargetView:(ATSizeButtonType)sizeButtonType
{
    NSString *targetImageName;
    switch (sizeButtonType) {
        case ATSizeButtonTypeSmall:
            targetImageName = @"target_area_small.png";
            break;
        case ATSizeButtonTypeMedium:
            targetImageName = @"target_area_medium.png";
            break;
        default:
            targetImageName = @"target_area_large.png";
            break;
    }
    self.targetView.image = [UIImage imageNamed:targetImageName];
}

-(IBAction)sizeButtonSelected:(id)sender
{
    UIButton *sizeButton = (UIButton*)sender;
    [self deselectAllButtonsInArray:self.optionsButtonsArray exceptForType:sizeButton.tag];
    if ([self.delegate respondsToSelector:@selector(sizeButtonSelected:)]) {
        [self.delegate performSelector:@selector(sizeButtonSelected:) withObject:sender];
    }
}

- (void)deselectAllButtonsInArray:(NSArray*)buttons exceptForType:(int)buttonType
{
    for (UIButton *button in buttons) {
        if (button.tag != buttonType) {
            button.selected = NO;
        } else {
            button.selected = YES;
        }
    }
}

- (IBAction)closeButtonSelected:(id)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:kdidSelectCloseCameraButton object:nil];
    //This is for the sample room photo
    
    
    
    NSDictionary *params = [[NSDictionary alloc] initWithObjectsAndKeys:@"no",@"completed", [NSNumber numberWithInt:_distanceButtonTaps], @"number distance taps", [NSNumber numberWithInt:_sizeButtonTaps], @"number size taps", nil];
    [Flurry endTimedEvent:FL_STARTED_TAKING_PHOTO withParameters:params];
    
    if ([self.delegate respondsToSelector:@selector(closeButtonSelected)]) {
        [self.delegate performSelector:@selector(closeButtonSelected)];
    }
}

#pragma mark
#pragma mark Notification Handlers

- (void)didRemoveFinalIntroScreen:(NSNotification*)note
{
    NSDictionary *dict = [note userInfo];
    self.titleLabel.text = [dict objectForKey:@"title"];
    self.descriptionLabel.text = [dict objectForKey:@"description"];
}

- (void)didChooseWallDistance:(NSNotification*)note
{
    NSDictionary *dict = [note userInfo];
    int tag = [[dict valueForKey:@"distanceButtonTag"] intValue];
//    [self deselectAllButtonsExcept:tag];
    [self deselectAllButtonsInArray:self.distanceButtonsArray exceptForType:tag];
}


@end
