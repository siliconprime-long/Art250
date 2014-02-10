//
//  ATCheckoutTimerViewController.m
//  art250
//
//  Created by Winfred Raguini on 4/19/13.
//  Copyright (c) 2013 Art250. All rights reserved.
//

#import "ATCheckoutTimerViewController.h"
#import "ATArtManager.h"

@interface ATCheckoutTimerViewController ()

@end

@implementation ATCheckoutTimerViewController

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
	// Do any additional setup after loading the view.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(timerDidFire:) name:kTimerDidFireNotification object:nil];

    [self updateTimerLabelWithTime:[[ATArtManager sharedManager] secondsLeftToCompleteCheckout]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)updateTimerLabelWithTime:(int)timeLeft
{
    if (self.timerLabel != nil) {
        if (self.timerContainerView.hidden) {
            [self.timerContainerView setHidden:NO];
        }
        
        self.timerLabel.text = [NSString stringWithFormat:@"%02d:%02d",timeLeft/60,timeLeft - ((timeLeft/60)*60)];
    }
}

- (void)timerDidFire:(NSNotification*)note
{
//    //NSLog(@"timer %d", [[[note userInfo] objectForKey:@"checkoutTimer"] intValue]);
    int secondsLeftToCheckout = [[[note userInfo] objectForKey:@"checkoutTimer"] intValue];
    [self updateTimerLabelWithTime:secondsLeftToCheckout];
}

- (void)hideCheckoutTimer
{
    [self.timerContainerView setHidden:YES];
}

@end
