//
//  ATFTDIntroViewController.m
//  art250
//
//  Created by Winfred Raguini on 8/20/13.
//  Copyright (c) 2013 Art250. All rights reserved.
//

#import "ATFTDIntroViewController.h"

@interface ATFTDIntroViewController ()

@end

@implementation ATFTDIntroViewController

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
    // Do any additional setup after loading the view from its nib.
//    if (self.backgroundView.image == nil) {
//        [self.overlayView setAlpha:0.0f];
//    } else {
//        [self.overlayView setAlpha:1.0f];
//    }
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didStartTour:) name:kdidStartTourNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didEndTour) name:kdidChooseEndTourButtonNotification object:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (BOOL)prefersStatusBarHidden
{
    return YES;
}


- (IBAction)skipTourButtonSelected:(id)sender
{
    NSDictionary *params = [[NSDictionary alloc] initWithObjectsAndKeys:[NSNumber numberWithInt:self.pageControl.currentPage],@"ended tour at page", nil];
    [Flurry endTimedEvent:FL_STARTED_FTD_TOUR withParameters:params];
    [self didEndTour];
}

- (void)didEndTour
{
    if ([self.delegate respondsToSelector:@selector(didEndTour)]) {
        [self.delegate performSelector:@selector(didEndTour)];
    } else {
        [self.view removeFromSuperview];
        [[NSNotificationCenter defaultCenter] postNotificationName:kdidChooseSkipTourButtonNotification object:nil];
    }
}



#pragma mark
#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [super scrollViewDidScroll:scrollView];
    if ([self.delegate respondsToSelector:@selector(scrollViewDidScroll:)]) {
        [self.delegate performSelector:@selector(scrollViewDidScroll:) withObject:scrollView];
    }
}


- (void)didStartTour:(NSNotification*)note
{
    [self.skipTourButton setHidden:NO];
}

@end
