//
//  ATProfileSettingsViewController.m
//  art250
//
//  Created by Winfred Raguini on 3/27/13.
//  Copyright (c) 2013 Art250. All rights reserved.
//

#import "ATProfileSettingsViewController.h"

@interface ATProfileSettingsViewController ()

@end

@implementation ATProfileSettingsViewController

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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark
#pragma mark Private

- (IBAction)cancelButtonSelected:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
