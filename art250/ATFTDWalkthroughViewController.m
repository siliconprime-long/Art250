//
//  ATFTDWalkthrough0ViewController.m
//  art250
//
//  Created by Winfred Raguini on 8/20/13.
//  Copyright (c) 2013 Art250. All rights reserved.
//

#import "ATFTDWalkthroughViewController.h"

@interface ATFTDWalkthroughViewController ()

@end

@implementation ATFTDWalkthroughViewController

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
}

- (void)viewDidAppear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] postNotificationName:kdidStartTourNotification object:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
