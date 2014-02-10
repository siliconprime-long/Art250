//
//  ATWalkThrough1ViewController.m
//  art250
//
//  Created by Winfred Raguini on 5/29/13.
//  Copyright (c) 2013 Art250. All rights reserved.
//

#import "ATArtManager.h"
#import "ATWalkThroughViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface ATWalkThroughViewController ()

@end

@implementation ATWalkThroughViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.titleString = nil;
        self.descriptionString = nil;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.isModal = NO;
    self.swipeLabel.text = self.swipeyString;
    self.titleLabel.text = self.titleString;
    self.descriptionLabel.text = self.descriptionString;
//    self.artworkSplashImageView.image = [[ATArtManager sharedManager] artworkSplashImage];
    self.slideImageView.image = [UIImage imageNamed:self.slideImageViewURLString];
    if (self.movieURLString) {
        NSString *url = [[NSBundle mainBundle] pathForResource:self.movieURLString ofType:@"mov"];
        self.moviePlayerController = [[MPMoviePlayerController alloc] initWithContentURL:[NSURL fileURLWithPath:url]];
        [self.moviePlayerController setControlStyle:MPMovieControlStyleNone];
        [self.moviePlayerController setRepeatMode:MPMovieRepeatModeOne];
        [self.moviePlayerController.view setFrame:CGRectMake(189, 183, 640, 360)];
        [self.view addSubview:self.moviePlayerController.view];
        [self.moviePlayerController.view.layer setBorderColor:[[UIColor whiteColor] CGColor]];
    }
    
    
    // Do any additional setup after loading the view from its nib.
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [[ATTrackingManager sharedManager] trackEvent:FL_VIEWED_INTRO_SLIDE];
    [self.actionButton setHidden:NO];
    [self performSelector:@selector(playMovie) withObject:nil afterDelay:0.0f];
}

- (void)playMovie
{
    if (self.moviePlayerController) {
        [self.moviePlayerController play];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)actionButtonSelected:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(skipTourButtonSelected)]) {
        [self.delegate performSelector:@selector(skipTourButtonSelected)];
    }
}
@end
