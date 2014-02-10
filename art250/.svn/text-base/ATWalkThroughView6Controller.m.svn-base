//
//  ATWalkThroughView6Controller.m
//  art250
//
//  Created by Winfred Raguini on 5/29/13.
//  Copyright (c) 2013 Art250. All rights reserved.
//

#import "ATWalkThroughView6Controller.h"

@interface ATWalkThroughView6Controller ()

@end

@implementation ATWalkThroughView6Controller

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.titleString = NSLocalizedString(@"See original art virtually hanging on your wall",nil);
        self.descriptionString = NSLocalizedString(@"Please STAND UP in front of your wall.",nil);
        self.slideImageViewURLString = @"bg_slide_05.png";
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.descriptionLabel.textColor = [UIColor whiteColor];
	// Do any additional setup after loading the view.
    [self.actionButton setBackgroundImage:[UIImage imageNamed:@"btn_take_photo.png"] forState:UIControlStateNormal];
    [self.actionButton setTitle:@"Take Photo" forState:UIControlStateNormal];
    
    UIButton *samplePhotoButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [samplePhotoButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [samplePhotoButton setTitle:@"Use Sample Room" forState:UIControlStateNormal];
    [samplePhotoButton setBackgroundImage:[UIImage imageNamed:@"btn_use_sample_room.png"]  forState:UIControlStateNormal];
    [samplePhotoButton.titleLabel setFont:[UIFont fontWithName:@"ProximaNova-Semibold" size:17.0f]];
    [samplePhotoButton addTarget:self action:@selector(samplePhotoButtonSelected:) forControlEvents:UIControlEventTouchUpInside];
    CGRect samplePhotoButtonFrame = samplePhotoButton.frame;
    samplePhotoButtonFrame.origin = CGPointMake(190.0f, self.actionButton.frame.origin.y);
    samplePhotoButtonFrame.size.height = 45.0f;
    samplePhotoButtonFrame.size.width = 176.0f;
    [samplePhotoButton setFrame:samplePhotoButtonFrame];
    [self.view addSubview:samplePhotoButton];
}

- (void)viewDidDisappear:(BOOL)animated
{
    //NSLog(@"Now remove the freaking introview and show the tutorial mode of the camera");

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)samplePhotoButtonSelected:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:kinvokeLaunchScreenSampleRoomNotification object:nil];
    [[ATTrackingManager sharedManager] trackEvent:TR_STARTED_WITH_SAMPLE_ROOM];
}

- (void)actionButtonSelected:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:kdidLoadFinalIntroScreen object:nil];
    
    [Flurry endTimedEvent:FL_STARTED_INTRO withParameters:nil];
    [[ATTrackingManager sharedManager] trackEvent:FL_USER_STARTS_APP_FIRST_TIME];
    [[ATTrackingManager sharedManager] trackEvent:FL_STARTED_TAKING_PHOTO timed:YES];
}

@end
